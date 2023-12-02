Class {
	#name : #ICMPPacket,
	#superclass : #Packet,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
ICMPPacket class >> fieldsNames [
	^ #( type typeName code codeName checksum)
]

{ #category : #accessing }
ICMPPacket class >> headerSize [
	^ 8
]

{ #category : #accessing }
ICMPPacket class >> protocol [
	^ 1
]

{ #category : #'instance creation' }
ICMPPacket class >> quote: anIPPacket [
	^ self with: (anIPPacket copyFrom: 1 to: anIPPacket headerSize + 8)
]

{ #category : #accessing }
ICMPPacket >> checksum [
	^ self shortAt: 3
]

{ #category : #accessing }
ICMPPacket >> checksum: anInteger [
	self shortAt: 3 put: anInteger
]

{ #category : #accessing }
ICMPPacket >> code [
	^ self at: 2
]

{ #category : #accessing }
ICMPPacket >> code: anInteger [
	self at: 2 put: anInteger
]

{ #category : #accessing }
ICMPPacket >> codeName [
	^ self codeNames at: self code + 1 ifAbsent: [#UnknownCode]
]

{ #category : #accessing }
ICMPPacket >> codeName: aSymbol [
	self code: (self codeNames indexOf: aSymbol) - 1
]

{ #category : #accessing }
ICMPPacket >> codeNames [
	self type = 3 "Destination Unreachable"
		ifTrue: [^ #(NetUnreachable HostUnreachable ProtocolUnreachable PortUnreachable FragmentationNeeded SourceRouteFailed NetUnknown HostUnknown HostIsolated NetAnomaly HostAnomaly NetUnrTos HostUnrTos PacketFiltered PrecedenceViolation PrecedenceCutOff)].
	self type = 5 "Redirect (change route)"
		ifTrue: [^ #(RedirectNet RedirectHost RedirectNetForTOS RedirectHostForTOS)].
	self type = 11 "Time Exceeded"
		ifTrue: [^ #(TTLCountExceeded FragmentationReassemblyTimeExceeded)].
	^ #()
]

{ #category : #helpers }
ICMPPacket >> computeChecksum [
	^ self checksumFrom: 1 to: self size
]

{ #category : #accessing }
ICMPPacket >> gateway [
	^ InternetAddress bytes: (self copyFrom: 5 to: 8)
]

{ #category : #accessing }
ICMPPacket >> gateway: anInternetAddress [
	self replaceFrom: 5 to: 8 with: anInternetAddress asByteArray
]

{ #category : #'accessing-echo' }
ICMPPacket >> id [
	^ self shortAt: 5
]

{ #category : #'accessing-echo' }
ICMPPacket >> id: anInteger [
	self shortAt: 5 put: anInteger
]

{ #category : #testing }
ICMPPacket >> isDestinationUnreachable [
	^ self type = 3
]

{ #category : #testing }
ICMPPacket >> isEchoReply [
	^ self type = 0
]

{ #category : #testing }
ICMPPacket >> isEchoRequest [
	^ self type = 8
]

{ #category : #testing }
ICMPPacket >> isError [
	^ self isQuery not
]

{ #category : #testing }
ICMPPacket >> isHostUnreachable [
	^ self type = 3 and: [self code = 1]
]

{ #category : #testing }
ICMPPacket >> isNetUnreachable [
	^ self type = 3 and: [self code = 0]
]

{ #category : #testing }
ICMPPacket >> isPortUnreachable [
	^ self type = 3 and: [self code = 3]
]

{ #category : #testing }
ICMPPacket >> isProtocolUnreachable [
	^ self type = 3 and: [self code = 2]
]

{ #category : #testing }
ICMPPacket >> isQuery [
	^ #(0 8 9 10 13 14 15 16 17 18) includes: self type
]

{ #category : #testing }
ICMPPacket >> isRedirect [
	^ self type = 5
]

{ #category : #testing }
ICMPPacket >> isTimestampRequest [
	^ self type = 13
]

{ #category : #'accessing-fragmented' }
ICMPPacket >> mtu [
	^ self shortAt: 7
]

{ #category : #'accessing-fragmented' }
ICMPPacket >> mtu: anInteger [
	self shortAt: 7 put: anInteger
]

{ #category : #'accessing-timestamp' }
ICMPPacket >> originateTimestamp [
	^ self longAt: 9
]

{ #category : #'accessing-timestamp' }
ICMPPacket >> originateTimestamp: anInteger [
	self longAt: 9 put: anInteger
]

{ #category : #printing }
ICMPPacket >> printOn: aStream [
	aStream nextPutAll: 'ICMP ', self typeName, ' ', self codeName
]

{ #category : #accessing }
ICMPPacket >> quote [
	^ IPPacket on: self
]

{ #category : #'accessing-timestamp' }
ICMPPacket >> receiveTimestamp [
	^ self longAt: 13
]

{ #category : #'accessing-timestamp' }
ICMPPacket >> receiveTimestamp: anInteger [
	self longAt: 13 put: anInteger
]

{ #category : #'accessing-echo' }
ICMPPacket >> sequence [
	^ self shortAt: 7
]

{ #category : #'accessing-echo' }
ICMPPacket >> sequence: anInteger [
	self shortAt: 7 put: anInteger
]

{ #category : #'accessing-timestamp' }
ICMPPacket >> transmitTimestamp [
	^ self longAt: 17
]

{ #category : #'accessing-timestamp' }
ICMPPacket >> transmitTimestamp: anInteger [
	self longAt: 17 put: anInteger
]

{ #category : #accessing }
ICMPPacket >> type [
	^ self at: 1
]

{ #category : #accessing }
ICMPPacket >> type: anInteger [
	^ self at: 1 put: anInteger
]

{ #category : #accessing }
ICMPPacket >> typeName [
	^ self typeNames at: self type + 1
]

{ #category : #accessing }
ICMPPacket >> typeName: aSymbol [
	^ self type: (self typeNames indexOf: aSymbol) - 1
]

{ #category : #accessing }
ICMPPacket >> typeNames [
	^ #(EchoReply nil nil DestinationUnreachable SourceQuench Redirect nil nil EchoRequest RouterAdvertisement RouterSolicitation TimeExceeded ParameterProblem TimestampRequest TimestampReply InfoRequest InfoReply AddressMaskRequest AddressMaskReply)
]
