"
    Copyright (c) 2022, Quorum Software.
    See (MIT) license in root directory.
"

Class {
	#name : #ModuleImporterModule,
	#superclass : #Module,
	#instVars : [],
	#category : #'ModuleImporter'
}

{ #category : #spec }
ModuleImporterModule >> imports [
	^{
		#Kernel -> #(#InternalReadStream #Character #CharacterArray #IdentitySet #Module).
		#Tonel -> #(#TonelReader).
		#CodeSpecs -> #(#ModuleSpec #ClassSpec #MetaclassSpec #MethodSpec).
		#STON -> #(#STONReader).
		#Compiler -> #(#SCompiler).
	}
]
