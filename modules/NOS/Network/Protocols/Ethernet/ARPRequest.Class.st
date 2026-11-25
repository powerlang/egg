'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ARPRequest category: 'SqueakNOS-Net-Protocols-Ethernet'!
Object subclass: #ARPRequest
	instanceVariableNames: 'arp protocol retryTime pendingPackets tries'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-Ethernet'!
!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
arp: anARP
	arp := anARP
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
delete
	arp requests remove: self ifAbsent: []
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
enqueue: aPacket
	pendingPackets add: aPacket
! !

!ARPRequest methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	pendingPackets := OrderedCollection new: 1.
	tries := 0
! !

!ARPRequest methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: 'who-has '; print: protocol; nextPutAll: ' ('; print: tries; nextPutAll: ' tries, '; print: pendingPackets size; nextPutAll: ' packets pending)'
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ protocol
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol: aNetAddress
	protocol := aNetAddress
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reply: anARPPacket
	arp cacheAt: anARPPacket senderProtocolAddress put: anARPPacket senderHardwareAddress.
	pendingPackets do: [ :each | arp << each].
	self delete
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
retryTime
	^ retryTime
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
retryTime: time
	retryTime := time
! !

!ARPRequest methodsFor:  'old api' stamp: 'KenD 28/Jun/2026 13:32:25'!
send
	| packet ethernet |
	tries := tries + 1.
	packet := (ARPPacket new: 42)
		opcodeName: #Request;
		senderHardwareAddress: arp hardwareAddress;
		senderProtocolAddress: arp protocolAddress;
		targetProtocolAddress: protocol.
	ethernet := (EthernetPacket with: packet)
		destination: EthernetAddress broadcast.
	arp << ethernet
! !

!ARPRequest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
tries
	^ tries
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ARPRequest class' category: 'SqueakNOS-Net-Protocols-Ethernet'!
ARPRequest class
	instanceVariableNames: ''!

!ARPRequest class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ super new initialize
! !


ARPRequest initialize!

