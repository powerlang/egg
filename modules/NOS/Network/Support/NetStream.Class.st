'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NetStream category: 'SqueakNOS-Net-Support'!
SocketStream subclass: #NetStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!NetStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
dataAvailable
	^ self isDataAvailable
! !

!NetStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger timeoutAfter: msecs
	self timeout: msecs // 1000.
	^self next: anInteger
! !

!NetStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForReadabilityTimeoutAfter: timeoutInMilliseconds
	^ socket waitForReadabilityTimeoutAfter: timeoutInMilliseconds
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NetStream class' category: 'SqueakNOS-Net-Support'!
NetStream class
	instanceVariableNames: ''!


