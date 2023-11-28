Class {
	#name : #HaltingSend,
	#superclass : #MessageLinker,
	#category : #Nativization
}

{ #category : #nativizing }
HaltingSend >> emitSend: aSymbol using: anAssembler [
	anAssembler breakpoint
]
