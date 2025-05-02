"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TimestampAdaptor,
	#superclass : #DataAdaptor,
	#instVars : [
		'format'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
TimestampAdaptor class >> iso8601 [
	^self new format: #iso8601]

{ #category : #services }
TimestampAdaptor >> dataFrom: anObject [
	| ts |
	ts := anObject isDate
		ifTrue: [anObject utc]
		ifFalse: [anObject asTimestamp].
	^ts perform: format
]

{ #category : #accessing }
TimestampAdaptor >> format: aSymbol [
	format := aSymbol
]

{ #category : #services }
TimestampAdaptor >> objectFrom: aString [
	^Timestamp perform: (format , ':') asSymbol with: aString
]

