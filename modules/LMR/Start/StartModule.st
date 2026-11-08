"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #StartModule,
	#superclass : #Module,
	#category : #'LMR-Start'
}

{ #category : #spec }
StartModule >> imports [
	^{
		#Kernel -> #(ImageSegment).
		#LMR -> #(Memory).
		#'FFI.Posix' -> #(DLLibrary).
		#'FFI.Windows' -> #(KernelDLL)
	}
]

{ #category : #services }
StartModule >> exitBecause: anException [
	Kernel host logError: anException description; exit: -1
]

{ #category : #entries }
StartModule >> start [
	| arguments name program |
	<callback: slong ()>
	Kernel host startUp.
	Kernel unhandledExceptionHandler: [:exception | self exitBecause: exception].
	Memory current startUp.
	arguments := Kernel host arguments.
	name := arguments at: 3.
	program := ImageSegment load: (arguments at: 2) , '/' , name , '.ems'.
	Kernel loadedModules at: name asSymbol put: program.
	program justLoaded.
	^program main: (arguments copyFrom: 4 to: arguments size)
]
