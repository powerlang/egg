'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SIdentifierNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SIdentifierNode
	instanceVariableNames: 'name binding'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SIdentifierNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitIdentifier: self
! !

!SIdentifierNode methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
beAssigned
	| immutable |
	binding canBeAssigned ifTrue: [^self].
	immutable := binding isClassBinding
		ifTrue: ['class']
		ifFalse: [compiler activeScope describe: binding name].
	self compileError: 'cannot assign to ' , immutable
! !

!SIdentifierNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
binding
	^binding
! !

!SIdentifierNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
binding: aBinding
	binding := aBinding
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
checkLowercase
	| char |
	char := name first.
	(char isLetter and: [char isUppercase]) ifFalse: [^self].
	self compileWarning: name storeString , ' should start with lowercase'
! !

!SIdentifierNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
declaration
	^binding declaration
! !

!SIdentifierNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
defineArgumentIn: aScriptScope
	binding := aScriptScope defineArgument: name.
	binding declaration: self
! !

!SIdentifierNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
defineTemporaryIn: scope
	binding := scope defineTemporary: name.
	binding declaration: self
! !

!SIdentifierNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	binding := DynamicBinding default
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isEvaluable
	^self isIdentifierLiteral
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isIdentifier
	^true
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isIdentifierLiteral
	binding isDynamic ifFalse: [^binding isLiteral].
	^self ast ifNil: [false] ifNotNil: [:ast | | b |
		b := ast scope resolve: name.
		b isLiteral]
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isImmediate
	^true
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLocal
	^binding isLocal
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isMethodArgument
	| ast |
	binding isArgument ifFalse: [^false].
	ast := self ast ifNil: [^false].
	^ast arguments includes: self declaration
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isMethodTemporary
	^self ast temporaries includes: self declaration
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSelf
	^binding isSelf
! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSuper
	^binding isSuper
! !

!SIdentifierNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^name
! !

!SIdentifierNode methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:40'!
name: aString
	name := aString reduced
! !

!SIdentifierNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	aStream nextPut: $<;
	nextPutAll: name;
	nextPutAll: '> ('.
	super printOn: aStream.
	aStream nextPut: $)
! !

!SIdentifierNode methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolveAssigning: aBoolean
	binding := compiler activeScope resolve: name.
	^binding

! !

!SIdentifierNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sourceIntervals
	| stretchs declaration ast string code index |
	stretchs := OrderedCollection new.
	declaration := binding declaration.
	ast := self ast.
	ast allNodesDo: [:node | 
		(node class == self class and: [node binding declaration == declaration])
			ifTrue: [stretchs add: node stretch]].
	string := self source.
	code := compiler sourceCode.
	index := ast stretch end.
	[
		index := code indexOfString: string startingAt: index + 1.
		index > 0]
		whileTrue: [stretchs add: (index to: index + string size - 1)].
	^stretchs
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SIdentifierNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SIdentifierNode class
	instanceVariableNames: ''!


SIdentifierNode initialize!

