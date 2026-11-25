'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #UART8250 category: 'SqueakNOS-Devices-Base'!
HardwareDevice subclass: #UART8250
	instanceVariableNames: 'receivedChars baudRate stopBits parity dataBits interruptId lineStatus modemStatus'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!UART8250 commentStamp: '<historical>' prior: 0!

This is the Serial port driver. It's useful for debugging.

Usage example: 

This code will loop until it receives 100 bytes and will write them in transcript. Caution, will block everything until it finishes reading.
| s |
s := Computer current defaultSerialPort.
s open.
100 timesRepeat: [Transcript show: (s nextPut: s next)]. 
!

!UART8250 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
anyInterrupt
	^(interruptId bitAnd: 2r1110) ~= 0


! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
baudRateDivisorFor: baud
	^ 115200 // baud

! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
checkError
	(lineStatus bitAnd: 16r1E) = 0
		ifFalse: [Transcript cr; show: 'Error LSR/UART ', lineStatus printStringHex]
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
close
	Preferences disableLogging.
	self interruptEnableRegister: 0.
	self modemControlRegister: 3.


! !

!UART8250 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
dataAvailabelInRDR
	^ (lineStatus bitAnd: 1) = 1
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
dataAvailable
	^ receivedChars isEmpty not
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableLoopbackTesting
	self modemControlRegister: 16r0
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableLoopbackTesting
	self modemControlRegister: 16r10
! !

!UART8250 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
exists
	self enableLoopbackTesting.
	self readModemStatus.
	(modemStatus anyMask: 16rF0) ifTrue: [^ false].
	self modemControlRegister: 16r1F.
	self readModemStatus.
	(modemStatus bitAnd: 16rF0) = 16rF0 ifFalse: [^ false].
	self disableLoopbackTesting.
	^true
		
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
flush
	^ self
! !

!UART8250 methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleIRQ
	self turnOffRTS.
	
	[self readInterruptId.
	self receivedDataPending
		ifTrue: 
			[
			[receivedChars nextPut: (self byteAt: 0).
			self readLineStatus.
			self checkError.
			self dataAvailabelInRDR] whileTrue].
	self interruptPending] whileTrue.
	self turnOnRTS
! !

!UART8250 methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	baudRate := 57600. "tried 115200 but doesn't work on my vmware at least"
	stopBits := 1.
	parity := 0.
	dataBits := 8
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeLineControlRegisterStopBitsType: stopBitsInteger parityType: parityInteger dataBits: numDataBits
	| lcr |
	numDataBits = 7
		ifTrue: [lcr := 2]
		ifFalse: [lcr := 3].
	stopBits = 2 ifTrue: [lcr := lcr bitOr: 4].
	parity = 0
		ifFalse: 
			[lcr := lcr bitOr: 8.
			parity = 2 ifTrue: [lcr := lcr bitOr: 16]].
	self lineControlRegister: lcr
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptEnableRegister
	^ self byteAt: 1
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptEnableRegister: aByte
	^ self byteAt: 1 put: aByte
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptIDRegister
	^ self byteAt: 2
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptIDRegister: aByte
	^ self byteAt: 2 put: aByte
! !

!UART8250 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptPending
	^(interruptId bitAnd: 1) = 0


! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
isOpen
	^ true
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
lineControlRegister
	^ self byteAt: 3
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
lineControlRegister: aByte
	^ self byteAt: 3 put: aByte
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
lineStatusRegister
	^ self byteAt: 5
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
lineStatusRegister: aByte
	^ self byteAt: 5 put: aByte
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
modemControlRegister
	^ self byteAt: 4
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
modemControlRegister: aByte
	^ self byteAt: 4 put: aByte
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
modemStatusRegister
	^ self byteAt: 6
! !

!UART8250 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
modemStatusRegister: aByte
	^ self byteAt: 6 put: aByte
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
next
	^ self nextByte
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
next: anInteger
	| answer |
	answer := ByteArray new: anInteger.
	1 to: anInteger do: [:index | answer at: index put: self next].
	^answer
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextAvailable
	| size answer |
	size := receivedChars size.
	answer := String new: size.
	1 to: size do: [:index | answer at: index put: self next].
	^answer
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextByte
	^ receivedChars next
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextPut: aCharacter
	self xmitByte: aCharacter asInteger.
	^ aCharacter
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextPutAll: aString
	aString do: [:char | self nextPut: char].
! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
open
	receivedChars := SharedQueue new.
	self setBaudRate: baudRate.
	self
		initializeLineControlRegisterStopBitsType: stopBits
		parityType: parity
		dataBits: dataBits.
	self byteAt: 0.
	self readLineStatus.
	self readModemStatus.
	self modemControlRegister: 16r0B.
	self interruptEnableRegister: 16r09.
	self interruptIDRegister
! !

!UART8250 methodsFor:  'squeakNOS primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primClosePort: portNumber
	self close
! !

!UART8250 methodsFor:  'squeakNOS primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primOpenPort: portNumber baudRate: baud stopBitsType: stop parityType: parityType dataBits: numDataBits inFlowControlType: inFlowCtrl outFlowControlType: outFlowCtrl xOnByte: xOn xOffByte: xOff
	self openPort: portNumber
! !

!UART8250 methodsFor:  'squeakNOS primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primReadPort: portNumber into: byteArray startingAt: startIndex count: count
	| index |
	index := startIndex.
	count timesRepeat: [
		byteArray at: index put: self nextByte.
		index := index + 1].
! !

!UART8250 methodsFor:  'squeakNOS primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primWritePort: portNumber from: byteArray startingAt: startIndex count: count
	| index |
	index := startIndex.
	count timesRepeat: [self nextPut: (byteArray at: index)]
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
readInterruptId
	interruptId := self interruptIDRegister


! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
readLineStatus
	lineStatus := self lineStatusRegister


! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
readModemStatus
	modemStatus := self modemStatusRegister


! !

!UART8250 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
receivedDataPending
	^(interruptId bitAnd: 2r110) = 2r100


! !

!UART8250 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
reopen
	self close.
	self open
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
setBaudRate: baud
	| brd |
	baudRate := baud.
	brd := self baudRateDivisorFor: baud.
	self lineControlRegister: 16r80.
 	self interruptEnableRegister: (brd bitShift: -8).
	self byteAt: 0 put: (brd bitAnd: 255).
! !

!UART8250 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
testTHR
	^(lineStatus bitAnd: 2r00100000) ~= 0
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
turnOffRTS
	| mcr |
	mcr := self modemControlRegister.
	self modemControlRegister: (mcr bitAnd: 2r11111101)

! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
turnOnRTS
	self modemControlRegister: 
		(self modemControlRegister bitOr: 2r10).
! !

!UART8250 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
xmitByte: value
	| process delay timeout |
	timeout := false.
	delay := Delay forSeconds: 5.
	process := 
			[delay wait.
			timeout := true]
				forkAt: Processor lowIOPriority.
	[self readLineStatus.
	timeout | self testTHR] whileFalse.
	timeout ifTrue: [Transcript cr; show: 'TimeOut'. ^self].
	"delay unschedule."
	process terminate.
	self byteAt: 0 put: value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UART8250 class' category: 'SqueakNOS-Devices-Base'!
UART8250 class
	instanceVariableNames: ''!

!UART8250 class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
detectedUARTS
	| uart |
	^#(16r3F8 16r2F8 16r3E8 16r2E8)
		collect: [:portNumber |
			uart := self onPort: portNumber.
			uart exists ifTrue: [uart] ifFalse: [nil]].

! !


UART8250 initialize!

