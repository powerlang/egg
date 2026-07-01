'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #SDDevice category: 'SqueakNOS-Devices-USB'!
PCIDevice subclass: #SDDevice
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-USB'!
!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
blockSizeRegister
	^self shortAt: 16r04
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
canIssueCommand
	^(self testPresentStateBit: 0) not
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
canIssueDATCommand
	^(self testPresentStateBit: 1) not
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
canWriteData
	^self testPresentStateBit: 10
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
capabilitiesRegister
	^self longAt: 16r40
! !

!SDDevice methodsFor:  'low level' stamp: 'KenD 28/Jun/2026 13:32:24'!
cardDetectPinLevel
	^(self testPresentStateBit: 18) ifTrue: [1] ifFalse: [0]
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
checkCardPresent
	self isCardInserted
		ifTrue: [self report: 'card inserted']
		ifFalse: [self report: 'card removed'].
! !

!SDDevice methodsFor:  'clearing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearCardInsertionInterrupt
	self setInterruptStatusBit:6
! !

!SDDevice methodsFor:  'clearing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearCardRemovalInterrupt
	self setInterruptStatusBit: 7
! !

!SDDevice methodsFor:  'clearing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearCommandCompleteInterrupt
	self setInterruptStatusBit: 0
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
clockControlRegister
	^ self shortAt: 16r2C
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableBlockGapInterrupt
	self setInterruptEnableBit: 2
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableBufferReadyInterrupt
	self setInterruptEnableBit: 5
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableBufferWriteReadyInterrupt
	self setInterruptEnableBit: 4
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCardInsertionInterrupt
	self setInterruptEnableBit: 6; enableCardInsertionInterruptStatus
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCardInsertionInterruptStatus
	self setInterruptStatusEnableBit: 6
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCardInterrupt
	self setInterruptEnableBit: 8; enableCardInterruptStatus
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCardInterruptStatus
	self setInterruptStatusEnableBit: 8
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCardRemovalInterrupt
	self setInterruptEnableBit: 7; enableCardRemovalInterruptStatus
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCardRemovalInterruptStatus
	self setInterruptStatusEnableBit: 7
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCommandCompleteInterrupt
	self setInterruptEnableBit: 0; enableCommandCompleteInterruptStatus
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCommandCompleteInterruptStatus
	self setInterruptStatusEnableBit: 0
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableDMAInterrupt
	self setInterruptEnableBit: 3
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableErrorInterrupt
	self setErrorInterruptEnableBit: 0;
		setErrorInterruptEnableBit: 1;
		setErrorInterruptEnableBit: 2;
		setErrorInterruptEnableBit: 3;
		setErrorInterruptEnableBit: 4;
		setErrorInterruptEnableBit: 5;
		setErrorInterruptStatusEnableBit: 1;
		setErrorInterruptStatusEnableBit: 2;
		setErrorInterruptStatusEnableBit: 3;
		setErrorInterruptStatusEnableBit: 4;
		setErrorInterruptStatusEnableBit: 5
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableInterrupts
	self enableCardRemovalInterrupt; 
		enableCardInsertionInterrupt; 
		enableCommandCompleteInterrupt;
		enableErrorInterrupt
! !

!SDDevice methodsFor:  'enabling interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableTransferCompleteInterrupt
	self setInterruptEnableBit: 1
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
errorInterruptEnableRegister
	^self shortAt: 16r3A
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
errorInterruptStatus
	^self shortAt: 16r32
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
errorInterruptStatusEnableRegister
	^self shortAt: 16r36
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
getCardID
	| answer address arg |
	address := self getRelativeAddress.
	arg := address bitShift: 16.
	answer := self sendCommand: 10 with: arg.
	^answer bitAnd: 16rFFFF
	
SDCommands
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
getRelativeAddress
	| answer |
	answer := self sendCommand: 3.
	answer bitShift: -16.
	^answer bitAnd: 16rFFFF
! !

!SDDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleIRQ
	self hasCardRemovalInterrupt ifTrue: [
		self clearCardRemovalInterrupt.
		self checkCardPresent].
	self hasCardInsertionInterrupt ifTrue: [
		self clearCardInsertionInterrupt.
		self checkCardPresent].
	self hasCommandCompleteInterrupt ifTrue: [
		self clearCommandCompleteInterrupt].
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasBlockGapInterrupt
	^self testInterruptStatusBit: 2
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasBufferReadReadyInterrupt
	^self testInterruptStatusBit: 5
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasBufferWriteReadyInterrupt
	^self testInterruptStatusBit: 4
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasCardInsertionInterrupt
	^self testInterruptStatusBit: 6
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasCardRemovalInterrupt
	^self testInterruptStatusBit: 7
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasCommandCompleteInterrupt
	^self testInterruptStatusBit: 0
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasDMAInterrupt
	^self testInterruptStatusBit: 3
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasErrorInterrupt
	^self testInterruptStatusBit: 15
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasReadableData
	^self testPresentStateBit: 11
! !

!SDDevice methodsFor:  'testing interrupts' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasTransferCompleteInterrupt
	^self testInterruptStatusBit: 1
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptEnableRegister
	^self shortAt: 16r38
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptStatus
	^self shortAt: 16r30
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptStatusEnableRegister
	^self shortAt: 16r34
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isCardInserted
	^self testPresentStateBit: 16
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isCardPresent
	^self testPresentStateBit: 18
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isDATLineActive
	^self testPresentStateBit: 2
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isReadingData
	^self testPresentStateBit: 9
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isStateStable
	^self testPresentStateBit: 17
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isWriteProtected
	^(self testPresentStateBit: 19) not
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isWritingData
	^self testPresentStateBit: 8
! !

!SDDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
lineSignalLevel
	^self testPresentStateBit: 24
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
presentState
	^self longAt: 16r24
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
readResponse
	| answer |
	answer := self responseRegister
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
reportStatus
! !

!SDDevice methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
responseRegister
	^self longAt: 16r10
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
sendCommand: c
	self sendCommand: c with: 0
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
sendCommand: c with: arg
	self
		waitForCommandSendAllowed;
		waitForDATCommandAllowed;
		longAt: 16r08 put: arg;
		shortAt: 16r0E put: (c bitShift: 8);
		waitForCommandComplete;
		readResponse
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
setClockControlRegisterBit: bit
	| register |
	register := self clockControlRegister.
	register := register bitOr: (1 bitShift: bit).
	self shortAt: 16r2C put: register
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
setErrorInterruptEnableBit: bit
	| register |
	register := self errorInterruptEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r3A put: register
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
setErrorInterruptStatusEnableBit: bit
	| register |
	register := self errorInterruptStatusEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r36 put: register
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
setInterruptEnableBit: bit
	| register |
	register := self interruptEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r38 put: register
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
setInterruptStatusBit: bit
	| register |
	register := self interruptStatus.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r30 put: register
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
setInterruptStatusEnableBit: bit
	| register |
	register := self interruptStatusEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r34 put: register
! !

!SDDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
supportsHighSpeed
	^self testCapabilitiesBit: 21
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
testCapabilitiesBit: bit
	^self capacilitiesRegister anyMask: (1 bitShift: bit)
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
testErrorInterruptStatusBit: bit
	^self errorInterruptStatus anyMask: (1 bitShift: bit)
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
testInterruptStatusBit: bit
	^self interruptStatus anyMask: (1 bitShift: bit)
! !

!SDDevice methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
testPresentStateBit: bit
	^self presentState anyMask: (1 bitShift: bit)
! !

!SDDevice methodsFor:  'serivices' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitFor: aBlock
	aBlock whileFalse
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitForCommandComplete
	self waitFor: [self hasCommandCompleteInterrupt]
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitForCommandSendAllowed
	self waitFor: [self canIssueCommand]
! !

!SDDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitForDATCommandAllowed
	self waitFor: [self canIssueDATCommand]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SDDevice class' category: 'SqueakNOS-Devices-USB'!
SDDevice class
	instanceVariableNames: ''!

!SDDevice class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
deviceId
	^2082
! !

!SDDevice class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	self initializeSDCommands
! !

!SDDevice class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeSDCommands
	SDCommands := Dictionary new
		at: 'SendCSD' put: 8;
		at: 'SendCID' put: 10;
		at: 'SendRelativeAddress' put: 3;
		yourself
! !

!SDDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	| card |
	card := super installOn: aComputer.
	card ifNil: [^ nil].
	card enableInterrupts.
	aComputer sdCard: card.
	^card
! !

!SDDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
onPCIEntry: aPCIBusEntry
	^self atMemoryAddress: aPCIBusEntry allMemoryRanges first key.

! !

!SDDevice class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
vendorId
	^4480
! !


SDDevice initialize!

