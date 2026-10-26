'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #SSelectorNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SSelectorNode
	instanceVariableNames: 'symbol keywords'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SSelectorNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:41'!
acceptVisitor: visitor
	^visitor visitSelector: self
! !

!SSelectorNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
addKeyword: aSelectorNode
	keywords isNil ifTrue: [keywords := OrderedCollection new: 1].
	keywords add: aSelectorNode
! !

!SSelectorNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
end
	stretch end ifNotNil: [:e | ^e].
	^keywords notNil ifTrue: [keywords last end]
! !

!SSelectorNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
hasSymbol
	^symbol isSymbol
! !

!SSelectorNode methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:41'!
isBinary
	^symbol isBinary
! !

!SSelectorNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isSelector
	^true
! !

!SSelectorNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
keywords
	^keywords isNil ifTrue: [{self}] ifFalse: [keywords]
! !

!SSelectorNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
positions
	^self keywords collect: [:node | node position]
! !

!SSelectorNode methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:41'!
symbol
	^symbol
! !

!SSelectorNode methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:41'!
symbol: aString
	symbol := aString asSymbol
! !

!SSelectorNode methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:41'!
value
	^symbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSelectorNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSelectorNode class
	instanceVariableNames: ''!


