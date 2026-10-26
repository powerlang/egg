'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #Packet category: 'SqueakNOS-Net-Packets'!
ArrayedCollection subclass: #Packet
	instanceVariableNames: 'bytes offset envelope'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!Packet methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
>> aConduit
	aConduit input: self
! !

!Packet methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asByteArray
	^ bytes copyFrom: 1 + offset to: bytes size
! !

!Packet methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asString
	^ self asByteArray asString
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	^ bytes at: anInteger + offset
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger put: aByte
	^ bytes at: anInteger + offset put: aByte
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes
	^ bytes
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	bytes := aByteArray asByteArray
! !

!Packet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksumFrom: start to: stop
	^ self checksumOf: bytes from: start + offset to: stop + offset
! !

!Packet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksumOf: aByteArray from: start to: stop
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
! !

!Packet methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
computeChecksum
	^ self subclassResponsibility
! !

!Packet methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:32:25'!
copy
	^ self class bytes: bytes copy offset: offset
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
data
	^ nil
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
envelope
	^ envelope
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
envelope: aPacket
	envelope := aPacket
! !

!Packet methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fullPrintOn: aStream
	| packet |
	packet := self.
	[aStream print: packet; space.
	(packet := packet data) isNil] whileFalse: [aStream nextPutAll: '| ']
! !

!Packet methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fullPrintString
	^ String streamContents: [ :stream | self fullPrintOn: stream]
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
headerSize
	^ self class headerSize
! !

!Packet methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	offset := 0
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
longAt: anInteger
	^ (self shortAt: anInteger) * 16r10000 + (self shortAt: anInteger + 2)
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
longAt: anInteger put: aLong
	self shortAt: anInteger put: aLong // 16r10000.
	self shortAt: anInteger+2 put: aLong \\ 16r10000.
	^ aLong
! !

!Packet methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
normalizeChecksum: anInteger
	| sum |
	sum := anInteger.
	sum := sum >> 16 + (sum bitAnd: 16rFFFF).		"add hi 16 + low 16".
	sum := sum >> 16 + sum.		"add carry"
	^ sum bitAnd: 16rFFFF		"truncate to 16 bits"
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
offset
	^ offset
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
offset: anInteger
	offset := anInteger
! !

!Packet methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream print: self class; space.
	self do: [ :each |
		aStream
			nextPut: ('0123456789ABCDEF' at: each // 16 + 1);
			nextPut: ('0123456789ABCDEF' at: (each \\ 16 + 1))]
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
rawData
	^ self copyFrom: self headerSize + 1 to: self size
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
rawDataStream
	^ bytes readStream position: self headerSize + offset
! !

!Packet methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
setChecksum
	self checksum: 0.
	self checksum: 16rFFFF - self computeChecksum
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortAt: anInteger
	^ (self at: anInteger) * 256 + (self at: anInteger+1)
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortAt: anInteger put: aShort
	self at: anInteger put: aShort // 256.
	self at: anInteger+1 put: aShort \\ 256.
	^ aShort
! !

!Packet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ bytes size - offset
! !

!Packet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
species
	^ ByteArray
! !

!Packet methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
verifiesChecksum
	^ self computeChecksum = 16rFFFF
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Packet class' category: 'SqueakNOS-Net-Packets'!
Packet class
	instanceVariableNames: ''!

!Packet class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
allFieldsNames
	^ self basicFieldsNames, self fieldsNames
! !

!Packet class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
basicFieldsNames
	^ #(self bytes offset envelope data rawData)
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	^ self bytes: aByteArray offset: 0
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray offset: anInteger
	| bytes |
	anInteger >= 0 ifTrue: [^ self new bytes: aByteArray; offset: anInteger].
	bytes := ByteArray new: aByteArray size - anInteger.
	bytes replaceFrom: anInteger negated + 1 to: bytes size with: aByteArray.
	^ self new bytes: bytes; offset: 0
! !

!Packet class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
create: link identity: identity kind: kind
 
    ^ super new
        link: link
        identity: identity
        kind: kind

! !

!Packet class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
etherType
	^ nil
! !

!Packet class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fieldsNames
	^ #()
! !

!Packet class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
headerSize
	^ self error: 'undefined header size'
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ self basicNew initialize
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new: anInteger
	^ self bytes: (ByteArray new: 1500) offset: 1500 - anInteger - self headerSize
"
Note: the number 1500 is the default buffer size, a number supposedly close to (and not smaller than) the average packet size.
"
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aPacket
	^ self new
		bytes: aPacket bytes;
		offset: aPacket headerSize + aPacket offset;
		envelope: aPacket
! !

!Packet class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ nil
! !

!Packet class methodsFor:  'examples' stamp: 'KenD 28/Jun/2026 13:32:25'!
quake
	"
	EthernetPacket quake
	"
	^ self bytes: #(0 224 125 133 118 7 0 80 218 114 237 208 8 0 69 0 0 60 80 84 0 0 128 17 227 192 192 168 66 201 192 168 66 130 108 253 109 6 0 40 151 16 37 205 0 0 145 44 0 0)
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
with: aPacket
	^ self with: aPacket headerSize: self headerSize
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
with: aPacketOrByteArray headerSize: anInteger
	| answer |
	(aPacketOrByteArray isKindOf: Packet)
		ifFalse: [^ self bytes: aPacketOrByteArray offset: anInteger negated].

	answer := self bytes: aPacketOrByteArray bytes offset: aPacketOrByteArray offset - anInteger.
	aPacketOrByteArray envelope: answer.
	^ answer
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
with: aPacketOrByteArray headerSize: anInteger options: aCollection
	| optionsSize answer index |
	optionsSize := aCollection inject: 0 into: [ :count :each | count + each size].
	answer := self with: aPacketOrByteArray headerSize: anInteger + optionsSize + 1.
	index := anInteger + 1.
	aCollection do: [ :each |
		answer replaceFrom: index to: index + each size - 1 with: each.
		index := index + each size].
	answer at: index put: 0.
	^ answer
! !

!Packet class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
with: aPacket options: aCollection
	^ self with: aPacket headerSize: self headerSize options: aCollection
! !


Packet initialize!

