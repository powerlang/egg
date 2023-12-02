Class {
	#name : #IPTimestamp,
	#superclass : #IPOption,
	#category : 'SqueakNOS-Net-Options-IP'
}

{ #category : #accessing }
IPTimestamp class >> type [
	^ 68
]

{ #category : #adding }
IPTimestamp >> add: anInteger [
	| timestampBytes |
	self length - 4 > self pointer ifFalse: [^ self].
	timestampBytes := (BitArray new: 4*8 with: anInteger) asByteArray.
	1 to: 4 do: [ :each | self at: self pointer + each - 1 put: (timestampBytes at: each)].
	self pointer: self pointer + 4.
	^ anInteger
]

{ #category : #accessing }
IPTimestamp >> flags [
	^ self at: 5
]

{ #category : #accessing }
IPTimestamp >> flags: anInteger [
	self at: 5 put: anInteger
]

{ #category : #testing }
IPTimestamp >> isPrespecified [
	^ self flags = 3
]

{ #category : #testing }
IPTimestamp >> isTimestampsAndAddresses [
	^ self flags = 1
]

{ #category : #testing }
IPTimestamp >> isTimestampsOnly [
	^ self flags = 0
]

{ #category : #accessing }
IPTimestamp >> name [
	^ 'timestamp'
]

{ #category : #accessing }
IPTimestamp >> overflow [
	^ self at: 4
]

{ #category : #accessing }
IPTimestamp >> overflow: anInteger [
	self at: 4 put: anInteger
]

{ #category : #accessing }
IPTimestamp >> pointer [
	^ self at: 3
]

{ #category : #accessing }
IPTimestamp >> pointer: anInteger [
	self at: 3 put: anInteger
]

{ #category : #accessing }
IPTimestamp >> timestamps [
	^ (4 to: self pointer by: 4) collect: [ :each | (BitArray bytes: (self copyFrom: each to: each + 4)) asInteger]
]
