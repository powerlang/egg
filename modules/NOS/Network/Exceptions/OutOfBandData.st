Class {
	#name : #OutOfBandData,
	#superclass : #Notification,
	#instVars : [
		'data'
	],
	#category : 'SqueakNOS-Net-Exceptions'
}

{ #category : #accessing }
OutOfBandData >> data [
	^ data
]

{ #category : #accessing }
OutOfBandData >> data: anObject [
	data := anObject
]
