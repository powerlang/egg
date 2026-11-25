'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ICMPPacket category: 'SqueakNOS-Net-Packets'!
Packet subclass: #ICMPPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksum
	^ self shortAt: 3
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksum: anInteger
	self shortAt: 3 put: anInteger
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
code
	^ self at: 2
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
code: anInteger
	self at: 2 put: anInteger
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
codeName
	^ self codeNames at: self code + 1 ifAbsent: [#UnknownCode]
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
codeName: aSymbol
	self code: (self codeNames indexOf: aSymbol) - 1
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
codeNames
	self type = 3 "Destination Unreachable"
		ifTrue: [^ #(NetUnreachable HostUnreachable ProtocolUnreachable PortUnreachable FragmentationNeeded SourceRouteFailed NetUnknown HostUnknown HostIsolated NetAnomaly HostAnomaly NetUnrTos HostUnrTos PacketFiltered PrecedenceViolation PrecedenceCutOff)].
	self type = 5 "Redirect (change route)"
		ifTrue: [^ #(RedirectNet RedirectHost RedirectNetForTOS RedirectHostForTOS)].
	self type = 11 "Time Exceeded"
		ifTrue: [^ #(TTLCountExceeded FragmentationReassemblyTimeExceeded)].
	^ #()
! !

!ICMPPacket methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
computeChecksum
	^ self checksumFrom: 1 to: self size
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
gateway
	^ InternetAddress bytes: (self copyFrom: 5 to: 8)
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
gateway: anInternetAddress
	self replaceFrom: 5 to: 8 with: anInternetAddress asByteArray
! !

!ICMPPacket methodsFor:  'accessing-echo' stamp: 'KenD 28/Jun/2026 13:32:25'!
id
	^ self shortAt: 5
! !

!ICMPPacket methodsFor:  'accessing-echo' stamp: 'KenD 28/Jun/2026 13:32:25'!
id: anInteger
	self shortAt: 5 put: anInteger
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDestinationUnreachable
	^ self type = 3
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isEchoReply
	^ self type = 0
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isEchoRequest
	^ self type = 8
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isError
	^ self isQuery not
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isHostUnreachable
	^ self type = 3 and: [self code = 1]
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isNetUnreachable
	^ self type = 3 and: [self code = 0]
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isPortUnreachable
	^ self type = 3 and: [self code = 3]
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isProtocolUnreachable
	^ self type = 3 and: [self code = 2]
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isQuery
	^ #(0 8 9 10 13 14 15 16 17 18) includes: self type
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isRedirect
	^ self type = 5
! !

!ICMPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isTimestampRequest
	^ self type = 13
! !

!ICMPPacket methodsFor:  'accessing-fragmented' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu
	^ self shortAt: 7
! !

!ICMPPacket methodsFor:  'accessing-fragmented' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu: anInteger
	self shortAt: 7 put: anInteger
! !

!ICMPPacket methodsFor:  'accessing-timestamp' stamp: 'KenD 28/Jun/2026 13:32:25'!
originateTimestamp
	^ self longAt: 9
! !

!ICMPPacket methodsFor:  'accessing-timestamp' stamp: 'KenD 28/Jun/2026 13:32:25'!
originateTimestamp: anInteger
	self longAt: 9 put: anInteger
! !

!ICMPPacket methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: 'ICMP ', self typeName, ' ', self codeName
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
quote
	^ IPPacket on: self
! !

!ICMPPacket methodsFor:  'accessing-timestamp' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveTimestamp
	^ self longAt: 13
! !

!ICMPPacket methodsFor:  'accessing-timestamp' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveTimestamp: anInteger
	self longAt: 13 put: anInteger
! !

!ICMPPacket methodsFor:  'accessing-echo' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence
	^ self shortAt: 7
! !

!ICMPPacket methodsFor:  'accessing-echo' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence: anInteger
	self shortAt: 7 put: anInteger
! !

!ICMPPacket methodsFor:  'accessing-timestamp' stamp: 'KenD 28/Jun/2026 13:32:25'!
transmitTimestamp
	^ self longAt: 17
! !

!ICMPPacket methodsFor:  'accessing-timestamp' stamp: 'KenD 28/Jun/2026 13:32:25'!
transmitTimestamp: anInteger
	self longAt: 17 put: anInteger
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ self at: 1
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type: anInteger
	^ self at: 1 put: anInteger
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
typeName
	^ self typeNames at: self type + 1
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
typeName: aSymbol
	^ self type: (self typeNames indexOf: aSymbol) - 1
! !

!ICMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
typeNames
	^ #(EchoReply nil nil DestinationUnreachable SourceQuench Redirect nil nil EchoRequest RouterAdvertisement RouterSolicitation TimeExceeded ParameterProblem TimestampRequest TimestampReply InfoRequest InfoReply AddressMaskRequest AddressMaskReply)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ICMPPacket class' category: 'SqueakNOS-Net-Packets'!
ICMPPacket class
	instanceVariableNames: ''!

!ICMPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fieldsNames
	^ #( type typeName code codeName checksum)
! !

!ICMPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
headerSize
	^ 8
! !

!ICMPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ 1
! !

!ICMPPacket class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
quote: anIPPacket
	^ self with: (anIPPacket copyFrom: 1 to: anIPPacket headerSize + 8)
! !


