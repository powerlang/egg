'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IPReassemblyList category: 'SqueakNOS-Net-Protocols-IP'!
Object subclass: #IPReassemblyList
	instanceVariableNames: 'fragments timeout'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-IP'!
!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: aPacket
	^ fragments add: aPacket
! !

!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
destination
	^ fragments first destination
! !

!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fragments
	^ fragments
! !

!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
id
	^ fragments first id
! !

!IPReassemblyList methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	fragments := SortedCollection sortBlock: [ :a :b | a fragmentOffset <= b fragmentOffset]
! !

!IPReassemblyList methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isComplete
	fragments last mf ifTrue: [^ false].
	fragments first fragmentOffset = 0 ifFalse: [^ false].
	fragments size > 1 ifFalse: [^ false].
	1 to: fragments size - 1 do: [ :each |
		(fragments at: each) fragmentOffset + (fragments at: each) length < (fragments at: each+1) fragmentOffset ifTrue: [^ false]].
	^ true
! !

!IPReassemblyList methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
matches: aPacket
	| aFragment |
	aFragment := fragments first.
	^ aFragment id = aPacket id and: [aFragment source = aPacket source and: [aFragment destination = aPacket destination]]
! !

!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
packet
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
! !

!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
source
	^ fragments first source
! !

!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
timeout
	^ timeout
! !

!IPReassemblyList methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
timeout: anInteger
	timeout := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IPReassemblyList class' category: 'SqueakNOS-Net-Protocols-IP'!
IPReassemblyList class
	instanceVariableNames: ''!

!IPReassemblyList class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ super new initialize
! !


IPReassemblyList initialize!

