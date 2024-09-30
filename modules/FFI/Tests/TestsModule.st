"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #TestsModule,
	#superclass : #Module,
	#category : #Tests
}

{ #category : #private }
TestsModule >> imports [
	^{
		#Kernel -> #(WordSize).
		#FFI -> #(ExternalLibrary)
	}
]

{ #category : #initialization }
TestsModule >> main: args [
	| result |
	test := TestLibrary new open.
	result := test addInt: 3 toInt: 4.
	result = 7 ifFalse: [self error: 'addInt:toInt: failed!'].
	result := test addDouble: 3.0 toDouble: 4.0.
	result = 7.0 ifFalse: [self error: 'addDouble:toDouble: failed!'].
	Kernel log: 'all FFI tests passed!'
]


