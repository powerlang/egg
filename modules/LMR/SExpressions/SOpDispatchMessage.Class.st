'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpDispatchMessage category: 'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpDispatchMessage
	instanceVariableNames: 'message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpDispatchMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpDispatchMessage: self
! !

!SOpDispatchMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
message
	^ message
! !

!SOpDispatchMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
message: anSMessage
	message := anSMessage
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpDispatchMessage class' category: 'Powerlang-Core-SExpressions'!
SOpDispatchMessage class
	instanceVariableNames: ''!


