'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #MemoryManagerStrategy category: #'SqueakNOS-Memory-Manager'!
Object subclass: #MemoryManagerStrategy
	instanceVariableNames: 'memory processor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Memory-Manager'!
!MemoryManagerStrategy methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
memory
	^memory
! !

!MemoryManagerStrategy methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
memory: aMemory
	memory  := aMemory
! !

!MemoryManagerStrategy methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
processor
	^processor
! !

!MemoryManagerStrategy methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
processor: aProcessor
	processor := aProcessor.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MemoryManagerStrategy class' category: #'SqueakNOS-Memory-Manager'!
MemoryManagerStrategy class
	instanceVariableNames: ''!

!MemoryManagerStrategy class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
forMemory: aMemory
	^self new memory: aMemory; identityMapping 
! !

!MemoryManagerStrategy class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
forMemory: aMemory using: aProcessor
	^self new memory: aMemory; processor: aProcessor; identityMapping 
! !


