'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IPInterface category: 'SqueakNOS-Net-Interfaces'!
NetInterface subclass: #IPInterface
	instanceVariableNames: 'ip'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Interfaces'!
!IPInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	ip := IP new.
	ip | TCP new.
	ip | UDP new.
	self | ip
! !

!IPInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
internetAddress: anInternetAddress
	ip address: anInternetAddress
! !

!IPInterface methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
ip
	^ ip
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IPInterface class' category: 'SqueakNOS-Net-Interfaces'!
IPInterface class
	instanceVariableNames: ''!


IPInterface initialize!

