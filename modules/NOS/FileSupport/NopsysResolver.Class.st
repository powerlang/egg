'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NopsysResolver category: 'SqueakNOS-FileSupport'!
PlatformResolver subclass: #NopsysResolver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-FileSupport'!
!NopsysResolver methodsFor:  'resolving' stamp: 'KenD 28/Jun/2026 13:32:25'!
resolve: anObject
	Computer showCallTrace.
	^nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NopsysResolver class' category: 'SqueakNOS-FileSupport'!
NopsysResolver class
	instanceVariableNames: ''!

!NopsysResolver class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
platformName
	^'SqueakNOS'
! !


