"
16 bits version of the initialization block.
see http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/19436.pdf
page 156
"
Class {
	#name : #LanceNICInitializationBlock16,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-Devices-Network'
}

{ #category : #'as yet unclassified' }
LanceNICInitializationBlock16 class >> fields [
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
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> address [
	^ self pointer asInteger
]

{ #category : #testing }
LanceNICInitializationBlock16 >> is16 [
	^ true
]

{ #category : #testing }
LanceNICInitializationBlock16 >> is32 [
	^ false
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> ladrf0 [
	"This method was automatically generated"
	^handle unsignedLongAt: 9
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> ladrf0: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> ladrf1 [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> ladrf1: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> logicalAddressFilter [
	^ self ladrf1 << 32 + self ladrf0
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> logicalAddressFilter: a64BitsInteger [
	self ladrf0: (a64BitsInteger bitAnd: 16rFFFFFFFF).
	self ladrf1: (a64BitsInteger >> 32 bitAnd: 16rFFFFFFFF).


]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mac0 [
	"This method was automatically generated"
	^handle unsignedShortAt: 3
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mac0: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mac1 [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mac1: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mac2 [
	"This method was automatically generated"
	^handle unsignedShortAt: 7
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mac2: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 7 put: anObject
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> macAddress [
	| addr |
	addr := self mac2 << 16 + self mac1 << 16 + self mac0.
	^ EthernetAddress fromInteger: addr
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> macAddress: anEthernetAddress [
	| a6BytesInteger |
	a6BytesInteger := anEthernetAddress asInteger.
	self mac0: (a6BytesInteger bitAnd: 16rFFFF).
	self mac1: (a6BytesInteger >> 16 bitAnd: 16rFFFF).
	self mac2: (a6BytesInteger >> 32 bitAnd: 16rFFFF).

]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mode [
	"This method was automatically generated"
	^handle unsignedShortAt: 1
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> mode: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 1 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> rdra0 [
	"This method was automatically generated"
	^handle unsignedShortAt: 17
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> rdra0: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 17 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> rdra1 [
	"This method was automatically generated"
	^handle unsignedByteAt: 19
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> rdra1: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 19 put: anObject
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> receiveRing [
	^ LanceNICReceiveRingDescriptor16 fromHandle: (ExternalAddress new fromInteger: (self receiveRingAddress))
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> receiveRing: aLanceNICReceiveRing [
	^ self receiveRingAddress: aLanceNICReceiveRing address
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> receiveRingAddress [
	^ self rdra1  << 16 + self rdra0
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> receiveRingAddress: address [
	((address bitXor: self address) bitAnd: 16rFF000000) isZero
		ifFalse: [^ self error: 'In 16 bits mode the address for the receive buffer must share the higher byte with that of the initialization block'].
	self rdra0: (address bitAnd: 16rFFFF).
	^ self rdra1: (address >> 16 bitAnd: 16rFF)
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> receiveRingLen [
	^ self rlen >> 5
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> receiveRingLen: ringLen [
	^ self rlen: ringLen << 5
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> rlen [
	"This method was automatically generated"
	^handle unsignedByteAt: 20
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> rlen: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 20 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> tdra0 [
	"This method was automatically generated"
	^handle unsignedShortAt: 21
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> tdra0: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 21 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> tdra1 [
	"This method was automatically generated"
	^handle unsignedByteAt: 23
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> tdra1: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 23 put: anObject
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> tlen [
	"This method was automatically generated"
	^handle unsignedByteAt: 24
]

{ #category : #accessing }
LanceNICInitializationBlock16 >> tlen: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 24 put: anObject
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> transmitRing [
	^ LanceNICTransmitRingDescriptor16 fromHandle: (ExternalAddress new fromInteger: (self transmitRingAddress))
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> transmitRing: aLanceNICTransmitRing [
	^ self transmitRingAddress: aLanceNICTransmitRing address
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> transmitRingAddress [
	^ self tdra1 << 16 + self tdra0 + (self address bitAnd: 16rFF000000)
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> transmitRingAddress: address [
	((address bitXor: self address) bitAnd: 16rFF000000) isZero
		ifFalse: [^ self error: 'In 16 bits mode all addresses must share the higher byte'].
	self tdra0: (address bitAnd: 16rFFFF).
	^ self tdra1: (address >> 16 bitAnd: 16rFF)
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> transmitRingLen [
	^ self tlen >> 5
]

{ #category : #'accessing - noauto' }
LanceNICInitializationBlock16 >> transmitRingLen: ringLen [
	^ self tlen: ringLen << 5
]
