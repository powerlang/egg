Class {
	#name : #IPFragmentsTest,
	#superclass : #TestCase,
	#instVars : [
		'packet',
		'fragments'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #'as yet unclassified' }
IPFragmentsTest >> fragmentSize [
	^ 300
]

{ #category : #initialization }
IPFragmentsTest >> setUp [
	packet := IPPacket with: (UDPPacket new: 1000).
	packet
		source: (InternetAddress fromString: '1.2.3.4');
		destination: (InternetAddress fromString: '5.6.7.8').
	packet setChecksum.
	fragments := packet fragmentsSized: self fragmentSize
]

{ #category : #'as yet unclassified' }
IPFragmentsTest >> testFragmentsLength [
	self assert: (fragments allSatisfy: [ :each | each length <= self fragmentSize]).
	self assert: (fragments collect: [ :each | each length - each headerSize]) sum = (packet length - packet headerSize)
]

{ #category : #'as yet unclassified' }
IPFragmentsTest >> testMF [
	self assert: (fragments allButLast allSatisfy: [ :each | each mf]).
	self assert: fragments last mf not
]

{ #category : #tests }
IPFragmentsTest >> testReassembly [
	| defragmented reassemblyList |
	reassemblyList := IPReassemblyList new.
	fragments shuffled do: [ :each | reassemblyList add: each].
	self assert: reassemblyList isComplete.
	defragmented := reassemblyList packet.
	defragmented setChecksum.
	self assert: defragmented length = packet length.
	self assert: defragmented asByteArray = packet asByteArray
]

{ #category : #tests }
IPFragmentsTest >> testReassemblyCompletion [
	| shuffledFragments reassemblyList |
	reassemblyList := IPReassemblyList new.
	shuffledFragments := fragments shuffled.
	shuffledFragments allButLast do: [ :each | reassemblyList add: each].
	self assert: reassemblyList isComplete not.
	reassemblyList add: shuffledFragments last.
	self assert: reassemblyList isComplete
]
