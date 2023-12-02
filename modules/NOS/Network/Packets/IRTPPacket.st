Class {
	#name : #IRTPPacket,
	#superclass : #Packet,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
IRTPPacket class >> fieldsNames [
	^ #(type typeName port sequence length checksum)
]

{ #category : #accessing }
IRTPPacket class >> headerSize [
	^ 8
]

{ #category : #accessing }
IRTPPacket class >> protocol [
	^ 28
]

{ #category : #accessing }
IRTPPacket >> checksum [
	^ self shortAt: 7
]

{ #category : #accessing }
IRTPPacket >> checksum: anInteger [
	^ self shortAt: 7 put: anInteger
]

{ #category : #helpers }
IRTPPacket >> computeChecksum [
	^ self checksumFrom: 1 to: self size
]

{ #category : #accessing }
IRTPPacket >> length [
	^ self shortAt: 5
]

{ #category : #accessing }
IRTPPacket >> length: anInteger [
	^ self shortAt: 5 put: anInteger
]

{ #category : #accessing }
IRTPPacket >> port [
	^ self second
]

{ #category : #accessing }
IRTPPacket >> port: anInteger [
	^ self at: 2 put: anInteger
]

{ #category : #accessing }
IRTPPacket >> sequence [
	^ self shortAt: 3
]

{ #category : #accessing }
IRTPPacket >> sequence: anInteger [
	^ self shortAt: 3 put: anInteger
]

{ #category : #accessing }
IRTPPacket >> type [
	^ self first
]

{ #category : #accessing }
IRTPPacket >> type: anInteger [
	self at: 1 put: anInteger
]

{ #category : #accessing }
IRTPPacket >> typeName [
	^ self typeNames at: self type + 1
]

{ #category : #accessing }
IRTPPacket >> typeName: aSymbol [
	^ self type: (self typeNames indexOf: aSymbol) - 1
]

{ #category : #accessing }
IRTPPacket >> typeNames [
	^ #(Synch SynchAck Data DataAck PortNak)
]
