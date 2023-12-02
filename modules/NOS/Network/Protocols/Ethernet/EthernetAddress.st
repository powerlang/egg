Class {
	#name : #EthernetAddress,
	#superclass : #NetAddress,
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #'instance creation' }
EthernetAddress class >> broadcast [
	^ self bytes: #(255 255 255 255 255 255)
]

{ #category : #'instance creation' }
EthernetAddress class >> fromInteger: anInteger [
	^ self bytes: (anInteger asByteArrayOfSize: 6) reversed
]

{ #category : #'instance creation' }
EthernetAddress class >> fromString: aString [
	"Return the internet address represented by the given string. The string should contain four positive decimal integers delimited by periods, commas, or spaces, where each integer represents one address byte. Return nil if the string is not a host address in an acceptable format."
	"self fromString: '00:48:54:85:CC:51'"

	^ self bytes: ((aString findTokens: ':- ') collect: [ :each | Integer readFrom: each readStream base: 16])
]

{ #category : #accessing }
EthernetAddress class >> type [
	^ 1
]

{ #category : #converting }
EthernetAddress >> asInteger [
	^ (bytes unsignedShortAt: 5) << 16 + (bytes unsignedShortAt: 3) << 16 + (bytes unsignedShortAt: 1)

]

{ #category : #testing }
EthernetAddress >> isBroadcast [
	^ self bytes allSatisfy: [ :each | each = 255]
]

{ #category : #testing }
EthernetAddress >> isMulticast [
	^ (self bytes at: 1) = 16r01
		and: [(self bytes at: 2) = 16r00
			and: [(self bytes at: 3) = 16r5E]]
]

{ #category : #testing }
EthernetAddress >> isUnicast [
	^ self isBroadcast not and: [self isMulticast not]
]

{ #category : #printing }
EthernetAddress >> printOn: aStream [
	self bytes
		do: [ :each |
			aStream
				nextPut: ('0123456789ABCDEF' at: each // 16 + 1);
				nextPut: ('0123456789ABCDEF' at: each \\ 16 + 1)]
		separatedBy: [aStream nextPut: $:]
]
