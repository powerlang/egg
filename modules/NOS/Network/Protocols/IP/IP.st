Class {
	#name : #IP,
	#superclass : #Conduit,
	#instVars : [
		'address',
		'reassembler',
		'raw'
	],
	#category : 'SqueakNOS-Net-Protocols-IP'
}

{ #category : #flow }
IP >> accepts: aPacket [
	^ (aPacket isKindOf: IPPacket) and: [aPacket version = 4 and: [address isNil or: [aPacket destination = address]]]
]

{ #category : #accessing }
IP >> address [
	^ address
]

{ #category : #accessing }
IP >> address: anInternetAddress [
	address := anInternetAddress
]

{ #category : #accessing }
IP >> icmp [
	^ self findA: ICMP
]

{ #category : #initialization }
IP >> initialize [
	super initialize.
	reassembler := IPReassembler new.
	reassembler > self.
	self < reassembler.
	self | ICMP new.
	raw := Conduit new
]

{ #category : #flow }
IP >> input: anIPPacket [
	anIPPacket verifiesChecksum ifFalse: [^ self error: 'Bad checksum'].
	anIPPacket source isUnicast ifFalse: [^ self error: 'Bad source address'].
	anIPPacket isFragment
		ifTrue: [anIPPacket >> reassembler]
		ifFalse: [anIPPacket >> raw.
				super input: anIPPacket data]
]

{ #category : #accessing }
IP >> mtu [
	^ super mtu - IPPacket headerSize
]

{ #category : #flow }
IP >> output: aPacket [
	| data |
	address isNil ifFalse: [aPacket source: address].
	aPacket ttl = 0 ifTrue: [aPacket ttl: 255].
	aPacket id: 65536 atRandom - 1.
	aPacket setChecksum.
	(data := aPacket data) ifNotNil: [data setChecksum].
	aPacket size <= self mtu
		ifTrue: [super output: aPacket]
		ifFalse: [Transcript cr; show: 'FRAGMENTING!'.
				(aPacket fragmentsSized: self mtu) do: [ :each | super output: each]]
]

{ #category : #accessing }
IP >> raw [
	^ raw
]

{ #category : #accessing }
IP >> tcp [
	^ self findA: TCP
]

{ #category : #accessing }
IP >> udp [
	^ self findA: UDP
]

{ #category : #flow }
IP >> undeliverable: aPacket [
	| icmp ip |
	icmp := (ICMPPacket quote: aPacket envelope)
		typeName: #DestinationUnreachable;
		codeName: #ProtocolUnreachable.
	ip := (IPPacket with: icmp)
		source: aPacket envelope destination;
		destination: aPacket envelope source.
	self << ip
]
