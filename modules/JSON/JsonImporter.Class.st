'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonImporter category: #JSON!
Object subclass: #JsonImporter
	instanceVariableNames: 'parser metadata contents filename'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonImporter commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonImporter methodsFor:  'importing' stamp: 'KenD 28/Jun/2026 13:27:41'!
checkContentsKey: aString value: aDictionary
	aString = 'Contents'
		ifFalse: [self error: 'the Contents key is not defined as the second one'].
	contents := aDictionary
! !

!JsonImporter methodsFor:  'importing' stamp: 'KenD 28/Jun/2026 13:27:41'!
checkKey: key value: value index: index
	index = 1 ifTrue: [^self checkMetadataKey: key value: value].
	index = 2 ifTrue: [^self checkContentsKey: key value: value].
	index > 2 ifTrue: [^self failBecause: 'there are more keys than expected']
! !

!JsonImporter methodsFor:  'importing' stamp: 'KenD 28/Jun/2026 13:27:41'!
checkMetadataKey: aString value: aDictionary
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
! !

!JsonImporter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
contentsOf: aFilename
	| file |
	file := aFilename asFilename asFile.
	^file exists ifTrue: [file binaryContents]
! !

!JsonImporter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
currentVersion
	^self subclassResponsibility
! !

!JsonImporter methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:41'!
failBecause: aString
	| description |
	description := 'Could not import ' , filename asString , ' because '
		, aString.
	JsonImporterError signal: description
! !

!JsonImporter methodsFor:  'importing' stamp: 'KenD 28/Jun/2026 13:27:41'!
importFrom: aFilename
	| index |
	self reset.
	filename := aFilename.
	self updateParser.
	index := 1.
	parser parseMapKeysAndValuesDo: [:key :value | 
		self checkKey: key value: value index: index.
		index := index + 1].
	^contents
! !

!JsonImporter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
reset
	metadata := contents := parser := filename := nil
! !

!JsonImporter methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:41'!
updateParser
	| data string |
	data := self contentsOf: filename.
	data notNil ifTrue: [
		string := String fromUTF8: data.
		parser := JsonParser on: string readStream]
! !

!JsonImporter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
validTypes
	^self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonImporter class' category: #JSON!
JsonImporter class
	instanceVariableNames: ''!

!JsonImporter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
importFrom: aFilename
	^self new importFrom: aFilename
! !


