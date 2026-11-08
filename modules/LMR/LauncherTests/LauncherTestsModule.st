"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LauncherTestsModule,
	#superclass : #Module,
	#category : #'LMR-LauncherTests'
}

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
