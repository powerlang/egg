'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ZeroDivide category: #Kernel!
ArithmeticError subclass: #ZeroDivide
	instanceVariableNames: 'dividend'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ZeroDivide commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ZeroDivide methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
dividend
	^dividend
! !

!ZeroDivide methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
dividend: aNumber
	dividend := aNumber
! !

!ZeroDivide methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	description := 'Floating Point exception when trying to divide by zero'
! !

!ZeroDivide methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isResumable
	^true
! !

!ZeroDivide methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
operation: aSymbol
	super operation: aSymbol.
	description := aSymbol == #'/'
		ifTrue: ['Floating Point exception when trying to divide by zero']
		ifFalse: ['Divide by Zero exception in ''' , aSymbol , ''' operation']
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ZeroDivide class' category: #Kernel!
ZeroDivide class
	instanceVariableNames: ''!


ZeroDivide initialize!

