Class {
	#name : #Computer,
	#superclass : #Object,
	#instVars : [
		'devices',
		'info',
		'processor',
		'memoryManager',
		'ramdisk',
		'primaryFilesystem'
	],
	#classVars : [
		'Current',
		'PageFaultHandler',
		'Saving'
	],
	#classInstVars : [
		'snapshotter'
	],
	#category : #'SqueakNOS-Kernel'
}

{ #category : #filesystem }
Computer class >> blankBlockDeviceForTest [
	^self isSqueakNOS
				ifTrue: [ self blankDiskOnRealDiskForTest ]
				ifFalse: [self blankDiskOnFileForTest ].
]

{ #category : #filesystem }
Computer class >> blankDiskOnFileForTest [
	^BlockDeviceOnStream on: (StandardFileStream fileNamed: './testdata/blank') blockSize: 512.
]

{ #category : #filesystem }
Computer class >> blankDiskOnRealDiskForTest [
	^ATAController secondary slave.
]

{ #category : #accessing }
Computer class >> current [
	^ Current
]

{ #category : #primitives }
Computer class >> initialize [
	SessionManager default 
		registerGuiClassNamed: self name
	
]

{ #category : #testing }
Computer class >> isPharo [
	^true

]

{ #category : #testing }
Computer class >> isSqueakNOS [
	^Smalltalk os platformName = 'SqueakNOS'

]

{ #category : #primitives }
Computer class >> primPullDebugString [
	<primitive: 'primitivePullDebugString' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer class >> primPushDebugString: aString [
	<primitive: 'primitivePushDebugString' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer class >> primRegisterSemaphoreIndex: t1 forIRQ: t2 [ 
	<primitive: 'primitiveRegisterSemaphoreIndexForIRQ' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #debugging }
Computer class >> show: aString [ 
	self isSqueakNOS
	 ifTrue: [ self primPushDebugString: aString, String lf]
	 ifFalse: [ Transcript show: aString ]
]

{ #category : #debugging }
Computer class >> showCallTrace [
	| stream |
	stream := '' writeStream.
	thisContext printDebugOn: stream.
	Transcript show: stream contents.

]

{ #category : #'class initialization' }
Computer class >> shutDown: quitting [ 
	self isSqueakNOS ifTrue: [ 
		snapshotter := (ImageSnapshotter on: self current) prepareToWriteSnapshot.
		Saving := true.
	]
]

{ #category : #'class initialization' }
Computer class >> startUp: resuming [ 
	self isSqueakNOS
		ifTrue: [
				resuming ifTrue: [
					Transcript cr; show: 'This is SqueakNOS!!! :-)'; cr. 
					self startUpPCComputer
				] ifFalse: [
					snapshotter ifNotNil: [: s | s snapshot. snapshotter := nil] 
				]
		] ifFalse: [
			Transcript cr; show: 'This is not SqueakNOS! :-('; cr.
		]
]

{ #category : #'class initialization' }
Computer class >> startUpPCComputer [
	Current := self new.
	

]

{ #category : #'class initialization' }
Computer class >> tweakSqueakForSqueakNOS [
	EpSettings monitorEnabled: false.
	Smalltalk tools workspaceTool: Workspace.
	true
		ifFalse: [ | tmp2 |
			tmp2 := Smalltalk.
			tmp2
				removeFromStartUpList: #SecurityManager;
				removeFromStartUpList: #FileDirectory;
				removeFromShutDownList: #FileDirectory.
			#Debugger logDebuggerStackToFile: false ]
]

{ #category : #accessing }
Computer >> add: aHardwareDevice named: aSymbol [
	Transcript cr; show: aHardwareDevice printString, ' installed as ', aSymbol.
	^ devices at: aSymbol put: aHardwareDevice
]

{ #category : #filesystem }
Computer >> diskFS [
	| device |
	[ device := ATAController primary master.
	device information ]
		on: Error
		do: [ device := ATAController primary slave.
			device reset ].
	^ (FAT32FileSystem on: device primaryPartition) open
]

{ #category : #accessing }
Computer >> doesNotUnderstand: aMessage [
	| selector |
	"it would be nice to compile the accessor the first time it's used"
	selector := aMessage selector.
	(aMessage arguments size = 1 and: [selector last = $:])
		ifTrue: [
			^ self add: aMessage arguments first
				named: selector allButLast asSymbol].

	^ devices at: aMessage selector ifAbsent: [
		super doesNotUnderstand: aMessage]

]

{ #category : #memory }
Computer >> enablePaging [
	memoryManager := PageManager forMemory: self memory using: processor.
	memoryManager installOn: self.
	
]

{ #category : #accessing }
Computer >> has: aSymbol [
	^ devices includesKey: aSymbol
]

{ #category : #image }
Computer >> imageEndAddress [
	^(KernelModule fromHandle: (ExternalAddress new fromInteger: info multiboot modsAddress)) end
]

{ #category : #image }
Computer >> imageStartAddress [
	^(KernelModule fromHandle: (ExternalAddress new fromInteger: info multiboot modsAddress)) start
]

{ #category : #image }
Computer >> inPageFault [ 
	^info inPageFault
]

{ #category : #image }
Computer >> inPageFault: anInteger [
	info inPageFault: anInteger
]

{ #category : #accessing }
Computer >> info [
	^info
]

{ #category : #'initialize-release' }
Computer >> initialize [
	self currentWorld
		flash;
		fullRepaintNeeded.
	processor := X86Processor new.
	devices := Dictionary new.
	self class tweakSqueakForSqueakNOS.
	PIC8259 installOn: self.
	PCIBusEntry allValid
		do: [ :bus | "Transcript
				show: bus;
				cr;
				cr" ].
	"OldPCKeyboard installOn: Current. "
	PS2Keyboard installOn: self.
	"self defaultNetworkInterface: nil."
	"self initializeBridge."
	"Memory installOn: self."
	"self enablePaging."
	UART16550 installOn: self.
	CMOS installOn: self.
	"RemoteObjectChannel installOn: self."
	"LancePCIDevice installOn: self."
	self defaultNetworkInterface: nil.
	Realtek8139PCIDevice installOn: self.
	self defaultNetworkInterface
		ifNotNil: [ self networkingStack: (EthernetInterface on: self defaultNetworkInterface) ].
	"
	USBUHCIController installOn: self.
	SDDevice installOn: self."
	ATAController primary installOn: self.
	ramdisk := ByteArray new: 128 * 1024 * 1024.
	ATAController primary
		at: 1
		count: ramdisk size / 512
		of: 0
		into: ramdisk.
	primaryFilesystem := self ramdiskFS.
	self openSourceFiles.
	Display forceToScreen
	"(self confirm: 'Do you want to load sources from disk?') ifTrue: [self openSourceFiles]"
]

{ #category : #'initialize-release' }
Computer >> initializeBridge [
	info := VMBridge fromHandle: (ExternalAddress new fromInteger: self primVMBiosInformationPosition)
	
]

{ #category : #primitives }
Computer >> isSqueakNOS [
	^ self class isSqueakNOS
]

{ #category : #image }
Computer >> kernelPageAt: anAddress [
	^info snapshotInfo pageFor: anAddress
]

{ #category : #accessing }
Computer >> memory [
	^devices at: #memory
]

{ #category : #accessing }
Computer >> memory: aMemory [
	devices at: #memory put: aMemory
]

{ #category : #accessing }
Computer >> memoryManager [
	^memoryManager
]

{ #category : #accessing }
Computer >> memoryManager: aMemoryManager [
	memoryManager := aMemoryManager
]

{ #category : #'sources loading' }
Computer >> openSourceFiles [
	| filesystem directory source sources changes change |
	"Smalltalk imageName = SmalltalkImage lastImageName
		ifFalse: [SmalltalkImage lastImageName: Smalltalk imageName.
				Smalltalk isPharo ifTrue: [ Author fullName: '' ] ifFalse: [ Utilities setAuthorInitials: '' ] ]."
	filesystem := self primaryFilesystem.
	sources := filesystem pureFAT32FilenameFor: Smalltalk sourcesName.
	sources := sources copyFrom: 2 to: sources size.
	changes := filesystem pureFAT32FilenameFor: Smalltalk changesName.
	directory := filesystem root.
	(directory fileExists: sources)
		ifTrue: [ source := (directory readOnlyFileNamed: sources) readStream ].
	(directory fileExists: changes)
		ifTrue: [ change := (directory readOnlyFileNamed: changes) readWriteStream ].
	SourceFiles
		changesFileStream: change;
		sourcesFileStream: source
]

{ #category : #accessing }
Computer >> pageFaultAddress [ 
	^info pageFaultAddress
]

{ #category : #primitives }
Computer >> primAllocationBetweenGCs: anInteger [
	<primitive: 'primitiveSetAllocationBetweenGcs' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primDisableConsole [
	<primitive: 'primitiveDisableConsole' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primEnableConsole [
	<primitive: 'primitiveEnableConsole' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primEndOfVM [
	<primitive: 'primitiveVMEndPosition' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primInPortByte: portNumber [ 
	<primitive: 'primitiveInPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primMultibootInfoFromGrub [
	<primitive: 'primitiveMultibootInfoFromGrub' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primOFWCallout: anArray [ 
	<primitive: 'primitiveOFWCallout' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primOutPort: portNumber byte: byte [ 
	<primitive: 'primitiveOutPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primRegisterSemaphoreIndex: t1 forIRQ: t2 [ 
	<primitive: 'primitiveRegisterSemaphoreIndexForIRQ' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #image }
Computer >> primShutDown [
	<primitive: 'primitiveShutdown' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #primitives }
Computer >> primVMBiosInformationPosition [
	<primitive: 'primVMBiosInformationPosition' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #filesystem }
Computer >> primaryFilesystem [
	^ primaryFilesystem ifNil: [ primaryFilesystem := self diskFS ]
]

{ #category : #accessing }
Computer >> processor [
	^ processor
]

{ #category : #filesystem }
Computer >> ramdiskFS [
	| sectorSize boot record start partitionSize partition |
	sectorSize := 512.
	boot := MasterBootRecord on: (ramdisk copyFrom: 1 to: sectorSize).
	record := boot partitionRecord: 1.
	start := record offsetFromMBR * sectorSize +1.
	partitionSize := record numberOfSectors * sectorSize.
	partition := ramdisk segmentFrom: start size: partitionSize.
	^ (FAT32FileSystem on: partition) open
]

{ #category : #primitives }
Computer >> registerSemaphore: aSemaphore forIRQ: irqNumber [ 
	| semaIndex |
	semaIndex := Smalltalk registerExternalObject: aSemaphore.
	^ self primRegisterSemaphoreIndex: semaIndex forIRQ: irqNumber
]

{ #category : #'initialize-release' }
Computer >> reset [
	self keyboard controllerCommand: 16rF0.
	self keyboard controllerCommand: 16rD1; dataPort: 0.
]

{ #category : #'initialize-release' }
Computer >> resetSnapshotInfo [
	self totalPageFaults: 0.
	info	 snapshotInfo saved: 0; toSave: 500; resetPages
	
]

{ #category : #'initialize-release' }
Computer >> setInitialMemoryState [
	| image multiboot map |
	multiboot := info multiboot.
	multiboot areModulesValid ifTrue: [image := KernelModule fromHandle: (ExternalAddress new fromInteger: multiboot modsAddress)].
	multiboot areMemoryAddressesValid ifTrue: [self memory size: info multiboot memUpper + 1024 * 1024].
	"multiboot isMemoryMapValid ifTrue: [
		map := MultiBootMemoryMap fromHandle: (ExternalAddress new fromInteger: multiboot mmapAddress) size: multiboot mmapLength.
		map do: [:entry | | base | entry type = 1 ifFalse: [base := entry baseAddress. self memory alreadyReserved: (base to: base + entry length) for: 'Reserved']]
	]".
	self memory 
		alreadyReserved: (0 to: 1048575) for: 'First mega of low memory for bios, drivers, etc.';
		alreadyReserved: (1048576 to: self primEndOfVM) for: 'Virtual Machine code and data structures';
		alreadyReserved: (image start to: image end) for: 'Object memory (image)'.
	
		
	
]

{ #category : #'class initialization' }
Computer >> setSnapshotEndAddress [
	self snapshotEndAddress: self memory biggestEmptyBlock end.

]

{ #category : #snapshotting }
Computer >> snapshotEndAddress [
	^info snapshotEndAddress - Smalltalk headerSize.
]

{ #category : #snapshotting }
Computer >> snapshotEndAddress: anInteger [
	info snapshotEndAddress: anInteger
]

{ #category : #snapshotting }
Computer >> snapshotStartAddress [
	^info snapshotStartAddress
]

{ #category : #snapshotting }
Computer >> snapshotStartAddress: anInteger [
	info snapshotStartAddress: anInteger
]

{ #category : #image }
Computer >> totalPageFaults [
	^info totalPageFaults
]

{ #category : #image }
Computer >> totalPageFaults: anInteger [
	info totalPageFaults: anInteger
]
