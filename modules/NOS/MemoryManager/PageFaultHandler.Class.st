'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageFaultHandler category: 'SqueakNOS-Memory-Manager'!
Object subclass: #PageFaultHandler
	instanceVariableNames: 'manager handlingBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Memory-Manager'!
!PageFaultHandler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultHandlingBlock
	^[ :anAddress :handler | | directoryEntry pageEntry |
		self halt.
		directoryEntry := manager pageDirectoryEntryFor: anAddress.
		directoryEntry isPresentAndAllowed ifFalse: [directoryEntry setPresentAndWritable].
		pageEntry := manager pageTableEntryFor: anAddress.
		pageEntry isPresentAndAllowed 
			ifFalse: [pageEntry setPresentAndWritable]
			ifTrue: [self error: 'Why did this page faulted?']
	]
	
! !

!PageFaultHandler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
doDefaultHandlingFor: anAddress
	self defaultHandlingBlock value: anAddress value: self

	
! !

!PageFaultHandler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
handlingBlock
	^ handlingBlock
! !

!PageFaultHandler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
handlingBlock: aHandlingBlock
	handlingBlock := aHandlingBlock

! !

!PageFaultHandler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	handlingBlock := self defaultHandlingBlock.
! !

!PageFaultHandler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
manager: aMemoryManagerStrategy
	manager := aMemoryManagerStrategy
! !

!PageFaultHandler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
resolvePageFaultOn: anAddress
	handlingBlock value: anAddress value: self.
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageFaultHandler class' category: 'SqueakNOS-Memory-Manager'!
PageFaultHandler class
	instanceVariableNames: ''!


PageFaultHandler initialize!

