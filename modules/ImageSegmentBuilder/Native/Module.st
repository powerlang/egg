"
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
"

Extension { #name : #Module }

{ #category : #'*snapshotting' }
Module >> writeCachedSegmentAt: filename [
	^self writeCachedSegmentAt: filename methodCopyHandler: nil
]

{ #category : #'*snapshotting' }
Module >> writeCachedSegmentAt: filename methodCopyHandler: aBlockOrNil [
	| host writer image slash dir |
	host := Kernel host.
	slash := 0.
	1 to: filename size do: [:i |
		(filename at: i) == $/ ifTrue: [slash := i]].
	slash > 0 ifTrue: [
		dir := filename copyFrom: 1 to: slash - 1.
		host createDirectory: dir].
	writer := NativeWriter new.
	image := self writeImageSegmentUsing: writer methodCopyHandler: aBlockOrNil.
	host writeFile: filename contents: image
]
