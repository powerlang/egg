"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Module }

{ #category : #'*snapshotting' }
Module >> asSymbolicReference [
	^SymbolicReference forModule: self
]

{ #category : #'*snapshotting' }
Module >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == self
]

{ #category : #'*snapshotting' }
Module >> writeImageSegment [
	| builder writer |
	builder := Builder new.
	builder module: self; build.
	writer := JSONWriter new.
	^writer
		closure: builder closure;
		objects: builder objects;
		mapping: builder mapping;
		imports: builder imports;
		exports: self exports;
		write;
		image
]
