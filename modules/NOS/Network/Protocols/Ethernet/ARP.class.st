Class {
	#name : #ARP,
	#superclass : #Conduit,
	#instVars : [
		'entries',
		'requests',
		'routes'
	],
	#category : 'SqueakNOS-Net-Protocols-Ethernet'
}

{ #category : #flow }
ARP >> accepts: aPacket [
	^ aPacket isKindOf: ARPPacket
]

{ #category : #accessing }
ARP >> at: aNetAddress [
	^ self at: aNetAddress ifAbsent: []
]

{ #category : #accessing }
ARP >> at: aNetAddress ifAbsent: exceptionBlock [
	entries do: [ :each | each protocol = aNetAddress ifTrue: [^ each hardware]].
	^ self
		at: (routes gatewayTo: aNetAddress ifNone: [^ exceptionBlock value]) gateway
		ifAbsent: exceptionBlock
]

{ #category : #accessing }
ARP >> at: aProtocolAddress put: aHardwareAddress [
	(entries detect: [ :one | one protocol = aProtocolAddress] ifNone: [entries add: ARPEntry new])
		protocol: aProtocolAddress;
		hardware: aHardwareAddress
]

{ #category : #accessing }
ARP >> cacheAt: aProtocolAddress put: aHardwareAddress [
	(entries detect: [ :one | one protocol = aProtocolAddress] ifNone: [entries add: (ARPEntry new timeout: timer time + self keepMilliseconds)])
		protocol: aProtocolAddress;
		hardware: aHardwareAddress
]

{ #category : #accessing }
ARP >> flush [
	"Flush the cache."
	entries := entries select: [ :each | each isStatic].
	requests := OrderedCollection new
]

{ #category : #accessing }
ARP >> hardwareAddress [
	^ left address
]

{ #category : #testing }
ARP >> includes: aNetAddress [
	^ (self at: aNetAddress ifAbsent: []) notNil
]

{ #category : #initialization }
ARP >> initialize [
	super initialize.
	entries := Set new.
	routes := RoutingTable new.
	self flush
]

{ #category : #flow }
ARP >> input: anARPPacket [
	anARPPacket isRequest
		ifTrue: [self cacheAt: anARPPacket senderProtocolAddress put: anARPPacket senderHardwareAddress.
				self processRequest: anARPPacket].
	anARPPacket isReply
		ifTrue: [self processReply: anARPPacket].
	^ super input: anARPPacket
]

{ #category : #timers }
ARP >> keepMilliseconds [
	^ 20 * 60 * 1000
]

{ #category : #timers }
ARP >> pauseMilliseconds [
	^ 20 * 1000
]

{ #category : #flow }
ARP >> processReply: anARPPacket [
	(requests detect: [ :one | one protocol = anARPPacket senderProtocolAddress] ifNone: [^ self]) reply: anARPPacket
]

{ #category : #flow }
ARP >> processRequest: anARPPacket [
	| ethernet |
	anARPPacket targetProtocolAddress = self protocolAddress ifFalse: [^ self].
	anARPPacket
		opcodeName: #Reply;
		swapSenderAndTarget;
		senderHardwareAddress: self hardwareAddress.
	(ethernet := anARPPacket envelope)
		destination: anARPPacket targetHardwareAddress.
	self << ethernet
]

{ #category : #accessing }
ARP >> protocolAddress [
	^ (entries detect: [ :one | one hardware = self hardwareAddress] ifNone: [^ nil]) protocol
]

{ #category : #accessing }
ARP >> protocolAddress: aNetAddress [
	self at: aNetAddress put: self hardwareAddress
]

{ #category : #timers }
ARP >> prune [
	entries := entries select: [ :each | each isStatic or: [each timeout > timer time]]
]

{ #category : #timers }
ARP >> pruneMilliseconds [
	^ 5 * 60 * 1000
]

{ #category : #accessing }
ARP >> request: aNetAddress enqueue: aPacket [
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
]

{ #category : #accessing }
ARP >> requests [
	^ requests
]

{ #category : #timers }
ARP >> retryMilliseconds [
	^ 1000
]

{ #category : #accessing }
ARP >> routes [
	^ routes
]

{ #category : #timers }
ARP >> schedule [
	super schedule.
	timer every: self pruneMilliseconds send: #prune to: self
]
