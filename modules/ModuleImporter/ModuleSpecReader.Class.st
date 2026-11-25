'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ModuleSpecReader category: #ModuleSpecReader!
Object subclass: #ModuleSpecReader
	instanceVariableNames: 'module path metadata'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ModuleSpecReader'!
!ModuleSpecReader commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!ModuleSpecReader methodsFor:  'read' stamp: 'KenD 28/Jun/2026 13:27:38'!
read
	self readMetadata; readClasses; readExtendedClasses.
	^module
! !

!ModuleSpecReader methodsFor:  'read' stamp: 'KenD 28/Jun/2026 13:27:38'!
readClass: aString
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
! !

!ModuleSpecReader methodsFor:  'read' stamp: 'KenD 28/Jun/2026 13:27:38'!
readClasses
	(metadata at: #classes) do: [:name | self readClass: name]
! !

!ModuleSpecReader methodsFor:  'read' stamp: 'KenD 28/Jun/2026 13:27:38'!
readExtendedClass: aString

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
! !

!ModuleSpecReader methodsFor:  'read' stamp: 'KenD 28/Jun/2026 13:27:38'!
readExtendedClasses
	(metadata at: #extendedClasses ifAbsent: [#()])
		do: [:name | self readExtendedClass: name]
! !

!ModuleSpecReader methodsFor:  'read' stamp: 'KenD 28/Jun/2026 13:27:38'!
readMetadata
	| stream name classes |
	stream := (Kernel  readFile: path , '/package.st') readStream.
	stream throughAll: 'Package '.
	metadata := (STONReader on: stream) parseMap.
	name := (metadata at: #name) replace: $- with: Character space.
	module name: name asString.
	classes := metadata at: #classes.
	classes := classes copyWith: name asString, 'Module'.
	metadata at: #classes put: classes
! !

!ModuleSpecReader methodsFor:  'read' stamp: 'KenD 28/Jun/2026 13:27:38'!
readMethod: aDictionary
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
! !

!ModuleSpecReader methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	module := ModuleSpec new
! !

!ModuleSpecReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
module
	^module
! !

!ModuleSpecReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
module: aModuleSpec
	module := aModuleSpec
! !

!ModuleSpecReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
path: aFilename
	path := aFilename
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ModuleSpecReader class' category: #ModuleSpecReader!
ModuleSpecReader class
	instanceVariableNames: ''!


ModuleSpecReader initialize!

