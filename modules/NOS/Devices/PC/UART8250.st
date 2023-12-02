"
This is the Serial port driver. It's useful for debugging.

Usage example: 

This code will loop until it receives 100 bytes and will write them in transcript. Caution, will block everything until it finishes reading.
| s |
s := Computer current defaultSerialPort.
s open.
100 timesRepeat: [Transcript show: (s nextPut: s next)]. 
"
Class {
	#name : #UART8250,
	#superclass : #HardwareDevice,
	#instVars : [
		'receivedChars',
		'baudRate',
		'stopBits',
		'parity',
		'dataBits',
		'interruptId',
		'lineStatus',
		'modemStatus'
	],
	#category : 'SqueakNOS-Devices-Base'
}

{ #category : #'system startup' }
UART8250 class >> detectedUARTS [
	| uart |
	^#(16r3F8 16r2F8 16r3E8 16r2E8)
		collect: [:portNumber |
			uart := self onPort: portNumber.
			uart exists ifTrue: [uart] ifFalse: [nil]].

]

{ #category : #testing }
UART8250 >> anyInterrupt [
	^(interruptId bitAnd: 2r1110) ~= 0


]

{ #category : #accessing }
UART8250 >> baudRateDivisorFor: baud [
	^ 115200 // baud

]

{ #category : #accessing }
UART8250 >> checkError [
	(lineStatus bitAnd: 16r1E) = 0
		ifFalse: [Transcript cr; show: 'Error LSR/UART ', lineStatus printStringHex]
]

{ #category : #'device protocol' }
UART8250 >> close [
	Preferences disableLogging.
	self interruptEnableRegister: 0.
	self modemControlRegister: 3.


]

{ #category : #testing }
UART8250 >> dataAvailabelInRDR [
	^ (lineStatus bitAnd: 1) = 1
]

{ #category : #'device protocol' }
UART8250 >> dataAvailable [
	^ receivedChars isEmpty not
]

{ #category : #accessing }
UART8250 >> disableLoopbackTesting [
	self modemControlRegister: 16r0
]

{ #category : #accessing }
UART8250 >> enableLoopbackTesting [
	self modemControlRegister: 16r10
]

{ #category : #testing }
UART8250 >> exists [
	self enableLoopbackTesting.
	self readModemStatus.
	(modemStatus anyMask: 16rF0) ifTrue: [^ false].
	self modemControlRegister: 16r1F.
	self readModemStatus.
	(modemStatus bitAnd: 16rF0) = 16rF0 ifFalse: [^ false].
	self disableLoopbackTesting.
	^true
		
]

{ #category : #'device protocol' }
UART8250 >> flush [
	^ self
]

{ #category : #'irq handling' }
UART8250 >> handleIRQ [
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
]

{ #category : #initialization }
UART8250 >> initialize [
	super initialize.
	baudRate := 57600. "tried 115200 but doesn't work on my vmware at least"
	stopBits := 1.
	parity := 0.
	dataBits := 8
]

{ #category : #accessing }
UART8250 >> initializeLineControlRegisterStopBitsType: stopBitsInteger parityType: parityInteger dataBits: numDataBits [ 
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
]

{ #category : #registers }
UART8250 >> interruptEnableRegister [
	^ self byteAt: 1
]

{ #category : #registers }
UART8250 >> interruptEnableRegister: aByte [
	^ self byteAt: 1 put: aByte
]

{ #category : #registers }
UART8250 >> interruptIDRegister [
	^ self byteAt: 2
]

{ #category : #registers }
UART8250 >> interruptIDRegister: aByte [
	^ self byteAt: 2 put: aByte
]

{ #category : #testing }
UART8250 >> interruptPending [
	^(interruptId bitAnd: 1) = 0


]

{ #category : #'device protocol' }
UART8250 >> isOpen [
	^ true
]

{ #category : #registers }
UART8250 >> lineControlRegister [
	^ self byteAt: 3
]

{ #category : #registers }
UART8250 >> lineControlRegister: aByte [
	^ self byteAt: 3 put: aByte
]

{ #category : #registers }
UART8250 >> lineStatusRegister [
	^ self byteAt: 5
]

{ #category : #registers }
UART8250 >> lineStatusRegister: aByte [
	^ self byteAt: 5 put: aByte
]

{ #category : #registers }
UART8250 >> modemControlRegister [
	^ self byteAt: 4
]

{ #category : #registers }
UART8250 >> modemControlRegister: aByte [
	^ self byteAt: 4 put: aByte
]

{ #category : #registers }
UART8250 >> modemStatusRegister [
	^ self byteAt: 6
]

{ #category : #registers }
UART8250 >> modemStatusRegister: aByte [
	^ self byteAt: 6 put: aByte
]

{ #category : #'device protocol' }
UART8250 >> next [
	^ self nextByte
]

{ #category : #'device protocol' }
UART8250 >> next: anInteger [
	| answer |
	answer := ByteArray new: anInteger.
	1 to: anInteger do: [:index | answer at: index put: self next].
	^answer
]

{ #category : #'device protocol' }
UART8250 >> nextAvailable [
	| size answer |
	size := receivedChars size.
	answer := String new: size.
	1 to: size do: [:index | answer at: index put: self next].
	^answer
]

{ #category : #accessing }
UART8250 >> nextByte [
	^ receivedChars next
]

{ #category : #'device protocol' }
UART8250 >> nextPut: aCharacter [
	self xmitByte: aCharacter asInteger.
	^ aCharacter
]

{ #category : #'device protocol' }
UART8250 >> nextPutAll: aString [
	aString do: [:char | self nextPut: char].
]

{ #category : #'device protocol' }
UART8250 >> open [
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
]

{ #category : #'squeakNOS primitives' }
UART8250 >> primClosePort: portNumber [
	self close
]

{ #category : #'squeakNOS primitives' }
UART8250 >> primOpenPort: portNumber baudRate: baud stopBitsType: stop
	parityType: parityType dataBits: numDataBits
	inFlowControlType: inFlowCtrl outFlowControlType: outFlowCtrl
	xOnByte: xOn xOffByte: xOff [
	self openPort: portNumber
]

{ #category : #'squeakNOS primitives' }
UART8250 >> primReadPort: portNumber into: byteArray startingAt: startIndex count: count [
	| index |
	index := startIndex.
	count timesRepeat: [
		byteArray at: index put: self nextByte.
		index := index + 1].
]

{ #category : #'squeakNOS primitives' }
UART8250 >> primWritePort: portNumber from: byteArray startingAt: startIndex count: count [
	| index |
	index := startIndex.
	count timesRepeat: [self nextPut: (byteArray at: index)]
]

{ #category : #accessing }
UART8250 >> readInterruptId [
	interruptId := self interruptIDRegister


]

{ #category : #accessing }
UART8250 >> readLineStatus [
	lineStatus := self lineStatusRegister


]

{ #category : #accessing }
UART8250 >> readModemStatus [
	modemStatus := self modemStatusRegister


]

{ #category : #testing }
UART8250 >> receivedDataPending [
	^(interruptId bitAnd: 2r110) = 2r100


]

{ #category : #'device protocol' }
UART8250 >> reopen [
	self close.
	self open
]

{ #category : #accessing }
UART8250 >> setBaudRate: baud [
	| brd |
	baudRate := baud.
	brd := self baudRateDivisorFor: baud.
	self lineControlRegister: 16r80.
 	self interruptEnableRegister: (brd bitShift: -8).
	self byteAt: 0 put: (brd bitAnd: 255).
]

{ #category : #testing }
UART8250 >> testTHR [
	^(lineStatus bitAnd: 2r00100000) ~= 0
]

{ #category : #accessing }
UART8250 >> turnOffRTS [
	| mcr |
	mcr := self modemControlRegister.
	self modemControlRegister: (mcr bitAnd: 2r11111101)

]

{ #category : #accessing }
UART8250 >> turnOnRTS [
	self modemControlRegister: 
		(self modemControlRegister bitOr: 2r10).
]

{ #category : #accessing }
UART8250 >> xmitByte: value [
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
]
