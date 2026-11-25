'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ExceptionSet category: #Kernel!
Object subclass: #ExceptionSet
	instanceVariableNames: 'exceptions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ExceptionSet commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ExceptionSet methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
, aClass
	(exceptions includes: aClass) ifTrue: [^self].
	^self class with: aClass withAll: exceptions
! !

!ExceptionSet methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: aClass
	^exceptions add: aClass
! !

!ExceptionSet methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAll: classesCollection
	exceptions addAll: classesCollection
! !

!ExceptionSet methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
includesException: anException
	^exceptions anySatisfy: [:class | class includesException: anException]
! !

!ExceptionSet methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	exceptions := Set new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExceptionSet class' category: #Kernel!
ExceptionSet class
	instanceVariableNames: ''!

!ExceptionSet class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aClass
	^self new add: aClass
! !

!ExceptionSet class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aClass with: bClass
	^self new add: aClass; add: bClass; yourself
! !

!ExceptionSet class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aClass withAll: classesCollection
	^self new add: aClass; addAll: classesCollection; yourself
! !


ExceptionSet initialize!

