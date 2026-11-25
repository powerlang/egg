'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IP category: 'SqueakNOS-Net-Protocols-IP'!
Conduit subclass: #IP
	instanceVariableNames: 'address reassembler raw'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-IP'!
!IP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ (aPacket isKindOf: IPPacket) and: [aPacket version = 4 and: [address isNil or: [aPacket destination = address]]]
! !

!IP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	^ address
! !

!IP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address: anInternetAddress
	address := anInternetAddress
! !

!IP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
icmp
	^ self findA: ICMP
! !

!IP methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	reassembler := IPReassembler new.
	reassembler > self.
	self < reassembler.
	self | ICMP new.
	raw := Conduit new
! !

!IP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: anIPPacket
	anIPPacket verifiesChecksum ifFalse: [^ self error: 'Bad checksum'].
	anIPPacket source isUnicast ifFalse: [^ self error: 'Bad source address'].
	anIPPacket isFragment
		ifTrue: [anIPPacket >> reassembler]
		ifFalse: [anIPPacket >> raw.
				super input: anIPPacket data]
! !

!IP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu
	^ super mtu - IPPacket headerSize
! !

!IP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
output: aPacket
	| data |
	address isNil ifFalse: [aPacket source: address].
	aPacket ttl = 0 ifTrue: [aPacket ttl: 255].
	aPacket id: 65536 atRandom - 1.
	aPacket setChecksum.
	(data := aPacket data) ifNotNil: [data setChecksum].
	aPacket size <= self mtu
		ifTrue: [super output: aPacket]
		ifFalse: [Transcript cr; show: 'FRAGMENTING!!'.
				(aPacket fragmentsSized: self mtu) do: [ :each | super output: each]]
! !

!IP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
raw
	^ raw
! !

!IP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
tcp
	^ self findA: TCP
! !

!IP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
udp
	^ self findA: UDP
! !

!IP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
undeliverable: aPacket
	| icmp ip |
	icmp := (ICMPPacket quote: aPacket envelope)
		typeName: #DestinationUnreachable;
		codeName: #ProtocolUnreachable.
	ip := (IPPacket with: icmp)
		source: aPacket envelope destination;
		destination: aPacket envelope source.
	self << ip
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IP class' category: 'SqueakNOS-Net-Protocols-IP'!
IP class
	instanceVariableNames: ''!


IP initialize!

