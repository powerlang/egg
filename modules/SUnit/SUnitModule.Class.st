'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #SUnitModule category: #SUnit!
Module subclass: #SUnitModule
	instanceVariableNames: 'random'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!SUnitModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(Bag CharacterArray Class Closure CompiledExpression CompiledMethod Error Exception ExceptionHandler IdentitySet Notification Species Symbol).
		#Random -> #(Random)
	}
! !

!SUnitModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	super initialize.
! !

!SUnitModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
random
	^random ifNil: [ random := Random new]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SUnitModule class' category: #SUnit!
SUnitModule class
	instanceVariableNames: ''!


SUnitModule initialize!

