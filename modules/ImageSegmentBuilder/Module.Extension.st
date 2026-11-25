'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Module methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asSymbolicReference
	^SymbolicReference forModule: self
! !

!Module methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldBeStoredIn: anObjectClosure
	^anObjectClosure module == self
! !

!Module methodsFor:  '*snapshotting' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImageSegmentUsing: aWriter
	| builder |
	builder := Builder new.
	builder module: self; build.
	^aWriter
		closure: builder closure;
		objects: builder objects;
		mapping: builder mapping;
		imports: builder imports;
		exports: self exports;
		write;
		image
! !


