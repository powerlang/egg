'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #StackChunk category: #Kernel!
Object subclass: #StackChunk
	instanceVariableNames: 'sp bp base prev'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!StackChunk commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base
	^base
! !

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base: anInteger
	base := anInteger
! !

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
bp
	^bp
! !

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
bp: anInteger
	bp := anInteger
! !

!StackChunk methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
callbacksDo: aBlock
	| chunk |
	chunk := self.
	[chunk isForCallback] whileTrue: [
		aBlock value: chunk.
		chunk := chunk prev]
! !

!StackChunk methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isForCallback
	^prev notNil
! !

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
prev
	^prev
! !

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
prev: aCallbackStackLink
	prev := aCallbackStackLink
! !

!StackChunk methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
recordStackPointers
	| frame dropped |
	frame := StackFrameCursor top.
	dropped := 4.
	dropped timesRepeat: [frame moveNext].
	bp := frame current.
	sp := frame previous + 8 _asPointer
		- 8 _asPointer "is going to push 2 arguments for ffiCall:withArguments"
! !

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
sp
	^sp
! !

!StackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
sp: anInteger
	sp := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StackChunk class' category: #Kernel!
StackChunk class
	instanceVariableNames: ''!

!StackChunk class methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:39'!
after: aCallbackStackLink
	^self new prev: aCallbackStackLink
! !


