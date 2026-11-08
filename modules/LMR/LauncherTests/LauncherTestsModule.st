"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LauncherTestsModule,
	#superclass : #Module,
	#category : #'LMR-LauncherTests'
}

{ #category : #spec }
LauncherTestsModule >> imports [
	^{
		#Kernel -> #(ActiveProcess).
		#FFI -> #(ExternalLibrary ExternalMemory).
		#'FFI.Posix' -> #(DLLibrary).
		#'FFI.Windows' -> #(KernelDLL)
	}
]

{ #category : #entries }
LauncherTestsModule >> start [
	<callback: slong ()>
	^42
]

{ #category : #entries }
LauncherTestsModule >> sendsToReplacement [
	<callback: slong ()>
	^self class == LauncherTestsModule ifTrue: [1] ifFalse: [0]
]

{ #category : #entries }
LauncherTestsModule >> send [
	<callback: slong ()>
	^self answer
]

{ #category : #sending }
LauncherTestsModule >> answer [
	^42
]

{ #category : #entries }
LauncherTestsModule >> allocation [
	<callback: slong ()>
	^(ByteArray new: 3) size
]

{ #category : #entries }
LauncherTestsModule >> capture [
	<callback: slong ()>
	^self capture: 3 and: 4
]

{ #category : #testing }
LauncherTestsModule >> capture: anInteger and: anotherInteger [
	| block |
	block := [anInteger].
	^block value
]

{ #category : #entries }
LauncherTestsModule >> performAnswer [
	<callback: slong ()>
	^self perform: #answer
]

{ #category : #entries }
LauncherTestsModule >> negations [
	| first second |
	<callback: slong ()>
	first := (true andNot: [false]) ifTrue: [1] ifFalse: [0].
	second := (false orNot: [true]) ifTrue: [0] ifFalse: [2].
	^first + second
]

{ #category : #entries }
LauncherTestsModule >> nonLocalReturn [
	<callback: slong ()>
	^self firstEven + 10
]

{ #category : #testing }
LauncherTestsModule >> firstEven [
	#(1 2 3) do: [:each | each even ifTrue: [^each]].
	^0
]

{ #category : #entries }
LauncherTestsModule >> platformNameSize [
	<callback: slong ()>
	^Kernel host platformName size
]

{ #category : #entries }
LauncherTestsModule >> add [
	<callback: slong ()>
	^3 + 4
]

{ #category : #entries }
LauncherTestsModule >> times [
	<callback: slong ()>
	^self six * 7
]

{ #category : #entries }
LauncherTestsModule >> smiTimes [
	<callback: slong ()>
	^self six _smiTimes: 7
]

{ #category : #entries }
LauncherTestsModule >> largeProduct [
	| a |
	<callback: slong ()>
	a := 30916.
	^a * 16273
]

{ #category : #entries }
LauncherTestsModule >> modulo [
	| a |
	<callback: slong ()>
	a := 503096068.
	^a \\ 16
]

{ #category : #entries }
LauncherTestsModule >> answerIfNotNil [
	<callback: slong ()>
	self six ifNotNil: [:six | ^six].
	^0
]

{ #category : #entries }
LauncherTestsModule >> answerIfNilIfNotNil [
	| some none |
	<callback: slong ()>
	some := self six ifNil: [0] ifNotNil: [:six | six].
	none := self nothing ifNil: [1] ifNotNil: [:object | 100].
	^some + none
]

{ #category : #sending }
LauncherTestsModule >> nothing [
	^nil
]

{ #category : #sending }
LauncherTestsModule >> six [
	^6
]

{ #category : #entries }
LauncherTestsModule >> newArray [
	<callback: slong ()>
	^(Array new: 3) size
]

{ #category : #entries }
LauncherTestsModule >> newBytes [
	<callback: slong ()>
	^(ByteArray new: 5) size
]

{ #category : #entries }
LauncherTestsModule >> symbolHash [
	<callback: slong ()>
	^#launch: basicHash
]

{ #category : #entries }
LauncherTestsModule >> methodAt [
	<callback: slong ()>
	^(ActiveProcess compiledMethodAt: #launch:) isNil ifTrue: [0] ifFalse: [1]
]

{ #category : #entries }
LauncherTestsModule >> methodScan [
	| table |
	<callback: slong ()>
	table := ActiveProcess methodDictionary contents.
	1 to: table size do: [:i | (table at: i) == #launch: ifTrue: [^i]].
	^0
]

{ #category : #entries }
LauncherTestsModule >> tableSize [
	<callback: slong ()>
	^ActiveProcess methodDictionary contents size
]

{ #category : #entries }
LauncherTestsModule >> tableIndex [
	<callback: slong ()>
	^ActiveProcess methodDictionary contents indexOfHash: 503096068
]

{ #category : #entries }
LauncherTestsModule >> equates [
	<callback: slong ()>
	^(ActiveProcess methodDictionary contents equates: #launch: with: #launch:) ifTrue: [1] ifFalse: [0]
]

{ #category : #entries }
LauncherTestsModule >> emptySlot [
	<callback: slong ()>
	^ActiveProcess methodDictionary contents emptySlot isNil ifTrue: [1] ifFalse: [0]
]

{ #category : #entries }
LauncherTestsModule >> valueAt [
	<callback: slong ()>
	^(ActiveProcess methodDictionary contents valueAt: 9 ifAbsent: [nil]) isNil ifTrue: [0] ifFalse: [1]
]

{ #category : #entries }
LauncherTestsModule >> lookupKey [
	<callback: slong ()>
	^(ActiveProcess methodDictionary contents lookupKey: #launch: ifAbsent: [nil]) isNil ifTrue: [0] ifFalse: [1]
]

{ #category : #entries }
LauncherTestsModule >> hashFor [
	<callback: slong ()>
	^ActiveProcess methodDictionary contents hashFor: #launch:
]

{ #category : #entries }
LauncherTestsModule >> atIfAbsent [
	<callback: slong ()>
	^(ActiveProcess methodDictionary at: #launch: ifAbsent: [nil]) isNil ifTrue: [0] ifFalse: [1]
]

{ #category : #entries }
LauncherTestsModule >> toByDo [
	| up down |
	<callback: slong ()>
	up := 0.
	1 to: 10 by: 3 do: [:i | up := up * 100 + i].
	down := 0.
	10 to: 1 by: -4 do: [:i | down := down * 100 + i].
	^up + down
]

{ #category : #entries }
LauncherTestsModule >> callsC [
	| ffi libc memory found |
	<callback: slong ()>
	ffi := self startFFI.
	libc := ffi libc.
	memory := libc malloc: 16.
	libc free: memory.
	found := ffi loader findSymbol: #malloc in: libc address.
	^(memory = 0 or: [found = 0]) ifTrue: [0] ifFalse: [1]
]

{ #category : #entries }
LauncherTestsModule >> readsFile [
	| contents |
	<callback: slong ()>
	self startFFI.
	contents := Kernel host readFile: 'launcher-tests-file.txt'.
	^contents = 'egg reads files' ifTrue: [contents size] ifFalse: [0]
]

{ #category : #entries }
LauncherTestsModule >> allocatesHeap [
	| address memory |
	<callback: slong ()>
	self startFFI.
	address := Kernel host allocateHeap: 16r1000.
	(address bitShift: -32) = (self _oop bitShift: -32) ifFalse: [^0].
	memory := ExternalMemory at: address.
	memory at: 1 put: 42.
	^memory at: 1
]

{ #category : #entries }
LauncherTestsModule >> reservesMemory [
	| host address committed memory written released |
	<callback: slong ()>
	self startFFI.
	host := Kernel host.
	address := host reserve: 16r100000.
	address = 0 ifTrue: [^0].
	committed := host commit: 16r1000 at: address.
	committed = address ifFalse: [^0].
	memory := ExternalMemory at: address.
	memory at: 1 put: 42.
	written := memory at: 1.
	released := host release: address size: 16r100000.
	^released ifTrue: [written] ifFalse: [0]
]

{ #category : #entries }
LauncherTestsModule >> makesExecutable [
	| host address memory executable read |
	<callback: slong ()>
	self startFFI.
	host := Kernel host.
	address := host reserve: 16r100000.
	host commit: 16r1000 at: address.
	memory := ExternalMemory at: address.
	memory at: 1 put: 42.
	executable := host makeExecutable: address size: 16r1000.
	read := memory at: 1.
	host release: address size: 16r100000.
	^executable ifTrue: [read] ifFalse: [0]
]

{ #category : #services }
LauncherTestsModule >> startFFI [
	| os ffi |
	os := (Kernel host platformName endsWith: 'win32')
		ifTrue: [#'FFI.Windows' -> KernelDLL module]
		ifFalse: [#'FFI.Posix' -> DLLibrary module].
	Kernel loadedModules at: os key put: os value.
	ffi := ExternalLibrary module.
	ffi initializeForCurrentPlatform.
	^ffi
]
