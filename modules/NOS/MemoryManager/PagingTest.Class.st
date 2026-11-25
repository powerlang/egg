'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PagingTest category: 'SqueakNOS-Memory-Manager'!
TestCase subclass: #PagingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Memory-Manager'!
!PagingTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testCopyOnWriteHandling
	| memory manager directory pte pageTable pageTableAfterFault pteAfterFault |
	memory := Memory new size: 1048576. "1mb"
	manager := PageManager forMemory: memory.
	manager from: 0 to: 8192 useHandler: #copyOnWrite.
	directory := manager directory.
	pageTable := manager pageTableFor: 5000.
	pte := manager pageTableEntryFor: 5000.
	pte readOnly.
	manager resolvePageFaultOn: 5000.
	pageTableAfterFault := manager pageTableFor: 5000.
	pteAfterFault := manager pageTableEntryFor: 5000.	
	self deny: pageTable externalAddress = pageTableAfterFault externalAddress;
		 assert: (pageTable contentsFrom: 1 to: 4) = (pageTableAfterFault contentsFrom: 1 to: 4);
		assert: (pageTable contentsFrom: 9 to: 4096) = (pageTableAfterFault contentsFrom: 9 to: 4096);
		assert: pteAfterFault isPresentAndAllowed
! !

!PagingTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testDirectoryCloning
	| memory manager alienAddresses clone newAddresses |
	[
	memory := Memory new size: 10485760. "10mb" 
	manager := PageManager forMemory: memory.
	alienAddresses := manager directory entries collect: [:entry | entry pointedAddress].
	alienAddresses add: manager directory externalAddress. 
	clone := manager directory deepCopy.
	manager directory: clone.
	newAddresses := manager directory entries collect: [:entry | entry pointedAddress].
	self deny: (alienAddresses includes: manager directory externalAddress);
		 assert: (newAddresses noneSatisfy: [:address | alienAddresses includes: address]).
	16r0 to: 16rA00000 - 1 by: 1000 do: [:index | self assert: (manager translate: index) = index; assert: (manager isPresentAndAllowed: index)].
	] ensure: ["clone free"] 
	
! !

!PagingTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testIdentityTranslation
	| memory manager |
	memory := Memory new size: 104857600. "100mb"
	manager := PageManager forMemory: memory.
	16r0 to: 16r6400000 - 1 by: 413 do: [:index | self assert: (manager translate: index) = index; assert: (manager isPresentAndAllowed: index)].
! !

!PagingTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testPageIndexesPageAligned
	| memory manager addresses |
	memory := Memory new size: 200000000. "100mb"
	manager := PageManager forMemory: memory.
	addresses := manager directory entries collect: [:entry | entry pointedAddress].
	self assert: manager directory externalAddress \\ 4096 = 0;
	assert: (addresses allSatisfy: [:address | address \\ 4096 = 0])
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PagingTest class' category: 'SqueakNOS-Memory-Manager'!
PagingTest class
	instanceVariableNames: ''!


