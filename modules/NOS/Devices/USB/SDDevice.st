Class {
	#name : #SDDevice,
	#superclass : #PCIDevice,
	#category : #'SqueakNOS-Devices-USB'
}

{ #category : #accessing }
SDDevice class >> deviceId [
	^2082
]

{ #category : #'class initialization' }
SDDevice class >> initialize [
	super initialize.
	self initializeSDCommands
]

{ #category : #'class initialization' }
SDDevice class >> initializeSDCommands [
	SDCommands := Dictionary new
		at: 'SendCSD' put: 8;
		at: 'SendCID' put: 10;
		at: 'SendRelativeAddress' put: 3;
		yourself
]

{ #category : #'instance creation' }
SDDevice class >> installOn: aComputer [
	| card |
	card := super installOn: aComputer.
	card ifNil: [^ nil].
	card enableInterrupts.
	aComputer sdCard: card.
	^card
]

{ #category : #'instance creation' }
SDDevice class >> onPCIEntry: aPCIBusEntry [
	^self atMemoryAddress: aPCIBusEntry allMemoryRanges first key.

]

{ #category : #accessing }
SDDevice class >> vendorId [
	^4480
]

{ #category : #registers }
SDDevice >> blockSizeRegister [
	^self shortAt: 16r04
]

{ #category : #testing }
SDDevice >> canIssueCommand [
	^(self testPresentStateBit: 0) not
]

{ #category : #testing }
SDDevice >> canIssueDATCommand [
	^(self testPresentStateBit: 1) not
]

{ #category : #testing }
SDDevice >> canWriteData [
	^self testPresentStateBit: 10
]

{ #category : #registers }
SDDevice >> capabilitiesRegister [
	^self longAt: 16r40
]

{ #category : #'low level' }
SDDevice >> cardDetectPinLevel [
	^(self testPresentStateBit: 18) ifTrue: [1] ifFalse: [0]
]

{ #category : #private }
SDDevice >> checkCardPresent [
	self isCardInserted
		ifTrue: [self report: 'card inserted']
		ifFalse: [self report: 'card removed'].
]

{ #category : #'clearing interrupts' }
SDDevice >> clearCardInsertionInterrupt [
	self setInterruptStatusBit:6
]

{ #category : #'clearing interrupts' }
SDDevice >> clearCardRemovalInterrupt [
	self setInterruptStatusBit: 7
]

{ #category : #'clearing interrupts' }
SDDevice >> clearCommandCompleteInterrupt [
	self setInterruptStatusBit: 0
]

{ #category : #registers }
SDDevice >> clockControlRegister [
	^ self shortAt: 16r2C
]

{ #category : #'enabling interrupts' }
SDDevice >> enableBlockGapInterrupt [
	self setInterruptEnableBit: 2
]

{ #category : #'enabling interrupts' }
SDDevice >> enableBufferReadyInterrupt [
	self setInterruptEnableBit: 5
]

{ #category : #'enabling interrupts' }
SDDevice >> enableBufferWriteReadyInterrupt [
	self setInterruptEnableBit: 4
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCardInsertionInterrupt [
	self setInterruptEnableBit: 6; enableCardInsertionInterruptStatus
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCardInsertionInterruptStatus [
	self setInterruptStatusEnableBit: 6
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCardInterrupt [
	self setInterruptEnableBit: 8; enableCardInterruptStatus
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCardInterruptStatus [
	self setInterruptStatusEnableBit: 8
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCardRemovalInterrupt [
	self setInterruptEnableBit: 7; enableCardRemovalInterruptStatus
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCardRemovalInterruptStatus [
	self setInterruptStatusEnableBit: 7
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCommandCompleteInterrupt [
	self setInterruptEnableBit: 0; enableCommandCompleteInterruptStatus
]

{ #category : #'enabling interrupts' }
SDDevice >> enableCommandCompleteInterruptStatus [
	self setInterruptStatusEnableBit: 0
]

{ #category : #'enabling interrupts' }
SDDevice >> enableDMAInterrupt [
	self setInterruptEnableBit: 3
]

{ #category : #'enabling interrupts' }
SDDevice >> enableErrorInterrupt [
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
]

{ #category : #'enabling interrupts' }
SDDevice >> enableInterrupts [
	self enableCardRemovalInterrupt; 
		enableCardInsertionInterrupt; 
		enableCommandCompleteInterrupt;
		enableErrorInterrupt
]

{ #category : #'enabling interrupts' }
SDDevice >> enableTransferCompleteInterrupt [
	self setInterruptEnableBit: 1
]

{ #category : #registers }
SDDevice >> errorInterruptEnableRegister [
	^self shortAt: 16r3A
]

{ #category : #registers }
SDDevice >> errorInterruptStatus [
	^self shortAt: 16r32
]

{ #category : #registers }
SDDevice >> errorInterruptStatusEnableRegister [
	^self shortAt: 16r36
]

{ #category : #commands }
SDDevice >> getCardID [
	| answer address arg |
	address := self getRelativeAddress.
	arg := address bitShift: 16.
	answer := self sendCommand: 10 with: arg.
	^answer bitAnd: 16rFFFF
	
SDCommands
]

{ #category : #commands }
SDDevice >> getRelativeAddress [
	| answer |
	answer := self sendCommand: 3.
	answer bitShift: -16.
	^answer bitAnd: 16rFFFF
]

{ #category : #'irq handling' }
SDDevice >> handleIRQ [
	self hasCardRemovalInterrupt ifTrue: [
		self clearCardRemovalInterrupt.
		self checkCardPresent].
	self hasCardInsertionInterrupt ifTrue: [
		self clearCardInsertionInterrupt.
		self checkCardPresent].
	self hasCommandCompleteInterrupt ifTrue: [
		self clearCommandCompleteInterrupt].
]

{ #category : #'testing interrupts' }
SDDevice >> hasBlockGapInterrupt [
	^self testInterruptStatusBit: 2
]

{ #category : #'testing interrupts' }
SDDevice >> hasBufferReadReadyInterrupt [
	^self testInterruptStatusBit: 5
]

{ #category : #'testing interrupts' }
SDDevice >> hasBufferWriteReadyInterrupt [
	^self testInterruptStatusBit: 4
]

{ #category : #'testing interrupts' }
SDDevice >> hasCardInsertionInterrupt [
	^self testInterruptStatusBit: 6
]

{ #category : #'testing interrupts' }
SDDevice >> hasCardRemovalInterrupt [
	^self testInterruptStatusBit: 7
]

{ #category : #'testing interrupts' }
SDDevice >> hasCommandCompleteInterrupt [
	^self testInterruptStatusBit: 0
]

{ #category : #'testing interrupts' }
SDDevice >> hasDMAInterrupt [
	^self testInterruptStatusBit: 3
]

{ #category : #'testing interrupts' }
SDDevice >> hasErrorInterrupt [
	^self testInterruptStatusBit: 15
]

{ #category : #testing }
SDDevice >> hasReadableData [
	^self testPresentStateBit: 11
]

{ #category : #'testing interrupts' }
SDDevice >> hasTransferCompleteInterrupt [
	^self testInterruptStatusBit: 1
]

{ #category : #registers }
SDDevice >> interruptEnableRegister [
	^self shortAt: 16r38
]

{ #category : #registers }
SDDevice >> interruptStatus [
	^self shortAt: 16r30
]

{ #category : #registers }
SDDevice >> interruptStatusEnableRegister [
	^self shortAt: 16r34
]

{ #category : #testing }
SDDevice >> isCardInserted [
	^self testPresentStateBit: 16
]

{ #category : #testing }
SDDevice >> isCardPresent [
	^self testPresentStateBit: 18
]

{ #category : #testing }
SDDevice >> isDATLineActive [
	^self testPresentStateBit: 2
]

{ #category : #testing }
SDDevice >> isReadingData [
	^self testPresentStateBit: 9
]

{ #category : #testing }
SDDevice >> isStateStable [
	^self testPresentStateBit: 17
]

{ #category : #testing }
SDDevice >> isWriteProtected [
	^(self testPresentStateBit: 19) not
]

{ #category : #testing }
SDDevice >> isWritingData [
	^self testPresentStateBit: 8
]

{ #category : #accessing }
SDDevice >> lineSignalLevel [
	^self testPresentStateBit: 24
]

{ #category : #registers }
SDDevice >> presentState [
	^self longAt: 16r24
]

{ #category : #commands }
SDDevice >> readResponse [
	| answer |
	answer := self responseRegister
]

{ #category : #private }
SDDevice >> reportStatus [
]

{ #category : #registers }
SDDevice >> responseRegister [
	^self longAt: 16r10
]

{ #category : #commands }
SDDevice >> sendCommand: c [
	self sendCommand: c with: 0
]

{ #category : #commands }
SDDevice >> sendCommand: c with: arg [
	self
		waitForCommandSendAllowed;
		waitForDATCommandAllowed;
		longAt: 16r08 put: arg;
		shortAt: 16r0E put: (c bitShift: 8);
		waitForCommandComplete;
		readResponse
]

{ #category : #private }
SDDevice >> setClockControlRegisterBit: bit [
	| register |
	register := self clockControlRegister.
	register := register bitOr: (1 bitShift: bit).
	self shortAt: 16r2C put: register
]

{ #category : #private }
SDDevice >> setErrorInterruptEnableBit: bit [
	| register |
	register := self errorInterruptEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r3A put: register
]

{ #category : #private }
SDDevice >> setErrorInterruptStatusEnableBit: bit [
	| register |
	register := self errorInterruptStatusEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r36 put: register
]

{ #category : #private }
SDDevice >> setInterruptEnableBit: bit [
	| register |
	register := self interruptEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r38 put: register
]

{ #category : #private }
SDDevice >> setInterruptStatusBit: bit [
	| register |
	register := self interruptStatus.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r30 put: register
]

{ #category : #private }
SDDevice >> setInterruptStatusEnableBit: bit [
	| register |
	register := self interruptStatusEnableRegister.
	register := register bitOr: (1 bitShift: bit).
	self longAt: 16r34 put: register
]

{ #category : #testing }
SDDevice >> supportsHighSpeed [
	^self testCapabilitiesBit: 21
]

{ #category : #private }
SDDevice >> testCapabilitiesBit: bit [
	^self capacilitiesRegister anyMask: (1 bitShift: bit)
]

{ #category : #private }
SDDevice >> testErrorInterruptStatusBit: bit [
	^self errorInterruptStatus anyMask: (1 bitShift: bit)
]

{ #category : #private }
SDDevice >> testInterruptStatusBit: bit [
	^self interruptStatus anyMask: (1 bitShift: bit)
]

{ #category : #private }
SDDevice >> testPresentStateBit: bit [
	^self presentState anyMask: (1 bitShift: bit)
]

{ #category : #serivices }
SDDevice >> waitFor: aBlock [
	aBlock whileFalse
]

{ #category : #commands }
SDDevice >> waitForCommandComplete [
	self waitFor: [self hasCommandCompleteInterrupt]
]

{ #category : #commands }
SDDevice >> waitForCommandSendAllowed [
	self waitFor: [self canIssueCommand]
]

{ #category : #commands }
SDDevice >> waitForDATCommandAllowed [
	self waitFor: [self canIssueDATCommand]
]
