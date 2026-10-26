"
	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #IRModule,
	#superclass : #Module,
	#category : #IR
}

{ #category : #spec }
IRModule >> imports [
	^{
		#Kernel -> #(OrderedCollection)
	}
]
