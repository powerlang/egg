"
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
"

Extension { #name : #Module }

{ #category : #'*snapshotting' }
Module >> writeCachedSegmentAt: filename [
	self writeCachedSegmentAt: filename with: self newSegmentBuilder
]

{ #category : #'*snapshotting' }
Module >> writeCachedSegmentAt: filename with: aBuilder [
	| host writer image slash dir |
	host := Kernel host.
	slash := 0.
	1 to: filename size do: [:i |
		(filename at: i) == $/ ifTrue: [slash := i]].
	slash > 0 ifTrue: [
		dir := filename copyFrom: 1 to: slash - 1.
		host createDirectory: dir].
	writer := NativeWriter new.
	image := self writeImageSegmentUsing: writer with: aBuilder.
	host writeFile: filename contents: image
]
