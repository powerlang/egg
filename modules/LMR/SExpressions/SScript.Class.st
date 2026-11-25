'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SScript category: 'Powerlang-Core-SExpressions'!
SExpression subclass: #SScript
	instanceVariableNames: 'statements compiledCode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentCount
	^compiledCode argumentCount
! !

!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
compiledCode
	^compiledCode
! !

!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
compiledCode: anObject
	compiledCode := anObject
! !

!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	statements := #()
! !

!SScript methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
optimizedCode: anObject
	^ self compiledCode optimizedCode: anObject
! !

!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	statements
		do: [:statement | statement printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '.'; cr]
! !

!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
statements
	^statements
! !

!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
statements: aCollection
	statements := aCollection
! !

!SScript methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
tempCount
	^compiledCode tempCount
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SScript class' category: 'Powerlang-Core-SExpressions'!
SScript class
	instanceVariableNames: ''!

!SScript class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !


SScript initialize!

