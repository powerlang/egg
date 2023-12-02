Class {
	#name : #PagingTest,
	#superclass : #TestCase,
	#category : 'SqueakNOS-Memory-Manager'
}

{ #category : #'as yet unclassified' }
PagingTest >> testCopyOnWriteHandling [
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
]

{ #category : #'as yet unclassified' }
PagingTest >> testDirectoryCloning [
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
	
]

{ #category : #'as yet unclassified' }
PagingTest >> testIdentityTranslation [
	| memory manager |
	memory := Memory new size: 104857600. "100mb"
	manager := PageManager forMemory: memory.
	16r0 to: 16r6400000 - 1 by: 413 do: [:index | self assert: (manager translate: index) = index; assert: (manager isPresentAndAllowed: index)].
]

{ #category : #'as yet unclassified' }
PagingTest >> testPageIndexesPageAligned [
	| memory manager addresses |
	memory := Memory new size: 200000000. "100mb"
	manager := PageManager forMemory: memory.
	addresses := manager directory entries collect: [:entry | entry pointedAddress].
	self assert: manager directory externalAddress \\ 4096 = 0;
	assert: (addresses allSatisfy: [:address | address \\ 4096 = 0])
]
