'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #LanceNICInitializationBlock16 category: 'SqueakNOS-Devices-Network'!
ExternalStructure subclass: #LanceNICInitializationBlock16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Network'!
!LanceNICInitializationBlock16 commentStamp: '<historical>' prior: 0!

16 bits version of the initialization block.
see http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/19436.pdf
page 156
!

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
address
	^ self pointer asInteger
! !

!LanceNICInitializationBlock16 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
is16
	^ true
! !

!LanceNICInitializationBlock16 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
is32
	^ false
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
ladrf0
	"This method was automatically generated"
	^handle unsignedLongAt: 9
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
ladrf0: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
ladrf1
	"This method was automatically generated"
	^handle unsignedLongAt: 13
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
ladrf1: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
logicalAddressFilter
	^ self ladrf1 << 32 + self ladrf0
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
logicalAddressFilter: a64BitsInteger
	self ladrf0: (a64BitsInteger bitAnd: 16rFFFFFFFF).
	self ladrf1: (a64BitsInteger >> 32 bitAnd: 16rFFFFFFFF).


! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mac0
	"This method was automatically generated"
	^handle unsignedShortAt: 3
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mac0: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mac1
	"This method was automatically generated"
	^handle unsignedShortAt: 5
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mac1: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mac2
	"This method was automatically generated"
	^handle unsignedShortAt: 7
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mac2: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 7 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
macAddress
	| addr |
	addr := self mac2 << 16 + self mac1 << 16 + self mac0.
	^ EthernetAddress fromInteger: addr
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
macAddress: anEthernetAddress
	| a6BytesInteger |
	a6BytesInteger := anEthernetAddress asInteger.
	self mac0: (a6BytesInteger bitAnd: 16rFFFF).
	self mac1: (a6BytesInteger >> 16 bitAnd: 16rFFFF).
	self mac2: (a6BytesInteger >> 32 bitAnd: 16rFFFF).

! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mode
	"This method was automatically generated"
	^handle unsignedShortAt: 1
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mode: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 1 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rdra0
	"This method was automatically generated"
	^handle unsignedShortAt: 17
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rdra0: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 17 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rdra1
	"This method was automatically generated"
	^handle unsignedByteAt: 19
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rdra1: anObject
	"This method was automatically generated"
	handle unsignedByteAt: 19 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveRing
	^ LanceNICReceiveRingDescriptor16 fromHandle: (ExternalAddress new fromInteger: (self receiveRingAddress))
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveRing: aLanceNICReceiveRing
	^ self receiveRingAddress: aLanceNICReceiveRing address
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveRingAddress
	^ self rdra1  << 16 + self rdra0
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveRingAddress: address
	((address bitXor: self address) bitAnd: 16rFF000000) isZero
		ifFalse: [^ self error: 'In 16 bits mode the address for the receive buffer must share the higher byte with that of the initialization block'].
	self rdra0: (address bitAnd: 16rFFFF).
	^ self rdra1: (address >> 16 bitAnd: 16rFF)
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveRingLen
	^ self rlen >> 5
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveRingLen: ringLen
	^ self rlen: ringLen << 5
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rlen
	"This method was automatically generated"
	^handle unsignedByteAt: 20
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rlen: anObject
	"This method was automatically generated"
	handle unsignedByteAt: 20 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
tdra0
	"This method was automatically generated"
	^handle unsignedShortAt: 21
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
tdra0: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 21 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
tdra1
	"This method was automatically generated"
	^handle unsignedByteAt: 23
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
tdra1: anObject
	"This method was automatically generated"
	handle unsignedByteAt: 23 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
tlen
	"This method was automatically generated"
	^handle unsignedByteAt: 24
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
tlen: anObject
	"This method was automatically generated"
	handle unsignedByteAt: 24 put: anObject
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitRing
	^ LanceNICTransmitRingDescriptor16 fromHandle: (ExternalAddress new fromInteger: (self transmitRingAddress))
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitRing: aLanceNICTransmitRing
	^ self transmitRingAddress: aLanceNICTransmitRing address
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitRingAddress
	^ self tdra1 << 16 + self tdra0 + (self address bitAnd: 16rFF000000)
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitRingAddress: address
	((address bitXor: self address) bitAnd: 16rFF000000) isZero
		ifFalse: [^ self error: 'In 16 bits mode all addresses must share the higher byte'].
	self tdra0: (address bitAnd: 16rFFFF).
	^ self tdra1: (address >> 16 bitAnd: 16rFF)
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitRingLen
	^ self tlen >> 5
! !

!LanceNICInitializationBlock16 methodsFor:  'accessing - noauto' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitRingLen: ringLen
	^ self tlen: ringLen << 5
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LanceNICInitializationBlock16 class' category: 'SqueakNOS-Devices-Network'!
LanceNICInitializationBlock16 class
	instanceVariableNames: ''!

!LanceNICInitializationBlock16 class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
fields
	"self defineFields"
	^#(
		(mode 'ushort')
		(mac0 'ushort')
		(mac1 'ushort')
		(mac2 'ushort')
		(ladrf0 'ulong')
		(ladrf1 'ulong')
		(rdra0 'ushort')
		(rdra1 'byte')
		(rlen 'byte')
		(tdra0 'ushort')
		(tdra1 'byte')
		(tlen 'byte')
	)
! !


