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
Module >> requiresNativization [
	^false
]

{ #category : #'*snapshotting' }
Module >> nativizerBlock [
	^[:copy | ]
]

{ #category : #'*snapshotting' }
Module >> newSegmentBuilder [
	^Builder new module: self; nativizerBlock: self nativizerBlock; yourself
]

{ #category : #'*snapshotting' }
Module >> writeImageSegmentUsing: aWriter [
	^self writeImageSegmentUsing: aWriter with: self newSegmentBuilder
]

{ #category : #'*snapshotting' }
Module >> writeImageSegmentUsing: aWriter with: builder [
	builder build.
	^aWriter
		closure: builder closure;
		objects: builder objects;
		mapping: builder mapping;
		imports: builder imports;
		exports: self exports;
		write;
		image
]
