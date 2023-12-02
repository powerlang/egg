Class {
	#name : #HostDown,
	#superclass : #Error,
	#instVars : [
		'address'
	],
	#category : 'SqueakNOS-Net-Exceptions'
}

{ #category : #accessing }
HostDown >> address [
	^ address
]

{ #category : #accessing }
HostDown >> address: aNetAddress [
	address := aNetAddress
]

{ #category : #description }
HostDown >> isResumable [
	^ true
]
