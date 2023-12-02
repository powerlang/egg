Class {
	#name : #TCPReassemblerTest,
	#superclass : #TestCase,
	#instVars : [
		'reassembler',
		'stream',
		'packets'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> packetWithData: aString sequence: anInteger [
	| tcp ip |
	tcp _ TCPPacket new: aString size.
	tcp sequence: anInteger.
	tcp replaceFrom: tcp headerSize + 1 to: tcp size with: aString asByteArray startingAt: 1.
	ip _ IPPacket with: tcp.
	^ ip data
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> setUp [
	reassembler := TCPReassembler new.
	reassembler sequence: 0.
	stream := NetStream on: reassembler
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> testDataAfterFin [
	reassembler add: ((self packetWithData: '01234' sequence: 0) fin: true).
	reassembler add: (self packetWithData: '56789' sequence: 5).
	self assert: reassembler dataAvailable.
	self assert: reassembler finished.
	self assert: reassembler nextAvailable asString = '01234'.
	self assert: reassembler dataAvailable not
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> testFinWithData [
	reassembler add: (self packetWithData: '01234' sequence: 0).
	reassembler add: ((self packetWithData: '56789' sequence: 5) fin: true).
	self assert: stream dataAvailable.
	self assert: reassembler finished.
	self assert: (stream next: 10) asString = '0123456789'.
	self assert: stream dataAvailable not
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> testLateFin [
	self assert: reassembler finished not.
	reassembler add: ((self packetWithData: '' sequence: 0) syn: true).
	self assert: reassembler finished not.
	reassembler add: ((self packetWithData: '' sequence: 5) fin: true).
	self assert: reassembler finished not.
	reassembler add: (self packetWithData: '1234' sequence: 1).
	self assert: reassembler finished
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> testOverlapingData [
	reassembler add: (self packetWithData: '012345' sequence: 0).
	reassembler add: (self packetWithData: '456789' sequence: 4).
	self assert: stream dataAvailable.
	self assert: (stream next: 10) asString = '0123456789'.
	self assert: stream dataAvailable not
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> testReassembly [
	self assert: reassembler dataAvailable not.
	reassembler add: ((self packetWithData: '' sequence: 0) syn: true).
	self assert: reassembler dataAvailable not.
	reassembler add: (self packetWithData: 'asdf' sequence: 1).
	self assert: reassembler dataAvailable.
	self assert: reassembler nextAvailable asString = 'asdf'.
	self assert: reassembler dataAvailable not
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> testReassemblyStream [
	self assert: stream dataAvailable not.
	reassembler add: ((self packetWithData: '' sequence: 0) syn: true).
	self assert: stream dataAvailable not.
	reassembler add: (self packetWithData: 'asdfg' sequence: 1).
	self assert: stream dataAvailable.
	self assert: (stream next: 4) asString = 'asdf'.
	self assert: stream dataAvailable.
	self assert: stream next asCharacter = $g.
	self assert: stream dataAvailable not
]

{ #category : #tests }
TCPReassemblerTest >> testSequenceWrapAround [
	| seq |
	seq := TCPSequenceNumber value: 16rFFFFFFF8.
	reassembler sequence: seq.
	reassembler add: (self packetWithData: '012345' sequence: seq).
	reassembler add: (self packetWithData: '678901' sequence: seq+6).
	reassembler add: (self packetWithData: '23456789' sequence: seq+12).
	self assert: stream dataAvailable.
	self assert: (stream next: 20) asString = '01234567890123456789'.
	self assert: stream dataAvailable not
]

{ #category : #'as yet unclassified' }
TCPReassemblerTest >> testUnsortedData [
	reassembler add: (self packetWithData: '456789' sequence: 4).
	reassembler add: (self packetWithData: '012345' sequence: 0).
	self assert: stream dataAvailable.
	self assert: (stream next: 10) asString = '0123456789'.
	self assert: stream dataAvailable not
]
