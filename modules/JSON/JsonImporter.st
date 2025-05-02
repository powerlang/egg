"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonImporter,
	#superclass : #Object,
	#instVars : [
		'parser',
		'metadata',
		'contents',
		'filename'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
JsonImporter class >> importFrom: aFilename [
	^self new importFrom: aFilename
]

{ #category : #importing }
JsonImporter >> checkContentsKey: aString value: aDictionary [
	aString = 'Contents'
		ifFalse: [self error: 'the Contents key is not defined as the second one'].
	contents := aDictionary
]

{ #category : #importing }
JsonImporter >> checkKey: key value: value index: index [
	index = 1 ifTrue: [^self checkMetadataKey: key value: value].
	index = 2 ifTrue: [^self checkContentsKey: key value: value].
	index > 2 ifTrue: [^self failBecause: 'there are more keys than expected']
]

{ #category : #importing }
JsonImporter >> checkMetadataKey: aString value: aDictionary [
	| type version |
	aString = 'Metadata'
		ifFalse: [self
			failBecause: 'the metadata is not defined as the first key of the file'].
	type := aDictionary at: 'Type'.
	(self validTypes includes: type)
		ifFalse: [self failBecause: 'the defined Type is not valid'].
	version := aDictionary at: 'Version'.
	version <= self currentVersion ifFalse: [
		self
			error: 'the version of the file is newer than the current application version'].
	metadata := aDictionary
]

{ #category : #private }
JsonImporter >> contentsOf: aFilename [
	| file |
	file := aFilename asFilename asFile.
	^file exists ifTrue: [file binaryContents]
]

{ #category : #accessing }
JsonImporter >> currentVersion [
	^self subclassResponsibility
]

{ #category : #exceptions }
JsonImporter >> failBecause: aString [
	| description |
	description := 'Could not import ' , filename asString , ' because '
		, aString.
	JsonImporterError signal: description
]

{ #category : #importing }
JsonImporter >> importFrom: aFilename [
	| index |
	self reset.
	filename := aFilename.
	self updateParser.
	index := 1.
	parser parseMapKeysAndValuesDo: [:key :value | 
		self checkKey: key value: value index: index.
		index := index + 1].
	^contents
]

{ #category : #accessing }
JsonImporter >> reset [
	metadata := contents := parser := filename := nil
]

{ #category : #updating }
JsonImporter >> updateParser [
	| data string |
	data := self contentsOf: filename.
	data notNil ifTrue: [
		string := String fromUTF8: data.
		parser := JsonParser on: string readStream]
]

{ #category : #accessing }
JsonImporter >> validTypes [
	^self subclassResponsibility
]

