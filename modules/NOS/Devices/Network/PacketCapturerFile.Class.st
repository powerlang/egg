'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PacketCapturerFile category: 'SqueakNOS-Net-Devices'!
InternalNetworkDevice subclass: #PacketCapturerFile
	instanceVariableNames: 'stream packetClass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Devices'!
!PacketCapturerFile commentStamp: '<historical>' prior: 0!

(self onFileNamed: '../ssh-amadeus.tcpdump')
!

!PacketCapturerFile methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
atEnd
	^ stream atEnd
! !

!PacketCapturerFile methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
close
	stream close
! !

!PacketCapturerFile methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	packetClass := EthernetPacket
! !

!PacketCapturerFile methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextPacket
	| hdr packetLength capLen |
	hdr := stream next: 16.
	capLen := hdr unsignedLongAt: 9 bigEndian: false.
	packetLength := hdr unsignedLongAt: 13 bigEndian: false.
	^ packetClass bytes: (stream next: capLen)
! !

!PacketCapturerFile methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
output: ignore
	^ self
! !

!PacketCapturerFile methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
packetClass: aClass
	packetClass := aClass
! !

!PacketCapturerFile methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
run
	[self input: self nextPacket] repeat
! !

!PacketCapturerFile methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
stream: aStream
	stream := aStream binary.
	stream skip: 24
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PacketCapturerFile class' category: 'SqueakNOS-Net-Devices'!
PacketCapturerFile class
	instanceVariableNames: ''!

!PacketCapturerFile class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fileNamed: filename
	^ self new stream: (FileStream readOnlyFileNamed: filename)
! !


PacketCapturerFile initialize!

