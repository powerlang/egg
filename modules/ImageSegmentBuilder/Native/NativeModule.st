"
    Copyright (c) 2023-2024, Javier Pimás.
    See (MIT) license in root directory.

	This module implements a writer that serializes Egg objects into a stream in a format that is
	very similar to the format of objects in raw memory. Egg object format is decribed in detail
	in Egg documentation.
"

Class {
	#name : #NativeModule,
	#superclass : #Module,
	#instVars : [
		''
	],
	#category : #'Powerlang-Core-LMR'
}

{ #category : #spec }
NativeModule >> imports [
	^{
		#Kernel -> #(Module HashTable IdentityDictionary ProtoObject).
		#ImageSegmentBuilder -> #Writer
	}
] 

{ #category : #services }
NativeModule >> initialize [
	| names |
	super initialize.
	names := (ProtoObject classVarNamed: #ObjectBitsMasks).
	names ifNil: [self _halt].
	NativeWriter addNamespace: names.
]

{ #category : #services }
NativeModule >> newWriter [
	^NativeWriter new
]

{ #category : #services }
NativeModule >> fileExtension [
	"Egg Module Snapshot"
	^'ems'
]