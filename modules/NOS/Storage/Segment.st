Class {
	#name : #Segment,
	#superclass : #Interval,
	#category : #'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
Segment >> intersects: anotherSegment [
	start > anotherSegment stop ifTrue: [^false].
	stop < anotherSegment start ifTrue: [^false].
	^true.
]
