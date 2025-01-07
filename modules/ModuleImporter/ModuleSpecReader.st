"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleSpecReader,
	#superclass : #Object,
	#instVars : [
		'module',
		'path',
		'metadata'
	],
	#category : #ModuleSpecReader
}

{#category : #read}
ModuleSpecReader >> read [
	self readMetadata; readClasses; readExtendedClasses.
	^module
]

{#category : #read}
ModuleSpecReader >> readClass: aString [
	| filename reader definition pointers variable class metasclass stream contents |
	filename := path / aString ,  '.st'.
	contents := Kernel readFile: filename.
	contents size = 0 ifTrue: [
		filename := path / aString , '.class.st'.
		contents := Kernel readFile: filename.
		contents size = 0 ifTrue: [
			self error: 'Cannot find file for class ' , aString]].
	stream := InternalReadStream on: contents.
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

{#category : #read}
ModuleSpecReader >> readClasses [
	(metadata at: #classes) do: [:name | self readClass: name]
]

{#category : #read}
ModuleSpecReader >> readExtendedClass: aString [

	| filename contents stream reader definition class metaclass |
	filename := path / aString ,  '.st'.
	contents := Kernel readFile: filename.
	contents size = 0 ifTrue: [
			self error: 'Cannot find file for extended class ' , aString].
	stream := InternalReadStream on: contents.
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

{#category : #read}
ModuleSpecReader >> readExtendedClasses [
	(metadata at: #extendedClasses ifAbsent: [#()])
		do: [:name | self readExtendedClass: name]
]

{#category : #read}
ModuleSpecReader >> readMetadata [
	| stream name classes |
	stream := (Kernel  readFile: path , '/package.st') readStream.
	stream throughAll: 'Package '.
	metadata := (STONReader on: stream) parseMap.
	name := (metadata at: #name) replace: $- with: Character space.
	module name: name asString.
	classes := metadata at: #classes.
	classes := classes copyWith: name asString, 'Module'.
	metadata at: #classes put: classes
]

{#category : #read}
ModuleSpecReader >> readMethod: aDictionary [
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
ModuleSpecReader >> initialize [
	super initialize.
	module := ModuleSpec new
]

{#category : #accessing}
ModuleSpecReader >> module [
	^module
]

{#category : #accessing}
ModuleSpecReader >> module: aModuleSpec [
	module := aModuleSpec
]

{#category : #accessing}
ModuleSpecReader >> path: aFilename [
	path := aFilename
]

