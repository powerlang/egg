'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ARP category: 'SqueakNOS-Net-Protocols-Ethernet'!
Conduit subclass: #ARP
	instanceVariableNames: 'entries requests routes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-Ethernet'!
!ARP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ aPacket isKindOf: ARPPacket
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aNetAddress
	^ self at: aNetAddress ifAbsent: []
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aNetAddress ifAbsent: exceptionBlock
	entries do: [ :each | each protocol = aNetAddress ifTrue: [^ each hardware]].
	^ self
		at: (routes gatewayTo: aNetAddress ifNone: [^ exceptionBlock value]) gateway
		ifAbsent: exceptionBlock
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aProtocolAddress put: aHardwareAddress
	(entries detect: [ :one | one protocol = aProtocolAddress] ifNone: [entries add: ARPEntry new])
		protocol: aProtocolAddress;
		hardware: aHardwareAddress
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
cacheAt: aProtocolAddress put: aHardwareAddress
	(entries detect: [ :one | one protocol = aProtocolAddress] ifNone: [entries add: (ARPEntry new timeout: timer time + self keepMilliseconds)])
		protocol: aProtocolAddress;
		hardware: aHardwareAddress
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
flush
	"Flush the cache."
	entries := entries select: [ :each | each isStatic].
	requests := OrderedCollection new
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardwareAddress
	^ left address
! !

!ARP methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
includes: aNetAddress
	^ (self at: aNetAddress ifAbsent: []) notNil
! !

!ARP methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	entries := Set new.
	routes := RoutingTable new.
	self flush
! !

!ARP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: anARPPacket
	anARPPacket isRequest
		ifTrue: [self cacheAt: anARPPacket senderProtocolAddress put: anARPPacket senderHardwareAddress.
				self processRequest: anARPPacket].
	anARPPacket isReply
		ifTrue: [self processReply: anARPPacket].
	^ super input: anARPPacket
! !

!ARP methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
keepMilliseconds
	^ 20 * 60 * 1000
! !

!ARP methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
pauseMilliseconds
	^ 20 * 1000
! !

!ARP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
processReply: anARPPacket
	(requests detect: [ :one | one protocol = anARPPacket senderProtocolAddress] ifNone: [^ self]) reply: anARPPacket
! !

!ARP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
processRequest: anARPPacket
	| ethernet |
	anARPPacket targetProtocolAddress = self protocolAddress ifFalse: [^ self].
	anARPPacket
		opcodeName: #Reply;
		swapSenderAndTarget;
		senderHardwareAddress: self hardwareAddress.
	(ethernet := anARPPacket envelope)
		destination: anARPPacket targetHardwareAddress.
	self << ethernet
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocolAddress
	^ (entries detect: [ :one | one hardware = self hardwareAddress] ifNone: [^ nil]) protocol
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocolAddress: aNetAddress
	self at: aNetAddress put: self hardwareAddress
! !

!ARP methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
prune
	entries := entries select: [ :each | each isStatic or: [each timeout > timer time]]
! !

!ARP methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
pruneMilliseconds
	^ 5 * 60 * 1000
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
request: aNetAddress enqueue: aPacket
	| request |
	request :=
		requests detect: [ :one | one protocol = aNetAddress]
		ifNone: [requests add: (ARPRequest new arp: self; protocol: aNetAddress; retryTime: timer time)].
	request enqueue: aPacket.
	request retryTime >= timer time
		ifFalse: [request tries \\ 5 = 0 ifTrue: [HostDown new address: aNetAddress; signal].
				^ self].
	request send.
	request retryTime: timer time + (request tries \\ 5 = 0 ifTrue: [self retryMilliseconds] ifFalse: [self pauseMilliseconds])
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
requests
	^ requests
! !

!ARP methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
retryMilliseconds
	^ 1000
! !

!ARP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
routes
	^ routes
! !

!ARP methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
schedule
	super schedule.
	timer every: self pruneMilliseconds send: #prune to: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ARP class' category: 'SqueakNOS-Net-Protocols-Ethernet'!
ARP class
	instanceVariableNames: ''!


ARP initialize!

