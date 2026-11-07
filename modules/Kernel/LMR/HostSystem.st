"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRHostSystem,
	#superclass : #HostSystem,
	#category : #Kernel
}

{ #category : #services }
LMRHostSystem >> currentMilliseconds [
	| timespec |
	timespec := ByteArray new: 16.
	^self currentMillisecondsIn: timespec
]

{ #category : #services }
LMRHostSystem >> currentMicrosecondsIn: aByteArray [
	| seconds nanoseconds |
	self libc timespecGet: aByteArray base: 1.
	seconds := aByteArray pointerAtOffset: 0.
	nanoseconds := aByteArray uLongAtOffset: 8.
	^seconds * 1000000 + (nanoseconds // 1000)
]

{ #category : #services }
LMRHostSystem >> currentMillisecondsIn: aByteArray [
	^(self currentMicrosecondsIn: aByteArray) // 1000
]

{ #category : #services }
LMRHostSystem >> exit: anInteger [
	self libc exit: anInteger
]

{ #category : #accessing }
LMRHostSystem >> libc [
	^LibC module libc
]

{ #category : #logging }
LMRHostSystem >> log: aString level: anInteger [
	| fd prefix text newline |
	fd := anInteger >= 4 ifTrue: [2] ifFalse: [1].
	prefix := #('[trace] ' '' '' '[warn] ' '[error] ' '[FATAL] ') at: anInteger + 1.
	text := aString isString ifTrue: [aString] ifFalse: [aString printString].
	newline := String with: Character lf.
	self
		write: prefix to: fd;
		write: text to: fd;
		write: newline to: fd
]

{ #category : #services }
LMRHostSystem >> write: aString to: anInteger [
	aString isEmpty ifTrue: [^self].
	self libc write: anInteger address: aString size: aString size
]
