'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #InternalSocket category: 'SqueakNOS-Net-Conduits'!
Conduit subclass: #InternalSocket
	instanceVariableNames: 'timedOut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Conduits'!
!InternalSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
abort
	"Close immediatly. Don't try to send any queued data."
	self close
! !

!InternalSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	"Close myself."

	^ self
! !

!InternalSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
dataAvailable
	"Answer whether there is data available for reading."
	^ self subclassResponsibility
! !

!InternalSocket methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	timedOut := false
! !

!InternalSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isActive
	"Answer whether I'm active. In general, active means both myself and my peer(s) consider there to be a connection."

	^self isOpen
! !

!InternalSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isConnected
	"Return true if this socket is connected."
	^ true
! !

!InternalSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isOpen
	"Answer whether I'm open. In general, open means that I consider there to be a connection with my peer(s), but it/they may not necessarily agree."

	^ true
! !

!InternalSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next
	^ self subclassResponsibility
! !

!InternalSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger into: aByteArray startingAt: startIndex
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."

	^ self subclassResponsibility
! !

!InternalSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: aPacket
	^ self subclassResponsibility
! !

!InternalSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: anInteger from: aByteArray startingAt: startIndex
	"Write the next anInteger elements in aByteArray, starting at startIndex. Answer the number of bytes actually written."

	^ self subclassResponsibility
! !

!InternalSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextTimeoutMSecs: milliseconds
	^ self subclassResponsibility
! !

!InternalSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
peerClosed
	"Answer whether my peer closed the connection."
	"This is only possible for ClientTCPSockets."

	^false
! !

!InternalSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
reopen
	"Reopen myself."

	^ self
! !

!InternalSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
restart
	"Restart myself, if I was active."

	self isActive ifTrue: [self reopen]
! !

!InternalSocket methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
scheduleDetachAfter: msecs
	timer removeAlarm: #detach for: self.
	timer after: msecs send: #detach to: self
! !

!InternalSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
scribes
	"Answer whether I read or write (as opposed to accept)."

	^true
! !

!InternalSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
setOption: aName value: aValue
	"setup options on this socket, see Unix man pages for values for 
	sockets, IP, TCP, UDP. IE SO_KEEPALIVE
	returns an array, element one is the error number
	element two is the resulting of the negotiated value.
	See getOption for list of keys"

	self error: 'Not implemented'
! !

!InternalSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
timedOut
	"Answer whether I missed a deadline in my most recent wait."

	^ timedOut
! !

!InternalSocket methodsFor:  'waiting' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForReadabilityTimeoutAfter: timeoutInMilliseconds
	"Wait for readable data, or until timeoutInMilliseconds pass, whichever comes first. -1 is special case wait for ever, also some callers pass zero"

	^ self subclassResponsibility
! !

!InternalSocket methodsFor:  'waiting' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForWriteability
	"Wait for writing space."
	"Writing space is typically in bountiful supply, so timeouts are effectively never necessary."
	^ self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalSocket class' category: 'SqueakNOS-Net-Conduits'!
InternalSocket class
	instanceVariableNames: ''!


InternalSocket initialize!

