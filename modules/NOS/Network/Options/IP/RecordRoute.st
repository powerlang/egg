Class {
	#name : #RecordRoute,
	#superclass : #IPOption,
	#category : 'SqueakNOS-Net-Options-IP'
}

{ #category : #accessing }
RecordRoute class >> type [
	^ 7
]

{ #category : #accessing }
RecordRoute >> add: anInternetAddress [
	self length - 4 > self pointer ifFalse: [^ self].
	1 to: 4 do: [ :each | self at: self pointer + each - 1 put: (anInternetAddress at: each)].
	self pointer: self pointer + 4.
	^ anInternetAddress
]

{ #category : #accessing }
RecordRoute >> addresses [
	^ (4 to: self pointer by: 4) collect: [ :each | InternetAddress bytes: (self copyFrom: each to: each + 4)]
]

{ #category : #accessing }
RecordRoute >> name [
	^ 'RecordRoute'
]

{ #category : #accessing }
RecordRoute >> pointer [
	^ self at: 3
]

{ #category : #accessing }
RecordRoute >> pointer: anInteger [
	self at: 3 put: anInteger
]
