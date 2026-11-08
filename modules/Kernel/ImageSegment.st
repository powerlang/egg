"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #ImageSegment,
	#superclass : #Object,
	#instVars : [
		'name',
		'bytes',
		'segmentSize',
		'codeSize',
		'importStrings',
		'importDescriptors',
		'exports',
		'imports'
	],
	#category : #Kernel
}

{ #category : #accessing }
ImageSegment class >> load: filename [
	"TO BE IMPLEMENTED!"
	^nil
]

{ #category : #'instance creation' }
ImageSegment class >> on: aString [
	^self new parse: aString
]

{ #category : #accessing }
ImageSegment >> codeSize [
	^codeSize
]

{ #category : #accessing }
ImageSegment >> exports [
	^exports
]

{ #category : #accessing }
ImageSegment >> importDescriptors [
	^importDescriptors
]

{ #category : #accessing }
ImageSegment >> importStrings [
	^importStrings
]

{ #category : #accessing }
ImageSegment >> name [
	^name
]

{ #category : #accessing }
ImageSegment >> name: aString [
	name := aString
]

{ #category : #parsing }
ImageSegment >> parse: aString [
	| offset |
	bytes := aString.
	(bytes copyFrom: 1 to: 7) = 'EGG_IS
' ifFalse: [^self error: 'wrong image segment signature'].
	segmentSize := bytes pointerAtOffset: 16.
	codeSize := bytes pointerAtOffset: 40.
	offset := self readImportStringsAt: self storedSize.
	offset := self readImportDescriptorsAt: offset.
	self readExportsAt: offset
]

{ #category : #parsing }
ImageSegment >> readExportsAt: anInteger [
	| count offset |
	count := bytes uLongAtOffset: anInteger.
	offset := anInteger + 4.
	exports := Dictionary new.
	count timesRepeat: [| address length export |
		address := bytes pointerAtOffset: offset.
		length := bytes pointerAtOffset: offset + 8.
		export := bytes copyFrom: offset + 17 to: offset + 16 + length.
		exports at: export put: address.
		offset := offset + 16 + length]
]

{ #category : #parsing }
ImageSegment >> readImportDescriptorsAt: anInteger [
	| count offset |
	count := bytes uLongAtOffset: anInteger.
	offset := anInteger + 4.
	importDescriptors := (1 to: count) collect: [:i | | length descriptor |
		length := bytes uLongAtOffset: offset.
		descriptor := (1 to: length) collect: [:j | bytes uLongAtOffset: offset + (j * 4)].
		offset := offset + 4 + (length * 4).
		descriptor].
	^offset
]

{ #category : #parsing }
ImageSegment >> readImportStringsAt: anInteger [
	| count offset |
	count := bytes uLongAtOffset: anInteger.
	offset := anInteger + 4.
	importStrings := (1 to: count) collect: [:i | | length string |
		length := bytes uLongAtOffset: offset.
		string := bytes copyFrom: offset + 5 to: offset + 4 + length.
		offset := offset + 4 + length.
		string].
	^offset
]

{ #category : #accessing }
ImageSegment >> segmentSize [
	^segmentSize
]

{ #category : #parsing }
ImageSegment >> storedSize [
	codeSize = 0 ifTrue: [^segmentSize].
	^(segmentSize alignedTo: 16r10000) + codeSize
]

{ #category : #accessing }
ImageSegment >> imports [
	^imports
]

{ #category : #linking }
ImageSegment >> link: anArray [
	| descriptor token reference |
	descriptor := anArray collect: [:index | (importStrings at: index + 1) asSymbol].
	descriptor size = 2 ifTrue: [token := descriptor second].
	descriptor size > 2 ifTrue: [token := descriptor allButFirst].
	reference := SymbolicReference linker: descriptor first token: token.
	^reference link
]

{ #category : #linking }
ImageSegment >> linkImports [
	imports := importDescriptors collect: [:descriptor | self link: descriptor].
	^imports
]
