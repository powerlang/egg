Class {
	#name : #NopsysResolver,
	#superclass : #PlatformResolver,
	#category : 'SqueakNOS-FileSupport'
}

{ #category : #accessing }
NopsysResolver class >> platformName [
	^'SqueakNOS'
]

{ #category : #resolving }
NopsysResolver >> resolve: anObject [
	Computer showCallTrace.
	^nil
]
