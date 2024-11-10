"
    Copyright (c) 2024, Javier Pimas.
    See (MIT) license in root directory.
"

Class {
	#name : #HostSystem,
	#superclass : #Object,
	#category : #Kernel
}


HostSystem >> currentMilliseconds [
	<primitive: HostCurrentMilliseconds>
]

HostSystem >> exit: anInteger [
	<primitive: HostExit>
]

{ #category : #bootstrapping }
HostSystem >> fixOverrides [
	<primitive: HostFixOverrides>
]

{ #category : #bootstrapping }
HostSystem >> initializeFFI: anExternalLibrary symbolFinder: anFFIMethod [
	<primitive: HostInitializeFFI>
]

{ #category : #loading }
HostSystem >> primitiveLoad: aSymbol [
	<primitive: HostLoadModule>
]

{ #category : #loading }
HostSystem >> load: aSymbol [
	| module |
	module := self primitiveLoad: aSymbol.
	^module justLoaded
]

{ #category : #logging }
HostSystem >> logError: aString [
	<primitive: HostLogError>
]

{ #category : #loading }
HostSystem >> platformName [
	<primitive: HostPlatformName>
]

{ #category : #private }
HostSystem >> suspended: aProcess because: anException [
	<primitive: HostSuspendedBecause>
]

{ #category : #services }
HostSystem >> readFile: filename [
	<primitive: HostReadFile>
]
