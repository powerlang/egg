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
Module >> writeImageSegmentUsing: aWriter [
	^self writeImageSegmentUsing: aWriter methodCopyHandler: nil
]

{ #category : #'*snapshotting' }
Module >> writeImageSegmentUsing: aWriter methodCopyHandler: aBlockOrNil [

	| builder |
	builder := Builder new.
	aBlockOrNil ifNotNil: [builder methodCopyHandler: aBlockOrNil].
	builder module: self; build.
	^aWriter
		closure: builder closure;
		objects: builder objects;
		mapping: builder mapping;
		imports: builder imports;
		exports: self exports;
		write;
		image
]
