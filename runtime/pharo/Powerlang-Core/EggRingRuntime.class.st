"
I allow sending messages to objects of the `VirtualSmalltalkImage`.
The messages are interpreted and evaluated with the objects living in
that virtual image, and our semantics tries to mimic as much as possible
the one of the final system.
"
Class {
	#name : #EggRingRuntime,
	#superclass : #EggRuntime,
	#instVars : [
		'image',
		'sexpressionsCache'
	],
	#category : #'Powerlang-Core-Execution-Bootstrap-Ring'
}

{ #category : #'instance creation' }
EggRingRuntime class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : #accessing }
EggRingRuntime >> arrayedSizeOf: anObjectMap [
	^anObjectMap arrayedSize
]

{ #category : #services }
EggRingRuntime >> behaviorOf: anObjectMap [
	^ anObjectMap spec
]

{ #category : #services }
EggRingRuntime >> blockArgumentCount: block [
	^ block argumentCount
]

{ #category : #'own services' }
EggRingRuntime >> blockCapturesSelf: block [
	^ block capturesSelf 
]

{ #category : #services }
EggRingRuntime >> blockExecutableCode: block [
	^block optimizedCode
]

{ #category : #services }
EggRingRuntime >> blockExecutableCode: block put: anObject [
	block optimizedCode: anObject
]

{ #category : #services }
EggRingRuntime >> blockExecutionTree: block [
	^ block executionTree
]

{ #category : #services }
EggRingRuntime >> blockMethod: anObjectMap [
	^ anObjectMap method
]

{ #category : #services }
EggRingRuntime >> blockTempCount: block [
	^ block tempCount
]

{ #category : #services }
EggRingRuntime >> closureBlock: aClosureMap [
	^aClosureMap block
]

{ #category : #services }
EggRingRuntime >> closureHome: anObjectMap [
	^ anObjectMap home
]

{ #category : #accessing }
EggRingRuntime >> compile: anRGMethod [
	| class |
	class := image speciesFor: anRGMethod parent.
	^ SCompiler new
		forClass: class;
		compile: anRGMethod sourceCode
]

{ #category : #accessing }
EggRingRuntime >> doLookup: aSymbol startingAt: aBehavior [
	| behavior m c smethod |
	self ASSERT: aSymbol !== #error:.
	behavior := aBehavior.
	[ m := self methodFor: aSymbol in: behavior.
	m
		ifNotNil: [ smethod := self compile: m.
			^ self transferMethodLiterals: smethod ].
	behavior := behavior superclass.
	behavior notNil ] whileTrue.
	^ aBehavior isMeta
		ifTrue: [ c := aBehavior environment at: #Class.
			self doLookup: aSymbol startingAt: c ]
]

{ #category : #accessing }
EggRingRuntime >> executableCodeWork: code [
	^code
]

{ #category : #services }
EggRingRuntime >> extensionMethodModule: method [

	^ method module
]

{ #category : #services }
EggRingRuntime >> homeEnvironmentOf: aClosureMap [
	^ aClosureMap slotAt: 2
]

{ #category : #accessing }
EggRingRuntime >> image [
	^image
]

{ #category : #accessing }
EggRingRuntime >> image: aPowertalkImage [
	image := aPowertalkImage.
	nilObj := image nil.
	trueObj := image true.
	falseObj := image false.
	self
		initializeEmulationOverrides;
		initializeInterpreter
]

{ #category : #accessing }
EggRingRuntime >> initializeDNU [
	| proto selector |
	proto := image classNamed: #ProtoObject.
	selector := image newSymbol: #_doesNotUnderstand:with:.
	doesNotUnderstandMethod := self sendLocal: #at: to: proto instanceBehavior methods with: {selector}.

]

{ #category : #initialization }
EggRingRuntime >> initializeEmulationOverrides [
	| classes |
	classes := image vmPrimitivesSpec allExtensionClasses.
	classes
		do: [ :class | 
			class methods do: [ :m | self override: class name with: m ].
			class metaclass methods
				do: [ :m | self override: class metaclass name with: m ] ]
]

{ #category : #services }
EggRingRuntime >> integerFrom: anObjectMap [
	anObjectMap isImmediate
		ifTrue: [ ^ anObjectMap value ].
		self halt.
	^ anObjectMap spec name == #LargePositiveInteger
		ifTrue: [ anObjectMap bytes asLittleEndianPositiveInteger ]
		ifFalse: [ anObjectMap bytes asLittleEndianNegativeInteger ]
]

{ #category : #accessing }
EggRingRuntime >> isBlock: anSCompiledMethod [
	^anSCompiledMethod isBlock
]

{ #category : #services }
EggRingRuntime >> isClosure: anObjectMap [
	^anObjectMap class = ProtoeggClosure
]

{ #category : #services }
EggRingRuntime >> isExecutableCode: code [

	^ code !== nil and: [code !== nilObj]
]

{ #category : #accessing }
EggRingRuntime >> literalFor: anObject [
	^ image transferLiteral: anObject
]

{ #category : #accessing }
EggRingRuntime >> loadAssociationValue: association [
	^association value
]

{ #category : #services }
EggRingRuntime >> localMethodTreecodes: anSCompiledMethod [

	^ self methodTreecodes: anSCompiledMethod
]

{ #category : #services }
EggRingRuntime >> localSymbolFrom: anObjectMap [
	^ anObjectMap symbol
]

{ #category : #accessing }
EggRingRuntime >> lookupAssociationFor: aSymbol in: dictionary [
^dictionary
				associationAt: aSymbol
				ifPresent: [ :assoc | assoc]
]

{ #category : #accessing }
EggRingRuntime >> method: anSCompiledMethod literalAt: index [
	^anSCompiledMethod at: index
]

{ #category : #services }
EggRingRuntime >> methodArgumentCount: method [
	^ method argumentCount
]

{ #category : #services }
EggRingRuntime >> methodClassBinding: method [
	^ method classBinding
]

{ #category : #services }
EggRingRuntime >> methodEnvironmentSize: anSCompiledMethod [
	^anSCompiledMethod environmentCount
]

{ #category : #services }
EggRingRuntime >> methodExecutableCode: anSCompiledMethod [
	^ anSCompiledMethod optimizedCode
]

{ #category : #services }
EggRingRuntime >> methodExecutableCode: method put: anObject [

	method optimizedCode: anObject.
		^anObject 
		
]

{ #category : #accessing }
EggRingRuntime >> methodFor: aSymbol in: anRGBehavior [
	overrides at: anRGBehavior->aSymbol ifPresent: [:m | ^m].
	^anRGBehavior methodNamed: aSymbol
]

{ #category : #services }
EggRingRuntime >> methodIsExtension: method [

	^ method isExtension
]

{ #category : #services }
EggRingRuntime >> methodTempCount: method [
	^ method tempCount
]

{ #category : #services }
EggRingRuntime >> methodTreecodes: anSCompiledMethod [

	^ anSCompiledMethod treecodes
]

{ #category : #accessing }
EggRingRuntime >> moduleNamespace: anObjectMap [ 
	^ anObjectMap namespace
]

{ #category : #accessing }
EggRingRuntime >> newArraySized: anInteger [
	^ image newArraySized: anInteger
]

{ #category : #accessing }
EggRingRuntime >> newBootstrapDictionaryOf: aSpeciesMap [
	^ image newBootstrapDictionaryOf: aSpeciesMap spec instanceSide
]

{ #category : #accessing }
EggRingRuntime >> newBytesOf:  aSpeciesMap sized: size [
	^ image newOf: aSpeciesMap spec instanceSide sized: size
]

{ #category : #accessing }
EggRingRuntime >> newClosureFor: compiledBlock [
	| closure |
	closure :=  image newClosure: compiledBlock environmentCount.
	^closure
		block: compiledBlock

]

{ #category : #accessing }
EggRingRuntime >> newCompiledMethod [
	^ SCompiledMethod new
]

{ #category : #accessing }
EggRingRuntime >> newEnvironmentSized: anInteger [
	^ image newArraySized: anInteger
]

{ #category : #accessing }
EggRingRuntime >> newExecutableCodeFor: anObject [
	^anObject
]

{ #category : #accessing }
EggRingRuntime >> newInteger: anInteger [
	^image newInteger: anInteger
]

{ #category : #accessing }
EggRingRuntime >> newOf: aSpeciesMap sized: size [
	^ image newOf: aSpeciesMap spec instanceSide sized: size
]

{ #category : #accessing }
EggRingRuntime >> newSlotsOf: aSpeciesMap [
	^image newSlotsOf: aSpeciesMap spec instanceSide sized: 0
]

{ #category : #services }
EggRingRuntime >> newSymbol: aSymbol [
	^ image newSymbol: aSymbol
]

{ #category : #services }
EggRingRuntime >> override: classname with: rgMethod [
	| species selector method override |
	species := image specs at: classname.
	selector := rgMethod selector.
	method := species methodNamed: selector.
	override := method copy sourceCode: rgMethod sourceCode.
	overrides at: species -> selector put: override
]

{ #category : #accessing }
EggRingRuntime >> override: assoc withPrimitive: primitive [
	| species selector method override count source |
	species := image specs at: assoc key.
	selector := assoc value.
	source := String
		streamContents: [ :s | 
			selector numArgs = 0
				ifTrue: [ s nextPutAll: selector ]
				ifFalse: [ count := 1.
					selector keywords
						do: [ :keyword | 
							s
								nextPutAll: keyword;
								nextPutAll: ' arg';
								nextPutAll: count asString;
								space.
							count := count + 1 ] ].
			s nextPutAll: '<primitive: ' , primitive , '>' ].
	method := species methodNamed: selector.
	override := method copy sourceCode: source.
	overrides at: species -> selector put: override
]

{ #category : #accessing }
EggRingRuntime >> removeBootstrapDictionaryOverrides [
self
		removeOverride: #'Namespace class' -> #new

]

{ #category : #accessing }
EggRingRuntime >> removeOverride: assoc [
	| species selector symbol |
	species := image specs at: assoc key.
	selector := assoc value.
	overrides removeKey: species -> selector.
	methodCache removeKey: selector -> species ifAbsent: nil.
	symbol := self symbolFromLocal: selector.
	symbolCache
		at: symbol
		ifPresent: [ :messages | messages do: #flushCache ]
]

{ #category : #accessing }
EggRingRuntime >> speciesFor: anObjectMap [
	^ image speciesFor: anObjectMap spec
]

{ #category : #accessing }
EggRingRuntime >> speciesModule: aSpeciesMap [
	^ aSpeciesMap module
]

{ #category : #accessing }
EggRingRuntime >> speciesNamespaces: aSpeciesMap [
	^ aSpeciesMap namespaces
]

{ #category : #accessing }
EggRingRuntime >> speciesSuperclass: aSpeciesMap [
	^ aSpeciesMap superclass
]

{ #category : #accessing }
EggRingRuntime >> staticBindingForIvar: aSymbol in: receiver [
	^receiver allSlotNames indexOf: aSymbol.
]

{ #category : #accessing }
EggRingRuntime >> storeAssociation: association value: anObject [
	association value: anObject
]

{ #category : #accessing }
EggRingRuntime >> superBehaviorOf: aSpeciesMap [
	^ aSpeciesMap superclass instanceSpec
]

{ #category : #services }
EggRingRuntime >> symbolFrom: anObjectMap [
	^ anObjectMap symbol
]

{ #category : #services }
EggRingRuntime >> symbolFromLocal: aSymbol [
	^ image newSymbol: aSymbol
]

{ #category : #accessing }
EggRingRuntime >> transferLiteral: anObject [
	^image transferLiteral: anObject
]

{ #category : #accessing }
EggRingRuntime >> transferMethodLiterals: method [
	| class |
	method withIndexDo: [:literal :i | 
		class := literal class.
		((class inheritsFrom: ProtoeggObject)
			or: [ class = SCompiledBlock ])
			ifFalse: [ method at: i put: (image transferLiteralDeep: literal) ] ].
	^ method
]
