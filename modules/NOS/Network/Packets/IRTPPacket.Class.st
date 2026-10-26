'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IRTPPacket category: 'SqueakNOS-Net-Packets'!
Packet subclass: #IRTPPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksum
	^ self shortAt: 7
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksum: anInteger
	^ self shortAt: 7 put: anInteger
! !

!IRTPPacket methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
computeChecksum
	^ self checksumFrom: 1 to: self size
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length
	^ self shortAt: 5
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length: anInteger
	^ self shortAt: 5 put: anInteger
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
port
	^ self second
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
port: anInteger
	^ self at: 2 put: anInteger
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence
	^ self shortAt: 3
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence: anInteger
	^ self shortAt: 3 put: anInteger
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ self first
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type: anInteger
	self at: 1 put: anInteger
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
typeName
	^ self typeNames at: self type + 1
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
typeName: aSymbol
	^ self type: (self typeNames indexOf: aSymbol) - 1
! !

!IRTPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
typeNames
	^ #(Synch SynchAck Data DataAck PortNak)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IRTPPacket class' category: 'SqueakNOS-Net-Packets'!
IRTPPacket class
	instanceVariableNames: ''!

!IRTPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fieldsNames
	^ #(type typeName port sequence length checksum)
! !

!IRTPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
headerSize
	^ 8
! !

!IRTPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ 28
! !


