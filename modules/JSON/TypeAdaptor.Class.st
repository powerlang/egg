'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #TypeAdaptor category: #JSON!
DataAdaptor subclass: #TypeAdaptor
	instanceVariableNames: 'classes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!TypeAdaptor commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!TypeAdaptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
classes: aCollection
	classes := aCollection asDictionaryUsing: #name
! !

!TypeAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
dataFrom: aClass
	^(classes includes: aClass) ifTrue: [aClass name]
! !

!TypeAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectClasses
	^classes
! !

!TypeAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: aString
	^classes at: aString ifAbsent: nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TypeAdaptor class' category: #JSON!
TypeAdaptor class
	instanceVariableNames: ''!

!TypeAdaptor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
of: class
	^self new classes: {class}! !

!TypeAdaptor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
restrictedTo: classes
	^self new classes: classes
! !


