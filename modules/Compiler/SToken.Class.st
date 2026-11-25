'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
Object subclass: #SToken
	instanceVariableNames: 'compiler stretch comments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SToken methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
comment
	^comments notNil ifTrue: [comments anyOne]
! !

!SToken methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
comments
	^comments
! !

!SToken methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
comments: aCollection
	aCollection isNil ifTrue: [^self].
	comments isNil
		ifTrue: [comments := aCollection]
		ifFalse: [comments addAll: aCollection]
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compileWarning: aString
	compiler notify: aString at: self stretch
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiler
	^compiler
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiler: aSmalltalkCompiler
	compiler := aSmalltalkCompiler
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
end
	^stretch end
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
end: aNumber
	stretch end: aNumber
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
endsExpression
	^self isEnd
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasSymbol
	^false
! !

!SToken methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	stretch := 1 thru: 0
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
is: anObject
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isAssignment
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isBar
	^(self is: #'|') or: [self is: #'/']
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isBlockNode
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isComment
	^false
! !

!SToken methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDelimitedIdentifier
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDelimiter
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isEnd
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isIdentifier
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isKeyword
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLiteral
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isNameToken
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isNumberNode
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isPoolLiteral
	^false
! !

!SToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isStringToken
	^false
! !

!SToken methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveCommentsTo: aParseNode
	aParseNode comments: comments.
	comments := nil
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
position
	^stretch start
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
position: aNumber
	stretch start: aNumber
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prevPosition
	^stretch start - 1
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
source
	^compiler sourceCode copyFrom: stretch start to: stretch end
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stretch
	^stretch
! !

!SToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stretch: aStretch
	stretch := aStretch
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken class
	instanceVariableNames: ''!


SToken initialize!

