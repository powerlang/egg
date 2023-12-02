Class {
	#name : #InternetAddress,
	#superclass : #NetAddress,
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #'instance creation' }
InternetAddress class >> fromString: aString [
	"Return the internet address represented by the given string. The string should contain four positive decimal integers delimited by periods, commas, or spaces, where each integer represents one address byte. Return nil if the string is not a host address in an acceptable format."
	"self fromString: '1.2.3.4'"
	"self fromString: '1,2,3,4'"
	"self fromString: '1 2 3 4'"

	^ self bytes: ((aString findTokens: '., ') collect: [ :each | each asInteger])
]

{ #category : #accessing }
InternetAddress class >> type [
	^ 16r800
]

{ #category : #accessing }
InternetAddress >> group [
	^ self isMulticast ifTrue: [((BitArray bytes: bytes) copyFrom: 5 to: 5+28-1) asInteger]
]

{ #category : #accessing }
InternetAddress >> host [
	| bits |
	bits := BitArray bytes: bytes.
	self isClassA ifTrue: [^ (bits copyFrom: 9 to: 32) asInteger].
	self isClassB ifTrue: [^ (bits copyFrom: 17 to: 32) asInteger].
	self isClassC ifTrue: [^ (bits copyFrom: 25 to: 32) asInteger].
	^ nil
]

{ #category : #testing }
InternetAddress >> isAny [
	^ bytes allSatisfy: [ :each | each = 0]
]

{ #category : #testing }
InternetAddress >> isBroadcast [
	^ bytes allSatisfy: [ :each | each = 255]
]

{ #category : #testing }
InternetAddress >> isClassA [
	^ bytes first between: 0 and: 127
]

{ #category : #testing }
InternetAddress >> isClassB [
	^ bytes first between: 128 and: 191
]

{ #category : #testing }
InternetAddress >> isClassC [
	^ bytes first between: 192 and: 223
]

{ #category : #testing }
InternetAddress >> isClassD [
	^ bytes first between: 224 and: 239
]

{ #category : #testing }
InternetAddress >> isClassE [
	^ bytes first between: 240 and: 247
]

{ #category : #testing }
InternetAddress >> isMulticast [
	^ bytes first between: 224 and: 239
]

{ #category : #testing }
InternetAddress >> isUnicast [
	^ bytes first between: 0 and: 223
]

{ #category : #accessing }
InternetAddress >> net [
	| bits |
	bits := BitArray bytes: bytes.
	self isClassA ifTrue: [^ (bits copyFrom: 2 to: 2+7-1) reversed asInteger].
	self isClassB ifTrue: [^ (bits copyFrom: 3 to: 3+14-1) reversed asInteger].
	self isClassC ifTrue: [^ (bits copyFrom: 4 to: 4+21-1) reversed asInteger].
	^ nil
]

{ #category : #printing }
InternetAddress >> printOn: aStream [
	self bytes
		do: [ :each | aStream nextPutAll: each asString]
		separatedBy: [aStream nextPut: $.]
]
