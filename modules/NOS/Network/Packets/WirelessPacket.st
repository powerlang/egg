Class {
	#name : #WirelessPacket,
	#superclass : #Packet,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
WirelessPacket >> destination [
	^ EthernetAddress bytes: (self copyFrom: 11 to: 16)
]

{ #category : #accessing }
WirelessPacket >> duration [
	"Only meaningful for data frames."
	^ self shortAt: 3
]

{ #category : #accessing }
WirelessPacket >> fcs [
	"Answer the Frame Check Sequence (32-bit CRC)."
	^ self longAt: 31
]

{ #category : #'accessing-private' }
WirelessPacket >> frameControl [
	^ self shortAt: 1
]

{ #category : #'accessing-control' }
WirelessPacket >> fromDS [
	^ (self frameControl bitShift: -9) odd
]

{ #category : #accessing }
WirelessPacket >> id [
	"Answer the associated identity of the transmitting station.
	Only meaningful for control frames."
	^ self shortAt: 3
]

{ #category : #'testing-control' }
WirelessPacket >> isACK [
	^ self isControl and: [self subtype = 2r1101]
]

{ #category : #'testing-management' }
WirelessPacket >> isATIM [
	^ self isManagement and: [self subtype = 2r1001]
]

{ #category : #'testing-management' }
WirelessPacket >> isAssociationRequest [
	^ self isManagement and: [self subtype = 2r0000]
]

{ #category : #'testing-management' }
WirelessPacket >> isAssociationResponse [
	^ self isManagement and: [self subtype = 2r0001]
]

{ #category : #'testing-management' }
WirelessPacket >> isAuthentication [
	^ self isManagement and: [self subtype = 2r1011]
]

{ #category : #'testing-management' }
WirelessPacket >> isBeacon [
	^ self isManagement and: [self subtype = 2r1000]
]

{ #category : #'testing-control' }
WirelessPacket >> isCTS [
	^ self isControl and: [self subtype = 2r1100]
]

{ #category : #testing }
WirelessPacket >> isControl [
	^ self type = 2r01
]

{ #category : #testing }
WirelessPacket >> isData [
	^ self type = 2r10
]

{ #category : #'testing-management' }
WirelessPacket >> isDeauthentication [
	^ self isManagement and: [self subtype = 2r1100]
]

{ #category : #'testing-management' }
WirelessPacket >> isDisassociation [
	^ self isManagement and: [self subtype = 2r1010]
]

{ #category : #testing }
WirelessPacket >> isManagement [
	^ self type = 2r00
]

{ #category : #'testing-management' }
WirelessPacket >> isProbeRequest [
	^ self isManagement and: [self subtype = 2r0100]
]

{ #category : #'testing-management' }
WirelessPacket >> isProbeResponse [
	^ self isManagement and: [self subtype = 2r0101]
]

{ #category : #'testing-control' }
WirelessPacket >> isRTS [
	^ self isControl and: [self subtype = 2r1011]
]

{ #category : #'testing-management' }
WirelessPacket >> isReasociationRequest [
	^ self isManagement and: [self subtype = 2r0010]
]

{ #category : #'testing-management' }
WirelessPacket >> isReasociationResponse [
	^ self isManagement and: [self subtype = 2r0011]
]

{ #category : #'accessing-control' }
WirelessPacket >> md [
	"More data flag."
	^ (self frameControl bitShift: -13) odd
]

{ #category : #'accessing-control' }
WirelessPacket >> mf [
	"More fragments flag."
	^ (self frameControl bitShift: -10) odd
]

{ #category : #'accessing-control' }
WirelessPacket >> order [
	^ (self frameControl bitShift: -15) = 1
]

{ #category : #'accessing-control' }
WirelessPacket >> pm [
	"Power management flag."
	^ (self frameControl bitShift: -12) odd
]

{ #category : #printing }
WirelessPacket >> printOn: aStream [
	aStream nextPutAll: '802.11 '; nextPutAll: self typeName; nextPut: $/; nextPutAll: self subtypeName.
	aStream space; print: self source.
	self size > 10 ifTrue: [aStream nextPutAll: ' -> '; print: self destination]
]

{ #category : #'accessing-control' }
WirelessPacket >> retry [
	"Answer true if this is a retransmission."
	^ (self frameControl bitShift: -11) odd
]

{ #category : #accessing }
WirelessPacket >> rx [
	"Answer the receiving wireless station."
	^ EthernetAddress bytes: (self copyFrom: 17 to: 22)
]

{ #category : #accessing }
WirelessPacket >> sequence [
	^ self shortAt: 23
]

{ #category : #accessing }
WirelessPacket >> source [
	^ EthernetAddress bytes: (self copyFrom: 5 to: 10)
]

{ #category : #'accessing-control' }
WirelessPacket >> subtype [
	^ (self frameControl bitShift: -4) bitAnd: 2r1111
]

{ #category : #'accessing-control' }
WirelessPacket >> subtypeName [
	self isManagement ifTrue: [^ #(AssociationRequest AssociationResponse ReassociationRequest ReassociationResponse ProbeRequest ProbeResponse Reserved Reserved Beacon ATIM Disassociation Authentication Deathentication Reserved Reserved Reserved) at: self subtype + 1].
	self isControl ifTrue: [^ #(Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved 'PS-Poll' RTS CTS ACK 'CF-End' 'CF-End+CF-ACK') at: self subtype + 1].
	self isData ifTrue: [^ #(Data 'Data+CF-ACK' 'Data+CF-Poll' 'Data+CF-ACK+CF-Poll' Null 'CF-ACK' 'CF-Poll' 'CF-ACK+CF-Poll' Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved) at: self subtype + 1].
	^ #Reserved
]

{ #category : #'accessing-control' }
WirelessPacket >> toDS [
	^ (self frameControl bitShift: -8) odd
]

{ #category : #accessing }
WirelessPacket >> tx [
	"Answer the transmitting wireless station."
	^ EthernetAddress bytes: (self copyFrom: 25 to: 30)
]

{ #category : #'accessing-control' }
WirelessPacket >> type [
	^ (self frameControl bitShift: -2) bitAnd: 2r11
]

{ #category : #'accessing-control' }
WirelessPacket >> typeName [
	^ #(Management Data Control Reserved) at: self type + 1
]

{ #category : #'accessing-control' }
WirelessPacket >> version [
	^ self frameControl bitAnd: 2r11
]

{ #category : #'accessing-control' }
WirelessPacket >> wep [
	^ (self frameControl bitShift: -14) odd
]
