"
    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #LoaderModule,
	#superclass : #Module,
	#category : #'Tonel'
}

{ #category : #spec }
LoaderModule >> imports [
	^{
		#Kernel -> #(IdentitySet Module).
		#Compiler -> #SCompiler
	}
]

{ #category : #initializing }
LoaderModule >> start [

]
