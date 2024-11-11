Class {
	#name : 'EggRuntime',
	#superclass : 'Object',
	#instVars : [
		'methodCache',
		'falseObj',
		'trueObj',
		'nilObj',
		'interpreter',
		'overrides',
		'symbolCache',
		'doesNotUnderstandMethod'
	],
	#pools : [
		'ClosureElementTypes'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : 'services' }
EggRuntime >> argumentCountOf: code [
	^(self isBlock: code)
		        ifTrue: [ self blockArgumentCount: code ]
		        ifFalse: [ self methodArgumentCount: code ]
]

{ #category : 'accessing' }
EggRuntime >> behaviorOf: anObject [
	^self subclassResponsibility
]

{ #category : 'services' }
EggRuntime >> booleanFor: aBoolean [
	^ aBoolean
		ifTrue: [ trueObj ]
		ifFalse: [ falseObj ]
]

{ #category : 'services' }
EggRuntime >> booleanFrom: anObject [
	anObject == falseObj
		ifTrue: [ ^ false ].
	anObject == trueObj
		ifTrue: [ ^ true ].
	self error: 'not a boolean'
]

{ #category : 'initialization' }
EggRuntime >> doesNotUnderstandMethod [

	^doesNotUnderstandMethod
]

{ #category : 'accessing' }
EggRuntime >> evaluatePrimitiveHash: receiver [
	| hash |
	hash := receiver headerHash.
	hash = 0
		ifTrue: [ hash := self nextHash.
			receiver headerHash: hash ].
	^ self newInteger: hash
]

{ #category : 'accessing' }
EggRuntime >> executableCodeWork: code [

	^ self subclassResponsibility
]

{ #category : 'services' }
EggRuntime >> extensionMethodModule: method [

	self subclassResponsibility
]

{ #category : 'initialization' }
EggRuntime >> false [
	^ falseObj
]

{ #category : 'accessing' }
EggRuntime >> flushDispatchCache: aSymbol [

	| cached |
	symbolCache
		at: aSymbol
		ifPresent: [ :messages | messages do: [:m | m flushCache ]].
	cached := methodCache keys select: [ :key |  key key == aSymbol ].
	cached do: [ :key | methodCache removeKey: key]
]

{ #category : 'accessing' }
EggRuntime >> flushDispatchCache: aSymbol in: class [
	| behavior |
	behavior := self speciesInstanceBehavior: class.
	symbolCache at: aSymbol ifPresent: [ :messages | messages do: [:m | m flushCache ]].
	^ methodCache removeKey: aSymbol -> behavior ifAbsent: []
]

{ #category : 'initialization' }
EggRuntime >> initialize [
	methodCache := Dictionary new.
	symbolCache := Dictionary new.
	overrides := Dictionary new
]

{ #category : 'initialization' }
EggRuntime >> initializeInterpreter [
	"interpreter := PowertalkRecursiveInterpreter new runtime: self"

	"interpreter := PowertalkIterativeTreeInterpreter new runtime: self"

	"interpreter := PowertalkLinkedLinearInterpreter new runtime: self"

	interpreter := EggIterativeStackedInterpreter new runtime: self
]

{ #category : 'accessing' }
EggRuntime >> instanceVarOf: receiver at: anInteger [
	^ receiver slotAt: anInteger
]

{ #category : 'accessing' }
EggRuntime >> instanceVarOf: receiver at: anInteger put: value [
	^ receiver slotAt: anInteger put: value
]

{ #category : 'initialization' }
EggRuntime >> interpreter [
	^interpreter
]

{ #category : 'accessing' }
EggRuntime >> isClosure: anObject [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> literalFor: anObject [
	^anObject
]

{ #category : 'accessing' }
EggRuntime >> localMethodTreecodes: method [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> localSymbolFrom: anObject [
	^ anObject bytes allButLast asString asSymbol
]

{ #category : 'accessing' }
EggRuntime >> lookup: aSymbol startingAt: aBehavior [
	^methodCache at: aSymbol -> aBehavior ifAbsentPut: [ self doLookup: aSymbol startingAt: aBehavior ]
]

{ #category : 'accessing' }
EggRuntime >> methodClassBinding: method [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> methodEnvironmentSize: anObject [
	^self subclassResponsibility
]

{ #category : 'services' }
EggRuntime >> methodIsExtension: method [
		self subclassResponsibility 
]

{ #category : 'services' }
EggRuntime >> methodModule: method [
	| species |
	^(self methodIsExtension: method)
		ifTrue: [ self extensionMethodModule: method ]
		ifFalse: [ 
	species := self methodClassBinding: method.
	self speciesModule: species].
]

{ #category : 'accessing' }
EggRuntime >> methodTreecodes: method [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> newBootstrapDictionaryOf: receiver [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> newBytesOf: receiver sized: size [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> newClosureFor: compiledBlock [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> newEnvironmentSized: anInteger [
	^self subclassResponsibility

]

{ #category : 'accessing' }
EggRuntime >> newExecutableCodeFor: anObject [
	^ self subclassResponsibility

]

{ #category : 'accessing' }
EggRuntime >> newInteger: anInteger [
	^self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> newOf: receiver sized: size [
	^ self subclassResponsibility

]

{ #category : 'accessing' }
EggRuntime >> newSlotsOf: receiver [
^self subclassResponsibility
]

{ #category : 'initialization' }
EggRuntime >> nil [
	^nilObj
	
]

{ #category : 'accessing' }
EggRuntime >> registerCache: anSMessage for: symbol [
	| messages |
	messages := symbolCache at: symbol ifAbsentPut: [OrderedCollection new].
	messages add: anSMessage 
]

{ #category : 'accessing' }
EggRuntime >> sendLocal: aSymbol to: receiver [
	^ self sendLocal: aSymbol to: receiver with: {}
]

{ #category : 'accessing' }
EggRuntime >> sendLocal: aSymbol to: receiver with: anArray [
	^interpreter sendLocal: aSymbol to: receiver with: anArray
]

{ #category : 'accessing' }
EggRuntime >> sexpressionsOf: method [

	| treecodes decoder |
	treecodes := self localMethodTreecodes: method.
	decoder := TreecodeDecoder new
		           stream: treecodes readStream;
		           method: method;
		           builder: self.
	^ decoder decodeMethod
]

{ #category : 'accessing' }
EggRuntime >> speciesFor: anObject [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> speciesInstanceBehavior: class [
^	self subclassResponsibility 
]

{ #category : 'services' }
EggRuntime >> speciesModule: method [

	self subclassResponsibility
]

{ #category : 'accessing' }
EggRuntime >> symbolFrom: anObject [
	^anObject
]

{ #category : 'initialization' }
EggRuntime >> symbolFromLocal: aSymbol [
	^self subclassResponsibility
]

{ #category : 'initialization' }
EggRuntime >> temporaryCountOf: anEggObject [
	^(self isBlock: anEggObject)
		ifTrue: [ self blockTempCount: anEggObject ]
		ifFalse: [ self methodTempCount: anEggObject ]

]

{ #category : 'initialization' }
EggRuntime >> true [
	^ trueObj
]
