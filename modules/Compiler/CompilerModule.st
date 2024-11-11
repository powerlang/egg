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
	TreecodeEncoder initializeBindingIds; initializeTreecodeIds.
	self initializeClosureElementIds
]

{ #category : #spec }
CompilerModule >> imports [
	^{
		#Kernel -> #(Error ByteArray CompiledBlock Module NumberParser Species OrderedDictionary)
	}
] 

{ #category : #'class initialization' }
CompilerModule class >> initializeClosureElementIds [
	| namespace |
	self namespace
		at: #CaptureSelf put: 0;
		at: #CaptureLocalArgument put: 1;
		at: #CaptureEnvironment put: 2;
		at: #CaptureEnvironmentValue put: 3;
		at: #CaptureInlinedArgument put: 4
]