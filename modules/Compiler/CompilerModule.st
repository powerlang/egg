"
    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #CompilerModule,
	#superclass : #Module,
	#instVars : [],
	#category : #'Powerlang-Core-LMR'
}

{ #category : #initializing }
CompilerModule >> initialize [
	super initialize.
	TreecodeEncoder initializeBindingIds; initializeTreecodeIds; initializeClosureElementIds
]

{ #category : #spec }
CompilerModule >> imports [
	^{
		#Kernel -> #(Error ByteArray CompiledBlock Module NumberParser Species OrderedDictionary)
	}
] 
