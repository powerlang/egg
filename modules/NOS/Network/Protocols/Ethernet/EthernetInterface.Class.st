'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #EthernetInterface category: 'SqueakNOS-Net-Interfaces'!
NetInterface subclass: #EthernetInterface
	instanceVariableNames: 'ethernet ip'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Interfaces'!
!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
device: aDevice
	super device: aDevice.
	ethernet address: aDevice macAddress
! !

!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
down
	self ethernet arp timerDown.
	self ip tcp timerDown.
	super down
! !

!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
ethernet
	^ ethernet
! !

!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	ip := IP new.
	ip | TCP new.
	ip | UDP new.
	ethernet := Ethernet new.
	self | PluggableConduit transcripter | ethernet | ip
! !

!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
internetAddress: anInternetAddress
	ip address: anInternetAddress.
	ethernet arp protocolAddress: anInternetAddress
! !

!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
ip
	^ ip
! !

!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
macAddress: anEthernetAddress
	ethernet address: anEthernetAddress.
	device macAddress: anEthernetAddress
! !

!EthernetInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
up
	super up.
	self ethernet arp timerUp.
	self ip tcp timerUp
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EthernetInterface class' category: 'SqueakNOS-Net-Interfaces'!
EthernetInterface class
	instanceVariableNames: ''!


EthernetInterface initialize!

