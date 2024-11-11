Class {
	#name : 'EggMetacircularRuntime',
	#superclass : 'EggRuntime',
	#instVars : [
		'kernel',
		'wordSize',
		'bootstrapper',
		'behaviorNextIndex',
		'behaviorMethodDictionaryIndex',
		'behaviorClassIndex',
		'classNameIndex',
		'methodFlagsIndex',
		'symbolTable',
		'maxSMI',
		'minSMI',
		'knownSymbols',
		'arrayClass',
		'metaclassClass',
		'speciesInstanceBehaviorIndex',
		'speciesFormatIndex',
		'methodTreecodesIndex',
		'methodInstSize',
		'methodClassBindingIndex',
		'speciesSuperclassIndex',
		'methodClass',
		'smallIntegerClass',
		'blockClass',
		'speciesIvarsIndex',
		'dictionaryTableIndex',
		'metaclassInstanceClassIndex',
		'classModuleIndex',
		'moduleNamespaceIndex',
		'byteArrayClass',
		'stringClass',
		'closureBlockIndex',
		'closureClass',
		'lastHash',
		'blockMethodIndex',
		'behaviorClass',
		'classNamespacesIndex',
		'largePositiveIntegerClass',
		'largeNegativeIntegerClass',
		'methodSelectorIndex',
		'compiledCodeExecutableCodeIndex',
		'floatClass',
		'processStackSPIndex',
		'ffiMethodClass'
	],
	#pools : [
		'SCompiledBlockFlags',
		'SCompiledMethodFlags'
	],
	#category : 'Powerlang-Core-Execution-Metacircular',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Metacircular'
}

{ #category : 'initialization' }
EggMetacircularRuntime >> addSymbol: aSymbol [
	| string |
	string := self newString: aSymbol asString.
	^ self sendLocal: #asSymbol to: string
]

{ #category : 'initialization' }
EggMetacircularRuntime >> argumentCountOf: anEggObject [
	^(self isBlock: anEggObject)
		ifTrue: [ self blockArgumentCount: anEggObject ]
		ifFalse: [ self methodArgumentCount: anEggObject ]

]

{ #category : 'initialization' }
EggMetacircularRuntime >> arrayClass: anLMRObject [
	arrayClass := anLMRObject 
]

{ #category : 'initialization' }
EggMetacircularRuntime >> arrayedSizeOf: anLMRObject [
	| species ivars |
	anLMRObject isImmediate ifTrue: [ ^0 ].
	species := self speciesFor: anLMRObject.
	ivars := self speciesInstanceSize: species.
	^anLMRObject size - ivars
]

{ #category : 'initialization' }
EggMetacircularRuntime >> associationValue: association [

	^association slotAt: 2
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorClass: anLMRObject [
	^ anLMRObject slotAt: behaviorClassIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorClassIndex: anInteger [
	behaviorClassIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorClass_: anLMRObject [
	behaviorClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorMethodDictionary: anLMRObject [
	^ anLMRObject slotAt: behaviorMethodDictionaryIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorMethodDictionaryIndex: anInteger [
	behaviorMethodDictionaryIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorNext: anLMRObject [
	^ anLMRObject slotAt: behaviorNextIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorNextIndex: anInteger [
	behaviorNextIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> behaviorOf: anLMRObject [
	^anLMRObject isImmediate ifTrue: [ self smallIntegerBehavior ] ifFalse: [anLMRObject behavior]
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockArgumentCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: BlockArgCount
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockCapturesHome: block [
	| flags |
	flags := block slotAt: methodFlagsIndex.
	^ flags value anyMask: BlockCapturesHome
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockCapturesSelf: block [
	| flags |
	flags := block slotAt: methodFlagsIndex.
	^ flags value anyMask: BlockCapturesSelf
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockClass: anLMRObject [
	blockClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockEnvironmentCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: BlockEnvCount
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockExecutableCode: anLMRObject [

	^ self methodExecutableCode: anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockExecutableCode: anLMRObject put: anObject [
	^ self methodExecutableCode: anLMRObject put: anObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockExecutionTree: anLMRObject [
	^ anLMRObject slotAt: compiledCodeExecutableCodeIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockMethod: anLMRObject [
	^ anLMRObject slotAt: blockMethodIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockMethodIndex: anInteger [
	blockMethodIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> blockTempCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: BlockTempCount
]

{ #category : 'initialization' }
EggMetacircularRuntime >> bootstrapper [
	^bootstrapper
]

{ #category : 'initialization' }
EggMetacircularRuntime >> bootstrapper: aBootstrapper [
	bootstrapper := aBootstrapper
]

{ #category : 'initialization' }
EggMetacircularRuntime >> byteArrayClass: anLMRObject [
	byteArrayClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> classIvars: anLMRObject [
	^ anLMRObject slotAt: speciesIvarsIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> classModule: class [
	^ class slotAt: classModuleIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> classModuleIndex: anInteger [
	classModuleIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> className: anLMRObject [
	^ anLMRObject slotAt: classNameIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> classNameIndex: anInteger [
	classNameIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> classNamespacesIndex: anInteger [
	classNamespacesIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> closureBlock: closure [ 
	^closure slotAt: closureBlockIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> closureBlockIndex: anInteger [
	closureBlockIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> closureClass: anLMRObject [
	closureClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> closureHome: closure [
	| block |
	block := self closureBlock: closure.
	(self blockCapturesHome: block)
		ifFalse: [ self error: 'closure has no home' ].
	^ (self blockCapturesSelf: block)
		ifTrue: [ closure at: 2 ]
		ifFalse: [ closure at: 1 ]
]

{ #category : 'initialization' }
EggMetacircularRuntime >> dictionaryTable: anLMRObject [
	^anLMRObject slotAt: dictionaryTableIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> dictionaryTableIndex: anInteger [
	dictionaryTableIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> doLookup: aSymbol startingAt: aBehavior [
	| behavior m |
	behavior := aBehavior.
	[ m := self methodFor: aSymbol in: behavior.
	m ifNotNil: [ ^m ].
	behavior := self behaviorNext: behavior.
	behavior != nilObj ] whileTrue.
	^ nil
]

{ #category : 'initialization' }
EggMetacircularRuntime >> doesNotUnderstandMethod: anEggObject [
	doesNotUnderstandMethod := anEggObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> executableCodeWork: anEggExecutableCode [
	self ASSERT: anEggExecutableCode !== nilObj.
	^anEggExecutableCode code
]

{ #category : 'initialization' }
EggMetacircularRuntime >> extensionMethodModule: anLMRObject [
	| association |
	association := anLMRObject slotAt: anLMRObject size.
	^ self associationValue: association
]

{ #category : 'initialization' }
EggMetacircularRuntime >> ffiMethodClass [
	^ffiMethodClass
]

{ #category : 'initialization' }
EggMetacircularRuntime >> ffiMethodClass: anEggObject [
	ffiMethodClass := anEggObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> fixOverrides [
	| selector md |
	overrides
		keysAndValuesDo: [ :assoc :method | 
			selector := assoc value.
			md := self behaviorMethodDictionary: assoc key.
			self
				sendLocal: #at:put:
				to: md
				with:
					{selector.
					method} ]
]

{ #category : 'initialization' }
EggMetacircularRuntime >> floatClass: anLMRObject [

	floatClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> hashFor: anLMRObject [
	| shifted hash current |
	anLMRObject isImmediate
		ifTrue: [ ^ anLMRObject value ].
	current := anLMRObject headerHash.
	current != 0
		ifTrue: [ ^ current ].
	shifted := lastHash bitShift: -1.
	hash := (lastHash bitAnd: 1) = 0
		ifTrue: [ shifted ]
		ifFalse: [ shifted bitXor: 16rB9C8 ].
	anLMRObject headerHash: hash.
	^ lastHash := hash
]

{ #category : 'initialization' }
EggMetacircularRuntime >> initialize [
	lastHash := 1.
	super initialize
]

{ #category : 'initialization' }
EggMetacircularRuntime >> integerFrom: anLMRObject [
	| behavior class |
	anLMRObject isImmediate
		ifTrue: [ ^ anLMRObject value ].
	behavior := self behaviorOf: anLMRObject.
	class := self behaviorClass: behavior.
	^ class == largePositiveIntegerClass
		ifTrue: [ anLMRObject bytes asLittleEndianPositiveInteger ]
		ifFalse: [ anLMRObject bytes asLittleEndianNegativeInteger ]
]

{ #category : 'initialization' }
EggMetacircularRuntime >> isBlock: compiledCode [
	^ (self behaviorClass: compiledCode behavior) ==
	blockClass 
]

{ #category : 'initialization' }
EggMetacircularRuntime >> isExecutableCode: code [
	^code class == EggExecutableCode
]

{ #category : 'initialization' }
EggMetacircularRuntime >> isMetaclass: anLMRObject [
	^ (self speciesFor: anLMRObject) == metaclassClass
]

{ #category : 'initialization' }
EggMetacircularRuntime >> kernel [
	^kernel
]

{ #category : 'initialization' }
EggMetacircularRuntime >> kernel: anLMRObject [ 
	kernel := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> knownSymbols: associations [
	knownSymbols := Dictionary withAll: associations
]

{ #category : 'initialization' }
EggMetacircularRuntime >> largeNegativeIntegerClass: anLMRObject [
	largeNegativeIntegerClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> largePositiveIntegerClass: anLMRObject [
	largePositiveIntegerClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> loadAssociationValue: association [
	^ association slotAt: 2.

]

{ #category : 'initialization' }
EggMetacircularRuntime >> loadModule: symbol [
	^ bootstrapper loadModule: symbol asLocalString
]

{ #category : 'initialization' }
EggMetacircularRuntime >> localMethodTreecodes: method [

	^ (self methodTreecodes: method) bytes
]

{ #category : 'initialization' }
EggMetacircularRuntime >> lookupAssociationFor: aSymbol in: dictionary [
	|  table assoc key |
	table := self dictionaryTable: dictionary.
	2 to: table size do: [ :index | 
		assoc := table slotAt: index.
		assoc == nilObj ifFalse: [key := assoc slotAt: 1. key == aSymbol
			ifTrue: [ ^ assoc] ]].
	^ nil
	
]

{ #category : 'initialization' }
EggMetacircularRuntime >> metaclassClass: anLMRObject [
	metaclassClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> metaclassInstanceClass: anLMRObject [
	^ anLMRObject slotAt: metaclassInstanceClassIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> metaclassInstanceClassIndex: anInteger [
	metaclassInstanceClassIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> method: method literalAt: index [
	^ method slotAt: methodInstSize + index
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodArgumentCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: ArgCount
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodClass: anLMRObject [
	methodClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodClassBinding: anLMRObject [
	^ anLMRObject slotAt: methodClassBindingIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodClassBindingIndex: anInteger [
	methodClassBindingIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodEnvironmentSize: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: EnvCount
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodExecutableCode: anLMRObject [

^anLMRObject slotAt: compiledCodeExecutableCodeIndex.
	
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodExecutableCode: anLMRObject put: anObject [

	^ anLMRObject slotAt: compiledCodeExecutableCodeIndex put: anObject 
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodExecutableCodeIndex: anInteger [
	compiledCodeExecutableCodeIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodFlagsIndex: anInteger [
	methodFlagsIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodFor: aSymbol in: behavior [
	| md table  |
	overrides at: behavior -> aSymbol ifPresent: [ :m | ^ m ].
	md := self behaviorMethodDictionary: behavior.
	table := self dictionaryTable: md.
	2 to: table size by: 2 do: [ :index | 
		(table slotAt: index) == aSymbol
			ifTrue: [ ^ table slotAt: index + 1 ] ].
	^ nil
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodInstSize: anInteger [
	methodInstSize := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodIsCallout: method [
	^(self speciesFor: method) == ffiMethodClass
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodIsExtension: anLMRObject [

	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value anyMask: IsExtension
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodNeedsEnvironment: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ (flags value bitAnd: HasEnvironment) = HasEnvironment
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodSelector: anLMRObject [

	^ anLMRObject slotAt: methodSelectorIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodSelectorIndex: anInteger [

	methodSelectorIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodTempCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: TempCount
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodTreecodes: anLMRObject [
	^ anLMRObject slotAt: methodTreecodesIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> methodTreecodesIndex: anInteger [
	methodTreecodesIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> moduleNamespace: anLMRObject [
	^anLMRObject slotAt: moduleNamespaceIndex

]

{ #category : 'initialization' }
EggMetacircularRuntime >> moduleNamespaceIndex: anInteger [

	moduleNamespaceIndex := anInteger
]

{ #category : 'validating' }
EggMetacircularRuntime >> nativizeForLMR [
	| script |
	script := 'nativizeForLMR
	lmr := Kernel loadModule: ''Nativization/LMR''. 
	lmr nativizeLoadedModules'.
	self
		compile: script in: #UndefinedObject;
		sendLocal: #nativizeForLMR to: nilObj
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newArray: anArray [
| result |
result := 	self newArraySized: anArray size.
	anArray withIndexDo: [ :elem :i | result at: i put: elem ].
	^result
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newArraySized: anInteger [
	| behavior header |
	behavior := self speciesInstanceBehavior: arrayClass.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: true named: false;
		size: anInteger;
		hash: 0.
	^ EggSlotObject new header: header
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newByteArray: aByteArray [

	| behavior header |
	behavior := self speciesInstanceBehavior: byteArrayClass.
	header := EggObjectHeader new
		          behavior: behavior;
		          bytes: true arrayed: true named: false;
		          size: aByteArray size;
		          hash: 0.
	^ EggByteObject new
		  header: header;
		  bytes: aByteArray
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newBytes: species size: anInteger [
	| behavior header |
	behavior := self speciesInstanceBehavior: species.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: true arrayed: true named: false;
		size: anInteger;
		hash: 0.
	^ EggByteObject new
		header: header;
		bytes: (ByteArray newBytes: anInteger)
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newBytesOf: species sized: size [
	^ self newBytes: species size: size
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newCharacter: aCharacter [
	| value |
	value := self newInteger: aCharacter asInteger.
	^self sendLocal: #asCharacter to: value.

]

{ #category : 'initialization' }
EggMetacircularRuntime >> newClosureFor: compiledBlock [
	| size closure |
	size := self blockEnvironmentCount: compiledBlock.
	closure := self newSlots: closureClass size:  size.
	closure slotAt: closureBlockIndex put: compiledBlock.
	^ closure
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newCompiledMethod [
	| behavior header method |
	behavior := self speciesInstanceBehavior: methodClass.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: true named: false;
		size: methodInstSize;
		hash: 0.
	method := EggSlotObject new header: header.
	method slotAt: methodFlagsIndex put: (self newInteger: 0).
	^method
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newEnvironmentSized: anInteger [
	^ self newArraySized: anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newExecutableCodeFor: anObject [
		| behavior header |
	behavior := self speciesInstanceBehavior: arrayClass.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: true named: false;
		size: 0;
		hash: 0.

	 ^EggExecutableCode new header: header; code: anObject.

]

{ #category : 'initialization' }
EggMetacircularRuntime >> newFloat: aFloat [

	| behavior header |
	behavior := self speciesInstanceBehavior: floatClass.
	header := EggObjectHeader new
		          behavior: behavior;
		          bytes: true arrayed: true named: false;
		          size: 8;
		          hash: 0.
	^ EggByteObject new
		  header: header;
		  bytes: aFloat pointerDouble
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newInteger: anInteger [
	anInteger > maxSMI
		ifTrue: [ ^ self newLargePositiveInteger: anInteger ].
	anInteger < minSMI
		ifTrue: [ ^ self newLargeNegativeInteger: anInteger ].
	^ EggSmallInteger new value: anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newLargeNegativeInteger: anInteger [
	"
		phato's bytesCount is unsigned (i.e. 255 bytesCount = 1). In Egg, 
		largenegs are twos-complement, and largepos are unsigned, so largenegs
		have 1 less available bit
	"

	| size bytes result |
	size := (anInteger bytesCount alignedTo: 2) max: wordSize.
	(anInteger byteAt: size) > 16r80 ifTrue: [ size := size + 2 ].
	bytes := anInteger asEggByteArrayOfSize: size.
	result := self newBytes: largeNegativeIntegerClass size: bytes size.
	^ result bytes: bytes
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newLargePositiveInteger: anInteger [

	| size bytes result |
	size := (anInteger bytesCount alignedTo: 2) max: wordSize.
	bytes := anInteger asEggByteArrayOfSize: size.
	result := self newBytes: largePositiveIntegerClass size: size.
	^ result bytes: bytes
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newOf: aSpecies sized: anInteger [
	^(self speciesIsBytes: aSpecies)
		ifTrue: [ self newBytes: aSpecies size: anInteger ]
		ifFalse: [ self newSlots: aSpecies size: anInteger ]
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newSlots: class [
	^self newSlots: class size: 0
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newSlots: class size: anInteger [
	| ivars behavior header result |
	ivars := self speciesInstanceSize: class.
	behavior := self speciesInstanceBehavior: class.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: anInteger > 0 named: ivars > 0;
		size: ivars + anInteger;
		hash: 0.
	result := class == behaviorClass
		ifTrue: [ EggBehaviorObject new runtime: self]
		ifFalse: [ EggSlotObject new ].
	^ result
		header: header;
		nilSlots: nilObj
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newSlotsOf: class [
	^ self newSlots: class size: 0
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newSmallInteger: anInteger [
	^ EggSmallInteger new value: anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> newString: aString [
	| behavior header bytes |
	behavior := self speciesInstanceBehavior: stringClass.
	bytes := aString asByteArray copyWith: 0.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: true arrayed: true named: false;
		size: bytes size;
		hash: 0.
	^ EggByteObject new
		header: header;
		bytes: bytes
]

{ #category : 'initialization' }
EggMetacircularRuntime >> nil: n true: t false: f [
	nilObj := n.
	trueObj := t.
	falseObj := f
]

{ #category : 'initialization' }
EggMetacircularRuntime >> override: assoc with: method [
	overrides at: assoc put: method
]

{ #category : 'initialization' }
EggMetacircularRuntime >> print: anLMRObject on: aStream [
	| species name selector |
	species := self behaviorClass: anLMRObject behavior.
	name := self speciesLocalName: species.
	name = 'Symbol'
		ifTrue: [ ^ aStream nextPutAll: '<#' , anLMRObject asLocalString , '>' ].
	name = 'String'
		ifTrue: [ ^ aStream nextPutAll: '<''' , anLMRObject asLocalString , '''>' ].
	name = 'CompiledMethod'
		ifTrue: [
			selector := anLMRObject slotAt: methodSelectorIndex.
			selector := selector == nilObj ifTrue: ['<nil>'] ifFalse: [ selector asLocalString ].
			  ^ aStream
				nextPutAll: '<';
				print: (self methodClassBinding: anLMRObject);
				nextPutAll: '>>#';
				nextPutAll: selector;
				nextPutAll: '>' ].
	aStream
		nextPut: $<;
		nextPutAll: name withArticle;
		nextPut: $>
]

{ #category : 'initialization' }
EggMetacircularRuntime >> printBehavior: anLMRBehavior on: aStream [
	| species name |
	species := self behaviorClass: anLMRBehavior.
	name := self speciesLocalName: species.
	aStream
		nextPutAll: '<' , name , ' instanceBehavior>'
]

{ #category : 'initialization' }
EggMetacircularRuntime >> processStackSP: anLMRObject [

	^ anLMRObject slotAt: processStackSPIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> processStackSPIndex: anInteger [
 processStackSPIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> readFile: filename [
	^ bootstrapper readFile: filename asLocalString
]

{ #category : 'validating' }
EggMetacircularRuntime >> readKernel [
	| script |
	script := 'readKernel
	| reader |
	reader := Kernel loadModule: ''ImageSegment/Reader''. 
	segment := reader read: ''build/Kernel.ims''.
	^segment'.
	self
		compile: script in: #UndefinedObject;
		sendLocal: #readKernel to: nilObj
]

{ #category : 'initialization' }
EggMetacircularRuntime >> removeOverride: assoc [
	| species selector |
	species := assoc key.
	selector := assoc value.
	overrides removeKey: species -> selector.
	methodCache removeKey: selector -> species ifAbsent: nil.
	symbolCache
		at: selector
		ifPresent: [ :messages | messages do: #flushCache ]
]

{ #category : 'initialization' }
EggMetacircularRuntime >> smallIntegerBehavior [
	^self speciesInstanceBehavior: smallIntegerClass
]

{ #category : 'initialization' }
EggMetacircularRuntime >> smallIntegerClass: anLMRObject [
	smallIntegerClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesFor: anEggObject [
	| behavior |
	behavior := self behaviorOf: anEggObject.
	^self behaviorClass: behavior.


]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesFormatIndex: anInteger [
	speciesFormatIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesInstanceBehavior: anLMRObject [
	^anLMRObject slotAt: speciesInstanceBehaviorIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesInstanceBehaviorIndex: anInteger [
	speciesInstanceBehaviorIndex := anInteger 
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesInstanceClass: anLMRObject [
	| metaclass |
	metaclass := self isMetaclass: anLMRObject.
	^ metaclass
		ifTrue: [ self metaclassInstanceClass: anLMRObject ]
		ifFalse: [ anLMRObject ]
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesInstanceSize: anLMRObject [
	^ (anLMRObject slotAt: speciesFormatIndex) value bitAnd: 16r7F.
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesIsBytes: anLMRObject [
	^ (anLMRObject slotAt: speciesFormatIndex) value noMask: 16r4000
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesIvarsIndex: anInteger [
	speciesIvarsIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesLocalName: species [
	| name class |
	(self isMetaclass: species) ifFalse: [
		name :=self className: species.
		^name asLocalString].
	
	class := self metaclassInstanceClass: species. 
	name := self className: class.
	^ name asLocalString, ' class'
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesModule: species [
	| class |
	(self isMetaclass: species)
		ifFalse: [ ^ self classModule: species ].
	class := self metaclassInstanceClass: species.
	^ self classModule: class
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesNamespaces: anLMRObject [
	| class |
	class := self speciesInstanceClass: anLMRObject.
	^class slotAt: classNamespacesIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesSuperclass: anLMRObject [
	^ anLMRObject slotAt: speciesSuperclassIndex
]

{ #category : 'initialization' }
EggMetacircularRuntime >> speciesSuperclassIndex: anInteger [
	speciesSuperclassIndex := anInteger
]

{ #category : 'initialization' }
EggMetacircularRuntime >> staticBindingForIvar: aSymbol in: receiver [
	| class all slots bytes |
	
	class := self speciesFor: receiver.
	all := Array new: 0.
	[ class != nilObj ]
		whileTrue: [ slots := self classIvars: class.
			slots == nilObj
				ifFalse: [ all := slots slots , all ].
			class := self speciesSuperclass: class ].
	bytes := aSymbol bytes.
	all withIndexDo: [ :ivar :index | ivar bytes = bytes ifTrue: [ ^ index ] ].
	^0
]

{ #category : 'initialization' }
EggMetacircularRuntime >> storeAssociation: association value: anObject [
	association slotAt: 2 put: anObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> stringClass: anLMRObject [
	stringClass := anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> superBehaviorOf: class [
	| superclass |
	superclass := self speciesSuperclass: class.
	^ self speciesInstanceBehavior: superclass
]

{ #category : 'initialization' }
EggMetacircularRuntime >> symbolFromLocal: aSymbol [

	| bytes table symbol |
	knownSymbols at: aSymbol ifPresent: [ :s | ^ s ].
	bytes := aSymbol asByteArray , #[ 0 ].
	table := symbolTable slotAt: 2.
	2 to: table size do: [ :i | 
		symbol := table slotAt: i.
		symbol == nilObj ifFalse: [ 
			symbol bytes = bytes ifTrue: [ ^ symbol ] ] ].
	self error: 'symbol not found'
]

{ #category : 'initialization' }
EggMetacircularRuntime >> symbolTable: anLMRObject [
	symbolTable:= anLMRObject
]

{ #category : 'initialization' }
EggMetacircularRuntime >> temporaryCountOf: anEggObject [
	^(self isBlock: anEggObject)
		ifTrue: [ self blockTempCount: anEggObject ]
		ifFalse: [ self methodTempCount: anEggObject ]

]

{ #category : 'initialization' }
EggMetacircularRuntime >> wordSize [
	^wordSize
]

{ #category : 'initialization' }
EggMetacircularRuntime >> wordSize: anInteger [
	wordSize := anInteger.
	maxSMI := (1 bitShift: wordSize * 8 - 2) - 1.
	minSMI := maxSMI negated - 1
]

{ #category : 'validating' }
EggMetacircularRuntime >> writeKernelAt: anInteger [
	| script |
	script := 'writeKernel
	| writer |
	writer := Kernel loadModule: ''ImageSegment/Writer''. 
	writer write: Kernel at: ' , anInteger asString
		, ' to: ''build/Kernel.ims'''.
	self
		compile: script in: #UndefinedObject;
		sendLocal: #writeKernel to: nilObj
]
