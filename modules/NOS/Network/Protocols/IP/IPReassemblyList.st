Class {
	#name : #IPReassemblyList,
	#superclass : #Object,
	#instVars : [
		'fragments',
		'timeout'
	],
	#category : 'SqueakNOS-Net-Protocols-IP'
}

{ #category : #'instance creation' }
IPReassemblyList class >> new [
	^ super new initialize
]

{ #category : #accessing }
IPReassemblyList >> add: aPacket [
	^ fragments add: aPacket
]

{ #category : #accessing }
IPReassemblyList >> destination [
	^ fragments first destination
]

{ #category : #accessing }
IPReassemblyList >> fragments [
	^ fragments
]

{ #category : #accessing }
IPReassemblyList >> id [
	^ fragments first id
]

{ #category : #initialization }
IPReassemblyList >> initialize [
	fragments := SortedCollection sortBlock: [ :a :b | a fragmentOffset <= b fragmentOffset]
]

{ #category : #testing }
IPReassemblyList >> isComplete [
	fragments last mf ifTrue: [^ false].
	fragments first fragmentOffset = 0 ifFalse: [^ false].
	fragments size > 1 ifFalse: [^ false].
	1 to: fragments size - 1 do: [ :each |
		(fragments at: each) fragmentOffset + (fragments at: each) length < (fragments at: each+1) fragmentOffset ifTrue: [^ false]].
	^ true
]

{ #category : #testing }
IPReassemblyList >> matches: aPacket [
	| aFragment |
	aFragment := fragments first.
	^ aFragment id = aPacket id and: [aFragment source = aPacket source and: [aFragment destination = aPacket destination]]
]

{ #category : #accessing }
IPReassemblyList >> packet [
	| answer start |
	answer := IPPacket new: fragments last fragmentOffset + fragments last length - fragments last headerSize.
	answer replaceFrom: 1 to: fragments first headerSize with: fragments first startingAt: 1.
	answer mf: false.
	fragments do: [ :each |
		start := answer headerSize + 1 + each fragmentOffset.
		answer replaceFrom: start to: start + each length - each headerSize - 1 with: each startingAt: each headerSize + 1].
	answer length: answer size.
	answer setChecksum.
	^ answer
]

{ #category : #accessing }
IPReassemblyList >> source [
	^ fragments first source
]

{ #category : #accessing }
IPReassemblyList >> timeout [
	^ timeout
]

{ #category : #accessing }
IPReassemblyList >> timeout: anInteger [
	timeout := anInteger
]
