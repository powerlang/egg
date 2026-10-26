'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPPersist category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
TCPOutputState subclass: #TCPPersist
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
!TCPPersist methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendWindowProbe
	^ self
! !

!TCPPersist methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
updatedSendingWindowSize
	socket usableWindow size > 0 ifTrue: [self moveTo: TCPTransmit new]
! !

!TCPPersist methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForWritabilityTimeoutAfter: timeoutInMilliseconds
	| semaphore |
	semaphore := Semaphore new.
	self when: #transition send: #signal to: semaphore.
	semaphore waitTimeoutMSecs: timeoutInMilliseconds.
	socket sendingWindowSize > 0 ifFalse: [TimedOut new signal]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPPersist class' category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
TCPPersist class
	instanceVariableNames: ''!


