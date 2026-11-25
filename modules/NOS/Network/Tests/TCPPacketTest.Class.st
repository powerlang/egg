'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPPacketTest category: 'SqueakNOS-Net-Tests'!
TestCase subclass: #TCPPacketTest
	instanceVariableNames: 'packet'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!TCPPacketTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
setUp
	packet _ TCPPacket bytes: #(129 12 0 21 46 10 150 13 0 0 0 0 160 2 22 208 48 22 0 0 2 4 5 180 4 2 8 10 0 27 234 226 0 0 0 0 1 3 3 0) asByteArray
! !

!TCPPacketTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testOptions
	| mss timestamp windowScale |
	self assert: packet options size = 5.
	mss := packet options first.
	self assert: mss value = 1460.
	timestamp := packet options third.
	self assert: timestamp value = 1829602.
	self assert: timestamp echo = 0.
	windowScale := packet options last.
	self assert: windowScale factor = 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPPacketTest class' category: 'SqueakNOS-Net-Tests'!
TCPPacketTest class
	instanceVariableNames: ''!


