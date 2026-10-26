'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #Assembly category: #'Powerlang-Core-Assembly-Intel-Parser'!
Object subclass: #Assembly
	instanceVariableNames: 'labels instructions source parser'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Parser'!
!Assembly commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!Assembly methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	labels := Dictionary new.
	instructions := OrderedCollection new.
	parser := AssemblerParser new
! !

!Assembly methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
parse
	| everything |
	everything := parser parse: source.
	everything do: [:token | 
		token isString
			ifTrue: [labels at: token allButLast put: instructions size]
			ifFalse: [instructions add: token]]
! !

!Assembly methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
parser: anAssemblerParser
	parser := anAssemblerParser
! !

!Assembly methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
source: aString
	source := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Assembly class' category: #'Powerlang-Core-Assembly-Intel-Parser'!
Assembly class
	instanceVariableNames: ''!

!Assembly class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
new
	^super new initialize
! !

!Assembly class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
on: aString
	^self new source: aString
! !


Assembly initialize!

