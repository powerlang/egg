Class {
	#name : #InternalSocket,
	#superclass : #Conduit,
	#instVars : [
		'timedOut'
	],
	#category : 'SqueakNOS-Net-Conduits'
}

{ #category : #control }
InternalSocket >> abort [
	"Close immediatly. Don't try to send any queued data."
	self close
]

{ #category : #control }
InternalSocket >> close [
	"Close myself."

	^ self
]

{ #category : #testing }
InternalSocket >> dataAvailable [
	"Answer whether there is data available for reading."
	^ self subclassResponsibility
]

{ #category : #initialization }
InternalSocket >> initialize [
	super initialize.
	timedOut := false
]

{ #category : #testing }
InternalSocket >> isActive [
	"Answer whether I'm active. In general, active means both myself and my peer(s) consider there to be a connection."

	^self isOpen
]

{ #category : #testing }
InternalSocket >> isConnected [
	"Return true if this socket is connected."
	^ true
]

{ #category : #testing }
InternalSocket >> isOpen [
	"Answer whether I'm open. In general, open means that I consider there to be a connection with my peer(s), but it/they may not necessarily agree."

	^ true
]

{ #category : #accessing }
InternalSocket >> next [
	^ self subclassResponsibility
]

{ #category : #accessing }
InternalSocket >> next: anInteger into: aByteArray startingAt: startIndex [
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."

	^ self subclassResponsibility
]

{ #category : #accessing }
InternalSocket >> nextPut: aPacket [
	^ self subclassResponsibility
]

{ #category : #accessing }
InternalSocket >> nextPut: anInteger from: aByteArray startingAt: startIndex [
	"Write the next anInteger elements in aByteArray, starting at startIndex. Answer the number of bytes actually written."

	^ self subclassResponsibility
]

{ #category : #accessing }
InternalSocket >> nextTimeoutMSecs: milliseconds [
	^ self subclassResponsibility
]

{ #category : #testing }
InternalSocket >> peerClosed [
	"Answer whether my peer closed the connection."
	"This is only possible for ClientTCPSockets."

	^false
]

{ #category : #control }
InternalSocket >> reopen [
	"Reopen myself."

	^ self
]

{ #category : #control }
InternalSocket >> restart [
	"Restart myself, if I was active."

	self isActive ifTrue: [self reopen]
]

{ #category : #timer }
InternalSocket >> scheduleDetachAfter: msecs [
	timer removeAlarm: #detach for: self.
	timer after: msecs send: #detach to: self
]

{ #category : #testing }
InternalSocket >> scribes [
	"Answer whether I read or write (as opposed to accept)."

	^true
]

{ #category : #control }
InternalSocket >> setOption: aName value: aValue [ 
	"setup options on this socket, see Unix man pages for values for 
	sockets, IP, TCP, UDP. IE SO_KEEPALIVE
	returns an array, element one is the error number
	element two is the resulting of the negotiated value.
	See getOption for list of keys"

	self error: 'Not implemented'
]

{ #category : #testing }
InternalSocket >> timedOut [
	"Answer whether I missed a deadline in my most recent wait."

	^ timedOut
]

{ #category : #waiting }
InternalSocket >> waitForReadabilityTimeoutAfter: timeoutInMilliseconds [
	"Wait for readable data, or until timeoutInMilliseconds pass, whichever comes first. -1 is special case wait for ever, also some callers pass zero"

	^ self subclassResponsibility
]

{ #category : #waiting }
InternalSocket >> waitForWriteability [
	"Wait for writing space."
	"Writing space is typically in bountiful supply, so timeouts are effectively never necessary."
	^ self
]
