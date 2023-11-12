Class {
	#name : #BlockArithmetic0,
	#superclass : #BlockArithmetic,
	#category : #'SqueakNOS-Storage'
}

{ #category : #accessing }
BlockArithmetic0 >> blockNumberOf: anInteger [
	^anInteger // self blockSize.
]

{ #category : #accessing }
BlockArithmetic0 >> firstPositionInSameBlockOf: position [
	^position - (position \\ blockSize)
]

{ #category : #accessing }
BlockArithmetic0 >> offsetInBlockOf: position [
	^position \\ blockSize
]

{ #category : #'methodsFor:' }
BlockArithmetic0 >> size: aSize [
	^self new size: aSize
]

{ #category : #'methodsFor:' }
BlockArithmetic0 >> size: aSize index: index [
	^self new size: aSize index: index
]
