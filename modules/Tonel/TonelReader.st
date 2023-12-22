"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #TonelReader, 
	#superclass : #Object, 
	#instVars : OrderedCollection [
		'class', 
		'methods', 
		'stream'
	], 
	#classVars : [], 
	#category : #Tonel
}

{
	#category : #'instance creation'
}
TonelReader class >> new [
	^super new initialize]

{
	#category : #'instance creation'
}
TonelReader class >> on: aStream [
	^self new stream: aStream]

{
	#category : #accessing
}
TonelReader >> definition [
	^class]

{
	#category : #initialization
}
TonelReader >> initialize [
	class := OrderedDictionary new.
	methods := OrderedCollection new]

{
	#category : #accessing
}
TonelReader >> methods [
	^methods]

{
	#category : #reading
}
TonelReader >> nextBlock [
	| nested char start eol prev |
	nested := 0.
	prev := nil.
	char := $[.
	start := stream skipLine; position.
	[
		(char == $[ andNot: [prev == $$]) ifTrue: [nested := nested + 1].
		(char = $] andNot: [prev == $$]) ifTrue: [nested := nested - 1].
		prev := char.
		char = $' ifTrue: [self skipString].
		char = $" ifTrue: [self skipComment].
		nested = 0]
		whileFalse: [char := stream next].
	eol := stream eol size.
	^stream copyFrom: start + eol - 1 to: stream position - 1]

{
	#category : #reading
}
TonelReader >> read [
	self
		readComments;
		readType;
		readDefinition;
		readMethods]

{
	#category : #reading
}
TonelReader >> readComments [
	stream skipSeparators.
	stream peek = $" ifTrue: [
		stream next.
		self skipComment]]

{
	#category : #reading
}
TonelReader >> readDefinition [
	STONReader new
		on: stream skipSeparators;
		parseMapDo: [:key :value | class at: key put: value]]

{
	#category : #reading
}
TonelReader >> readMethod [
	| metadata classname signature selector method |
	metadata := STON fromStream: stream.
	classname := stream skipSeparators; upToAll: '>>'.
	signature := stream upTo: $[.
	selector := SmalltalkParser parseSelector: signature.
	method := OrderedDictionary new.
	method
		addAll: metadata;
		at: #class put: classname trimBlanks;
		at: #signature put: signature trimBlanks;
		at: #selector put: selector;
		at: #body put: self nextBlock.
	methods add: method]

{
	#category : #reading
}
TonelReader >> readMethods [
	[stream skipSeparators; atEnd] whileFalse: [self readMethod]]

{
	#category : #reading
}
TonelReader >> readType [
	| type |
	type := stream skipSeparators; nextWordOrNumber.
	(type = 'Class' or: [type = 'Extension'])
		ifFalse: [self error: 'unsupported type']]

{
	#category : #private
}
TonelReader >> skipComment [
	self skipToMatch: $"]

{
	#category : #private
}
TonelReader >> skipString [
	self skipToMatch: $']

{
	#category : #private
}
TonelReader >> skipToMatch: aCharacter [
	[| found |
		found := stream skipTo: aCharacter.
		found ifFalse: [self error: aCharacter storeString , ' end expected'].
		stream peek = aCharacter ifTrue: [
			stream next.
			found := false].
		found] whileFalse]

{
	#category : #accessing
}
TonelReader >> stream: aReadStream [
	stream := aReadStream]

