Class {
	#name : #ARPEntry,
	#superclass : #Object,
	#instVars : [
		'hardware',
		'protocol',
		'timeout'
	],
	#category : 'SqueakNOS-Net-Protocols-Ethernet'
}

{ #category : #comparing }
ARPEntry >> = anARPEntry [
	^ self protocol = anARPEntry protocol
]

{ #category : #accesing }
ARPEntry >> hardware [
	^ hardware
]

{ #category : #accesing }
ARPEntry >> hardware: aNetAddress [
	hardware := aNetAddress
]

{ #category : #comparing }
ARPEntry >> hash [
	^ self protocol hash
]

{ #category : #testing }
ARPEntry >> isDynamic [
	^ self isStatic not
]

{ #category : #testing }
ARPEntry >> isStatic [
	^ timeout isNil
]

{ #category : #printing }
ARPEntry >> printOn: aStream [
	aStream print: hardware; nextPutAll: ' -> '; print: protocol.
	self isStatic ifTrue: [aStream nextPutAll: ' (STATIC)']
]

{ #category : #accesing }
ARPEntry >> protocol [
	^ protocol
]

{ #category : #accesing }
ARPEntry >> protocol: aNetAddress [
	protocol := aNetAddress
]

{ #category : #accesing }
ARPEntry >> timeout [
	^ timeout
]

{ #category : #accesing }
ARPEntry >> timeout: anInteger [
	timeout := anInteger
]
