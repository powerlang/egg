'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NetInterface category: 'SqueakNOS-Net-Interfaces'!
Conduit subclass: #NetInterface
	instanceVariableNames: 'inputQ process device'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Interfaces'!
!NetInterface methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
device
	^ device
! !

!NetInterface methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
device: aNetworkDevice
	device := aNetworkDevice
! !

!NetInterface methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
down
	device down.
	device removeActionsWithReceiver: self.
	process ifNotNil: [process terminate. process := nil]
! !

!NetInterface methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
flush
	"Discard all packets on the interface queue."
	[inputQ isEmpty] whileFalse: [inputQ next]
! !

!NetInterface methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleInputPacket: aPacket
	inputQ size > 100 ifTrue: [^ self error: 'Packet dropped'].
	inputQ nextPut: aPacket
! !

!NetInterface methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	inputQ := SharedQueue new
! !

!NetInterface methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDown
	^ self isUp not
! !

!NetInterface methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isUp
	^ process notNil
! !

!NetInterface methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
left: aConduit
	^ self shouldNotImplement
! !

!NetInterface methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu
	^ device mtu
! !

!NetInterface methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu: anInteger
	device mtu: anInteger
! !

!NetInterface methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
output: aPacket
	self isDown ifTrue: [^ NetDown signal].
	device output: aPacket
! !

!NetInterface methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
processLoop
	self input: inputQ next
! !

!NetInterface methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
up
	self down.
	process := [[process isNil] whileFalse: [self processLoop]] newProcess.
	device when: #input: send: #handleInputPacket: to: self.
	device up.
	process resume
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NetInterface class' category: 'SqueakNOS-Net-Interfaces'!
NetInterface class
	instanceVariableNames: ''!

!NetInterface class methodsFor:  'examples' stamp: 'KenD 28/Jun/2026 13:32:25'!
loopback
	^ self on: Loopback new
! !

!NetInterface class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aNetworkDevice
	^ self new device: aNetworkDevice
! !


NetInterface initialize!

