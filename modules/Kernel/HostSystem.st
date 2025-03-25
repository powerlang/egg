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
HostSystem >> log: aString level: anInteger [
	<primitive: HostLog>
]

{ #category : #logging }
HostSystem >> logTrace: aString [
	self log: aString level: 0
]

{ #category : #logging }
HostSystem >> logDebug: aString [
	self log: aString level: 1
]

{ #category : #logging }
HostSystem >> logInfo: aString [
	self log: aString level: 2
]

{ #category : #logging }
HostSystem >> logWarning: aString [
	self log: aString level: 3
]

{ #category : #logging }
HostSystem >> logError: aString [
	self log: aString level: 4
]

{ #category : #logging }
HostSystem >> logFatal: aString [
	self log: aString level: 5

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
