"
I allow sending messages to objects of the `VirtualSmalltalkImage`.
The messages are interpreted and evaluated with the objects living in
that virtual image, and our semantics tries to mimic as much as possible
the one of the final system.
"
Class {
	#name : 'EggBootstrapRuntime',
	#superclass : 'EggRuntime',
	#instVars : [
		'image',
		'sexpressionsCache'
	],
	#category : 'Powerlang-Core-Execution-Bootstrap',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Bootstrap'
}

{ #category : 'instance creation' }
EggBootstrapRuntime class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'accessing' }
EggBootstrapRuntime >> arrayedSizeOf: aProtoeggObject [

	^ aProtoeggObject arrayedSize
]

{ #category : 'services' }
EggBootstrapRuntime >> behaviorOf: aProtoeggObject [

	^ aProtoeggObject spec
]

{ #category : 'services' }
EggBootstrapRuntime >> blockArgumentCount: block [
	^ block argumentCount
]

{ #category : 'own services' }
EggBootstrapRuntime >> blockCapturesSelf: block [
	^ block capturesSelf 
]

{ #category : 'services' }
EggBootstrapRuntime >> blockExecutableCode: block [
	^block optimizedCode
]

{ #category : 'services' }
EggBootstrapRuntime >> blockExecutableCode: block put: anObject [
	block optimizedCode: anObject
]

{ #category : 'services' }
EggBootstrapRuntime >> blockExecutionTree: block [
	^ block executionTree
]

{ #category : 'services' }
EggBootstrapRuntime >> blockMethod: block [

	^ block method
]

{ #category : 'services' }
EggBootstrapRuntime >> blockTempCount: block [
	^ block tempCount
]

{ #category : 'services' }
EggBootstrapRuntime >> closureBlock: closure [

	^ closure block
]

{ #category : 'services' }
EggBootstrapRuntime >> closureHome: closure [

	^ closure home
]

{ #category : 'services' }
EggBootstrapRuntime >> closureHomeEnvironment: closure [

	^ closure slotAt: 2
]

{ #category : 'accessing' }
EggBootstrapRuntime >> compile: method [
	| class |
	class := image speciesFor: method classBinding.
	^ SCompiler new
		forClass: class;
		compile: method source
]

{ #category : 'accessing' }
EggBootstrapRuntime >> doLookup: aSymbol startingAt: aSpecies [
	| species m c smethod |
	self ASSERT: aSymbol !== #error:.
	species := aSpecies.
	[ m := self methodFor: aSymbol in: species.
	m
		ifNotNil: [ smethod := self compile: m.
			^ self transferMethodLiterals: smethod ].
	species := species superclass.
	species notNil ] whileTrue.
	^ aSpecies isMetaclass
		ifTrue: [ c := image => #Class.
			self doLookup: aSymbol startingAt: c]
]

{ #category : 'accessing' }
EggBootstrapRuntime >> executableCodeWork: code [
	^code
]

{ #category : 'services' }
EggBootstrapRuntime >> extensionMethodModule: method [

	^ method module
]

{ #category : 'accessing' }
EggBootstrapRuntime >> image [
	^image
]

{ #category : 'accessing' }
EggBootstrapRuntime >> image: anEggBootstrapImage [

	image := anEggBootstrapImage.
	nilObj := image nil.
	trueObj := image true.
	falseObj := image false.
	self
		initializeEmulationOverrides;
		initializeInterpreter
]

{ #category : 'accessing' }
EggBootstrapRuntime >> initializeDNU [
	| proto selector |
	proto := image classNamed: #ProtoObject.
	selector := image newSymbol: #_doesNotUnderstand:with:.
	doesNotUnderstandMethod := self sendLocal: #at: to: proto instanceBehavior methods with: {selector}.

]

{ #category : 'initialization' }
EggBootstrapRuntime >> initializeEmulationOverrides [
	| classes |
	classes := image vmPrimitivesSpec extendedClasses.
	classes
		do: [ :class | 
			class methods do: [ :m | self override: class name with: m ].
			class metaclass methods
				do: [ :m | self override: class metaclass name with: m ] ]
]

{ #category : 'services' }
EggBootstrapRuntime >> integerFrom: anObjectMap [

	anObjectMap isImmediate ifTrue: [ ^ anObjectMap value ].
	self halt.
	^ anObjectMap spec name == #LargePositiveInteger
		  ifTrue: [ anObjectMap bytes asLittleEndianPositiveInteger ]
		  ifFalse: [ anObjectMap bytes asLittleEndianNegativeInteger ]
]

{ #category : 'accessing' }
EggBootstrapRuntime >> isBlock: anSCompiledMethod [
	^anSCompiledMethod isBlock
]

{ #category : 'services' }
EggBootstrapRuntime >> isClosure: aProtoeggObject [

	^ aProtoeggObject class = ProtoeggClosure
]

{ #category : 'services' }
EggBootstrapRuntime >> isExecutableCode: code [

	^ code !== nil and: [code !== nilObj]
]

{ #category : 'accessing' }
EggBootstrapRuntime >> literalFor: anObject [
	^ image transferLiteral: anObject
]

{ #category : 'accessing' }
EggBootstrapRuntime >> loadAssociationValue: association [
	^association value
]

{ #category : 'services' }
EggBootstrapRuntime >> localMethodTreecodes: anSCompiledMethod [

	^ self methodTreecodes: anSCompiledMethod
]

{ #category : 'services' }
EggBootstrapRuntime >> localSymbolFrom: aProtoeggObject [

	^ aProtoeggObject symbol
]

{ #category : 'accessing' }
EggBootstrapRuntime >> lookupAssociationFor: aSymbol in: dictionary [
^dictionary
				associationAt: aSymbol
				ifPresent: [ :assoc | assoc]
]

{ #category : 'accessing' }
EggBootstrapRuntime >> method: anSCompiledMethod literalAt: index [
	^anSCompiledMethod at: index
]

{ #category : 'services' }
EggBootstrapRuntime >> methodArgumentCount: method [
	^ method argumentCount
]

{ #category : 'services' }
EggBootstrapRuntime >> methodClassBinding: method [
	^ method classBinding
]

{ #category : 'services' }
EggBootstrapRuntime >> methodEnvironmentSize: anSCompiledMethod [
	^anSCompiledMethod environmentCount
]

{ #category : 'services' }
EggBootstrapRuntime >> methodExecutableCode: anSCompiledMethod [
	^ anSCompiledMethod optimizedCode
]

{ #category : 'services' }
EggBootstrapRuntime >> methodExecutableCode: method put: anObject [

	method optimizedCode: anObject.
		^anObject 
		
]

{ #category : 'accessing' }
EggBootstrapRuntime >> methodFor: aSymbol in: aSpeciesSpec [
	overrides at: aSpeciesSpec->aSymbol ifPresent: [:m | ^m].
	^aSpeciesSpec methodNamed: aSymbol
]

{ #category : 'services' }
EggBootstrapRuntime >> methodIsExtension: method [

	^ method isExtension
]

{ #category : 'services' }
EggBootstrapRuntime >> methodNeedsEnvironment: anSCompiledMethod [
	^anSCompiledMethod hasEnvironment
]

{ #category : 'services' }
EggBootstrapRuntime >> methodTempCount: method [
	^ method tempCount
]

{ #category : 'services' }
EggBootstrapRuntime >> methodTreecodes: anSCompiledMethod [

	^ anSCompiledMethod treecodes
]

{ #category : 'accessing' }
EggBootstrapRuntime >> moduleNamespace: aProtoeggObject [

	^ aProtoeggObject namespace
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newArraySized: anInteger [
	^ image newArraySized: anInteger
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newBootstrapDictionaryOf: aProtoeggSpecies [

	^ image newBootstrapDictionaryOf: aProtoeggSpecies spec instanceSide
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newBytesOf:  aProtoeggSpecies sized: size [
	^ image newOf: aProtoeggSpecies spec instanceSide sized: size
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newClosureFor: compiledBlock [
	| closure |
	closure :=  image newClosure: compiledBlock environmentCount.
	^closure
		block: compiledBlock

]

{ #category : 'accessing' }
EggBootstrapRuntime >> newCompiledMethod [
	^ SCompiledMethod new
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newEnvironmentSized: anInteger [
	^ image newArraySized: anInteger
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newExecutableCodeFor: anObject [
	^anObject
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newInteger: anInteger [
	^image newInteger: anInteger
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newOf: aProtoeggSpecies sized: size [
	^ image newOf: aProtoeggSpecies spec instanceSide sized: size
]

{ #category : 'accessing' }
EggBootstrapRuntime >> newSlotsOf: aProtoeggSpecies [
	^image newSlotsOf: aProtoeggSpecies spec instanceSide sized: 0
]

{ #category : 'services' }
EggBootstrapRuntime >> newSymbol: aSymbol [
	^ image newSymbol: aSymbol
]

{ #category : 'services' }
EggBootstrapRuntime >> override: classname with: aMethodSpec [
	| species selector method override |
	species := image specs at: classname.
	selector := aMethodSpec selector.
	method := species methodNamed: selector.
	override := method copy source: aMethodSpec sourceCode.
	overrides at: species -> selector put: override
]

{ #category : 'accessing' }
EggBootstrapRuntime >> override: assoc withPrimitive: primitive [
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

{ #category : 'accessing' }
EggBootstrapRuntime >> removeBootstrapDictionaryOverrides [
self
		removeOverride: #'Namespace class' -> #new

]

{ #category : 'accessing' }
EggBootstrapRuntime >> removeOverride: assoc [
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

{ #category : 'accessing' }
EggBootstrapRuntime >> speciesFor: aProtoeggObject [

	^ image speciesFor: aProtoeggObject spec
]

{ #category : 'accessing' }
EggBootstrapRuntime >> speciesModule: aProtoeggSpecies [

	^ aProtoeggSpecies module
]

{ #category : 'accessing' }
EggBootstrapRuntime >> speciesNamespaces: aProtoeggSpecies [
	^ aProtoeggSpecies namespaces
]

{ #category : 'accessing' }
EggBootstrapRuntime >> speciesSuperclass: aProtoeggSpecies [
	^ aProtoeggSpecies superclass
]

{ #category : 'accessing' }
EggBootstrapRuntime >> staticBindingForIvar: aSymbol in: receiver [
	^receiver allSlotNames indexOf: aSymbol.
]

{ #category : 'accessing' }
EggBootstrapRuntime >> storeAssociation: association value: anObject [
	association value: anObject
]

{ #category : 'accessing' }
EggBootstrapRuntime >> superBehaviorOf: aProtoeggSpecies [
	^ aProtoeggSpecies superclass instanceSpec
]

{ #category : 'services' }
EggBootstrapRuntime >> symbolFrom: aProtoeggObject [

	^ aProtoeggObject symbol
]

{ #category : 'services' }
EggBootstrapRuntime >> symbolFromLocal: aSymbol [
	^ image newSymbol: aSymbol
]

{ #category : 'accessing' }
EggBootstrapRuntime >> transferLiteral: anObject [
	^image transferLiteral: anObject
]

{ #category : 'accessing' }
EggBootstrapRuntime >> transferMethodLiterals: method [
	| class |
	method withIndexDo: [:literal :i | 
		class := literal class.
		((class inheritsFrom: ProtoeggObject)
			or: [ class = SCompiledBlock ])
			ifFalse: [ method at: i put: (image transferLiteralDeep: literal) ] ].
	^ method
]
