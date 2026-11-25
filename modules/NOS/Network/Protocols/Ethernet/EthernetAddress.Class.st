'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #EthernetAddress category: 'SqueakNOS-Net-Support'!
NetAddress subclass: #EthernetAddress
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!EthernetAddress methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asInteger
	^ (bytes unsignedShortAt: 5) << 16 + (bytes unsignedShortAt: 3) << 16 + (bytes unsignedShortAt: 1)

! !

!EthernetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isBroadcast
	^ self bytes allSatisfy: [ :each | each = 255]
! !

!EthernetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isMulticast
	^ (self bytes at: 1) = 16r01
		and: [(self bytes at: 2) = 16r00
			and: [(self bytes at: 3) = 16r5E]]
! !

!EthernetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isUnicast
	^ self isBroadcast not and: [self isMulticast not]
! !

!EthernetAddress methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	self bytes
		do: [ :each |
			aStream
				nextPut: ('0123456789ABCDEF' at: each // 16 + 1);
				nextPut: ('0123456789ABCDEF' at: each \\ 16 + 1)]
		separatedBy: [aStream nextPut: $:]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EthernetAddress class' category: 'SqueakNOS-Net-Support'!
EthernetAddress class
	instanceVariableNames: ''!

!EthernetAddress class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
broadcast
	^ self bytes: #(255 255 255 255 255 255)
! !

!EthernetAddress class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
fromInteger: anInteger
	^ self bytes: (anInteger asByteArrayOfSize: 6) reversed
! !

!EthernetAddress class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
fromString: aString
	"Return the internet address represented by the given string. The string should contain four positive decimal integers delimited by periods, commas, or spaces, where each integer represents one address byte. Return nil if the string is not a host address in an acceptable format."
	"self fromString: '00:48:54:85:CC:51'"

	^ self bytes: ((aString findTokens: ':- ') collect: [ :each | Integer readFrom: each readStream base: 16])
! !

!EthernetAddress class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 1
! !


