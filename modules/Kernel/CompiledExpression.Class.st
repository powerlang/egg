'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #CompiledExpression category: #Kernel!
CompiledMethod subclass: #CompiledExpression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!CompiledExpression commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!CompiledExpression methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
currentVersion
	^self
! !

!CompiledExpression methodsFor:  'evaluation' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluate
	^self executeOn: nil
! !

!CompiledExpression methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDoit
	^self selector == #doit
! !

!CompiledExpression methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isExpression
	^true
! !

!CompiledExpression methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector
	^selector ifNil: [#doit]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CompiledExpression class' category: #Kernel!
CompiledExpression class
	instanceVariableNames: ''!


