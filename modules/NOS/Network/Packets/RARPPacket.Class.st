'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RARPPacket category: 'SqueakNOS-Net-Packets'!
ARPPacket subclass: #RARPPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!RARPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isReply
	^ self opcode = 4
! !

!RARPPacket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isRequest
	^ self opcode = 3
! !

!RARPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
opcodeNames
	^ #(Unknown Unknown Request Reply)
! !

!RARPPacket methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: 'RARP '.
	self isRequest
		ifTrue: [aStream nextPutAll: 'who-is '; print: self targetHardwareAddress; nextPutAll: ' tell '; print: self senderHardwareAddress.
				^ self].
	self isReply
		ifTrue: [aStream print: self targetProtocolAddress; nextPutAll: ' at '; print: self targetProtocolAddress.
				^ self].
	aStream nextPutAll: 'unknown opcode'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RARPPacket class' category: 'SqueakNOS-Net-Packets'!
RARPPacket class
	instanceVariableNames: ''!

!RARPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
etherType
	^ 16r8035
! !


