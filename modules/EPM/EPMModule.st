"
    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #EPMModule,
	#superclass : #Module,
	#instVars : [
		'args',
		'dir',
		'projectName'
	],
	#category : #'Powerlang-Core-LMR'
}

{ #category : #spec }
EPMModule >> imports [
	^{
		#Kernel -> #(Error ByteArray Module NumberParser Species OrderedDictionary).
		#FileSystem.
		#ArgParser -> ArgParser.
	}
]

{ #category : #initializing }
EPMModule >> main: aCollection [
	args := aCollection
	parser := ArgParser for: self.
	parser evaluate
]

{ #category : #private }
EPMModule >> createModuleClass [
	| classname filename |
	classname := projectName, 'Module'.
	filename := dir / classname , '.st'.
	filename writeStreamDo: [:ws |
		ws
			cr; nextPutAll: 'Class {'; crtab;
			nextPutAll: '#name : #Module'; crtab;
			nextPutAll: '#superclass : #', supername; crtab;
			nextPutAll: '#category : #', projectName; cr;
			nextPut: $}; cr; cr;
			nextPutAll: '{ #category: #main }'; cr;
			nextPutAll: classname; nextPutAll: ' >> main: args ['; cr;
			nextPut: $]; cr; cr
	]
]

{ #category : #commands }
EPMModule >> dev [
	| dev module |
	dir := '.' asFilename asDirectory.
	projectName := dir parent name.
	dev := Kernel load: #Development.
	module := Kernel load: projectName.
	dev main: args
]

{ #category : #commands }
EPMModule >> new: aString [
	projectName := aString.
	dir := projectName asFilename asDirectory.
	dir exists 
		ifTrue: [
			dir isEmpty ifTrue: [ ^self error: 'the directory is not empty']]
		ifFalse: [ dir create ].
	
	self createModuleClass
]

{ #category : #commands }
EPMModule >> start [
	| module |
	dir := '.' asFilename asDirectory.
	projectName := dir parent name.
	module := Kernel load: projectName.
	module main: args
]

