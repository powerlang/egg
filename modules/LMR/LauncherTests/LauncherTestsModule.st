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
