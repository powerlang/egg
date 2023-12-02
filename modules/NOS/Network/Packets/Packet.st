Class {
	#name : #Packet,
	#superclass : #ArrayedCollection,
	#instVars : [
		'bytes',
		'offset',
		'envelope'
	],
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
Packet class >> allFieldsNames [
	^ self basicFieldsNames, self fieldsNames
]

{ #category : #accessing }
Packet class >> basicFieldsNames [
	^ #(self bytes offset envelope data rawData)
]

{ #category : #'instances creation' }
Packet class >> bytes: aByteArray [
	^ self bytes: aByteArray offset: 0
]

{ #category : #'instances creation' }
Packet class >> bytes: aByteArray offset: anInteger [
	| bytes |
	anInteger >= 0 ifTrue: [^ self new bytes: aByteArray; offset: anInteger].
	bytes := ByteArray new: aByteArray size - anInteger.
	bytes replaceFrom: anInteger negated + 1 to: bytes size with: aByteArray.
	^ self new bytes: bytes; offset: 0
]

{ #category : #'as yet unclassified' }
Packet class >> create: link identity: identity kind: kind [
 
    ^ super new
        link: link
        identity: identity
        kind: kind

]

{ #category : #accessing }
Packet class >> etherType [
	^ nil
]

{ #category : #accessing }
Packet class >> fieldsNames [
	^ #()
]

{ #category : #accessing }
Packet class >> headerSize [
	^ self error: 'undefined header size'
]

{ #category : #'instances creation' }
Packet class >> new [
	^ self basicNew initialize
]

{ #category : #'instances creation' }
Packet class >> new: anInteger [
	^ self bytes: (ByteArray new: 1500) offset: 1500 - anInteger - self headerSize
"
Note: the number 1500 is the default buffer size, a number supposedly close to (and not smaller than) the average packet size.
"
]

{ #category : #'instances creation' }
Packet class >> on: aPacket [
	^ self new
		bytes: aPacket bytes;
		offset: aPacket headerSize + aPacket offset;
		envelope: aPacket
]

{ #category : #accessing }
Packet class >> protocol [
	^ nil
]

{ #category : #examples }
Packet class >> quake [
	"
	EthernetPacket quake
	"
	^ self bytes: #(0 224 125 133 118 7 0 80 218 114 237 208 8 0 69 0 0 60 80 84 0 0 128 17 227 192 192 168 66 201 192 168 66 130 108 253 109 6 0 40 151 16 37 205 0 0 145 44 0 0)
]

{ #category : #'instances creation' }
Packet class >> with: aPacket [
	^ self with: aPacket headerSize: self headerSize
]

{ #category : #'instances creation' }
Packet class >> with: aPacketOrByteArray headerSize: anInteger [
	| answer |
	(aPacketOrByteArray isKindOf: Packet)
		ifFalse: [^ self bytes: aPacketOrByteArray offset: anInteger negated].

	answer := self bytes: aPacketOrByteArray bytes offset: aPacketOrByteArray offset - anInteger.
	aPacketOrByteArray envelope: answer.
	^ answer
]

{ #category : #'instances creation' }
Packet class >> with: aPacketOrByteArray headerSize: anInteger options: aCollection [
	| optionsSize answer index |
	optionsSize := aCollection inject: 0 into: [ :count :each | count + each size].
	answer := self with: aPacketOrByteArray headerSize: anInteger + optionsSize + 1.
	index := anInteger + 1.
	aCollection do: [ :each |
		answer replaceFrom: index to: index + each size - 1 with: each.
		index := index + each size].
	answer at: index put: 0.
	^ answer
]

{ #category : #'instances creation' }
Packet class >> with: aPacket options: aCollection [
	^ self with: aPacket headerSize: self headerSize options: aCollection
]

{ #category : #helpers }
Packet >> >> aConduit [
	aConduit input: self
]

{ #category : #converting }
Packet >> asByteArray [
	^ bytes copyFrom: 1 + offset to: bytes size
]

{ #category : #converting }
Packet >> asString [
	^ self asByteArray asString
]

{ #category : #accessing }
Packet >> at: anInteger [
	^ bytes at: anInteger + offset
]

{ #category : #accessing }
Packet >> at: anInteger put: aByte [
	^ bytes at: anInteger + offset put: aByte
]

{ #category : #accessing }
Packet >> bytes [
	^ bytes
]

{ #category : #accessing }
Packet >> bytes: aByteArray [
	bytes := aByteArray asByteArray
]

{ #category : #private }
Packet >> checksumFrom: start to: stop [
	^ self checksumOf: bytes from: start + offset to: stop + offset
]

{ #category : #private }
Packet >> checksumOf: aByteArray from: start to: stop [
	| nleft sum pos |
	nleft := stop - start + 1.
	sum := 0.

	pos := start.
	[nleft > 1]
		whileTrue: [sum := (aByteArray at: pos) * 256 + (aByteArray at: pos+1) + sum.
					pos := pos + 2.
					nleft := nleft - 2].

	nleft = 1 ifTrue: [sum := (aByteArray at: pos) * 256 + sum].

	^ self normalizeChecksum: sum
]

{ #category : #helpers }
Packet >> computeChecksum [
	^ self subclassResponsibility
]

{ #category : #copying }
Packet >> copy [
	^ self class bytes: bytes copy offset: offset
]

{ #category : #accessing }
Packet >> data [
	^ nil
]

{ #category : #accessing }
Packet >> envelope [
	^ envelope
]

{ #category : #accessing }
Packet >> envelope: aPacket [
	envelope := aPacket
]

{ #category : #printing }
Packet >> fullPrintOn: aStream [
	| packet |
	packet := self.
	[aStream print: packet; space.
	(packet := packet data) isNil] whileFalse: [aStream nextPutAll: '| ']
]

{ #category : #printing }
Packet >> fullPrintString [
	^ String streamContents: [ :stream | self fullPrintOn: stream]
]

{ #category : #accessing }
Packet >> headerSize [
	^ self class headerSize
]

{ #category : #initialization }
Packet >> initialize [
	offset := 0
]

{ #category : #accessing }
Packet >> longAt: anInteger [
	^ (self shortAt: anInteger) * 16r10000 + (self shortAt: anInteger + 2)
]

{ #category : #accessing }
Packet >> longAt: anInteger put: aLong [
	self shortAt: anInteger put: aLong // 16r10000.
	self shortAt: anInteger+2 put: aLong \\ 16r10000.
	^ aLong
]

{ #category : #helpers }
Packet >> normalizeChecksum: anInteger [
	| sum |
	sum := anInteger.
	sum := sum >> 16 + (sum bitAnd: 16rFFFF).		"add hi 16 + low 16".
	sum := sum >> 16 + sum.		"add carry"
	^ sum bitAnd: 16rFFFF		"truncate to 16 bits"
]

{ #category : #accessing }
Packet >> offset [
	^ offset
]

{ #category : #accessing }
Packet >> offset: anInteger [
	offset := anInteger
]

{ #category : #printing }
Packet >> printOn: aStream [
	aStream print: self class; space.
	self do: [ :each |
		aStream
			nextPut: ('0123456789ABCDEF' at: each // 16 + 1);
			nextPut: ('0123456789ABCDEF' at: (each \\ 16 + 1))]
]

{ #category : #accessing }
Packet >> rawData [
	^ self copyFrom: self headerSize + 1 to: self size
]

{ #category : #accessing }
Packet >> rawDataStream [
	^ bytes readStream position: self headerSize + offset
]

{ #category : #helpers }
Packet >> setChecksum [
	self checksum: 0.
	self checksum: 16rFFFF - self computeChecksum
]

{ #category : #accessing }
Packet >> shortAt: anInteger [
	^ (self at: anInteger) * 256 + (self at: anInteger+1)
]

{ #category : #accessing }
Packet >> shortAt: anInteger put: aShort [
	self at: anInteger put: aShort // 256.
	self at: anInteger+1 put: aShort \\ 256.
	^ aShort
]

{ #category : #accessing }
Packet >> size [
	^ bytes size - offset
]

{ #category : #private }
Packet >> species [
	^ ByteArray
]

{ #category : #testing }
Packet >> verifiesChecksum [
	^ self computeChecksum = 16rFFFF
]
