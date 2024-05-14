"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleReader, 
	#superclass : #Object, 
	#instVars : [
		'module', 
		'path', 
		'metadata'
	], 
	#category : #ModuleReader
}

{#category : #'instance creation'}
ModuleReader class >> new [
	^super new initialize
]

{#category : #reading}
ModuleReader >> read [
	self readMetadata; readClasses; readExtendedClasses
]

{#category : #reading}
ModuleReader >> readClass: aString [
	| content filename reader definition pointers variable class metasclass stream |
	filename := path, '\', aString , '.st'.
	content := Kernel readFile: filename.
	content ifNil: [
		filename := path, '\', aString , 'class.st'.
		content := Kernel readFile: filename.
		content
			ifNil: [self error: 'Cannot find file for class ' , aString]].
	stream := ReadStream on: content.
	reader := TonelReader on: stream.
	[reader read] ensure: [stream close].
	definition := reader definition.
	variable := pointers := true.
	definition at: #type ifPresent: [:type | 
		variable := true.
		type = #bytes ifTrue: [pointers := false]].
	class := ClassSpec new
		module: module;
		name: (definition at: #name) asString;
		supername: (definition at: #superclass ifAbsent: nil) asString;
		ivars: (definition at: #instVars ifAbsent: #());
		cvarNames: (definition at: #classVars ifAbsent: #());
		sharedPools: (definition at: #pools ifAbsent: #());
		isVariable: variable;
		isPointers: pointers.
	metasclass := MetaclassSpec new
		module: module;
		instanceClass: class;
		ivars: (definition at: #classInstVars ifAbsent: #()).
	class metaclass: metasclass.
	module addClass: class.
	reader methods do: [:m | self readMethod: m]
]

{#category : #reading}
ModuleReader >> readClasses [
	(metadata at: #classes) do: [:name | self readClass: name]
]

{#category : #reading}
ModuleReader >> readExtendedClass: aString [
	| content stream reader definition class metaclass |
	filename := path , '\', aString , '.st'.
	content := Kernel readFile: filename.
	content ifNil: [self error: 'Cannot find file for extended class ' , aString].
	stream := ReadStream on: content.
	reader := TonelReader on: stream.
	[reader read] ensure: [stream close].
	definition := reader definition.
	class := ClassSpec new
		module: module;
		name: (definition at: #name) asString.
	metaclass := MetaclassSpec new module: module; instanceClass: class.
	class metaclass: metaclass.
	module addClassExtension: class.
	reader methods do: [:m | self readMethod: m]
]

{#category : #reading}
ModuleReader >> readExtendedClasses [
	| classes filenames candidates |
	classes := metadata at: #classes.
	filenames := path asDirectory fileNamesWithExtension: 'st'.
	candidates := filenames collect: [:s | s asFilename fileNameOnly].
	candidates := candidates
		reject: [:n | n = 'package' or: [classes includes: n]].
	candidates do: [:n | self readExtendedClass: n]
]

{#category : #reading}
ModuleReader >> readMetadata [
	| content stream name |
	content := Kernel readFile: path , '\package.st'.
	stream := ReadStream on: content.
	stream throughAll: 'Package '.
	metadata := (STONReader on: stream) parseMap.
	name := (metadata at: #name) replace: $- with: Character space.
	module name: name asString
]

{#category : #reading}
ModuleReader >> readMethod: aDictionary [
	| classname selector category class signature body source method |
	classname := aDictionary at: #class.
	selector := aDictionary at: #selector.
	category := aDictionary at: #category.
	class := module resolveClass: classname.
	class isNil ifTrue: [
		self
			error: 'Cannot find class for method ' , classname , ' >> #'
				, selector asString].
	signature := aDictionary at: #signature.
	body := aDictionary at: #body.
	source := signature dosToUnix unixToMac , String cr
		, body dosToUnix unixToMac.
	method := MethodSpec new
		module: module;
		classBinding: class;
		selector: selector;
		category: category;
		source: source.
	class addMethod: method
]

{#category : #initialization}
ModuleReader >> initialize [
	super initialize.
	module := ModuleSpec new
]

{#category : #accessing}
ModuleReader >> module [
	^module
]

{#category : #accessing}
ModuleReader >> module: aModuleSpec [
	module := aModuleSpec
]

{#category : #accessing}
ModuleReader >> path: aFilename [
	path := aFilename
]

