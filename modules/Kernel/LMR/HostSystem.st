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

{ #category : #services }
LMRHostSystem >> initializeFFI: anExternalLibrary symbolFinder: anFFIMethod [
	anExternalLibrary address: (HostLinkage at: 2).
	anFFIMethod address: (HostLinkage at: 1)
]

{ #category : #services }
LMRHostSystem >> platformName [
	| rawName |
	rawName := HostLinkage at: 3.
	^rawName upTo: Character null
]

{ #category : #services }
LMRHostSystem >> readFile: filename [
	| libc fd size contents read |
	libc := self libc.
	fd := libc openForReading: filename.
	fd < 0 ifTrue: [^self error: 'cannot open ' , filename].
	size := libc lseek: fd offset: 0 whence: 2.
	libc lseek: fd offset: 0 whence: 0.
	contents := String new: size.
	read := libc read: fd address: contents size: size.
	libc close: fd.
	read = size ifFalse: [^self error: 'cannot read ' , filename].
	^contents
]

{ #category : #memory }
LMRHostSystem >> commit: size at: address [
	^LibC module os commit: size at: address
]

{ #category : #memory }
LMRHostSystem >> release: address size: size [
	^LibC module os release: address size: size
]

{ #category : #memory }
LMRHostSystem >> reserve: size [
	^LibC module os reserve: size
]

{ #category : #memory }
LMRHostSystem >> makeExecutable: address size: size [
	^LibC module os makeExecutable: address size: size
]
