'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ArithmeticError category: #Kernel!
Error subclass: #ArithmeticError
	instanceVariableNames: 'operation type'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ArithmeticError commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ArithmeticError methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
getDescription
	| string |
	string := self typeDescription.
	operation notNil
		ifTrue: [string := string , ' in ''' , operation , ''' operation'].
	^string
! !

!ArithmeticError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
operation: aSymbol
	operation := aSymbol
! !

!ArithmeticError methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: self class name; space.
	type notNil ifTrue: [type printOn: aStream]
! !

!ArithmeticError methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalCoprocessorMissing
	^self type: #coprocessor; signal
! !

!ArithmeticError methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalDenormalized
	^self type: #denormalized; signal
! !

!ArithmeticError methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalInexactOperation
	^self type: #inexact; signal
! !

!ArithmeticError methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalInvalidOperation
	^self type: #invalid; signal
! !

!ArithmeticError methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalOverflow
	^self type: #overflow; signal
! !

!ArithmeticError methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalUndefined
	^self type: #undefined; signal
! !

!ArithmeticError methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalUnderflow
	^FloatUnderflow signal
! !

!ArithmeticError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
type
	^type
! !

!ArithmeticError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
type: aSymbol
	type := aSymbol.
	description := self getDescription
! !

!ArithmeticError methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
typeDescription
	type == #overflow ifTrue: [^'Floating Point overflow exception'].
	type == #underflow ifTrue: [^'Floating Point underflow exception'].
	type == #denormalized ifTrue: [^'Floating Point denormalized operand'].
	type == #invalid ifTrue: [^'Floating Point invalid operation exception'].
	type == #undefined ifTrue: [^'Floating Point undefined exception'].
	type == #inexact ifTrue: [^'Floating Point inexact result'].
	type == #coprocessor ifTrue: [^'Math coprocessor missing'].
	^type printString , ' invalid type symbol'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ArithmeticError class' category: #Kernel!
ArithmeticError class
	instanceVariableNames: ''!

!ArithmeticError class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aSymbol
	^self new operation: aSymbol
! !


