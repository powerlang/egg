'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Behavior methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asSymbolicReference
	self DENY: self isInstanceBehavior.
	^SymbolicReference forBehavior: self
! !

!Behavior methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldBeStoredIn: anObjectClosure
	^anObjectClosure scope includes: class
! !


