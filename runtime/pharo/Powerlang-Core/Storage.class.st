Class {
	#name : 'Storage',
	#superclass : 'Object',
	#category : 'Powerlang-Core-Metaphysics',
	#package : 'Powerlang-Core',
	#tag : 'Metaphysics'
}

{ #category : 'storage' }
Storage >> arrayedSlotOf: base at: index put: value [
	^ self subclassResponsibility
]

{ #category : 'storage' }
Storage >> new: oid [
	^self subclassResponsibility
]

{ #category : 'storage' }
Storage >> slotOf: base at: index [
	^ self subclassResponsibility
]

{ #category : 'storage' }
Storage >> slotOf: base at: index put: value [
	^self subclassResponsibility
]
