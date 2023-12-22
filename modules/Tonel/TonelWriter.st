"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #TonelWriter, 
	#superclass : #Object, 
	#instVars : OrderedCollection [
		'stream', 
		'class', 
		'category', 
		'methods'
	], 
	#classVars : [], 
	#category : #Tonel
}

{
	#category : #'instance creation'
}
TonelWriter class >> on: aWriteStream [
	^self new stream: aWriteStream]

{
	#category : #'instance creation'
}
TonelWriter class >> writeClass: aClass [
	"
	TonelWriter writeClass: Point
	"
	^self writeClass: aClass category: nil]

{
	#category : #'instance creation'
}
TonelWriter class >> writeClass: aClass category: aString [
	"
	TonelWriter writeClass: Point category: 'Kernel'
	"
	| tonel |
	tonel := '' writeStream.
	(self on: tonel) writeClass: aClass category: aString.
	^tonel contents]

{
	#category : #'instance creation'
}
TonelWriter class >> writeMethods: aCollection [
	"
	TonelWriter writeMethods: Point methodDictionary asArray
	"
	| tonel |
	tonel := '' writeStream.
	(self on: tonel) writeMethods: aCollection.
	^tonel contents]

{
	#category : #accessing
}
TonelWriter >> category: aString [
	category := aString]

{
	#category : #accessing
}
TonelWriter >> class: aClass [
	class := aClass]

{
	#category : #private
}
TonelWriter >> crtab [
	stream crtab]

{
	#category : #private
}
TonelWriter >> definition [
	| map supername |
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
	class _instancesHavePointers
		ifTrue: [class _instancesAreArrayed ifTrue: [map at: #type put: #variable]]
		ifFalse: [map at: #type put: #bytes].
	map
		at: #instVars put: class instVarNames;
		at: #classVars put: class classVarNames asSortedCollection asArray.
	category notNil ifTrue: [map at: #category put: category asSymbol].
	^map]

{
	#category : #testing
}
TonelWriter >> isExtension [
	^self type = 'Extension']

{
	#category : #accessing
}
TonelWriter >> methods [
	methods notNil ifTrue: [^methods].
	class isNil ifTrue: [^#()].
	^class class methodDictionary asArray & class methodDictionary asArray]

{
	#category : #accessing
}
TonelWriter >> methods: aCollection [
	methods := aCollection.
	self ASSERT: (methods isEmptyOrNil or: [| classes |
		classes := methods collect: #classBinding in: Set new.
		classes size = 1 or: [
			classes size = 2 and: [| meta |
				meta := classes detect: [:cls | cls isMetaclass] ifNone: nil.
				meta notNil and: [classes anySatisfy: [:cls | cls = meta instanceClass]]]]])]

{
	#category : #private
}
TonelWriter >> position: aStream afterSelector: aSymbol [
	| c |
	aSymbol arity = 0
		ifTrue: [aStream skipSeparators; skip: aSymbol size]
		ifFalse: [
			aSymbol keywords do: [:part | 
				aStream
					skipSeparators;
					skip: part size;
					skipSeparators;
					nextKeyword]].
	[
		aStream atEnd ifTrue: [^self].
		c := aStream peek.
		c isSeparator andNot: [c isEndOfLine]]
		whileTrue: [aStream next].
	c isEndOfLine ifTrue: [aStream next]]

{
	#category : #accessing
}
TonelWriter >> stream: aWriteStream [
	stream := aWriteStream]

{
	#category : #private
}
TonelWriter >> type [
	^class notNil ifTrue: ['Class'] ifFalse: ['Extension']]

{
	#category : #writing
}
TonelWriter >> write [
	self
		writeComments;
		writeType;
		writeDefinition;
		writeMethods]

{
	#category : #writing
}
TonelWriter >> writeClass: aClass [
	self writeClass: aClass category: nil]

{
	#category : #writing
}
TonelWriter >> writeClass: aClass category: aString [
	self
		class: aClass;
		category: aString;
		methods: nil;
		write]

{
	#category : #writing
}
TonelWriter >> writeComments [
	]

{
	#category : #writing
}
TonelWriter >> writeDefinition [
	(STONWriter on: stream) writeMap: self definition.
	stream cr; cr]

{
	#category : #writing
}
TonelWriter >> writeMethod: method [
	| source head body metadata |
	source := method sourceCode readStream.
	self position: source afterSelector: method selector.
	head := source copyFrom: 1 to: source position.
	body := source upToEnd.
	metadata := OrderedDictionary new.
	metadata at: #category put: method category.
	(STONWriter on: stream) writeMap: metadata.
	stream cr; print: method classBinding name; nextPutAll: ' >> '.
	head lines
		do: [:line | stream nextPutAll: line utf8]
		separatedBy: [stream cr].
	stream nextPutAll: ' ['.
	body := body readStream.
	[
		stream cr; nextPutAll: body nextLine utf8.
		body atEnd] whileFalse.
	stream nextPutAll: ']'; cr; cr]

{
	#category : #writing
}
TonelWriter >> writeMethods [
	self methods do: [:m | self writeMethod: m]]

{
	#category : #writing
}
TonelWriter >> writeMethods: aCollection [
	self class: nil; methods: aCollection; write]

{
	#category : #writing
}
TonelWriter >> writeType [
	stream nextPutAll: self type; space]

