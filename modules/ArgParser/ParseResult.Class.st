'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ParseResult category: #ArgParser!
Object subclass: #ParseResult
	instanceVariableNames: 'command positionals options'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArgParser'!
!ParseResult commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addPositional: aString
	positionals add: aString
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
command
	^command
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
command: aString
	command := aString
! !

!ParseResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasOption: aString
	^options includesKey: aString
! !

!ParseResult methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	positionals := OrderedCollection new.
	options := OrderedDictionary new
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
optionAt: aString
	^options at: aString ifAbsent: [nil]
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
optionAt: aString ifAbsent: aBlock
	^options at: aString ifAbsent: aBlock
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
options
	^options
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
positionalAt: anInteger
	^positionals at: anInteger
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
positionals
	^positionals
! !

!ParseResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
setOption: aString to: aValue
	options at: aString put: aValue
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ParseResult class' category: #ArgParser!
ParseResult class
	instanceVariableNames: ''!


ParseResult initialize!

