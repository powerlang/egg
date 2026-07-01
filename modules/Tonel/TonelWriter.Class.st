'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TonelWriter category: #Tonel!
Object subclass: #TonelWriter
	instanceVariableNames: 'stream class category methods'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tonel'!
!TonelWriter commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!TonelWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
category: aString
	category := aString
! !

!TonelWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
class: aClass
	class := aClass
! !

!TonelWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
crtab
	stream crtab
! !

!TonelWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
definition
	| map supername ivars cvars |
	map := OrderedDictionary new.
	self isExtension
		ifTrue: [^map
			at: #name put: methods anyone classBinding name asSymbol;
			yourself].
	supername := (class respondsTo: #supername)
		ifTrue: [class supername]
		ifFalse: [class superclass ifNotNil: [:c | c name]].
	map
		at: #name put: class name asSymbol;
		at: #superclass put: supername asSymbol.
	class instancesHavePointers
		ifTrue: [class instancesAreArrayed ifTrue: [map at: #type put: #variable]]
		ifFalse: [map at: #type put: #bytes].
	ivars := class instVarNames asArray.
	ivars isEmpty ifFalse: [map at: #instVars put: ivars].
	cvars := class classVarNames asSortedCollection asArray.
	cvars isEmpty ifFalse: [map at: #classVars put: cvars].
	category notNil ifTrue: [map at: #category put: category asSymbol].
	^map
! !

!TonelWriter methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isExtension
	^self type = 'Extension'
! !

!TonelWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
methods
	methods notNil ifTrue: [^methods].
	class isNil ifTrue: [^#()].
	^class class methodDictionary asArray & class methodDictionary asArray
! !

!TonelWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
methods: aCollection
	methods := aCollection.
	self ASSERT: (methods isEmptyOrNil or: [| classes |
		classes := methods collect: #classBinding in: Set new.
		classes size = 1 or: [
			classes size = 2 and: [| meta |
				meta := classes detect: [:cls | cls isMetaclass] ifNone: nil.
				meta notNil and: [classes anySatisfy: [:cls | cls = meta instanceClass]]]]])
! !

!TonelWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sortedMethods
	| classMethods instanceMethods |
	classMethods := OrderedCollection new.
	instanceMethods := OrderedCollection new.
	self methods do: [:m |
		m classBinding isMetaclass
			ifTrue: [classMethods add: m]
			ifFalse: [instanceMethods add: m]].
	classMethods sortBy: [:a :b | a selector <= b selector].
	instanceMethods sortBy: [:a :b | a selector <= b selector].
	^classMethods asArray & instanceMethods asArray
! !

!TonelWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
position: aStream afterSelector: aSymbol
	| c |
	aSymbol arity = 0
		ifTrue: [aStream skipSeparators; skip: aSymbol size]
		ifFalse: [
			aSymbol keywords do: [:part | 
				aStream skipSeparators; skip: part size; skipSeparators.
				self skipIdentifierIn: aStream]].
	[
		aStream atEnd ifTrue: [^self].
		c := aStream peek.
		c isSeparator andNot: [c isEndOfLine]]
		whileTrue: [aStream next].
	c isEndOfLine ifTrue: [aStream next]
! !

!TonelWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
skipIdentifierIn: aStream
	[aStream atEnd not and: [aStream peek isAlphaNumericOrUnderscore]]
		whileTrue: [aStream next]
! !

!TonelWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stream: aWriteStream
	stream := aWriteStream
! !

!TonelWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
type
	^class notNil ifTrue: ['Class'] ifFalse: ['Extension']
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
write
	self
		writeComments;
		writeType;
		writeDefinition;
		writeMethods
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeClass: aClass
	self writeClass: aClass category: nil
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeClass: aClass category: aString
	self
		class: aClass;
		category: aString;
		methods: nil;
		write
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeComments
	| comment |
	comment := class comment.
	(comment isNil or: [comment isEmpty]) ifTrue: [^self].
	stream nextPut: $"; nextPutAll: comment; nextPut: $"; cr; cr
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeDefinition
	(STONWriter on: stream) writeMap: self definition.
	stream cr; cr
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeMethod: method
	| source head body metadata |
	source := method sourceObject.
	source isNil ifTrue: [^self].
	source := source readStream.
	self position: source afterSelector: method selector.
	head := source copyFrom: 1 to: source position.
	body := source upToEnd.
	metadata := OrderedDictionary new.
	metadata at: #category put: method category.
	(STONWriter on: stream) writeMap: metadata.
	stream cr; print: method classBinding name; nextPutAll: ' >> '.
	head lines
		do: [:line | stream nextPutAll: line]
		separatedBy: [stream cr].
	stream nextPutAll: ' ['.
	body := body readStream.
	[
		stream cr; nextPutAll: body nextLine.
		body atEnd] whileFalse.
	stream
		cr;
		nextPutAll: ']';
		cr;
		cr
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeMethods
	self sortedMethods do: [:m | self writeMethod: m]
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeMethods: aCollection
	self class: nil; methods: aCollection; write
! !

!TonelWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeType
	stream nextPutAll: self type; space
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TonelWriter class' category: #Tonel!
TonelWriter class
	instanceVariableNames: ''!

!TonelWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
on: aWriteStream
	^self new stream: aWriteStream
! !

!TonelWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeClass: aClass
	"
	TonelWriter writeClass: Point
	"
	^self writeClass: aClass category: nil
! !

!TonelWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeClass: aClass category: aString
	"
	TonelWriter writeClass: Point category: 'Kernel'
	"
	| tonel |
	tonel := '' writeStream.
	(self on: tonel) writeClass: aClass category: aString.
	^tonel contents
! !

!TonelWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeMethods: aCollection
	"
	TonelWriter writeMethods: Point methodDictionary asArray
	"
	| tonel |
	tonel := '' writeStream.
	(self on: tonel) writeMethods: aCollection.
	^tonel contents
! !


