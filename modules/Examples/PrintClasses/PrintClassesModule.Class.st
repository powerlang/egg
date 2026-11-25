'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PrintClassesModule category: #'Examples-PrintClasses'!
Module subclass: #PrintClassesModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Examples-PrintClasses'!
!PrintClassesModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{}
! !

!PrintClassesModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
printAClass: aClass indent: indentCount
	| aString |
	indentCount timesRepeat: [
		Kernel log: '    '.
	].
	Kernel log: aClass printString, String cr.
	aClass subclassesDo: [ :sub | self printAClass: sub indent: indentCount + 1 ].
! !

!PrintClassesModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
main: arguments
	Kernel log: 'Current Local Classes', String cr.
	self printAClass: Object class indent: 0.
	^0
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PrintClassesModule class' category: #'Examples-PrintClasses'!
PrintClassesModule class
	instanceVariableNames: ''!


