Class {
	#name : #IGMPPacket,
	#superclass : #Packet,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
IGMPPacket class >> headerSize [
	^ 8
]

{ #category : #accessing }
IGMPPacket class >> protocol [
	^ 2
]

{ #category : #accessing }
IGMPPacket >> checksum [
	^ self shortAt: 3
]

{ #category : #accessing }
IGMPPacket >> checksum: anInteger [
	self shortAt: 3 put: anInteger
]

{ #category : #accessing }
IGMPPacket >> code [
	^ self at: 2
]

{ #category : #accessing }
IGMPPacket >> code: anInteger [
	self at: 2 put: anInteger
]

{ #category : #helpers }
IGMPPacket >> computeChecksum [
	^ 0
]

{ #category : #accessing }
IGMPPacket >> group [
	^ self longAt: 5
]

{ #category : #accessing }
IGMPPacket >> group: anInteger [
	self longAt: 5 put: anInteger
]

{ #category : #accessing }
IGMPPacket >> type [
	^ self at: 1
]

{ #category : #accessing }
IGMPPacket >> type: anInteger [
	self at: 1 put: anInteger
]
