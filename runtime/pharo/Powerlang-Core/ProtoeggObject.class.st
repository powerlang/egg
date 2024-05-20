Class {
	#name : #ProtoeggObject,
	#superclass : #Object,
	#instVars : [
		'spec'
	],
	#category : #'Powerlang-Core-Execution-Ring'
}

{ #category : #'instance creation' }
ProtoeggObject class >> classFor: anRGBehavior [
	anRGBehavior name == #SmallInteger ifTrue: [^ProtoeggSmallInteger].
	^anRGBehavior isBytes
		ifTrue: [ ProtoeggByteObject ]
		ifFalse: [ ProtoeggSlotObject ]
]

{ #category : #'instance creation' }
ProtoeggObject class >> new: anRGBehavior [
	^self new: anRGBehavior size: 0
]

{ #category : #'instance creation' }
ProtoeggObject class >> new: anRGBehavior size: size [
	| class |
	"self assert: (anRGBehavior isVariable or: [ size == 0 ]). isVariable too slow to assert"
	class := self classFor: anRGBehavior.
	^ class new initializeAs: anRGBehavior sized: size
]

{ #category : #services }
ProtoeggObject >> allSlotNames [
	^#()
]

{ #category : #accessing }
ProtoeggObject >> arrayedSize [
	^self size
]

{ #category : #accessing }
ProtoeggObject >> behavior: aSlotObjectMap [
	| class |
	class := aSlotObjectMap slotAt: 1.
	spec := class instanceSpec
]

{ #category : #accessing }
ProtoeggObject >> bodySizeInBytes [
	"Return the size of object body(s) in bytes,
	 padded if a byte object"
	^ self subclassResponsibility 
]

{ #category : #accessing }
ProtoeggObject >> classname [
	^spec name
]

{ #category : #accessing }
ProtoeggObject >> headerSizeInBytes [
	"
		Return the size of object header in bytes, 
		including both small and large part (if any).
	"
	
	^ self isSmall ifTrue: [ 8 ] ifFalse: [ 16 ]

]

{ #category : #accessing }
ProtoeggObject >> headerSmallSize [
	"Return value of 'size' field of small header"
	 | size |	
   size := self size.
   ^ size < 256 ifTrue: [ size ] ifFalse: [ 0 ]
]

{ #category : #initialization }
ProtoeggObject >> initializeAs: anRGBehavior sized: size [
	self subclassResponsibility
]

{ #category : #testing }
ProtoeggObject >> isBytes [
	^ false
]

{ #category : #testing }
ProtoeggObject >> isClosure [
	^ false
]

{ #category : #testing }
ProtoeggObject >> isDictionaryMap [ 
	^ false
]

{ #category : #testing }
ProtoeggObject >> isImmediate [ 
	^false
]

{ #category : #testing }
ProtoeggObject >> isNil [
	^ spec notNil and: [spec name = #UndefinedObject]
]

{ #category : #testing }
ProtoeggObject >> isPointers [
	^false
]

{ #category : #testing }
ProtoeggObject >> isSmall [
	^self size < 256
]

{ #category : #testing }
ProtoeggObject >> loadIvar: aSymbol [
	^nil
]

{ #category : #initialization }
ProtoeggObject >> nilAll: nilObject [
	
]

{ #category : #initialization }
ProtoeggObject >> nilWith: nilObject [
]

{ #category : #accessing }
ProtoeggObject >> size [
	"Return the size if this object, that this, the value of
	 size field in object header. 
	
	 For slot (pointer) objects, this is a number of slots. 
	 For byte objects, this is a number of bytes. "
	
	self subclassResponsibility 
]

{ #category : #accessing }
ProtoeggObject >> sizeInBytes [
	"Return the size of object in bytes without padding"
	^ self subclassResponsibility 
]

{ #category : #accessing }
ProtoeggObject >> slotAt: index [
	"Get named slot at given `index`, starting with 1. This CANNOT be used 
	 for accessing indexed slots  (i.e., variable part of array-like objects), 
   to set them use #at:"
	
	self subclassResponsibility  
]

{ #category : #accessing }
ProtoeggObject >> slotAt: index put: value [
	"Set named slot at given `index` to `value`. This CANNOT be used 
	 for setting indexed slots  (i.e., variable part of array-like objects), 
   to set them use #at:put:"
	
	self subclassResponsibility
]

{ #category : #accessing }
ProtoeggObject >> slotNamed: name [
	"Get a named slot with given `name`"

	| index |
	index := self allSlotNames indexOf: name.
	index == 0
		ifTrue: [ ^ self error: 'No slot named "' , name , '"' ].
	^ self slotAt: index
]

{ #category : #accessing }
ProtoeggObject >> slotNamed: name put: value [
	"Set a named slot with given `name` to `value`"

	| index |
	index := self allSlotNames indexOf: name.
	index == 0
		ifTrue: [ ^ self error: 'No slot named "' , name , '"' ].
	^ self slotAt: index put: value
]

{ #category : #accessing }
ProtoeggObject >> slotsDo: aBlock [
	
]

{ #category : #accessing }
ProtoeggObject >> spec [
	^ spec
]

{ #category : #testing }
ProtoeggObject >> storeIvar: aSymbol with: anObjectMap [
	^ nil
]

{ #category : #accessing }
ProtoeggObject >> wordSize [
	"Return the size in bytes of the word (i.e, a reference to an object)"
	
	^ 8 "For now, 64bit only!"
]
