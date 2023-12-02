"
First reference is this:

http://www.repairfaq.org/filipg/LINK/F_IDE-tech.html

But it contains some errors/simplifications, particularly about LBA addressing, so I recomend
reading this too:

http://www.t13.org/Documents/UploadedDocuments/project/d0791r4c-ATA-1.pdf

ATA Specification defines a set of registers that are used to communicate with a hard disk controller. Each controller controls at most two hard disks: a master and a slave. Most
commands issued in these registers apply to the controller's selected disk (master or slave).

+----+------+------+---+---+---+----------------+---------------+
|Addr|-CS1FX|-CS3FX|SA2|SA1|SA0| Read (-IOR)    | Write (-IOW)  |
+----+------+------+---+---+---+----------------+---------------+-----------+
|    |  0   |  0   | X | X | X | ILLEGAL        | ILLEGAL       | <--+      |
|    |  1   |  1   | X | X | X | High Impedance | Not Used      | Control   |
|3FX |  1   |  0   | 0 | X | X | High Impedance | Not Used      | Block     |
|3FX |  1   |  0   | 1 | 0 | X | High Impedance | Not Used      | Registers |
|3F6 |  1   |  0   | 1 | 1 | 0 | Altern Status  | Device Control|    |      |
|3F7 |  1   |  0   | 1 | 1 | 1 | Drive Address  | Not Used      | <--+      |
+----+------+------+---+---+---+----------------+---------------+-----------+
|1F0 |  0   |  1   | 0 | 0 | 0 | Data Port      | Data Port     | <--+      |
|1F1 |  0   |  1   | 0 | 0 | 1 | Error Register | Features       |    |      |
|1F2 |  0   |  1   | 0 | 1 | 0 | Sector Count   | Sector Count  | Command   |
|1F3 |  0   |  1   | 0 | 1 | 1 | Sector Number  | Sector Number | Block     |
|1F4 |  0   |  1   | 1 | 0 | 0 | Cylinder Low   | Cylinder Low  | Registers |
|1F5 |  0   |  1   | 1 | 0 | 1 | Cylinder High  | Cylinder High |    |      |
|1F6 |  0   |  1   | 1 | 1 | 0 | Drive / Head   | Drive / Head  |    |      |
|1F7 |  0   |  1   | 1 | 1 | 1 | Status         | Command       | <--+      |
+----+------+------+---+---+---+----------------+---------------+-----------+

1F0: Read/Write: DATA PORT REGISTER
1F1: Read: ERROR REGISTER
1F1: Write: FEATURES
1F2: Read/Write: SECTOR COUNT REGISTER
1F3: Read/Write: SECTOR NUMBER REGISTER
1F4: Read/Write: CYLINDER LOW REGISTER
1F5: Read/Write: CYLINDER HIGH REGISTER
1F6: Read/Write: DRIVE/HEAD REGISTER (rrrDHHHH)
1F7: Read: STATUS REGISTER
1F7: Write: COMMAND REGISTER

	mov     dx,1f6h         ;Drive and head port
	mov     al,0a0h         ;Drive 0, head 0
	out     dx,al

	mov     dx,1f2h         ;Sector count port
	mov     al,1            ;Read one sector
	out     dx,al

	mov     dx,1f3h         ;Sector number port
	mov     al,1            ;Read sector one
	out     dx,al

	mov     dx,1f4h         ;Cylinder low port
	mov     al,0            ;Cylinder 0
	out     dx,al

	mov     dx,1f5h         ;Cylinder high port
	mov     al,0            ;The rest of the cylinder 0
	out     dx,al

	mov     dx,1f7h         ;Command port
	mov     al,20h          ;Read with retry.
	out     dx,al
still_going:
	in      al,dx
	test    al,8            ;This means the sector buffer requires
"
Class {
	#name : #ATAController,
	#superclass : #PCIDevice,
	#instVars : [
		'control',
		'busMaster',
		'buffer',
		'done',
		'busy',
		'transferReady',
		'transferReadyBool',
		'interruptController',
		'bytes'
	],
	#classVars : [
		'primary',
		'secondary'
	],
	#category : 'SqueakNOS-Devices-Storage'
}

{ #category : #'as yet unclassified' }
ATAController class >> findPCIBusEntry [
	
	"IDE controller have a PCI classID = 1 (Mass storage device) and subclass 1 (IDE Mass storage device)."
	
	^PCIBusEntry allValid detect: [ :entry | entry classCode = 1 and: [entry classSubCode = 1]] ifNone: [^nil].
]

{ #category : #'instance creation' }
ATAController class >> onPort: portNumber [
	^ (super onPort: portNumber) initializeControlBlock; initializeBusMaster
]

{ #category : #'as yet unclassified' }
ATAController class >> primary [
	primary ifNil: [ primary := self onPort: 16r1F0 ].
	^primary.
]

{ #category : #'as yet unclassified' }
ATAController class >> secondary [
	secondary ifNil: [ secondary := self onPort: 16r170 ].
	^secondary.
]

{ #category : #services }
ATAController >> at2: startSector count: sectorCount of: deviceNumber [
	| remaining alreadyRead nextBlockNumber |
	"The max we can read is 256 sectors (thats an ATA limit). If we want to read more, we do it by grabing chunks of 256 sectors until we finish."
	"Transcript show: 'Reading from: ', firstBlockNumber asString, ' to: ', lastBlockNumber asString, Character cr asString."
	"self halt."
	remaining := sectorCount.
	alreadyRead := 0.
	nextBlockNumber := startSector - 1.
	[ remaining > 0 ]
		whileTrue: [ | chunkSize |
			chunkSize := remaining min: 256.
			self
				issueReadFrom: nextBlockNumber
				count: chunkSize
				device: deviceNumber
				timeout: self readMillisecondsTimeout.
			nextBlockNumber := nextBlockNumber + chunkSize.
			alreadyRead := alreadyRead + 256.
			remaining := remaining - 256 ].
]

{ #category : #services }
ATAController >> at: startSector count: sectorCount of: deviceNumber [

		| answer |
	answer := ByteArray new: sectorCount * self sectorSize.
		self at: startSector count: sectorCount of: deviceNumber into: answer.
		^answer

]

{ #category : #services }
ATAController >> at: startSector count: sectorCount of: deviceNumber into: answer [
	| remaining alreadyRead nextBlockNumber start size |
	"The max we can read is 256 sectors (thats an ATA limit). If we want to read more, we do it by grabing chunks of 256 sectors until we finish."
	"Transcript show: 'Reading from: ', firstBlockNumber asString, ' to: ', lastBlockNumber asString, Character cr asString."
	"self halt."
	answer unsignedLongAt: 1 put: 16r55AA66BB.
	remaining := sectorCount.
	alreadyRead := 0.
	nextBlockNumber := startSector - 1.
	[ remaining > 0 ]
		whileTrue: [ | chunkSize |
			chunkSize := remaining min: 256.
			start := self byteOffsetOfBlock: alreadyRead + 1.
			size := chunkSize * self blockSize.
			self
						issueReadFrom: nextBlockNumber
						count: chunkSize
						device: deviceNumber
						timeout: self readMillisecondsTimeout.
			buffer fillInto: answer at: start size: size.
			nextBlockNumber := nextBlockNumber + chunkSize.
			alreadyRead := alreadyRead + 256.
			remaining := remaining - 256 ].
	^ answer
]

{ #category : #services }
ATAController >> at: firstSectorNumber of: aDeviceNumber putAll: aByteArray [
	| nextSectorNumber |
	nextSectorNumber := firstSectorNumber - 1. "Decrement 1 because block num comes 1-based and LBA indexes are 0-based"
	self groupsOfMax: 256 * 512 atATimeIn: aByteArray do: [ :sectorContents |
		self
			issueWrite: sectorContents
			at: nextSectorNumber
			device: aDeviceNumber
			timeout: self writeMillisecondsTimeout.
			nextSectorNumber := nextSectorNumber + 256.
	].


	

]

{ #category : #registers }
ATAController >> atAlternateStatusReg [
	^ control uByteAtOffset: 0
]

{ #category : #registers }
ATAController >> atCommandRegPut: aSmallInteger [
	"When the host request a command it is transferred to the hard drive through an eight bit code written to the command register. As soon as the drive receives a command in its command register, it begins execution of the command. The following table lists the commands in alphabetical order and the parameters for each executable command:"

	^ self byteAt: 7 put: aSmallInteger
	
	"
	+--------+---------------------------------+-----------------+
	| Command| Command Description             | Parameters Used 
	| Code   |                                 | PC SC SN CY DH  
	+--------+---------------------------------+-----------------+
	| 98h  @ | Check Power Mode                |    V        D   
	| E5h  @ | Check Power Mode (same as 98h)  |    V        D   
	| 90h    | Execute Drive Diagnostic        |             D+  
	| 50h    | Format Track                    |          V  V   
	| ECh  @ | Identify Drive                  |             D   
	| 97h  @ | Idle                            |    V        D   
	| E3h  @ | Idle (same as 97h)              |    V        D   
	| 95h  @ | Idle Immediate                  |             D   
	| E1h  @ | Idle Immadiate (same as 95h)    |             D   
	| 91h    | Initialize Drive Parameters     |    V        V   
	| E4h  @ | Read Buffer                     |             D   
	| C8h  @ | Read DMA With Retry             |  >> Unknown <<  
	| C9h  @ | Read DMA                        |  >> Unknown <<  
	| C4h  @ | Read Multiple                   |    V  V  V  V   
	| 20h    | Read Sectors With Retry         |    V  V  V  V   
	| 21h    | Read Sectors                    |    V  V  V  V   
	| 22h    | Read Long With Retry            |    V  V  V  V   
	| 23h    | Read Long                       |    V  V  V  V   
	| 40h    | Read Verify Sectors With Retry  |    V  V  V  V   
	| 41h    | Read Verify Sectors             |    V  V  V  V   
	| 1Xh    | Recalibrate                     |             D   
	| 7Xh    | Seek                            |          V  V   
	| EFh  @ | Set Features                    |  V          D   
	| C6h  @ | Set Multiple Mode               |    V        D   
	| 99h  @ | Set Sleep Mode                  |             D   
	| E6h  @ | Set Sleep Mode (same as 99h)    |             D   
	| 96h  @ | Standby                         |    V        D   
	| E2h  @ | Standby (same as 96h)           |    V        D   
	| 94h  @ | Standby Immediate               |             D   
	| E0h  @ | Standby Immediate (same as 94h) |             D   
	| 8Xh    | Vendor Unique                   |  >> Unknown <<  
	| 9Ah    | Vendor Unique                   |  >> Unknown <<  
	| C0h    | Vendor Unique                   |  >> Unknown <<  
	| C1h    | Vendor Unique                   |  >> Unknown <<  
	| C2h    | Vendor Unique                   |  >> Unknown <<  
	| C3h    | Vendor Unique                   |  >> Unknown <<  
	| F5h    | Vendor Unique                   |  >> Unknown <<  
	| F6h    | Vendor Unique                   |  >> Unknown <<  
	| F7h    | Vendor Unique                   |  >> Unknown <<  
	| F8h    | Vendor Unique                   |  >> Unknown <<  
	| F9h    | Vendor Unique                   |  >> Unknown <<  
	| FAh    | Vendor Unique                   |  >> Unknown <<  
	| FBh    | Vendor Unique                   |  >> Unknown <<  
	| FCh    | Vendor Unique                   |  >> Unknown <<  
	| FDh    | Vendor Unique                   |  >> Unknown <<  
	| FEh    | Vendor Unique                   |  >> Unknown <<  
	| FFh    | Vendor Unique                   |  >> Unknown <<  
	| E8h  @ | Write Buffer                    |             D   
	| CAh  @ | Write DMA With Retry            |  >> Unknown <<  
	| CBh  @ | Write DMA                       |  >> Unknown <<  
	| C5h  @ | Write Multiple                  |    V  V  V  V   
	| E9h  @ | Write Same                      |  >> Unknown <<  
	| 30h    | Write Sectors With Retry        |    V  V  V  V   
	| 31h    | Write Sectors                   |    V  V  V  V   
	| 32h    | Write Long With Retry           |    V  V  V  V   
	| 33h    | Write Long                      |    V  V  V  V   
	| 3Ch  @ | Write Verify                    |    V  V  V  V   
	+--------+---------------------------------+-----------------+
	"
]

{ #category : #registers }
ATAController >> atCylinderHighReg [
	^ self byteAt: 5
]

{ #category : #registers }
ATAController >> atCylinderHighRegPut: aSmallInteger [
	^ self byteAt: 5 put: aSmallInteger
]

{ #category : #registers }
ATAController >> atCylinderLowReg [
	^ self byteAt: 4
]

{ #category : #registers }
ATAController >> atCylinderLowRegPut: aSmallInteger [
	^ self byteAt: 4 put: aSmallInteger
]

{ #category : #registers }
ATAController >> atDataPortRegRead: anAmount [
	"Read amount of shorts from data register."
	^ self shortStringAt: 0 size: anAmount.
]

{ #category : #registers }
ATAController >> atDataPortRegWrite: aString [
	^ self shortStringAt: 0 put: aString
]

{ #category : #registers }
ATAController >> atDeviceControRegPut: anInteger [
	^ control uByteAtOffset: 0 + 1put: anInteger
]

{ #category : #registers }
ATAController >> atDriveHeadReg [
	"Drive/Head head register, Offset 6, 8 bits.
	 This register contains the drive and head numbers. The contents of this
	 register define the number of heads minus 1, when executing an Initialize
	 Drive Parameters command.
	
	 Upon command completion this register is updated to refplect the head number currently
	 selected.
	"

	^ self byteAt: 6.
	
	"
	+-----------------------------------------+
	| 7 | 6  | 5 |  4   |   3  |   2  |  1  |  0  |
	|---+---+---+-----+-----+-----+-----+-----|
	| 1 | L | 1 | DRV | HS3 | HS2 | HS1 | HS0 |
	+-----------------------------------------+

	- L is the binary encoded address mode select. When L=0, addressing is
	by CHS mode. When L=1, addressing is by LBA mode.
	- DRV is the binary encoded drive select number. When DRV-0, Drive 0 is
	selected. When DRV=1, Drive 1 is selected.
	- If L=0, HS3 through HS0 contain the binary coded address of the head to
	be selected e.g., if HS3 through HS0 are 0011b, respectively, head 3
	will be selected. HS3 is the most significant bit. At command
	completion, these bits are updated to reflect the currently selected
	head.
	- If L=1, HS3 through HS0 contain bits 24-27 of the LBA. At command
	completion, these bits are updated to reflect the current LBA bits
	24-27.
	"
]

{ #category : #registers }
ATAController >> atDriveHeadRegPut: aValue [
	"Drive/Head head register, Offset 6, 8 bits.
	 This register contains the drive and head numbers. The contents of this
	 register define the number of heads minus 1, when executing an Initialize
	 Drive Parameters command.
	
	 Upon command completion this register is updated to refplect the head number currently
	 selected.
	"
	^ self byteAt: 6 put: aValue.
	
	"
	+-----------------------------------------+
	| 7 | 6  | 5 |  4   |   3  |   2  |  1  |  0  |
	|---+---+---+-----+-----+-----+-----+-----|
	| 1 | L | 1 | DRV | HS3 | HS2 | HS1 | HS0 |
	+-----------------------------------------+

	- L is the binary encoded address mode select. When L=0, addressing is
	by CHS mode. When L=1, addressing is by LBA mode.
	- DRV is the binary encoded drive select number. When DRV-0, Drive 0 is
	selected. When DRV=1, Drive 1 is selected.
	- If L=0, HS3 through HS0 contain the binary coded address of the head to
	be selected e.g., if HS3 through HS0 are 0011b, respectively, head 3
	will be selected. HS3 is the most significant bit. At command
	completion, these bits are updated to reflect the currently selected
	head.
	- If L=1, HS3 through HS0 contain bits 24-27 of the LBA. At command
	completion, these bits are updated to reflect the current LBA bits
	24-27.
	"
	
]

{ #category : #registers }
ATAController >> atSectorNumberReg [
	^ self byteAt: 3
]

{ #category : #registers }
ATAController >> atSectorNumberRegPut: aSmallInteger [
	^ self byteAt: 3 put: aSmallInteger
]

{ #category : #registers }
ATAController >> atStatusReg [
	"Contains information about the status of the drive and controller. The contents of
	 this register are updated at the completion of each command. When the busy bit
	 is set, no other bits in the Command Block Registers are valid. When the busy bit
	 is not set, the information in the Status Register and Command Block Registers is valid."
	
	^ self byteAt: 7
	
	"
	+-----+----------+----------------------------------------------------------+
	| BIT | Mnemonic | Description                                              
	+-----+----------+----------------------------------------------------------+
	|  7  |  BUSY    | Busy bit. Set by the controller logic of the drive when  
	|     |          | ever the drive has access to and the host is locked out 
	|     |          | of the Command Block Registers. Set under the following  
	|     |          | conditions:                                              
	|     |          |  o Within 400 nsec after the negation of RESET or after  
	|     |          |    SRST is set in the Device Control Register. After a   
	|     |          |    reset it is recomended that BUSY be set no more than  
	|     |          |    30 seconds.                                           
	|     |          |  o Within 400 nsec of a host write to the Command        
	|     |          |    Register with a Recalibrate, Read Long, Read Buffer,  
	|     |          |    Read, Read Verify, Initialize Drive Parameters, Seek  
	|     |          |    Identify Drive, or Execute Drive Diagnostic command.  
	|     |          |  o Within 5 microseconds following the transfer of 512   
	|     |          |    bytes of data during the execution of a Write, Write  
	|     |          |    Buffer or Format Track command; or 512 bytes of data  
	|     |          |    and the appropriate number of ECC bytes during the    
	|     |          |    execution of a Write Long command.                    
	|     |          |    When BUSY is set no Command Block Register can be     
	|     |          |    written too and a read of any Command Block Register  
	|     |          |    returns the contents of the Status Register.          
	|     |          |                                                          
	|  6  |  DRDY    | Drive Ready bit. Indicates that the drive is ready to    
	|     |          | accept commands. When and error occurs, this bit stays   
	|     |          | unchanged until the host reads the Status Register then  
	|     |          | again indicates that hte drive is ready. On power up,    
	|     |          | this bit should be cleared and should remain cleared     
	|     |          | until the drive is up to speed and ready to accept a     
	|     |          | command.                                                 
	|     |          |                                                          
	|  5  |  DWF     | Drive Write Fault bit. When an error occurs, this bit    
	|     |          | remains unchanged until the host reads the Status        
	|     |          | Register, then again indicates the current write fault   
	|     |          | status.                                                  
	|     |          |                                                          
	|  4  |  DSC     | Drive Seek Complete bit. This bit is set when a seek     
	|     |          | operation is complete and the heads are settled over a   
	|     |          | track. When an error occurs, this bit remains unchanged  
	|     |          | until the host reads the Status Register, then again it  
	|     |          | indicates the current seek complete status.              
	|     |          |                                                          
	|  3  |  DRQ     | Data Request bit. When set it indicates that the drive   
	|     |          | is ready to transfer a word or byte of data between the  
	|     |          | host and the data port.                                  
	|     |          |                                                          
	|  2  |  CORR    | Corrected Data bit. When a correctable data error has    
	|     |          | been encountered and the data has been corrected, this   
	|     |          | bit is set. This condition does not terminate a multi    
	|     |          | sector read operation.                                   
	|     |          |                                                          
	|  1  |  INDEX   | Index bit. Set when the index mark is detected once per  
	|     |          | disk revolution.                                         
	|     |          |                                                          
	|  0  |  ERROR   | Error bit. When set indicates that the previous command  
	|     |          | ended in an error. The other bits in the Error Register  
	|     |          | and Status Register contain additional information about 
	|     |          | the cause of the error.                                  
	+-----+----------+----------------------------------------------------------+
	"
]

{ #category : #accessing }
ATAController >> blockSize [
	^512
]

{ #category : #'status/testing' }
ATAController >> busy: aStatus [
	^ aStatus anyMask: 128.
]

{ #category : #private }
ATAController >> byteOffsetOfBlock: aBlockNumber [
	"Returns the position of the first byte of the block"
	^ aBlockNumber - 1 * self blockSize + 1.
]

{ #category : #commands }
ATAController >> cmdDeviceReset [
	^ self atCommandRegPut: 16r08
]

{ #category : #commands }
ATAController >> cmdIdentifyDevice [
	^ self atCommandRegPut: 16rEC
]

{ #category : #commands }
ATAController >> cmdReadSectors [
	^ self atCommandRegPut: 16r21
]

{ #category : #commands }
ATAController >> cmdReadSectorsDMA [
	^ self atCommandRegPut: 16rC9
]

{ #category : #commands }
ATAController >> cmdReadSectorsDMAWithRetry [
	^ self atCommandRegPut: 16rC8
]

{ #category : #commands }
ATAController >> cmdReadSectorsWithRetry [
	^ self atCommandRegPut: 16r20
]

{ #category : #commands }
ATAController >> cmdWriteSectorsWithRetry [
	^ self atCommandRegPut: 16r30
]

{ #category : #services }
ATAController >> consumeUselessInterrupt [
	self atStatusReg.
	transferReadyBool := false
	"transferReady wait."
]

{ #category : #registers }
ATAController >> control [
	^control
]

{ #category : #'status/testing' }
ATAController >> dataReady: aStatus [
	^ aStatus anyMask: 8.
]

{ #category : #registers }
ATAController >> disableInterrupts [
	^ self atDeviceControRegPut: 2r00000010
]

{ #category : #services }
ATAController >> doReadSectors: sectorCount [
	| result |
	result := self
		cmdReadSectors;
		readAllAvailable: sectorCount.
	self reenableIRQsAndCheckForErrors.
	^result
	
		
]

{ #category : #services }
ATAController >> doReadSectorsDMA: sectorCount [
	| size offset |
	size := sectorCount * self sectorSize.
	self cmdReadSectorsDMAWithRetry.
	offset := busMaster offset.
	busMaster
		setupTransferOf: size with: buffer;
		issueRead.
	self waitUntilTransferIsReady.
	busMaster
		stopTransfer;
		resetDescriptorTable.
	self reenableIRQsAndCheckForErrors.
	^buffer
]

{ #category : #'status/testing' }
ATAController >> driveReady: aStatus [
	^ aStatus anyMask: 64.
]

{ #category : #registers }
ATAController >> enableInterrupts [
	^ self atDeviceControRegPut: 0
]

{ #category : #'status/testing' }
ATAController >> errorOccurred: aStatus [
	^ aStatus anyMask: 1.
]

{ #category : #'status/testing' }
ATAController >> errorsDidntOccur: aStatus [
	^ aStatus noMask: 1.
]

{ #category : #services }
ATAController >> from: firstSectorNumber to: lastSectorNumber device: aDeviceNumber [
	^ self at: firstSectorNumber count: lastSectorNumber - firstSectorNumber + 1 of: aDeviceNumber.
]

{ #category : #private }
ATAController >> groupsOf: n atATimeIn: aByteArray do: aBlock [ 
	"Evaluate aBlock with my elements taken n at a time. Ignore any leftovers at the end. Taken from SequenceableCollection but highly optimized."
	| args |
	args := ByteArray new: n.
	n to: aByteArray size by: n do: [:index |
		args replaceFrom: 1
			 to: n
			 with: aByteArray
			 startingAt: index - n + 1.
		aBlock value: args.
	]

]

{ #category : #private }
ATAController >> groupsOfMax: n atATimeIn: aByteArray do: aBlock [
	"Evaluate aBlock with my elements taken n at a time. Also evaluate with leftover elements at end"
	| leftover |
	leftover := aByteArray size \\ n.
	n
		to: aByteArray size
		by: n
		do: [:index | 
			| args |
			args := (aByteArray copyFrom: index - n + 1 to: index).
			aBlock value: args
		].
	
	(leftover > 0) ifTrue: [
		aBlock value: (aByteArray copyFrom: aByteArray size - leftover + 1 to: aByteArray size)
	].


]

{ #category : #registers }
ATAController >> handleIRQ [
	"Transcript show: 'disk irq!'."

	transferReady signal.
	transferReadyBool := true.
]

{ #category : #initialization }
ATAController >> initialize [
	"buffer size is large enough to handle largest ata read, which is
	 256 sectors (128kb) and also aligned to 64kb for dma requirements"

	bytes := ByteArray new: 128 * 1024.
	buffer := ExternalAddress allocate: 64 * 3 * 1024.
	buffer fromInteger: (buffer asInteger alignedTo: 64 * 1024).
	transferReady := Semaphore new.
	transferReadyBool := false.
	busy := Semaphore forMutualExclusion
]

{ #category : #initialization }
ATAController >> initializeBusMaster [
	| entry port |
	entry := self class findPCIBusEntry.
	entry enableBusMastering.
	port := entry baseIOAddress: 4.
	busMaster := PCIBusMaster onPort: port function: entry


]

{ #category : #initialization }
ATAController >> initializeControlBlock [
	| port isPrimary |
	isPrimary := resource asInteger = 16r1F0.
	port := isPrimary
		ifTrue: [ 16r3F6 ]
		ifFalse: [ 16r376 ].
	control := ExternalIOPort address: port.
	self
		selectDrive: 0;
		resetController;
		enableInterrupts;
		selectDrive: 1;
		enableInterrupts;
		selectDrive: 0
]

{ #category : #services }
ATAController >> installOn: aComputer [
	aComputer interruptController addHandler: self forIRQ: 14.
]

{ #category : #services }
ATAController >> issueReadFrom: firstSector count: sectorCount device: deviceNumber timeout: timeout [
	^ self
		waitUntilNotBusyOr: timeout;
		selectSector: firstSector ofDrive: deviceNumber;
		regSectorCount: sectorCount;
		waitUntilReadyOr: timeout;
		doReadSectorsDMA: sectorCount
]

{ #category : #services }
ATAController >> issueWrite: aByteArray at: firstSector device: deviceNumber timeout: aTimeout [
	"Transcript show: 'going to write ', aByteArray size printString, ' bytes: ', aByteArray asString printString, ' at: ', firstSector printString, '
	'."
	self waitUntilNotBusyOr: aTimeout;
		selectSector: firstSector ofDrive: deviceNumber;
		regSectorCount: aByteArray size // 512;
		waitUntilReadyOr: aTimeout;
		cmdWriteSectorsWithRetry;
		writeAllAvailable: aByteArray.

	

]

{ #category : #initialization }
ATAController >> lock [
	busy wait
]

{ #category : #'device creation' }
ATAController >> master [
	^ATADevice controlledBy: self device: 0.
]

{ #category : #'status/testing' }
ATAController >> moreDataIsAvailable [
	"We should remove this method, it does the same than waitUntilDataTransferIsReady"
	| status time |
	time := 0.
	[status := self atAlternateStatusReg. (self busy: status) & (self errorsDidntOccur: status) and: [ time < 10 ]] whileTrue:
		[time := time + 1. 50000 timesRepeat: [1+1]. "(Delay forMilliseconds: 1) wait" ]..
	(self errorOccurred: status) ifTrue: [self error: 'An error occurred while reading'].
	time >= 10 ifTrue: [Transcript show: 'Read timeout. Status: ', status, Character cr ].
	"tells wheter data port contains more data available. This happens if:"
	 ^ (self dataReady: status)" & (self errorsDidntOccur: status)".
]

{ #category : #private }
ATAController >> readAllAvailable [
	| answer |
	answer := ''.
	[ self waitUntilDeviceIsReadyForTransfer ] whileTrue: [ answer := answer , self readSector ].
	answer = ''
		ifTrue: [ Transcript show: 'Status: ' , self atAlternateStatusReg asString , String cr.
			self error: 'Could not read anything.' ].
	^ answer
]

{ #category : #private }
ATAController >> readAllAvailable: sectorCount [
	| each answer nextPosition |
	each := self sectorSize.
	answer := ByteArray new: sectorCount * each.
	nextPosition := 1.
	sectorCount timesRepeat: [ 
			self waitUntilDeviceIsReadyForTransfer.
			answer
				replaceFrom: nextPosition
				to: nextPosition + self sectorSize - 1
				with: self readSector
				startingAt: 1.
			nextPosition := nextPosition + each ].
	^ answer
]

{ #category : #private }
ATAController >> readMillisecondsTimeout [
	"Max amount of milliseconds to wait for ready status when trying to read a sector"
	^5000
]

{ #category : #accessing }
ATAController >> readSector [
	^ self atDataPortRegRead: 512
]

{ #category : #services }
ATAController >> reenableIRQsAndCheckForErrors [
	| status |
	status := self atStatusReg.
	(self errorOccurred: status) ifTrue:  [ self error: 'An error ocurred while transfering data' ]
]

{ #category : #registers }
ATAController >> regError [
	^ self byteAt: 1
]

{ #category : #registers }
ATAController >> regErrorClear [
	^ self byteAt: 1 put: 0
]

{ #category : #registers }
ATAController >> regSectorCount [
	^ self byteAt: 2
]

{ #category : #registers }
ATAController >> regSectorCount: aSmallInteger [
	"We handle special case when we want to read 256 sectors, which is done by puting a 0 in
	 sector count register"
	aSmallInteger = 256 ifTrue: [^ self byteAt: 2 put: 0].
	^ self byteAt: 2 put: aSmallInteger
]

{ #category : #initialization }
ATAController >> release [
	busy signal
]

{ #category : #registers }
ATAController >> resetController [
	^ self atDeviceControRegPut: 2r100
]

{ #category : #accessing }
ATAController >> resetDevice: aDriveNumber [
	^self
		selectDrive: aDriveNumber;
		cmdDeviceReset
]

{ #category : #registers }
ATAController >> sectorNumber [
	^ self byteAt: 3
]

{ #category : #registers }
ATAController >> sectorNumber: aSmallInteger [
	^ self byteAt: 3 put: aSmallInteger
]

{ #category : #registers }
ATAController >> sectorSize [
	^512
]

{ #category : #accessing }
ATAController >> selectDrive: aDriveNumber [
	"Select master or slave (aDriveNumber is 0 or 1 respectively). See 
	 atDriveHeadRegPut for more details"
	^ self atDriveHeadRegPut: aDriveNumber << 4.
]

{ #category : #accessing }
ATAController >> selectHead: aHeadNumber ofDevice: aDeviceNumber [
	"select head of drive. See atDriveHeadRegPut: for more details."
	^ self atDriveHeadRegPut: aDeviceNumber << 4 + aHeadNumber.
]

{ #category : #accessing }
ATAController >> selectSector: lbaAddress ofDrive: aDriveNumber [
	"LBA Addressing: 28 bits. 
	<4 bits: head> < 8 bits: cyl high> <8 bits: cyl low> <8 bits: sector>
	We add 4 to drive number so that the bit of LBA addressing mode is asserted inside selectHead.
	"

	| sector cylLow cylHigh head |
	sector := lbaAddress bitAnd: 16rFF.
	cylLow := (lbaAddress bitShift: -8) bitAnd: 16rFF.
	cylHigh := (lbaAddress bitShift: -16) bitAnd: 16rFF.
	head := (lbaAddress bitShift: -24) bitAnd: 16rF.
	self
		selectHead: head ofDevice: aDriveNumber + 4;
		regErrorClear;
		atSectorNumberRegPut: sector;
		atCylinderLowRegPut: cylLow;
		atCylinderHighRegPut: cylHigh
]

{ #category : #'status/testing' }
ATAController >> selectedDevice [
	^ self atDriveHeadReg >> 4 bitAnd: 1.
]

{ #category : #'status/testing' }
ATAController >> selectedHead [
	^ (self shortAt: 6) bitAnd: 2r1111
]

{ #category : #'device creation' }
ATAController >> slave [
	^ATADevice controlledBy: self device: 1.
]

{ #category : #private }
ATAController >> wait400ns [
	self
		atAlternateStatusReg;
		atAlternateStatusReg;
		atAlternateStatusReg;
		atAlternateStatusReg
]

{ #category : #'status/testing' }
ATAController >> waitUntilDeviceIsReadyForTransfer [
	| status |
	[ status := self atAlternateStatusReg.
	(self busy: status) & (self errorsDidntOccur: status) ] whileTrue.
	(self errorOccurred: status)
		ifTrue: [ self error: 'An error occurred while preparing transfer' ].
	^ self dataReady: status
]

{ #category : #services }
ATAController >> waitUntilNotBusyOr: maxMilliseconds [
	| time status |
	time := Time millisecondClockValue.
	
	[ status := self atStatusReg. (self busy: status) and: [ Time millisecondClockValue - time < maxMilliseconds ] ] whileTrue.
	"Time millisecondClockValue - time >= maxMilliseconds ifTrue: [Transcript show: 'Not busy timeout. Status: ', status, Character cr ]."
]

{ #category : #services }
ATAController >> waitUntilReadyOr: maxMilliseconds [
	| time status |
	time := Time millisecondClockValue.
	
	[ status := self atAlternateStatusReg. (self driveReady: status) not and: [ Time millisecondClockValue - time < maxMilliseconds ] ] whileTrue.
	
	"Time millisecondClockValue - time >= maxMilliseconds ifTrue: [Transcript show: 'Ready timeout. Status: ', status, Character cr ]."
]

{ #category : #services }
ATAController >> waitUntilTransferIsReady [
	| status |
	[ status := self atAlternateStatusReg.
	(self busy: status)
		ifFalse: [ 
			(self errorOccurred: status)
				ifTrue: [ 'An error occurred during transfer' ] ].
	transferReadyBool ] whileFalse.
	transferReadyBool := false.
	"transferReady wait."
	"self waitUntilNotBusyOr: 1000."
]

{ #category : #private }
ATAController >> writeAllAvailable: aByteArray [
	self groupsOf: 512 atATimeIn: aByteArray do: [ :sectorContents |
		self waitUntilDeviceIsReadyForTransfer.
		self atDataPortRegWrite: sectorContents.
	].

]

{ #category : #accessing }
ATAController >> writeDataOld: source fromByte: sourceOffset atByteOffset: destOffset bytesCount: count on: aDriveNumber [
	"Write count bytes from source starting at startIndex bytes. We handle half sector
	 overwriting. Should be optimized so it doesn't write intermediate sectors (which will
	 be completely overwritten)."
	| data sector sectorCount startOffset |
	sector := self offsetToSector: destOffset.
	sectorCount := (self offsetToSector: count) + 1.
	data := self
		regSectorCount: sectorCount;
		selectSector: sector ofDrive: aDriveNumber;
		cmdReadSectorsWithRetry;
		readAllAvailable.
	startOffset := destOffset \\ 512 + 1.
	data
		replaceFrom: startOffset
		to: startOffset + count - 1
		with: source
		startingAt: sourceOffset.
		
	self
		regSectorCount: sectorCount;
		selectSector: sector ofDrive: aDriveNumber;
		cmdWriteSectorsWithRetry;
		atDataPortRegWrite: data.
		
	^count.
]

{ #category : #private }
ATAController >> writeMillisecondsTimeout [
	"Max amount of milliseconds to wait for ready status when trying to read a sector"
	^5000
]

{ #category : #registers }
ATAController >> writePrecompensation: aSmallInteger [
	^ self shortAt: 1 put: aSmallInteger
]
