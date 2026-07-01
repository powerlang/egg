'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SCompiler category: #'Powerlang-Core-SCompiler'!
Object subclass: #SCompiler
	instanceVariableNames: 'errorHandler result class'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!SCompiler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canBeInIdentifier: aCharacter
	^aCharacter isLetter or: [aCharacter isDigit] or: [aCharacter = $_]
! !

!SCompiler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canStartIdentifier: aCharacter
	^aCharacter isLetter or: [aCharacter = $_]
! !

!SCompiler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
classBinding
	 ^class
! !

!SCompiler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
classBinding: aSpecies
	| instance |
	class := aSpecies.
	instance := aSpecies instanceClass.
	(instance respondsTo: #configureCompiler)
		ifTrue: [instance configureCompiler: self]
! !

!SCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
compile: aString
	result := self smalltalkCompiler compileMethod: aString.
	^result method
! !

!SCompiler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
forClass: aClass
	| c |
	c := aClass ifNil: [UndefinedObject].
	self classBinding: c
! !

!SCompiler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize: aDictionary
	class := aDictionary at: #UndefinedObject ifAbsent: nil
! !

!SCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
parse: aString
	result := self smalltalkCompiler parseMethod: aString.
	^result ast
! !

!SCompiler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
peekForIdentifier: aStream
	| char next |
	char := aStream peek.
	(self canBeInIdentifier: char) ifTrue: [
		aStream skip: 1.
		^true].
	char = $. ifFalse: [^false].
	aStream prev isLetter ifFalse: [
		aStream skip: 1.
		^false].
	next := aStream skip: 2; peek.
	next isNil ifTrue: [
		aStream skip: -1.
		^false].
	^next isLetter ifFalse: [aStream skip: -1]; yourself
! !

!SCompiler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
protect: aBlock
	^aBlock value
! !

!SCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
smalltalkCompiler
	^ SSmalltalkCompiler new frontend: self
! !

!SCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
smalltalkParser
	^ self smalltalkCompiler parser
! !

!SCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
smalltalkScanner
	^ self smalltalkCompiler scanner
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCompiler class' category: #'Powerlang-Core-SCompiler'!
SCompiler class
	instanceVariableNames: ''!

!SCompiler class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
compile: aString in: aClass
	| compiler |
	compiler := self forClass: aClass.
	^compiler compile: aString
! !

!SCompiler class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
forClass: aClass
	^self new forClass: aClass
! !

!SCompiler class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
parse: aString in: aClass
	| compiler |
	compiler := self forClass: aClass.
	^compiler parse: aString
! !


