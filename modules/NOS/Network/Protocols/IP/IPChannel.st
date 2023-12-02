Class {
	#name : #IPChannel,
	#superclass : #Conduit,
	#instVars : [
		'localAddress',
		'remoteAddress',
		'reassembler',
		'ttl',
		'tos',
		'df',
		'options'
	],
	#category : 'SqueakNOS-Net-Protocols-IP'
}

{ #category : #flow }
IPChannel >> accepts: aPacket [
	^ (aPacket isKindOf: IPPacket)
		and: [aPacket version = 4
			and: [(localAddress isNil or: [aPacket destination = localAddress])
				and: [remoteAddress isNil or: [aPacket source = remoteAddress]]]]
]

{ #category : #accessing }
IPChannel >> df [
	^ df
]

{ #category : #accessing }
IPChannel >> df: aBoolean [
	df := aBoolean
]

{ #category : #initialization }
IPChannel >> initialize [
	super initialize.
	reassembler := IPReassembler new.
	reassembler > self.
	self < reassembler.

	ttl := 255.
	tos := 0.
	df := false.
	options := #()
]

{ #category : #flow }
IPChannel >> input: anIPPacket [
	anIPPacket verifiesChecksum ifFalse: [^ self error: 'Bad checksum'].
	anIPPacket isFragment
		ifTrue: [anIPPacket >> reassembler]
		ifFalse: [super input: anIPPacket data]
]

{ #category : #accessing }
IPChannel >> mtu [
	^ super mtu - IPPacket headerSize "- options size"
]

{ #category : #accessing }
IPChannel >> options [
	^ options
]

{ #category : #accessing }
IPChannel >> options: aCollection [
	options := aCollection
]

{ #category : #flow }
IPChannel >> output: aPacket [ 
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
		ifFalse: [Transcript cr; show: 'FRAGMENTING!'.
			(ip fragmentsSized: self mtu)
				do: [:each | super output: each]]
]

{ #category : #accessing }
IPChannel >> tos [
	^ tos
]

{ #category : #accessing }
IPChannel >> tos: anInteger [
	tos := anInteger
]

{ #category : #accessing }
IPChannel >> ttl [
	^ ttl
]

{ #category : #accessing }
IPChannel >> ttl: anInteger [
	ttl := anInteger
]
