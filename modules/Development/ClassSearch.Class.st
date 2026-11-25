'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #ClassSearch category: #Development!
CodeSearch subclass: #ClassSearch
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!ClassSearch commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!ClassSearch methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
search
	self reset.
	Kernel namespace keysAndValuesDo: [:name :global | 
		(global isClass and: [self includes: name])
			ifTrue: [results add: (CodeSearchResult class: global)]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ClassSearch class' category: #Development!
ClassSearch class
	instanceVariableNames: ''!


