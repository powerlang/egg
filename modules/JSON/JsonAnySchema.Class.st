'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonAnySchema category: #JSON!
JsonCombinedSchema subclass: #JsonAnySchema
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonAnySchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonAnySchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isAnySchema
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonAnySchema class' category: #JSON!
JsonAnySchema class
	instanceVariableNames: ''!

!JsonAnySchema class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
typeName
	^'anyOf'
! !


