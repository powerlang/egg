"
    Copyright (c) 2022, Quorum Software.
    See (MIT) license in root directory.
"

Class {
	#name : #CodeSpecsImporterModule,
	#superclass : #Module,
	#instVars : [],
	#category : #'CodeSpecsImporter'
}

{ #category : #spec }
CodeSpecsImporterModule >> imports [
	^{
		#Kernel -> #(#InternalReadStream #Character #CharacterArray).
		#Tonel -> #(#TonelReader).
		#CodeSpecs -> #(#ModuleSpec #ClassSpec #MetaclassSpec #MethodSpec).
		#STON -> #(#STONReader)
	}
]
