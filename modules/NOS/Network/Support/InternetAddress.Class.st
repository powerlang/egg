'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #InternetAddress category: 'SqueakNOS-Net-Support'!
NetAddress subclass: #InternetAddress
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!InternetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
group
	^ self isMulticast ifTrue: [((BitArray bytes: bytes) copyFrom: 5 to: 5+28-1) asInteger]
! !

!InternetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
host
	| bits |
	bits := BitArray bytes: bytes.
	self isClassA ifTrue: [^ (bits copyFrom: 9 to: 32) asInteger].
	self isClassB ifTrue: [^ (bits copyFrom: 17 to: 32) asInteger].
	self isClassC ifTrue: [^ (bits copyFrom: 25 to: 32) asInteger].
	^ nil
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isAny
	^ bytes allSatisfy: [ :each | each = 0]
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isBroadcast
	^ bytes allSatisfy: [ :each | each = 255]
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isClassA
	^ bytes first between: 0 and: 127
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isClassB
	^ bytes first between: 128 and: 191
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isClassC
	^ bytes first between: 192 and: 223
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isClassD
	^ bytes first between: 224 and: 239
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isClassE
	^ bytes first between: 240 and: 247
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isMulticast
	^ bytes first between: 224 and: 239
! !

!InternetAddress methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isUnicast
	^ bytes first between: 0 and: 223
! !

!InternetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
net
	| bits |
	bits := BitArray bytes: bytes.
	self isClassA ifTrue: [^ (bits copyFrom: 2 to: 2+7-1) reversed asInteger].
	self isClassB ifTrue: [^ (bits copyFrom: 3 to: 3+14-1) reversed asInteger].
	self isClassC ifTrue: [^ (bits copyFrom: 4 to: 4+21-1) reversed asInteger].
	^ nil
! !

!InternetAddress methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	self bytes
		do: [ :each | aStream nextPutAll: each asString]
		separatedBy: [aStream nextPut: $.]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternetAddress class' category: 'SqueakNOS-Net-Support'!
InternetAddress class
	instanceVariableNames: ''!

!InternetAddress class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
fromString: aString
	"Return the internet address represented by the given string. The string should contain four positive decimal integers delimited by periods, commas, or spaces, where each integer represents one address byte. Return nil if the string is not a host address in an acceptable format."
	"self fromString: '1.2.3.4'"
	"self fromString: '1,2,3,4'"
	"self fromString: '1 2 3 4'"

	^ self bytes: ((aString findTokens: '., ') collect: [ :each | each asInteger])
! !

!InternetAddress class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 16r800
! !


