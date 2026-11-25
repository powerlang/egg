'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #WirelessPacket category: 'SqueakNOS-Net-Packets'!
Packet subclass: #WirelessPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
destination
	^ EthernetAddress bytes: (self copyFrom: 11 to: 16)
! !

!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
duration
	"Only meaningful for data frames."
	^ self shortAt: 3
! !

!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fcs
	"Answer the Frame Check Sequence (32-bit CRC)."
	^ self longAt: 31
! !

!WirelessPacket methodsFor:  'accessing-private' stamp: 'KenD 28/Jun/2026 13:32:25'!
frameControl
	^ self shortAt: 1
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
fromDS
	^ (self frameControl bitShift: -9) odd
! !

!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
id
	"Answer the associated identity of the transmitting station.
	Only meaningful for control frames."
	^ self shortAt: 3
! !

!WirelessPacket methodsFor:  'testing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
isACK
	^ self isControl and: [self subtype = 2r1101]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isATIM
	^ self isManagement and: [self subtype = 2r1001]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isAssociationRequest
	^ self isManagement and: [self subtype = 2r0000]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isAssociationResponse
	^ self isManagement and: [self subtype = 2r0001]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isAuthentication
	^ self isManagement and: [self subtype = 2r1011]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isBeacon
	^ self isManagement and: [self subtype = 2r1000]
! !

!WirelessPacket methodsFor:  'testing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
isCTS
	^ self isControl and: [self subtype = 2r1100]
! !

!WirelessPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isControl
	^ self type = 2r01
! !

!WirelessPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isData
	^ self type = 2r10
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDeauthentication
	^ self isManagement and: [self subtype = 2r1100]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDisassociation
	^ self isManagement and: [self subtype = 2r1010]
! !

!WirelessPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isManagement
	^ self type = 2r00
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isProbeRequest
	^ self isManagement and: [self subtype = 2r0100]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isProbeResponse
	^ self isManagement and: [self subtype = 2r0101]
! !

!WirelessPacket methodsFor:  'testing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
isRTS
	^ self isControl and: [self subtype = 2r1011]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isReasociationRequest
	^ self isManagement and: [self subtype = 2r0010]
! !

!WirelessPacket methodsFor:  'testing-management' stamp: 'KenD 28/Jun/2026 13:32:25'!
isReasociationResponse
	^ self isManagement and: [self subtype = 2r0011]
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
md
	"More data flag."
	^ (self frameControl bitShift: -13) odd
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
mf
	"More fragments flag."
	^ (self frameControl bitShift: -10) odd
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
order
	^ (self frameControl bitShift: -15) = 1
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
pm
	"Power management flag."
	^ (self frameControl bitShift: -12) odd
! !

!WirelessPacket methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: '802.11 '; nextPutAll: self typeName; nextPut: $/; nextPutAll: self subtypeName.
	aStream space; print: self source.
	self size > 10 ifTrue: [aStream nextPutAll: ' -> '; print: self destination]
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
retry
	"Answer true if this is a retransmission."
	^ (self frameControl bitShift: -11) odd
! !

!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
rx
	"Answer the receiving wireless station."
	^ EthernetAddress bytes: (self copyFrom: 17 to: 22)
! !

!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence
	^ self shortAt: 23
! !

!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
source
	^ EthernetAddress bytes: (self copyFrom: 5 to: 10)
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
subtype
	^ (self frameControl bitShift: -4) bitAnd: 2r1111
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
subtypeName
	self isManagement ifTrue: [^ #(AssociationRequest AssociationResponse ReassociationRequest ReassociationResponse ProbeRequest ProbeResponse Reserved Reserved Beacon ATIM Disassociation Authentication Deathentication Reserved Reserved Reserved) at: self subtype + 1].
	self isControl ifTrue: [^ #(Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved 'PS-Poll' RTS CTS ACK 'CF-End' 'CF-End+CF-ACK') at: self subtype + 1].
	self isData ifTrue: [^ #(Data 'Data+CF-ACK' 'Data+CF-Poll' 'Data+CF-ACK+CF-Poll' Null 'CF-ACK' 'CF-Poll' 'CF-ACK+CF-Poll' Reserved Reserved Reserved Reserved Reserved Reserved Reserved Reserved) at: self subtype + 1].
	^ #Reserved
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
toDS
	^ (self frameControl bitShift: -8) odd
! !

!WirelessPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
tx
	"Answer the transmitting wireless station."
	^ EthernetAddress bytes: (self copyFrom: 25 to: 30)
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ (self frameControl bitShift: -2) bitAnd: 2r11
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
typeName
	^ #(Management Data Control Reserved) at: self type + 1
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
version
	^ self frameControl bitAnd: 2r11
! !

!WirelessPacket methodsFor:  'accessing-control' stamp: 'KenD 28/Jun/2026 13:32:25'!
wep
	^ (self frameControl bitShift: -14) odd
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WirelessPacket class' category: 'SqueakNOS-Net-Packets'!
WirelessPacket class
	instanceVariableNames: ''!


