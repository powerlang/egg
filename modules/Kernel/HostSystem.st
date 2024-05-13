"
    Copyright (c) 2024, Javier Pimas.
    See (MIT) license in root directory.
"

Class {
	#name : #HostSystem,
	#superclass : #Object,
	#category : #Kernel
}

HostSystem >> exit: anInteger [
	<primitive: HostExit>
]

{ #category : #bootstrapping }
HostSystem >> fixOverrides [
	<primitive: HostFixOverrides>
]

{ #category : #loading }
HostSystem >> load: aSymbol [
	<primitive: HostLoadModule>
]

{ #category : #logging }
HostSystem >> logError: aString [
	<primitive: HostLogError>
]

{ #category : #private }
HostSystem >> suspended: aProcess because: anException [
	<primitive: HostSuspendedBecause>
]
