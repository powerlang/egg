Class {
	#name : #Loopback,
	#superclass : #InternalNetworkDevice,
	#category : 'SqueakNOS-Net-Devices'
}

{ #category : #initialization }
Loopback >> initialize [
	super initialize.
	mtu := 1536
]

{ #category : #accessing }
Loopback >> input: aPacket [
	self triggerEvent: #input: with: aPacket
]

{ #category : #accessing }
Loopback >> output: aPacket [
	^ self input: aPacket
]
