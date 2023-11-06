"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #HostSystem,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #loading }
HostSystem >> load: aSymbol [
	<primitive: HostLoadModule>
]

{ #category : #bootstrapping }
HostSystem >> fixOverrides [
	<primitive: HostFixOverrides>
]

	
