'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #Computer category: #'SqueakNOS-Kernel'!
Object subclass: #Computer
	instanceVariableNames: 'devices info processor memoryManager ramdisk primaryFilesystem'
	classVariableNames: 'Current PageFaultHandler Saving'
	poolDictionaries: ''
	category: 'SqueakNOS-Kernel'!
!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: aHardwareDevice named: aSymbol
	Transcript cr; show: aHardwareDevice printString, ' installed as ', aSymbol.
	^ devices at: aSymbol put: aHardwareDevice
! !

!Computer methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:25'!
diskFS
	| device |
	[ device := ATAController primary master.
	device information ]
		on: Error
		do: [ device := ATAController primary slave.
			device reset ].
	^ (FAT32FileSystem on: device primaryPartition) open
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
doesNotUnderstand: aMessage
	| selector |
	"it would be nice to compile the accessor the first time it's used"
	selector := aMessage selector.
	(aMessage arguments size = 1 and: [selector last = $:])
		ifTrue: [
			^ self add: aMessage arguments first
				named: selector allButLast asSymbol].

	^ devices at: aMessage selector ifAbsent: [
		super doesNotUnderstand: aMessage]

! !

!Computer methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:32:25'!
enablePaging
	memoryManager := PageManager forMemory: self memory using: processor.
	memoryManager installOn: self.
	
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
has: aSymbol
	^ devices includesKey: aSymbol
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
imageEndAddress
	^(KernelModule fromHandle: (ExternalAddress new fromInteger: info multiboot modsAddress)) end
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
imageStartAddress
	^(KernelModule fromHandle: (ExternalAddress new fromInteger: info multiboot modsAddress)) start
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
inPageFault
	^info inPageFault
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
inPageFault: anInteger
	info inPageFault: anInteger
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
info
	^info
! !

!Computer methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
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
! !

!Computer methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
initializeBridge
	info := VMBridge fromHandle: (ExternalAddress new fromInteger: self primVMBiosInformationPosition)
	
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
isSqueakNOS
	^ self class isSqueakNOS
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
kernelPageAt: anAddress
	^info snapshotInfo pageFor: anAddress
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memory
	^devices at: #memory
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memory: aMemory
	devices at: #memory put: aMemory
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memoryManager
	^memoryManager
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memoryManager: aMemoryManager
	memoryManager := aMemoryManager
! !

!Computer methodsFor:  'sources loading' stamp: 'KenD 28/Jun/2026 13:32:25'!
openSourceFiles
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
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pageFaultAddress
	^info pageFaultAddress
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primAllocationBetweenGCs: anInteger
	<primitive: 'primitiveSetAllocationBetweenGcs' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primDisableConsole
	<primitive: 'primitiveDisableConsole' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primEnableConsole
	<primitive: 'primitiveEnableConsole' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primEndOfVM
	<primitive: 'primitiveVMEndPosition' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primInPortByte: portNumber
	<primitive: 'primitiveInPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primMultibootInfoFromGrub
	<primitive: 'primitiveMultibootInfoFromGrub' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primOFWCallout: anArray
	<primitive: 'primitiveOFWCallout' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primOutPort: portNumber byte: byte
	<primitive: 'primitiveOutPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primRegisterSemaphoreIndex: t1 forIRQ: t2
	<primitive: 'primitiveRegisterSemaphoreIndexForIRQ' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
primShutDown
	<primitive: 'primitiveShutdown' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primVMBiosInformationPosition
	<primitive: 'primVMBiosInformationPosition' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!Computer methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:25'!
primaryFilesystem
	^ primaryFilesystem ifNil: [ primaryFilesystem := self diskFS ]
! !

!Computer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
processor
	^ processor
! !

!Computer methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:25'!
ramdiskFS
	| sectorSize boot record start partitionSize partition |
	sectorSize := 512.
	boot := MasterBootRecord on: (ramdisk copyFrom: 1 to: sectorSize).
	record := boot partitionRecord: 1.
	start := record offsetFromMBR * sectorSize +1.
	partitionSize := record numberOfSectors * sectorSize.
	partition := ramdisk segmentFrom: start size: partitionSize.
	^ (FAT32FileSystem on: partition) open
! !

!Computer methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
registerSemaphore: aSemaphore forIRQ: irqNumber
	| semaIndex |
	semaIndex := Smalltalk registerExternalObject: aSemaphore.
	^ self primRegisterSemaphoreIndex: semaIndex forIRQ: irqNumber
! !

!Computer methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
reset
	self keyboard controllerCommand: 16rF0.
	self keyboard controllerCommand: 16rD1; dataPort: 0.
! !

!Computer methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
resetSnapshotInfo
	self totalPageFaults: 0.
	info	 snapshotInfo saved: 0; toSave: 500; resetPages
	
! !

!Computer methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
setInitialMemoryState
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
	
		
	
! !

!Computer methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
setSnapshotEndAddress
	self snapshotEndAddress: self memory biggestEmptyBlock end.

! !

!Computer methodsFor:  'snapshotting' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotEndAddress
	^info snapshotEndAddress - Smalltalk headerSize.
! !

!Computer methodsFor:  'snapshotting' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotEndAddress: anInteger
	info snapshotEndAddress: anInteger
! !

!Computer methodsFor:  'snapshotting' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotStartAddress
	^info snapshotStartAddress
! !

!Computer methodsFor:  'snapshotting' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotStartAddress: anInteger
	info snapshotStartAddress: anInteger
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
totalPageFaults
	^info totalPageFaults
! !

!Computer methodsFor:  'image' stamp: 'KenD 28/Jun/2026 13:32:25'!
totalPageFaults: anInteger
	info totalPageFaults: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Computer class' category: #'SqueakNOS-Kernel'!
Computer class
	instanceVariableNames: 'Current PageFaultHandler Saving'!

!Computer class methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:25'!
blankBlockDeviceForTest
	^self isSqueakNOS
				ifTrue: [ self blankDiskOnRealDiskForTest ]
				ifFalse: [self blankDiskOnFileForTest ].
! !

!Computer class methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:25'!
blankDiskOnFileForTest
	^BlockDeviceOnStream on: (StandardFileStream fileNamed: './testdata/blank') blockSize: 512.
! !

!Computer class methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:25'!
blankDiskOnRealDiskForTest
	^ATAController secondary slave.
! !

!Computer class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
current
	^ Current
! !

!Computer class methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	SessionManager default 
		registerGuiClassNamed: self name
	
! !

!Computer class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isPharo
	^true

! !

!Computer class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isSqueakNOS
	^Smalltalk os platformName = 'SqueakNOS'

! !

!Computer class methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primPullDebugString
	<primitive: 'primitivePullDebugString' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer class methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primPushDebugString: aString
	<primitive: 'primitivePushDebugString' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!Computer class methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primRegisterSemaphoreIndex: t1 forIRQ: t2
	<primitive: 'primitiveRegisterSemaphoreIndexForIRQ' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!Computer class methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:32:25'!
show: aString
	self isSqueakNOS
	 ifTrue: [ self primPushDebugString: aString, String lf]
	 ifFalse: [ Transcript show: aString ]
! !

!Computer class methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:32:25'!
showCallTrace
	| stream |
	stream := '' writeStream.
	thisContext printDebugOn: stream.
	Transcript show: stream contents.

! !

!Computer class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
shutDown: quitting
	self isSqueakNOS ifTrue: [ 
		snapshotter := (ImageSnapshotter on: self current) prepareToWriteSnapshot.
		Saving := true.
	]
! !

!Computer class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
startUp: resuming
	self isSqueakNOS
		ifTrue: [
				resuming ifTrue: [
					Transcript cr; show: 'This is SqueakNOS!!!!!! :-)'; cr. 
					self startUpPCComputer
				] ifFalse: [
					snapshotter ifNotNil: [: s | s snapshot. snapshotter := nil] 
				]
		] ifFalse: [
			Transcript cr; show: 'This is not SqueakNOS!! :-('; cr.
		]
! !

!Computer class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
startUpPCComputer
	Current := self new.
	

! !

!Computer class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
tweakSqueakForSqueakNOS
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
! !


Computer initialize!

