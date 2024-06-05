Class {
	#name : 'ProtoeggSlotObject',
	#superclass : 'ProtoeggObject',
	#instVars : [
		'slots',
		'hash'
	],
	#category : 'Powerlang-Core-Execution-Bootstrap-Ring',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Bootstrap-Ring'
}

{ #category : 'instance creation' }
ProtoeggSlotObject class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'instance creation' }
ProtoeggSlotObject class >> new: anRGBehavior size: size [

	^ self new initializeAs: anRGBehavior sized: size
]

{ #category : 'instance creation' }
ProtoeggSlotObject class >> new: anRGBehavior size: size withAll: value [
	| obj |
	obj := self new: anRGBehavior size: size.
	^obj atAllPut: value; yourself
	
]

{ #category : 'accessing' }
ProtoeggSlotObject >> allSlotNames [

	^ spec allInstVarNames
]

{ #category : 'accessing' }
ProtoeggSlotObject >> arrayedSize [
	"
	 Return the size of the arrayed part of this object, that this,
	 the value of size field in object header minus the instSize. 
	"

	^ self size - self instSize
]

{ #category : 'accessing' }
ProtoeggSlotObject >> asBoolean [
	spec name = #True ifTrue: [ ^true ].	spec name = #False ifTrue: [ ^false ].
		self ASSERT: false
]

{ #category : 'accessing' }
ProtoeggSlotObject >> at: index [
	"Return indexed value at given index, starting with 1. This CANNOT be 
	 used for accessing named slots (aka, instance variables), to access 
	 them use #instVarAt:"
	
	self assert: (index between: 1 and: slots size - self instSize).
	^slots at: self instSize + index
]

{ #category : 'accessing' }
ProtoeggSlotObject >> at: index put: value [
	"Set indexed value at given `index` to `value`. This CANNOT be used for 
	 setting named slots (aka, instance variables), to access them use 
	 #instVarAt:put:"
	self assert: spec isVariable.
	self assert: (index between: 1 and: slots size - self instSize).
	self assert: (value isKindOf: ProtoeggObject).
	^slots at: self instSize + index put: value
]

{ #category : 'initialization' }
ProtoeggSlotObject >> atAllPut: value [
	slots atAllPut: value
]

{ #category : 'accessing' }
ProtoeggSlotObject >> basicAt: index [
	"Return indexed value at given raw index, starting with 1"

	self assert: (index between: 1 and: slots size).
	^ slots at: index
]

{ #category : 'accessing' }
ProtoeggSlotObject >> bodySizeInBytes [	
	^ self sizeInBytes

]

{ #category : 'accessing' }
ProtoeggSlotObject >> doesNotUnderstand: aMessage [
	| sel ivars |
	sel := aMessage selector.
	ivars := self allSlotNames.
	sel isUnary
		ifTrue: [ (ivars includes: sel)
				ifTrue: [ ^ self slotNamed: sel ] ].
	(sel isKeyword and: [ sel numArgs == 1 ])
		ifTrue: [ sel := sel allButLast.
			(ivars includes: sel)
				ifTrue: [ ^ self slotNamed: sel put: aMessage arguments first ] ].
	^ super doesNotUnderstand: aMessage
]

{ #category : 'testing' }
ProtoeggSlotObject >> headerFlags [
	| variable named small |
	variable := spec isVariable ifTrue: [2] ifFalse: [0].
	named := spec instSize == 0 ifTrue: [0] ifFalse: [4].
	small := self isSmall ifTrue: [16r80] ifFalse: [0].
	^ variable | named | small
]

{ #category : 'testing' }
ProtoeggSlotObject >> headerHash [
	^hash
]

{ #category : 'testing' }
ProtoeggSlotObject >> headerHash: anInteger [
	hash := anInteger
]

{ #category : 'testing' }
ProtoeggSlotObject >> initialize [
	hash := 0
]

{ #category : 'initialization' }
ProtoeggSlotObject >> initializeAs: anRGBehavior sized: size [
	self assert: anRGBehavior notNil.
	self assert: anRGBehavior isPointers.
	self assert: (anRGBehavior isVariable or: [ size == 0 ]).
	spec := anRGBehavior.
	slots := Array new: self instSize + size
]

{ #category : 'accessing' }
ProtoeggSlotObject >> instSize [
	^ spec instSize
]

{ #category : 'accessing' }
ProtoeggSlotObject >> isPointers [
	^true
]

{ #category : 'accessing' }
ProtoeggSlotObject >> loadIvar: aSymbol [
	| ivar |
	ivar := self allSlotNames indexOf: aSymbol.
	^ ivar > 0
		ifTrue: [ self slotAt: ivar ]
]

{ #category : 'accessing' }
ProtoeggSlotObject >> printOn: aStream [
	aStream
		nextPutAll: '<<';
		nextPutAll: spec name withArticle;
		nextPutAll: '>>'
]

{ #category : 'accessing' }
ProtoeggSlotObject >> size [
	"Return the size if this object, that this, the value of
	 size field in object header. 
	
	 For slot (pointer) objects, this is a number of slots. 
	 For byte objects, this is a number of bytes. "
	
	^ slots size
]

{ #category : 'accessing' }
ProtoeggSlotObject >> sizeInBytes [	
	^ self size * self wordSize

]

{ #category : 'accessing' }
ProtoeggSlotObject >> slotAt: index [
	"Get named slot at given `index`, starting with 1. This CANNOT be used 
	 for accessing indexed slots  (i.e., variable part of array-like objects), 
   to set them use #at:"
	
	self assert: (index between: 1 and: self instSize).
	^slots at: index
]

{ #category : 'accessing' }
ProtoeggSlotObject >> slotAt: index put: value [
	"Set named slot at given `index` to `value`. This CANNOT be used 
	 for setting indexed slots  (i.e., variable part of array-like objects), 
   to set them use #at:put:"
	
	self assert: (index between: 1 and: self instSize).
	self assert: (value isKindOf: ProtoeggObject).
	^slots at: index put: value
]

{ #category : 'accessing' }
ProtoeggSlotObject >> slots [
	^slots
]

{ #category : 'accessing' }
ProtoeggSlotObject >> slotsDo: aBlock [
	slots do: aBlock
]

{ #category : 'accessing' }
ProtoeggSlotObject >> storeIvar: aSymbol with: anObject [
	| ivar |
	ivar := self allSlotNames indexOf: aSymbol.
	^ ivar > 0
		ifTrue: [ self slotAt: ivar put: anObject ]
]

{ #category : 'validation' }
ProtoeggSlotObject >> validate [
	super validate.
	slots withIndexDo:[:value :index | self assert: value notNil ]
]

{ #category : 'accessing' }
ProtoeggSlotObject >> value [
	| message |
	(self allSlotNames includes: #value)
		ifFalse: [ ^ super value ].
	message := Message selector: #value.
	^ self doesNotUnderstand: message
]
