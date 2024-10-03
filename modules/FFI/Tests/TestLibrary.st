"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #TestLibrary,
	#superclass : #ExternalLibrary,
	#category : #Tests
}

{ #category : #accessing }
TestLibrary class >> libname [
	^'test'
]

{ #category : #accessing }
TestLibrary class >> libpath [
	^'./'
]

{ #category : #accessing }
TestLibrary >> addInt: anInteger toInt: anotherInteger [
	<cdecl: pointer PaddPP(pointer, pointer)>
]

{ #category : #accessing }
TestLibrary >> addDouble: aDouble toDouble: anotherDouble [
	<cdecl: double DaddDD(double, double)>
]

