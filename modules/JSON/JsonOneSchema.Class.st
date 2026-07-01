'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonOneSchema category: #JSON!
JsonCombinedSchema subclass: #JsonOneSchema
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonOneSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonOneSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isOneSchema
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonOneSchema class' category: #JSON!
JsonOneSchema class
	instanceVariableNames: ''!

!JsonOneSchema class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
typeName
	^'oneOf'
! !


