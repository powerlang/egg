Class {
	#name : #TCPPacketTest,
	#superclass : #TestCase,
	#instVars : [
		'packet'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #'as yet unclassified' }
TCPPacketTest >> setUp [
	packet _ TCPPacket bytes: #(129 12 0 21 46 10 150 13 0 0 0 0 160 2 22 208 48 22 0 0 2 4 5 180 4 2 8 10 0 27 234 226 0 0 0 0 1 3 3 0) asByteArray
]

{ #category : #tests }
TCPPacketTest >> testOptions [
	| mss timestamp windowScale |
	self assert: packet options size = 5.
	mss := packet options first.
	self assert: mss value = 1460.
	timestamp := packet options third.
	self assert: timestamp value = 1829602.
	self assert: timestamp echo = 0.
	windowScale := packet options last.
	self assert: windowScale factor = 1
]
