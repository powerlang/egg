"
    Copyright (c) 2022, Quorum Software. 
    See (MIT) license in root directory.
"
Class {
	#name : #CodeSpecsModule,
	#superclass : #Module,
	#instVars : [],
	#category : #'CodeSpecs'
}

{ #category : #spec }
CodeSpecsModule >> imports [
	^{
		#Kernel -> #(#OrderedDictionary).
	}
] 
