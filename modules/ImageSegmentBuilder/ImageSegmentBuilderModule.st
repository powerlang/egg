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
		#Kernel -> #Behavior. #Kernel -> #Boolean. #Kernel -> #False.
		#Kernel -> #HashTable. #Kernel -> #IdentityDictionary. #Kernel -> #IdentitySet.
		#Kernel -> #KernelModule. #Kernel -> #Module. #Kernel -> #Symbol.
		#Kernel -> #True. #Kernel -> #UndefinedObject}
] 

{ #category : #bootstrapping }
ImageSegmentBuilderModule >> writeJSONKernel [
	^self writeJSONModule: Kernel
]

{ #category : #bootstrapping }
ImageSegmentBuilderModule >> writeJSONModule: aModule [
	| builder writer |
	Kernel host fixOverrides.
	self
		import: #Writer from: #ImageSegmentBuilder.JSON.
	builder := Builder new.
	builder module: aModule; build.
	writer := Writer new.
	^writer
		closure: builder closure;
		objects: builder objects;
		mapping: builder mapping;
		imports: builder imports;
		exports: aModule exports;
		write;
		image
]


