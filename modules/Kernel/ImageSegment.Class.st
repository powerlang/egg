'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ImageSegment category: #Kernel!
Object subclass: #ImageSegment
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ImageSegment commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!ImageSegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name
	^name
! !

!ImageSegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name: aString
	name := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ImageSegment class' category: #Kernel!
ImageSegment class
	instanceVariableNames: ''!

!ImageSegment class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
load: filename
	"TO BE IMPLEMENTED!!"
	^nil
! !


