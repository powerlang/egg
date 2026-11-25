'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Metaclass methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asSymbolicReference
	^SymbolicReference forMetaclass: self
! !

!Metaclass methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldBeStoredIn: anObjectClosure
	^anObjectClosure scope includes: class
! !


