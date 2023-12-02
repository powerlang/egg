Class {
	#name : #NetInterface,
	#superclass : #Conduit,
	#instVars : [
		'inputQ',
		'process',
		'device'
	],
	#category : 'SqueakNOS-Net-Interfaces'
}

{ #category : #examples }
NetInterface class >> loopback [
	^ self on: Loopback new
]

{ #category : #'instance creation' }
NetInterface class >> on: aNetworkDevice [
	^ self new device: aNetworkDevice
]

{ #category : #accessing }
NetInterface >> device [
	^ device
]

{ #category : #accessing }
NetInterface >> device: aNetworkDevice [
	device := aNetworkDevice
]

{ #category : #control }
NetInterface >> down [
	device down.
	device removeActionsWithReceiver: self.
	process ifNotNil: [process terminate. process := nil]
]

{ #category : #control }
NetInterface >> flush [
	"Discard all packets on the interface queue."
	[inputQ isEmpty] whileFalse: [inputQ next]
]

{ #category : #private }
NetInterface >> handleInputPacket: aPacket [
	inputQ size > 100 ifTrue: [^ self error: 'Packet dropped'].
	inputQ nextPut: aPacket
]

{ #category : #initialization }
NetInterface >> initialize [
	super initialize.
	inputQ := SharedQueue new
]

{ #category : #testing }
NetInterface >> isDown [
	^ self isUp not
]

{ #category : #testing }
NetInterface >> isUp [
	^ process notNil
]

{ #category : #initialization }
NetInterface >> left: aConduit [
	^ self shouldNotImplement
]

{ #category : #accessing }
NetInterface >> mtu [
	^ device mtu
]

{ #category : #accessing }
NetInterface >> mtu: anInteger [
	device mtu: anInteger
]

{ #category : #flow }
NetInterface >> output: aPacket [
	self isDown ifTrue: [^ NetDown signal].
	device output: aPacket
]

{ #category : #private }
NetInterface >> processLoop [
	self input: inputQ next
]

{ #category : #control }
NetInterface >> up [
	self down.
	process := [[process isNil] whileFalse: [self processLoop]] newProcess.
	device when: #input: send: #handleInputPacket: to: self.
	device up.
	process resume
]
