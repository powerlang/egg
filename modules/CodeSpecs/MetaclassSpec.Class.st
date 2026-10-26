'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #MetaclassSpec category: #CodeSpecs!
SpeciesSpec subclass: #MetaclassSpec
	instanceVariableNames: 'class'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodeSpecs'!
!MetaclassSpec commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!MetaclassSpec methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
allSuperclassesDo: aBlock
	| s c |
	class supername isNil ifTrue: [
		c := module resolveClass: 'Class'.
		c ifNil: [c := Class].
		c allSuperclassesDo: aBlock].
	s := self superclass.
	s isNil ifTrue: [^self].
	aBlock value: s.
	s allSuperclassesDo: aBlock
! !

!MetaclassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
classVarNames
	^class classVarNames
! !

!MetaclassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instanceClass
	^class
! !

!MetaclassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instanceClass: aClassSpec
	class := aClassSpec
! !

!MetaclassSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMetaclass
	^true
! !

!MetaclassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
metaMethods
	^#()
! !

!MetaclassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^class name , ' class'
! !

!MetaclassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
sharedPools
	^class sharedPools
! !

!MetaclassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
superclass
	^class superclass ifNotNil: [:c | c metaclass]
! !

!MetaclassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
supername
	^self superclass name
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MetaclassSpec class' category: #CodeSpecs!
MetaclassSpec class
	instanceVariableNames: ''!


