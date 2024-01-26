"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STONReaderError, 
	#superclass : #Error, 
	#instVars : [
		'position'
	], 
	#category : #STON
}

{#category : #'instance creation'}
STONReaderError class >> signal: aString streamPosition: streamPosition [
	^ self new
		streamPosition: streamPosition;
		signal: aString;
		yourself
]

{#category : #accessing}
STONReaderError >> description [
	position ifNil: [^super description].
	^String streamContents: [:strm | 
		strm
			nextPutAll: 'At character ';
			nextPutAll: position asString;
			space;
			nextPutAll: super description]
]

{#category : #services}
STONReaderError >> signal: aString [
	self description: aString; signal
]

{#category : #accessing}
STONReaderError >> streamPosition [
	^ position
]

{#category : #accessing}
STONReaderError >> streamPosition: aNumber [
	position := aNumber
]

