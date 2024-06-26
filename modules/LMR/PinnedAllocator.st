"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #PinnedAllocator,
	#superclass : #Allocator,
	#category : #Kernel
}

{ #category : #copying }
PinnedAllocator >> allocate: anInteger [
	^memory pinnedAllocate: anInteger
]

