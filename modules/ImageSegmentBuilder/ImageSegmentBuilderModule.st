"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ImageSegmentBuilderModule,
	#superclass : #Module,
	#category : #ImageSegmentBuilder
}

{ #category : #spec }
ImageSegmentBuilderModule >> imports [
	^{
		#Kernel -> {
			#Behavior. #Boolean. #False. #HashTable. #IdentityDictionary. #IdentitySet. #KernelModule. 
			#Module. #Symbol. #SymbolicReference. #True. #UndefinedObject
		}
	}
]

