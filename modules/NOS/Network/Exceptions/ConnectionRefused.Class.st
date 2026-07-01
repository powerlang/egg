'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ConnectionRefused category: 'SqueakNOS-Net-Exceptions'!
Error subclass: #ConnectionRefused
	instanceVariableNames: 'host port'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Exceptions'!
!ConnectionRefused commentStamp: '<historical>' prior: 0!

Signals that a connection to the specified host and port was refused.

	host		host which refused the connection
	port		port to which the connection was refused

!

!ConnectionRefused methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
host
	^ host
! !

!ConnectionRefused methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
host: addressOrHostName port: portNumber
	host := addressOrHostName.
	port := portNumber
! !

!ConnectionRefused methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
port
	^ port
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ConnectionRefused class' category: 'SqueakNOS-Net-Exceptions'!
ConnectionRefused class
	instanceVariableNames: ''!

!ConnectionRefused class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
host: addressOrHostName port: portNumber
	^ self new host: addressOrHostName port: portNumber
! !


