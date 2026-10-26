'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IPFragmentsTest category: 'SqueakNOS-Net-Tests'!
TestCase subclass: #IPFragmentsTest
	instanceVariableNames: 'packet fragments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!IPFragmentsTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
fragmentSize
	^ 300
! !

!IPFragmentsTest methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
setUp
	packet := IPPacket with: (UDPPacket new: 1000).
	packet
		source: (InternetAddress fromString: '1.2.3.4');
		destination: (InternetAddress fromString: '5.6.7.8').
	packet setChecksum.
	fragments := packet fragmentsSized: self fragmentSize
! !

!IPFragmentsTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testFragmentsLength
	self assert: (fragments allSatisfy: [ :each | each length <= self fragmentSize]).
	self assert: (fragments collect: [ :each | each length - each headerSize]) sum = (packet length - packet headerSize)
! !

!IPFragmentsTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testMF
	self assert: (fragments allButLast allSatisfy: [ :each | each mf]).
	self assert: fragments last mf not
! !

!IPFragmentsTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testReassembly
	| defragmented reassemblyList |
	reassemblyList := IPReassemblyList new.
	fragments shuffled do: [ :each | reassemblyList add: each].
	self assert: reassemblyList isComplete.
	defragmented := reassemblyList packet.
	defragmented setChecksum.
	self assert: defragmented length = packet length.
	self assert: defragmented asByteArray = packet asByteArray
! !

!IPFragmentsTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testReassemblyCompletion
	| shuffledFragments reassemblyList |
	reassemblyList := IPReassemblyList new.
	shuffledFragments := fragments shuffled.
	shuffledFragments allButLast do: [ :each | reassemblyList add: each].
	self assert: reassemblyList isComplete not.
	reassemblyList add: shuffledFragments last.
	self assert: reassemblyList isComplete
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IPFragmentsTest class' category: 'SqueakNOS-Net-Tests'!
IPFragmentsTest class
	instanceVariableNames: ''!


