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
			#Behavior. #Boolean. #CallbackBehavior. #False. #HashTable. #IdentityDictionary. #IdentitySet. #KernelModule.
			#MethodDictionary. #Module. #ProcessorScheduler. #Symbol. #SymbolicReference.
			#True. #UndefinedObject
		}
	}
]

