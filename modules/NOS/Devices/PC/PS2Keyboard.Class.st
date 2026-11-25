'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PS2Keyboard category: 'SqueakNOS-Devices-Base'!
HardwareDevice subclass: #PS2Keyboard
	instanceVariableNames: 'modifiersAndButtons mouseCoord mouseDataCount events previousScanCode configBits decoder keysMapping'
	classVariableNames: ''
	poolDictionaries: 'EventSensorConstants'
	category: 'SqueakNOS-Devices-Base'!
!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
checkPassword
	self controllerCommand: 16rA6.
"	^ self readData"
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearCommandBit: bit
	^ self commandByte: (self commandByte bitClear: 1 << bit)

! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
commandByte
	self controllerCommand: 16r20.
	^ self readKeyboardData.
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
commandByte: value
	self controllerCommand: 16r60.
	self keyboardCommand: value.
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
controllerCommand: cmd
	self waitToWrite ifFalse: [^false].
	self controllerPort: cmd.
	^true
! !

!PS2Keyboard methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
controllerPort: cmd
	^ self byteAt: 4 put: cmd
! !

!PS2Keyboard methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
dataPort
	^ self byteAt: 0
! !

!PS2Keyboard methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
dataPort: value
	^ self byteAt: 0 put: value
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableIRQsWhile: aBlock
	| answer |
	self controllerCommand: 16r60; dataPort: 0.
	answer := aBlock value.
	self controllerCommand: 16r60; dataPort: 16r47.
	^ answer

! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableInputBufferFullInterrupt
	^ self clearCommandBit: 0
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableInterrupts
	^self disableInputBufferFullInterrupt; disableMouseInputBufferFullInterrupt

! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableKeyboard
	self keyboardCommand: 16rF5.
	^ self waitKeyboardAck
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableKeyboardInterface
	self controllerCommand: 16rAD.

! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableMouse
	^ self mouseCommand: 16rF5.
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableMouseInputBufferFullInterrupt
	^ self clearCommandBit: 1
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableMouseInterface
	self controllerCommand: 16rA7.

! !

!PS2Keyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableMouseScrollingParsing
	configBits := configBits bitClear: 1
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableScancodeTranslation
	^ self clearCommandBit: 6
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableWrapMode
	^ self mouseCommand: 16rEC.
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enable1in1Scaling
	^self mouseCommand: 16rE6.
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enable2in1Scaling
	^self mouseCommand: 16rE7.
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableKeyboard
	self keyboardCommand: 16rF4.
	^ self waitKeyboardAck
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableKeyboardInputBufferFullInterrupt
	^ self setCommandBit: 0
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableKeyboardInterface
	self controllerCommand: 16rAE.

! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableMouse
	^ self mouseCommand: 16rF4.
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableMouseInputBufferFullInterrupt
	^ self setCommandBit: 1
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableMouseInterface
	self controllerCommand: 16rA8.

! !

!PS2Keyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableMouseScrollingParsing
	configBits := configBits bitOr: 1
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableRemoteMode
	^ self mouseCommand: 16rF0.
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableScancodeTranslation
	^ self setCommandBit: 6
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableStreamMode
	^ self mouseCommand: 16rEA.
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableWrapMode
	^ self mouseCommand: 16rEE.
! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleIRQ
	[self keyboardOutputBufferFull] whileTrue: [
		self mouseOutputBufferFull
			ifTrue: [self handleMouseIRQ]
			ifFalse: [self handleKeyboardIRQ]]


! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleKeyboardIRQ
	| scanCode key |
	scanCode := self readKeyboardData.
	"Transcript show: 'keyboard irq: ', scanCode hex, String cr."

	decoder nextScanCode: scanCode.
	
	decoder nextKeyReady ifFalse: [^self].
	
	decoder isModifier
		ifFalse: [ "it's an ascii caracter"
			key := decoder keyUsing: keysMapping modifiers: modifiersAndButtons.
			key asciiValue = 0 ifTrue: [^self].
			decoder isKeyUp 
				ifTrue: [ self newKeyboardUpEvent: key ]
				ifFalse: [ self newKeyboardDownEvent: key].
		]
		ifTrue: [ " it's a modifier "
			"modifiersAndButtons := modifiersAndButtons bitXor: decoder translateModifierScanCode."
			
			decoder isKeyUp
				ifTrue: [ modifiersAndButtons := modifiersAndButtons bitClear: decoder translateModifierScanCode ]
				ifFalse: [ modifiersAndButtons := modifiersAndButtons bitOr: decoder translateModifierScanCode ].
		].
		
	


! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleMouseIRQ
	| data |
	data := self readMouseData.
	"Transcript show: 'mouse irq: ', data hex, String cr."
	
	"self mouseScrollingEnabled
			ifTrue:  [Keys1 add: 'Number ', mouseDataCount asString, ' data ', data asString, '
'. ]."
			
	mouseDataCount == 0 ifTrue: [ "button state"
		mouseDataCount := mouseDataCount + 1.
		^ modifiersAndButtons := (((modifiersAndButtons bitClear: 16r7)
			bitOr: (data bitAnd: 2))
			bitOr: (data bitAnd: 1) << 2)
			bitOr: (data bitAnd: 4) >> 2].

	data >= 16r80 ifTrue: [data := data - 16r100].

	mouseDataCount == 1 ifTrue: [ "x delta "
		mouseDataCount := mouseDataCount + 1.
		"Transcript show: 'x delta: ', data printString."
		^ mouseCoord := data @ 0 + mouseCoord].

	
	mouseDataCount = 2 ifTrue: [ " y delta "
		"Transcript show: 'y delta: ', data printString."
		mouseCoord := mouseCoord  - (0 @ data) adhereTo: Display boundingBox.
		].

	self mouseScrollingEnabled
			ifTrue:  [
				mouseDataCount = 2 ifTrue: [^mouseDataCount := mouseDataCount + 1.] ]
			ifFalse:[
				mouseDataCount := 0.
				^self newMouseEvent].
	
	" mouseDataCount == 3: z delta "
	mouseDataCount := 0.
	data < 0 ifTrue:["Scrolling up"
		^self newKeyboardControlCharEvent: Character arrowUp].
	data > 0 ifTrue:["Scrolling down"
		^self newKeyboardControlCharEvent: Character arrowDown].
	self newMouseEvent.
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasPassword
	self controllerCommand: 16rA4.
	^ self readKeyboardData == 16rFA
! !

!PS2Keyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.

	mouseDataCount := modifiersAndButtons := 0.
	mouseCoord := DisplayScreen actualScreenSize // 2.
	configBits := 0.
	
	keysMapping := self class generatedEnglishKeysMapping.
	decoder :=  ScancodeDecoder new.

	self initializeHardware.
	self initializeEventsQueue.
! !

!PS2Keyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeEventsQueue
	| p block |
	events := SharedQueue new.
	Computer isPharo
			   ifTrue: [ block := [ Sensor handleEvent: events next ] ]
			   ifFalse: [ block := [ Sensor processEvent: events next] ].
	p := [ block repeat] forkAt: Processor highIOPriority.
	
	p name: 'PS2Keboard shared queue poll'
! !

!PS2Keyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeHardware
	self
		initializeKeyboardHardware;
		initializeMouseHardware.

"	self enableKeyboardInputBufferFullInterrupt;	not needed, commandByte: 16r47 enables all
		enableKeyboardInterface.
"
	self commandByte: 16r47.	" enable mouse and keyboard, and set scan code 1 "

! !

!PS2Keyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeKeyboardHardware

	self report: 'Performing keyboard initialization';
		commandByte: 0.
	self report: 'reseting keyboard'.
	self
		resetKeyboard;
		commandByte: 0;
		report: 'keyboard reset.'.

	self testController
		ifFalse: 
			[self report: 'controller self test: failed.'.
			^ false].

	self report: 'controller self test: Ok'.
	self testKeyboardInterface
		ifFalse: 
			[self report: 'keyboard self test: failed.'.
			^ false].
	self report: 'keyboard self test: Ok'.

	self testKeyboardEcho
		ifFalse: 
			[self report: 'keyboard echo: failed.'.
			^ false].
	self report: 'keyboard echo: Ok'";
		keyboardLeds: 0;
		keyboardScanCodeSet: 1".		" this two commented out because they take too long to complete :( "

! !

!PS2Keyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeMouseHardware

	self report: 'Performing mouse initialization'.

	self testMouseInterface ifTrue: [
		self report: 'Mouse present'.
		self mouseSampleRate: 16rC8. 
		self mouseSampleRate: 16r64. 
		self mouseSampleRate: 16r50.
		self mouseId = 16r03
			ifTrue: [
				self report: 'Enabling mouse scrolling.'.
				self enableMouseScrollingParsing]
			ifFalse: [self disableMouseScrollingParsing].
"		self disableMouseScrollingParsing."
		self "disableMouse;
			resetMouse;"
			enableMouse";
			enableMouseInputBufferFullInterrupt;	 not needed, commandByte: 16r47 enables all 
			enableMouseInterface"].

! !

!PS2Keyboard methodsFor:  'hardware status' stamp: 'KenD 28/Jun/2026 13:32:24'!
inputBufferFull
	^ self statusPort anyMask: 2
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
inputPort
	self controllerCommand: 16rCO.
	^ self readKeyboardData.
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardBuffer: value
	self controllerCommand: 16rD2.
	self keyboardCommand: value.
	
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardCommand: cmd
	self waitToWrite ifFalse: [^false].
	self dataPort: cmd.
	^true
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardId
	self keyboardCommand: 16rF2.
	self waitKeyboardAck.
	^(self readKeyboardData bitShift: 8) bitOr: self keyboardData.
! !

!PS2Keyboard methodsFor:  'hardware status' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardInhibited
	^ (self statusPort anyMask: 16) not
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardLeds: value
	self keyboardCommand: 16rED.
	self waitKeyboardAck.
	self keyboardCommand: value.
	^self waitKeyboardAck.

! !

!PS2Keyboard methodsFor:  'hardware status' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardOutputBufferFull
	^ self statusPort anyMask: 1
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardScanCodeSet: value
	value == 1
		ifTrue: [self setCommandBit: 6]
		ifFalse: [self clearCommandBit: 6].
"	self keyboardCommand: 16rF0.
	self waitKeyboardAck.
	self keyboardCommand: value.
	^self waitKeyboardAck.
"
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardTypematicRateDelay: value
	self keyboardCommand: 16rF3.
	self waitKeyboardAck.
	self keyboardCommand: value.
	^self waitKeyboardAck
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseBuffer: value
	self controllerCommand: 16rD3.
	self keyboardCommand: value.
	
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseCommand: value
	self controllerCommand: 16rD4.
	self keyboardCommand: value.
	^ self waitMouseAck.
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseCommandNoAck: value
	self controllerCommand: 16rD4.
	self keyboardCommand: value.
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseId
	self mouseCommand: 16rF2.
	^self readMouseData
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseInputBufferInterruptEnabled
	^ self testCommandBit: 2
! !

!PS2Keyboard methodsFor:  'hardware status' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseOutputBufferFull
	^ self statusPort anyMask: 32
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseResolution: value
	^ (self mouseCommand: 16rE8) and: [self mouseCommand: value]
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseSampleRate: value
	^ (self mouseCommand: 16rF3) and: [self mouseCommand: value]
! !

!PS2Keyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseScrollingEnabled
	^ configBits anyMask: 1
! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newKeyboardControlCharEvent: char
	modifiersAndButtons  := (modifiersAndButtons  bitOr: 16r10).
	self newKeyboardEvent: char type: EventKeyChar.
	modifiersAndButtons := modifiersAndButtons bitClear: 16r10.

! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newKeyboardDownEvent: aCharacter
	self newKeyboardEvent: aCharacter type: EventKeyDown.
	self newKeyboardEvent: aCharacter type: EventKeyChar.

! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newKeyboardEvent: aCharacter type: byteType
	" taken from EventSensor >> #nextEventSynthesized "
	| event |
	"Transcript show: aCharacter asciiValue."
	(event := Array new: 8)
		at: 1 put: EventTypeKeyboard; "evt type"
		at: 2 put: Time millisecondClockValue; "time stamp"
		at: 3 put: aCharacter asciiValue; "char code"
		at: 4 put: byteType; "key press/release"
		at: 5 put: modifiersAndButtons >> 3; "modifier keys"
		at: 6 put: aCharacter asciiValue; "utf32Code, TODO: translate to utf32"
		at: 7 put: 0; "reserved"
		at: 8 put: 1. "window index"

	events nextPut: event.
! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newKeyboardUpEvent: aCharacter
	self newKeyboardEvent: aCharacter type: EventKeyUp
! !

!PS2Keyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newMouseEvent
	| modifiers buttons mapped event |
	modifiers := modifiersAndButtons bitShift: -3.
	buttons := modifiersAndButtons bitAnd: 7.
	mapped := Sensor mapButtons: buttons modifiers: modifiers.
	(event := Array new: 8)
		at: 1 put: EventTypeMouse;
		at: 2 put: Time millisecondClockValue;
		at: 3 put: mouseCoord x;
		at: 4 put: mouseCoord y;
		at: 5 put: mapped;
		at: 6 put: modifiers;
		at: 7 put: 0;
		at: 8 put: 1.
	events nextPut: event.
	"self report: event.
	WorldMorph doOneCycle"

! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
outputPort
	self controllerCommand: 16rDO.
	^ self readKeyboardData.
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
outputPort: value
	self controllerCommand: 16rD1.
	self keyboardCommand: value.
	
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
outputPortLow: value
	self controllerCommand: 16r90 + (value bitAnd: 15).
	
! !

!PS2Keyboard methodsFor:  'hardware status' stamp: 'KenD 28/Jun/2026 13:32:24'!
paryityError
	^ self statusPort anyMask: 128
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
pollMouseDataPacket
	self mouseCommand: 16rEB.
	^self readMouseDataPacket
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
pulseOutputPortLow: value
	self controllerCommand: 16rF0 + (value bitAnd: 15).
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
readKeyboardData
	self waitToReadKeyboard ifFalse: [^nil].
	^self dataPort
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
readMouseData
	self waitToReadMouse ifFalse: [^nil].
	^self dataPort.
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
readMouseDataPacket
	^ Array with: self readMouseData with: self readMouseData with: self readMouseData
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
readMouseStatus
	self mouseCommand: 16rE9.
	^self readMouseData
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
resendKeyboardCommand
	self keyboardCommand: 16rFE.
	^ self readKeyboardData
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
resendMouseCommand
	^ self mouseCommand: 16rFE.
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetKeyboard
	| answer |
	self keyboardCommand: 16rFF.
	self waitKeyboardAck ifFalse: [^false].
	(answer := self readKeyboardData) ifNil: [^ false].
	answer == 16rAA ifTrue: [^true].
	answer ~~ 16rFC ifTrue: [self report: 'Unexpected answer to reset command: ', answer hex].
	^ false
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetMouse
	| answer |
	(self mouseCommand: 16rFF) ifFalse: [^false].
	answer := self readMouseData.
	answer == 16rAA ifTrue: [^self readMouseData == 0 " mouse sends device ID after reset "].
	answer ~~ 16rFC ifTrue: [self report: 'Unexpected answer to reset command: ', answer hex].
	^ false
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
scancodeTranslationEnabled
	^ self testCommandBit: 16r40
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
setCommandBit: bit
	^ self commandByte: (self commandByte bitOr: 1 << bit)
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
setKeyboardDefaults
	self keyboardCommand: 16rF6.
	^ self waitKeyboardAck
! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
setMouseDefaults
	^ self mouseCommand: 16rF6.
! !

!PS2Keyboard methodsFor:  'keyboard access' stamp: 'KenD 28/Jun/2026 13:32:24'!
shiftPressed
	^ modifiersAndButtons anyMask: 8
! !

!PS2Keyboard methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusPort
	^ self byteAt: 4
! !

!PS2Keyboard methodsFor:  'hardware status' stamp: 'KenD 28/Jun/2026 13:32:24'!
systemInitialized
	^ self statusPort anyMask: 4
! !

!PS2Keyboard methodsFor:  'command byte' stamp: 'KenD 28/Jun/2026 13:32:24'!
testCommandBit: mask
	^ self commandByte anyMask: mask
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
testController
	self controllerCommand: 16rAA.
	^ self readKeyboardData == 16r55

! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
testKeyboardEcho
	self keyboardCommand: 16rEE.
	^ self readKeyboardData == 16rEE
! !

!PS2Keyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
testKeyboardInterface
	self controllerCommand: 16rAB.
	^ self readKeyboardData isZero

! !

!PS2Keyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
testMouseInterface
	self controllerCommand: 16rA9.
	^ self readKeyboardData isZero

! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
testPort
	self controllerCommand: 16rE0.
	^ self readKeyboardData
! !

!PS2Keyboard methodsFor:  'hardware status' stamp: 'KenD 28/Jun/2026 13:32:24'!
timeoutError
	^ self statusPort anyMask: 64
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
version
	self controllerCommand: 16rAD.
"	^ self readData."
! !

!PS2Keyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
versionNumber
	self controllerCommand: 16rA1.
"	^ self readData."
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitKeyboardAck
	^ self readKeyboardData == 16rFA
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitMouseAck
	^ self readMouseData == 16rFA
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitToReadKeyboard
	| delay |
	self keyboardOutputBufferFull ifTrue: [^true].
	delay := Delay forMilliseconds: 1.
	1000 timesRepeat: [
		"FIXME: cannot wait because the process switch seems to kill the image"
		"delay wait."
		self keyboardOutputBufferFull ifTrue: [^true]
	].
	self report: 'timedout out witing for keyboard input.'.
	^false
	
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitToReadMouse
	| delay |
	self mouseOutputBufferFull ifTrue: [^true].
	delay := Delay forMilliseconds: 1.
	250 timesRepeat: [
		delay wait.
		self mouseOutputBufferFull ifTrue: [^true]
	].
	self report: 'timedout out witing for mouse input.'.
	^false
	
! !

!PS2Keyboard methodsFor:  'low level protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitToWrite
	| delay |
	self inputBufferFull ifFalse: [^true].
	delay := Delay forMilliseconds: 1.
	250 timesRepeat: [
		delay wait.
		self inputBufferFull ifFalse: [^true]
	].
	self report: 'timedout out witing to write.'.
	^false
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PS2Keyboard class' category: 'SqueakNOS-Devices-Base'!
PS2Keyboard class
	instanceVariableNames: ''!

!PS2Keyboard class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
cCharsToArray: aString
	| strm table |
	strm := ReadStream on: aString.
	strm reset.
	table := OrderedCollection new: 128.
	[strm atEnd]
		whileFalse: [strm peek = $\
				ifTrue: 
					[strm next.
					strm peek isDigit
						ifTrue: [table add: (Character value: ('8r' , (strm next: 3)) asNumber)]
						ifFalse: [table add: (self unescapeCharacter: strm next)]]
				ifFalse: [table add: strm next]].
	^ table asArray
! !

!PS2Keyboard class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
fixPasteUpMorphIfPharo
	Computer isPharo ifFalse: [^self].
	PasteUpMorph compile:
	'morphsInFrontOf: someMorph overlapping: aRectangle do: aBlock
	"Include hands if the receiver is the World"
	self handsDo:[:m|
		m == someMorph ifTrue:[ "Try getting out quickly"
			owner ifNil:[^self].
			^owner morphsInFrontOf: self overlapping: aRectangle do: aBlock
		]
	].
		
	^super morphsInFrontOf: someMorph overlapping: aRectangle do: aBlock'
		classified: 'submorphs-accessing'.
		
! !

!PS2Keyboard class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
generatedEnglishKeysMapping

	| mapping temp |
	
	mapping := Dictionary new.
	
	mapping at: #(none) put: (self cCharsToArray: '\0331234567890-=\010\t' ,
		'qwertyuiop[]\r\000as' ,
		'dfghjkl;''`\000\\zxcv' ,
		'bnm,./\000*\000 \000\201\202\203\204\205' ,
		'\206\207\210\211\212\000\000789-456+1' ,
		'230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000' ,
		'\r\000/').
		
	mapping at: #(shift) put: (self cCharsToArray: 
		'\033!!@#$%^&*()_+\010\t' ,
		'QWERTYUIOP{}\r\000AS' ,
		'DFGHJKL:"~\000|ZXCV' ,
		'BNM<>?\000*\000 \000\201\202\203\204\205' ,
		'\206\207\210\211\212\000\000789-456+1' ,
		'230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000' ,
		'\r\000/').
		
	mapping at: #(alt) put: (Array new: 128 withAll: (Character value: 0)).
	mapping at: #(shift alt) put: (Array new: 128 withAll: (Character value: 0)).
	
	temp := Array new: 128 withAll: (Character value: 0).
	temp at: 16r48 put: Character arrowUp.
	temp at: 16r50 put: Character arrowDown.
	temp at: 16r4D put: Character arrowRight.
	temp at: 16r4B put: Character arrowLeft.
	temp at: 16r47 put: Character home.
	temp at: 16r4F put: Character end.
	temp at: 16r49 put: Character pageUp.
	temp at: 16r51 put: Character pageDown.
	temp at: 16r52 put: Character insert.	
	temp at: 16r53 put: Character delete.

	mapping at: #(extended) put: temp.
	
	 ^mapping.
! !

!PS2Keyboard class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
generatedSpanishKeysMapping

	| mapping |
	
	mapping := self generatedEnglishKeysMapping.
	
	"TODO: fill this"
	"mapping at: #(none) put: Dictionary new.
	mapping at: #(shift) put: Dictionary new.
	mapping at: #(alt) put: Dictionary new.
	mapping at: #(alt shift) put: Dictionary new.
	mapping at: #(extended) put: Dictionary new.
	"
	
	 ^mapping.
! !

!PS2Keyboard class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	
! !

!PS2Keyboard class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	| keyboard p |
	keyboard := self onPort: 16r60.
	aComputer interruptController addHandler: keyboard forIRQ: 1.
	aComputer interruptController addHandler: keyboard forIRQ: 12.
	self fixPasteUpMorphIfPharo.
	Cursor normal show.

	^ true

! !

!PS2Keyboard class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
unescapeCharacter: char
	char = $t ifTrue: [^ Character tab].
	char = $r ifTrue: [^ Character cr].
	char = $n ifTrue: [^ Character lf].
	^ char
! !


PS2Keyboard initialize!

