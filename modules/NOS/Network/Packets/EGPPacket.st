Class {
	#name : #EGPPacket,
	#superclass : #Packet,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
EGPPacket class >> protocol [
	^ 8
]

{ #category : #accessing }
EGPPacket >> checksum [
	^ self shortAt: 5
]

{ #category : #accessing }
EGPPacket >> code [
	^ self at: 3
]

{ #category : #accessing }
EGPPacket >> sequence [
	^ self shortAt: 9
]

{ #category : #accessing }
EGPPacket >> status [
	^ self at: 4
]

{ #category : #accessing }
EGPPacket >> system [
	^ self shortAt: 7
]

{ #category : #accessing }
EGPPacket >> type [
	^ self at: 2
]

{ #category : #accessing }
EGPPacket >> version [
	^ self at: 1
]
