'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ARPPacket category: 'SqueakNOS-Net-Packets'!
Packet subclass: #ARPPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardwareClass
	NetAddress allSubclassesDo: [ :each | each type = self hardwareType ifTrue: [^ each]].
	^ nil
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardwareSize
	^ self at: 5
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardwareSize: anInteger
	self at: 5 put: anInteger.

! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardwareType
	^ self shortAt: 1
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardwareType: anInteger
	self shortAt: 1 put: anInteger
! !

!ARPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isReply
	^ self opcode = 2
! !

!ARPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isRequest
	^ self opcode = 1
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
opcode
	^ self shortAt: 7 
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
opcode: anInteger
	self shortAt: 7 put: anInteger
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
opcodeName
	^ self opcodeNames at: self opcode ifAbsent: []
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
opcodeName: aSymbol
	^ self opcode: (self opcodeNames indexOf: aSymbol)
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
opcodeNames
	^ #(Request Reply RRequest RReply InRequest InReply NAK)
! !

!ARPPacket methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: 'ARP '.
	self isRequest
		ifTrue: [aStream nextPutAll: 'who-has '; print: self targetProtocolAddress; nextPutAll: ' tell '; print: self senderHardwareAddress.
				^ self].
	self isReply
		ifTrue: [aStream print: self senderProtocolAddress; nextPutAll: ' is-at '; print: self senderHardwareAddress.
				^ self].
	aStream nextPutAll: self opcodeName asString
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocolClass
	NetAddress allSubclassesDo: [ :each | each type = self protocolType ifTrue: [^ each]].
	^ nil
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocolSize
	^ self at: 6
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocolSize: anInteger
	self at: 6 put: anInteger.

! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocolType
	^ self shortAt: 3
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocolType: anInteger
	self shortAt: 3 put: anInteger
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
senderHardwareAddress
	^ (self hardwareClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 to: 9 - 1 + self hardwareSize)
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
senderHardwareAddress: aNetAddress
	self hardwareType: aNetAddress class type.
	self hardwareSize: aNetAddress size.
	self replaceFrom: 9 to: 9 - 1 + aNetAddress size with: aNetAddress asByteArray
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
senderProtocolAddress
	^ (self protocolClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 + self hardwareSize to: 8 + self hardwareSize + self protocolSize)
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
senderProtocolAddress: aNetAddress
	self protocolType: aNetAddress class type.
	self protocolSize: aNetAddress size.
	self replaceFrom: 9 + self hardwareSize to: 8 + self hardwareSize + aNetAddress size with: aNetAddress asByteArray
! !

!ARPPacket methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
swapSenderAndTarget
	| oldAddress |
	oldAddress := self senderHardwareAddress.
	self senderHardwareAddress: self targetHardwareAddress.
	self targetHardwareAddress: oldAddress.

	oldAddress := self senderProtocolAddress.
	self senderProtocolAddress: self targetProtocolAddress.
	self targetProtocolAddress: oldAddress
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
targetHardwareAddress
	^ (self hardwareClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 + self hardwareSize + self protocolSize to: 9 - 1 + (self hardwareSize*2) + self protocolSize)
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
targetHardwareAddress: aNetAddress
	self hardwareType: aNetAddress class type.
	self hardwareSize: aNetAddress size.
	self replaceFrom: 9 + self hardwareSize + self protocolSize to: 9 - 1 + (self hardwareSize*2) + self protocolSize with: aNetAddress asByteArray
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
targetProtocolAddress
	^ (self protocolClass ifNil: [^ nil])
		bytes: (self copyFrom: 9 + (self hardwareSize * 2) + self protocolSize to: 9 - 1 + (self hardwareSize + self protocolSize * 2))
! !

!ARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
targetProtocolAddress: aNetAddress
	self protocolType: aNetAddress class type.
	self protocolSize: aNetAddress size.
	self replaceFrom: 9 + (self hardwareSize * 2) + self protocolSize to: 8 + (self hardwareSize + self protocolSize * 2) with: aNetAddress asByteArray
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ARPPacket class' category: 'SqueakNOS-Net-Packets'!
ARPPacket class
	instanceVariableNames: ''!

!ARPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
etherType
	^ 16r806
! !

!ARPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fieldsNames
	^ #(hardwareAddressFormat protocolAddressFormat hardwareAddressLength protocolAddressLength opcode opcodeName)
! !

!ARPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
headerSize
	^ 7
! !


