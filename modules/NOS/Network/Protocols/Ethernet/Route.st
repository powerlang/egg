Class {
	#name : #Route,
	#superclass : #Object,
	#instVars : [
		'destination',
		'gateway',
		'interface'
	],
	#category : 'SqueakNOS-Net-Protocols-Ethernet'
}

{ #category : #accessing }
Route >> destination [
	^ destination
]

{ #category : #accessing }
Route >> destination: aNetBlock [
	destination := aNetBlock
]

{ #category : #accessing }
Route >> gateway [
	^ gateway
]

{ #category : #accessing }
Route >> gateway: aNetAddress [
	gateway := aNetAddress
]

{ #category : #accessing }
Route >> interface [
	^ interface
]

{ #category : #accessing }
Route >> interface: aNetInterface [
	interface := aNetInterface
]

{ #category : #printing }
Route >> printOn: aStream [
	aStream print: self destination; nextPutAll: ' -> '.
	self gateway isNil ifFalse: [aStream print: self gateway; nextPutAll: ' -> '].
	aStream print: self interface
]
