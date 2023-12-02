Class {
	#name : #ARPPacket,
	#superclass : #Packet,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
ARPPacket class >> etherType [
	^ 16r806
]

{ #category : #accessing }
ARPPacket class >> fieldsNames [
	^ #(hardwareAddressFormat protocolAddressFormat hardwareAddressLength protocolAddressLength opcode opcodeName)
]

{ #category : #accessing }
ARPPacket class >> headerSize [
	^ 7
]

{ #category : #accessing }
ARPPacket >> hardwareClass [
	NetAddress allSubclassesDo: [ :each | each type = self hardwareType ifTrue: [^ each]].
	^ nil
]

{ #category : #accessing }
ARPPacket >> hardwareSize [
	^ self at: 5
]

{ #category : #accessing }
ARPPacket >> hardwareSize: anInteger [
	self at: 5 put: anInteger.

]

{ #category : #accessing }
ARPPacket >> hardwareType [
	^ self shortAt: 1
]

{ #category : #accessing }
ARPPacket >> hardwareType: anInteger [
	self shortAt: 1 put: anInteger
]

{ #category : #testing }
ARPPacket >> isReply [
	^ self opcode = 2
]

{ #category : #testing }
ARPPacket >> isRequest [
	^ self opcode = 1
]

{ #category : #accessing }
ARPPacket >> opcode [
	^ self shortAt: 7 
]

{ #category : #accessing }
ARPPacket >> opcode: anInteger [
	self shortAt: 7 put: anInteger
]

{ #category : #accessing }
ARPPacket >> opcodeName [
	^ self opcodeNames at: self opcode ifAbsent: []
]

{ #category : #accessing }
ARPPacket >> opcodeName: aSymbol [
	^ self opcode: (self opcodeNames indexOf: aSymbol)
]

{ #category : #accessing }
ARPPacket >> opcodeNames [
	^ #(Request Reply RRequest RReply InRequest InReply NAK)
]

{ #category : #printing }
ARPPacket >> printOn: aStream [
	aStream nextPutAll: 'ARP '.
	self isRequest
		ifTrue: [aStream nextPutAll: 'who-has '; print: self targetProtocolAddress; nextPutAll: ' tell '; print: self senderHardwareAddress.
				^ self].
	self isReply
		ifTrue: [aStream print: self senderProtocolAddress; nextPutAll: ' is-at '; print: self senderHardwareAddress.
				^ self].
	aStream nextPutAll: self opcodeName asString
]

{ #category : #accessing }
ARPPacket >> protocolClass [
	NetAddress allSubclassesDo: [ :each | each type = self protocolType ifTrue: [^ each]].
	^ nil
]

{ #category : #accessing }
ARPPacket >> protocolSize [
	^ self at: 6
]

{ #category : #accessing }
ARPPacket >> protocolSize: anInteger [
	self at: 6 put: anInteger.

]

{ #category : #accessing }
ARPPacket >> protocolType [
	^ self shortAt: 3
]

{ #category : #accessing }
ARPPacket >> protocolType: anInteger [
	self shortAt: 3 put: anInteger
]

{ #category : #accessing }
ARPPacket >> senderHardwareAddress [
	^ (self hardwareClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 to: 9 - 1 + self hardwareSize)
]

{ #category : #accessing }
ARPPacket >> senderHardwareAddress: aNetAddress [
	self hardwareType: aNetAddress class type.
	self hardwareSize: aNetAddress size.
	self replaceFrom: 9 to: 9 - 1 + aNetAddress size with: aNetAddress asByteArray
]

{ #category : #accessing }
ARPPacket >> senderProtocolAddress [
	^ (self protocolClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 + self hardwareSize to: 8 + self hardwareSize + self protocolSize)
]

{ #category : #accessing }
ARPPacket >> senderProtocolAddress: aNetAddress [
	self protocolType: aNetAddress class type.
	self protocolSize: aNetAddress size.
	self replaceFrom: 9 + self hardwareSize to: 8 + self hardwareSize + aNetAddress size with: aNetAddress asByteArray
]

{ #category : #helpers }
ARPPacket >> swapSenderAndTarget [
	| oldAddress |
	oldAddress := self senderHardwareAddress.
	self senderHardwareAddress: self targetHardwareAddress.
	self targetHardwareAddress: oldAddress.

	oldAddress := self senderProtocolAddress.
	self senderProtocolAddress: self targetProtocolAddress.
	self targetProtocolAddress: oldAddress
]

{ #category : #accessing }
ARPPacket >> targetHardwareAddress [
	^ (self hardwareClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 + self hardwareSize + self protocolSize to: 9 - 1 + (self hardwareSize*2) + self protocolSize)
]

{ #category : #accessing }
ARPPacket >> targetHardwareAddress: aNetAddress [
	self hardwareType: aNetAddress class type.
	self hardwareSize: aNetAddress size.
	self replaceFrom: 9 + self hardwareSize + self protocolSize to: 9 - 1 + (self hardwareSize*2) + self protocolSize with: aNetAddress asByteArray
]

{ #category : #accessing }
ARPPacket >> targetProtocolAddress [
	^ (self protocolClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 + (self hardwareSize * 2) + self protocolSize to: 9 - 1 + (self hardwareSize + self protocolSize * 2))
]

{ #category : #accessing }
ARPPacket >> targetProtocolAddress: aNetAddress [
	self protocolType: aNetAddress class type.
	self protocolSize: aNetAddress size.
	self replaceFrom: 9 + (self hardwareSize * 2) + self protocolSize to: 8 + (self hardwareSize + self protocolSize * 2) with: aNetAddress asByteArray
]
