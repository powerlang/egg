Class {
	#name : #RARPPacket,
	#superclass : #ARPPacket,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
RARPPacket class >> etherType [
	^ 16r8035
]

{ #category : #testing }
RARPPacket >> isReply [
	^ self opcode = 4
]

{ #category : #testing }
RARPPacket >> isRequest [
	^ self opcode = 3
]

{ #category : #accessing }
RARPPacket >> opcodeNames [
	^ #(Unknown Unknown Request Reply)
]

{ #category : #printing }
RARPPacket >> printOn: aStream [
	aStream nextPutAll: 'RARP '.
	self isRequest
		ifTrue: [aStream nextPutAll: 'who-is '; print: self targetHardwareAddress; nextPutAll: ' tell '; print: self senderHardwareAddress.
				^ self].
	self isReply
		ifTrue: [aStream print: self targetProtocolAddress; nextPutAll: ' at '; print: self targetProtocolAddress.
				^ self].
	aStream nextPutAll: 'unknown opcode'
]
