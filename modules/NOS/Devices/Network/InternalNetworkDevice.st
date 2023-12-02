Class {
	#name : #InternalNetworkDevice,
	#superclass : #Stream,
	#instVars : [
		'mtu'
	],
	#category : 'SqueakNOS-Net-Devices'
}

{ #category : #'instance creation' }
InternalNetworkDevice class >> new [
	^ self basicNew initialize
]

{ #category : #testing }
InternalNetworkDevice >> atEnd [
	^ self subclassResponsibility
]

{ #category : #control }
InternalNetworkDevice >> down [
	^ self
]

{ #category : #initialization }
InternalNetworkDevice >> initialize [
	super initialize.
	mtu := 1024
]

{ #category : #accessing }
InternalNetworkDevice >> input: aPacket [
	self triggerEvent: #input: with: aPacket
]

{ #category : #accessing }
InternalNetworkDevice >> mtu [
	^ mtu
]

{ #category : #accessing }
InternalNetworkDevice >> mtu: anInteger [
	mtu := anInteger
]

{ #category : #accessing }
InternalNetworkDevice >> next [
	^ self nextPacket
]

{ #category : #accessing }
InternalNetworkDevice >> nextPacket [
	^ self subclassResponsibility
]

{ #category : #accessing }
InternalNetworkDevice >> nextPut: aPacket [
	^ self nextPacketPut: aPacket
]

{ #category : #accessing }
InternalNetworkDevice >> output: aPacket [
	^ self subclassResponsibility
]

{ #category : #printing }
InternalNetworkDevice >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPutAll: ' mtu='; print: self mtu
]

{ #category : #control }
InternalNetworkDevice >> up [
	^ self
]
