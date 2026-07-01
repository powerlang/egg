'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SAssignment category: 'Powerlang-Core-SExpressions'!
SExpression subclass: #SAssignment
	instanceVariableNames: 'assignees expression'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SAssignment methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^visitor visitAssignment: self
! !

!SAssignment methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: anSIdentifier
	assignees add: anSIdentifier
! !

!SAssignment methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
assignees
	^assignees
! !

!SAssignment methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
expression
	^expression
! !

!SAssignment methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
expression: anSExpression
	expression := anSExpression
! !

!SAssignment methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	assignees := OrderedCollection new
! !

!SAssignment methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isAssignment
	^true
! !

!SAssignment methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPutAll: '{AssignmentId.'.
	assignees
		do: [:identifier | 
			aStream cr.
			identifier printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '.'].
	aStream nextPutAll: '.'; cr.
	expression printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '}'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SAssignment class' category: 'Powerlang-Core-SExpressions'!
SAssignment class
	instanceVariableNames: ''!

!SAssignment class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeAssignment
! !

!SAssignment class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !


SAssignment initialize!

