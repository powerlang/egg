'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IPChannel category: 'SqueakNOS-Net-Protocols-IP'!
Conduit subclass: #IPChannel
	instanceVariableNames: 'localAddress remoteAddress reassembler ttl tos df options'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-IP'!
!IPChannel methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ (aPacket isKindOf: IPPacket)
		and: [aPacket version = 4
			and: [(localAddress isNil or: [aPacket destination = localAddress])
				and: [remoteAddress isNil or: [aPacket source = remoteAddress]]]]
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
df
	^ df
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
df: aBoolean
	df := aBoolean
! !

!IPChannel methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	reassembler := IPReassembler new.
	reassembler > self.
	self < reassembler.

	ttl := 255.
	tos := 0.
	df := false.
	options := #()
! !

!IPChannel methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: anIPPacket
	anIPPacket verifiesChecksum ifFalse: [^ self error: 'Bad checksum'].
	anIPPacket isFragment
		ifTrue: [anIPPacket >> reassembler]
		ifFalse: [super input: anIPPacket data]
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu
	^ super mtu - IPPacket headerSize "- options size"
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
options
	^ options
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
options: aCollection
	options := aCollection
! !

!IPChannel methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
output: aPacket
	| ip |
	(ip := IPPacket with: aPacket options: options) source: localAddress;
		 destination: remoteAddress;
		 ttl: ttl;
		 tos: tos;
		 df: df;
		 id: 65536 atRandom - 1.
	ip setChecksum.
	ip data setChecksum.
	ip size <= self mtu
		ifTrue: [super output: ip]
		ifFalse: [Transcript cr; show: 'FRAGMENTING!!'.
			(ip fragmentsSized: self mtu)
				do: [:each | super output: each]]
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
tos
	^ tos
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
tos: anInteger
	tos := anInteger
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
ttl
	^ ttl
! !

!IPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
ttl: anInteger
	ttl := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IPChannel class' category: 'SqueakNOS-Net-Protocols-IP'!
IPChannel class
	instanceVariableNames: ''!


IPChannel initialize!

