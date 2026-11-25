'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #SymbolAdaptor category: #JSON!
DataAdaptor subclass: #SymbolAdaptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!SymbolAdaptor commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!SymbolAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: aString
	^aString asSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SymbolAdaptor class' category: #JSON!
SymbolAdaptor class
	instanceVariableNames: ''!


