Class {
	#name : #PowertalkMetacircularRuntime,
	#superclass : #PowertalkRuntime,
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
		'methodAstcodesIndex',
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
		'processStackSPIndex'
	],
	#pools : [
		'SCompiledBlockFlags',
		'SCompiledMethodFlags'
	],
	#category : #'Powerlang-Core-Execution-Metacircular'
}

{ #category : #initialization }
PowertalkMetacircularRuntime >> addSymbol: aSymbol [
	| string |
	string := self newString: aSymbol asString.
	^ self sendLocal: #asSymbol to: string
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> arrayClass: anLMRObject [
	arrayClass := anLMRObject 
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> arrayedSizeOf: anLMRObject [
	| species ivars |
	anLMRObject isImmediate ifTrue: [ ^0 ].
	species := self speciesFor: anLMRObject.
	ivars := self speciesInstanceSize: species.
	^anLMRObject size - ivars
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> associationValue: association [

	^association slotAt: 2
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorClass: anLMRObject [
	^ anLMRObject slotAt: behaviorClassIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorClassIndex: anInteger [
	behaviorClassIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorClass_: anLMRObject [
	behaviorClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorMethodDictionary: anLMRObject [
	^ anLMRObject slotAt: behaviorMethodDictionaryIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorMethodDictionaryIndex: anInteger [
	behaviorMethodDictionaryIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorNext: anLMRObject [
	^ anLMRObject slotAt: behaviorNextIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorNextIndex: anInteger [
	behaviorNextIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> behaviorOf: anLMRObject [
	^anLMRObject isImmediate ifTrue: [ self smallIntegerBehavior ] ifFalse: [anLMRObject behavior]
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockArgumentCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: BlockArgCount
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockCapturesHome: block [
	| flags |
	flags := block slotAt: methodFlagsIndex.
	^ flags value anyMask: BlockCapturesHome
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockCapturesSelf: block [
	| flags |
	flags := block slotAt: methodFlagsIndex.
	^ flags value anyMask: BlockCapturesSelf
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockClass: anLMRObject [
	blockClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockEnvironmentCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: BlockEnvCount
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockExecutableCode: anLMRObject [

	^ self methodExecutableCode: anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockExecutableCode: anLMRObject put: anObject [
	^ self methodExecutableCode: anLMRObject put: anObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockExecutionTree: anLMRObject [
	^ anLMRObject slotAt: compiledCodeExecutableCodeIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockMethod: anLMRObject [
	^ anLMRObject slotAt: blockMethodIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockMethodIndex: anInteger [
	blockMethodIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> blockTempCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: BlockTempCount
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> bootstrapper [
	^bootstrapper
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> bootstrapper: aBootstrapper [
	bootstrapper := aBootstrapper
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> byteArrayClass: anLMRObject [
	byteArrayClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> classIvars: anLMRObject [
	^ anLMRObject slotAt: speciesIvarsIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> classModule: class [
	^ class slotAt: classModuleIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> classModuleIndex: anInteger [
	classModuleIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> className: anLMRObject [
	^ anLMRObject slotAt: classNameIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> classNameIndex: anInteger [
	classNameIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> classNamespacesIndex: anInteger [
	classNamespacesIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> closureBlock: closure [ 
	^closure slotAt: closureBlockIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> closureBlockIndex: anInteger [
	closureBlockIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> closureClass: anLMRObject [
	closureClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> closureHome: closure [
	| block |
	block := self closureBlock: closure.
	(self blockCapturesHome: block)
		ifFalse: [ self error: 'closure has no home' ].
	^ (self blockCapturesSelf: block)
		ifTrue: [ closure at: 2 ]
		ifFalse: [ closure at: 1 ]
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> dictionaryTable: anLMRObject [
	^anLMRObject slotAt: dictionaryTableIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> dictionaryTableIndex: anInteger [
	dictionaryTableIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> doLookup: aSymbol startingAt: aBehavior [
	| behavior m |
	behavior := aBehavior.
	[ m := self methodFor: aSymbol in: behavior.
	m ifNotNil: [ ^m ].
	behavior := self behaviorNext: behavior.
	behavior != nilObj ] whileTrue.
	^ nil
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> doesNotUnderstandMethod: anEggObject [
	doesNotUnderstandMethod := anEggObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> executableCodeWork: anLMRExecutableCode [
	self ASSERT: anLMRExecutableCode !== nilObj.
	^anLMRExecutableCode code
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> extensionMethodModule: anLMRObject [
	| association |
	association := anLMRObject slotAt: anLMRObject size.
	^ self associationValue: association
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> fixOverrides [
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

{ #category : #initialization }
PowertalkMetacircularRuntime >> floatClass: anLMRObject [

	floatClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> hashFor: anLMRObject [
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

{ #category : #initialization }
PowertalkMetacircularRuntime >> initialize [
	lastHash := 1.
	super initialize
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> integerFrom: anLMRObject [
	| behavior class |
	anLMRObject isImmediate
		ifTrue: [ ^ anLMRObject value ].
	behavior := self behaviorOf: anLMRObject.
	class := self behaviorClass: behavior.
	^ class == largePositiveIntegerClass
		ifTrue: [ anLMRObject bytes asLittleEndianPositiveInteger ]
		ifFalse: [ anLMRObject bytes asLittleEndianNegativeInteger ]
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> isBlock: compiledCode [
	^ (self behaviorClass: compiledCode behavior) ==
	blockClass 
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> isExecutableCode: code [
	^code class == EggExecutableCode
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> isMetaclass: anLMRObject [
	^ (self speciesFor: anLMRObject) == metaclassClass
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> kernel [
	^kernel
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> kernel: anLMRObject [ 
	kernel := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> knownSymbols: associations [
	knownSymbols := Dictionary withAll: associations
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> largeNegativeIntegerClass: anLMRObject [
	largeNegativeIntegerClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> largePositiveIntegerClass: anLMRObject [
	largePositiveIntegerClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> loadAssociationValue: association [
	^ association slotAt: 2.

]

{ #category : #initialization }
PowertalkMetacircularRuntime >> loadModule: symbol [
	^ bootstrapper loadModule: symbol asLocalString
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> localMethodAstcodes: method [

	^ (self methodAstcodes: method) bytes
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> lookupAssociationFor: aSymbol in: dictionary [
	|  table assoc key |
	table := self dictionaryTable: dictionary.
	2 to: table size do: [ :index | 
		assoc := table slotAt: index.
		assoc == nilObj ifFalse: [key := assoc slotAt: 1. key == aSymbol
			ifTrue: [ ^ assoc] ]].
	^ nil
	
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> metaclassClass: anLMRObject [
	metaclassClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> metaclassInstanceClass: anLMRObject [
	^ anLMRObject slotAt: metaclassInstanceClassIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> metaclassInstanceClassIndex: anInteger [
	metaclassInstanceClassIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> method: method literalAt: index [
	^ method slotAt: methodInstSize + index
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodArgumentCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: ArgCount
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodAstcodes: anLMRObject [
	^ anLMRObject slotAt: methodAstcodesIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodAstcodesIndex: anInteger [
	methodAstcodesIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodClass: anLMRObject [
	methodClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodClassBinding: anLMRObject [
	^ anLMRObject slotAt: methodClassBindingIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodClassBindingIndex: anInteger [
	methodClassBindingIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodEnvironmentSize: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: EnvCount
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodExecutableCode: anLMRObject [

^anLMRObject slotAt: compiledCodeExecutableCodeIndex.
	
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodExecutableCode: anLMRObject put: anObject [

	^ anLMRObject slotAt: compiledCodeExecutableCodeIndex put: anObject 
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodExecutableCodeIndex: anInteger [
	compiledCodeExecutableCodeIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodFlagsIndex: anInteger [
	methodFlagsIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodFor: aSymbol in: behavior [
	| md table  |
	overrides at: behavior -> aSymbol ifPresent: [ :m | ^ m ].
	md := self behaviorMethodDictionary: behavior.
	table := self dictionaryTable: md.
	2 to: table size by: 2 do: [ :index | 
		(table slotAt: index) == aSymbol
			ifTrue: [ ^ table slotAt: index + 1 ] ].
	^ nil
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodInstSize: anInteger [
	methodInstSize := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodIsExtension: anLMRObject [

	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value anyMask: IsExtension
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodSelector: anLMRObject [

	^ anLMRObject slotAt: methodSelectorIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodSelectorIndex: anInteger [

	methodSelectorIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> methodTempCount: anLMRObject [
	| flags |
	flags := anLMRObject slotAt: methodFlagsIndex.
	^ flags value bitsAt: TempCount
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> moduleNamespace: anLMRObject [
	^anLMRObject slotAt: moduleNamespaceIndex

]

{ #category : #initialization }
PowertalkMetacircularRuntime >> moduleNamespaceIndex: anInteger [

	moduleNamespaceIndex := anInteger
]

{ #category : #validating }
PowertalkMetacircularRuntime >> nativizeForLMR [
	| script |
	script := 'nativizeForLMR
	lmr := Kernel loadModule: ''Nativization/LMR''. 
	lmr nativizeLoadedModules'.
	self
		compile: script in: #UndefinedObject;
		sendLocal: #nativizeForLMR to: nilObj
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newArray: anArray [
| result |
result := 	self newArraySized: anArray size.
	anArray withIndexDo: [ :elem :i | result at: i put: elem ].
	^result
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newArraySized: anInteger [
	| behavior header |
	behavior := self speciesInstanceBehavior: arrayClass.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: true named: false;
		size: anInteger;
		hash: 0.
	^ EggSlotObject new header: header
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newByteArray: aByteArray [

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

{ #category : #initialization }
PowertalkMetacircularRuntime >> newBytes: species size: anInteger [
	| behavior header |
	behavior := self speciesInstanceBehavior: species.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: true named: false;
		size: anInteger;
		hash: 0.
	^ EggByteObject new
		header: header;
		bytes: (ByteArray new: anInteger)
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newBytesOf: species sized: size [
	^ self newBytes: species size: size
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newCharacter: aCharacter [
	| value |
	value := self newInteger: aCharacter asInteger.
	^self sendLocal: #asCharacter to: value.

]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newClosureFor: compiledBlock [
	| size closure |
	size := self blockEnvironmentCount: compiledBlock.
	closure := self newSlots: closureClass size:  size.
	closure slotAt: closureBlockIndex put: compiledBlock.
	^ closure
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newCompiledMethod [
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

{ #category : #initialization }
PowertalkMetacircularRuntime >> newEnvironmentSized: anInteger [
	^ self newArraySized: anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newExecutableCodeFor: anObject [
		| behavior header |
	behavior := self speciesInstanceBehavior: arrayClass.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: true named: false;
		size: 0;
		hash: 0.

	 ^EggExecutableCode new header: header; code: anObject.

]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newFloat: aFloat [

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

{ #category : #initialization }
PowertalkMetacircularRuntime >> newInteger: anInteger [
	anInteger > maxSMI
		ifTrue: [ ^ self newLargePositiveInteger: anInteger ].
	anInteger < minSMI
		ifTrue: [ ^ self newLargeNegativeInteger: anInteger ].
	^ EggSmallInteger new value: anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newLargeNegativeInteger: anInteger [
	| size bytes byte result complement |
	size := (anInteger bytesCount alignedTo: 2) max: wordSize.
	complement := anInteger negated - 1.
	bytes := ByteArray new: size withAll: 16rFF.
	1 to: anInteger bytesCount do: [ :i | 
		byte := 255 - (complement byteAt: i).
		bytes at: i put: byte ].
	(bytes at: size) < 128 ifTrue: [ bytes := bytes, #[16rFF 16rFF] ].
	result := self newBytes: largeNegativeIntegerClass size: bytes size.
	^result bytes: bytes

]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newLargePositiveInteger: anInteger [
	| size bytes result |
	size := (anInteger bytesCount alignedTo: 2) max: wordSize.
	bytes := anInteger asByteArrayOfSize: size.
	result := self newBytes: largePositiveIntegerClass size: size.
	^ result bytes: bytes reversed
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newOf: aSpecies sized: anInteger [
	^(self speciesIsBytes: aSpecies)
		ifTrue: [ self newBytes: aSpecies size: anInteger ]
		ifFalse: [ self newSlots: aSpecies size: anInteger ]
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newSlots: class [
	^self newSlots: class size: 0
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newSlots: class size: anInteger [
	| ivars behavior header result |
	ivars := self speciesInstanceSize: class.
	behavior := self speciesInstanceBehavior: class.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: false named: true;
		size: ivars + anInteger;
		hash: 0.
	result := class == behaviorClass
		ifTrue: [ EggBehaviorObject new runtime: self]
		ifFalse: [ EggSlotObject new ].
	^ result
		header: header;
		nilSlots: nilObj
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newSlotsOf: class [
	^ self newSlots: class size: 0
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newSmallInteger: anInteger [
	^ EggSmallInteger new value: anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> newString: aString [
	| behavior header bytes |
	behavior := self speciesInstanceBehavior: stringClass.
	bytes := aString asByteArray copyWith: 0.
	header := EggObjectHeader new
		behavior: behavior;
		bytes: false arrayed: true named: false;
		size: bytes size;
		hash: 0.
	^ EggByteObject new
		header: header;
		bytes: bytes
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> nil: n true: t false: f [
	nilObj := n.
	trueObj := t.
	falseObj := f
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> override: assoc with: method [
	overrides at: assoc put: method
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> print: anLMRObject on: aStream [
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

{ #category : #initialization }
PowertalkMetacircularRuntime >> printBehavior: anLMRBehavior on: aStream [
	| species name |
	species := self behaviorClass: anLMRBehavior.
	name := self speciesLocalName: species.
	aStream
		nextPutAll: '<' , name , ' instanceBehavior>'
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> processStackSP: anLMRObject [

	^ anLMRObject slotAt: processStackSPIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> processStackSPIndex: anInteger [
 processStackSPIndex := anInteger
]

{ #category : #validating }
PowertalkMetacircularRuntime >> readKernel [
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

{ #category : #initialization }
PowertalkMetacircularRuntime >> removeOverride: assoc [
	| species selector |
	species := assoc key.
	selector := assoc value.
	overrides removeKey: species -> selector.
	methodCache removeKey: selector -> species ifAbsent: nil.
	symbolCache
		at: selector
		ifPresent: [ :messages | messages do: #flushCache ]
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> smallIntegerBehavior [
	^self speciesInstanceBehavior: smallIntegerClass
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> smallIntegerClass: anLMRObject [
	smallIntegerClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesFor: anLMRObject [
	| behavior |
	behavior := self behaviorOf: anLMRObject.
	^self behaviorClass: behavior.


]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesFormatIndex: anInteger [
	speciesFormatIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesInstanceBehavior: anLMRObject [
	^anLMRObject slotAt: speciesInstanceBehaviorIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesInstanceBehaviorIndex: anInteger [
	speciesInstanceBehaviorIndex := anInteger 
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesInstanceClass: anLMRObject [
	| metaclass |
	metaclass := self isMetaclass: anLMRObject.
	^ metaclass
		ifTrue: [ self metaclassInstanceClass: anLMRObject ]
		ifFalse: [ anLMRObject ]
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesInstanceSize: anLMRObject [
	^ (anLMRObject slotAt: speciesFormatIndex) value bitAnd: 16r7F.
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesIsBytes: anLMRObject [
	^ (anLMRObject slotAt: speciesFormatIndex) value noMask: 16r4000
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesIvarsIndex: anInteger [
	speciesIvarsIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesLocalName: species [
	| name class |
	(self isMetaclass: species) ifFalse: [
		name :=self className: species.
		^name asLocalString].
	
	class := self metaclassInstanceClass: species. 
	name := self className: class.
	^ name asLocalString, ' class'
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesModule: species [
	| class |
	(self isMetaclass: species)
		ifFalse: [ ^ self classModule: species ].
	class := self metaclassInstanceClass: species.
	^ self classModule: class
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesNamespaces: anLMRObject [
	| class |
	class := self speciesInstanceClass: anLMRObject.
	^class slotAt: classNamespacesIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesSuperclass: anLMRObject [
	^ anLMRObject slotAt: speciesSuperclassIndex
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> speciesSuperclassIndex: anInteger [
	speciesSuperclassIndex := anInteger
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> staticBindingForIvar: aSymbol in: receiver [
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

{ #category : #initialization }
PowertalkMetacircularRuntime >> storeAssociation: association value: anObject [
	association slotAt: 2 put: anObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> stringClass: anLMRObject [
	stringClass := anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> superBehaviorOf: class [
	| superclass |
	superclass := self speciesSuperclass: class.
	^ self speciesInstanceBehavior: superclass
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> symbolFromLocal: aSymbol [

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

{ #category : #initialization }
PowertalkMetacircularRuntime >> symbolTable: anLMRObject [
	symbolTable:= anLMRObject
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> wordSize [
	^wordSize
]

{ #category : #initialization }
PowertalkMetacircularRuntime >> wordSize: anInteger [
	wordSize := anInteger.
	maxSMI := (1 bitShift: wordSize * 8 - 2) - 1.
	minSMI := maxSMI negated - 1
]

{ #category : #validating }
PowertalkMetacircularRuntime >> writeKernelAt: anInteger [
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
