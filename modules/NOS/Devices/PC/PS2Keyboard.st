Class {
	#name : #PS2Keyboard,
	#superclass : #HardwareDevice,
	#instVars : [
		'modifiersAndButtons',
		'mouseCoord',
		'mouseDataCount',
		'events',
		'previousScanCode',
		'configBits',
		'decoder',
		'keysMapping'
	],
	#pools : [
		'EventSensorConstants'
	],
	#category : #'SqueakNOS-Devices-Base'
}

{ #category : #'class initialization' }
PS2Keyboard class >> cCharsToArray: aString [
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
]

{ #category : #'class initialization' }
PS2Keyboard class >> fixPasteUpMorphIfPharo [
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
		
]

{ #category : #'class initialization' }
PS2Keyboard class >> generatedEnglishKeysMapping [

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
		'\033!@#$%^&*()_+\010\t' ,
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
]

{ #category : #'class initialization' }
PS2Keyboard class >> generatedSpanishKeysMapping [

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
]

{ #category : #'class initialization' }
PS2Keyboard class >> initialize [
	
]

{ #category : #'system startup' }
PS2Keyboard class >> installOn: aComputer [
	| keyboard p |
	keyboard := self onPort: 16r60.
	aComputer interruptController addHandler: keyboard forIRQ: 1.
	aComputer interruptController addHandler: keyboard forIRQ: 12.
	self fixPasteUpMorphIfPharo.
	Cursor normal show.

	^ true

]

{ #category : #'class initialization' }
PS2Keyboard class >> unescapeCharacter: char [ 
	char = $t ifTrue: [^ Character tab].
	char = $r ifTrue: [^ Character cr].
	char = $n ifTrue: [^ Character lf].
	^ char
]

{ #category : #'controller commands' }
PS2Keyboard >> checkPassword [
	self controllerCommand: 16rA6.
"	^ self readData"
]

{ #category : #'command byte' }
PS2Keyboard >> clearCommandBit: bit [
	^ self commandByte: (self commandByte bitClear: 1 << bit)

]

{ #category : #'controller commands' }
PS2Keyboard >> commandByte [
	self controllerCommand: 16r20.
	^ self readKeyboardData.
]

{ #category : #'controller commands' }
PS2Keyboard >> commandByte: value [
	self controllerCommand: 16r60.
	self keyboardCommand: value.
]

{ #category : #'low level protocol' }
PS2Keyboard >> controllerCommand: cmd [
	self waitToWrite ifFalse: [^false].
	self controllerPort: cmd.
	^true
]

{ #category : #'I/O' }
PS2Keyboard >> controllerPort: cmd [
	^ self byteAt: 4 put: cmd
]

{ #category : #'I/O' }
PS2Keyboard >> dataPort [
	^ self byteAt: 0
]

{ #category : #'I/O' }
PS2Keyboard >> dataPort: value [
	^ self byteAt: 0 put: value
]

{ #category : #'low level protocol' }
PS2Keyboard >> disableIRQsWhile: aBlock [
	| answer |
	self controllerCommand: 16r60; dataPort: 0.
	answer := aBlock value.
	self controllerCommand: 16r60; dataPort: 16r47.
	^ answer

]

{ #category : #'command byte' }
PS2Keyboard >> disableInputBufferFullInterrupt [
	^ self clearCommandBit: 0
]

{ #category : #'command byte' }
PS2Keyboard >> disableInterrupts [
	^self disableInputBufferFullInterrupt; disableMouseInputBufferFullInterrupt

]

{ #category : #'keyboard commands' }
PS2Keyboard >> disableKeyboard [
	self keyboardCommand: 16rF5.
	^ self waitKeyboardAck
]

{ #category : #'keyboard commands' }
PS2Keyboard >> disableKeyboardInterface [
	self controllerCommand: 16rAD.

]

{ #category : #'mouse commands' }
PS2Keyboard >> disableMouse [
	^ self mouseCommand: 16rF5.
]

{ #category : #'command byte' }
PS2Keyboard >> disableMouseInputBufferFullInterrupt [
	^ self clearCommandBit: 1
]

{ #category : #'mouse commands' }
PS2Keyboard >> disableMouseInterface [
	self controllerCommand: 16rA7.

]

{ #category : #accessing }
PS2Keyboard >> disableMouseScrollingParsing [
	configBits := configBits bitClear: 1
]

{ #category : #'command byte' }
PS2Keyboard >> disableScancodeTranslation [
	^ self clearCommandBit: 6
]

{ #category : #'mouse commands' }
PS2Keyboard >> disableWrapMode [
	^ self mouseCommand: 16rEC.
]

{ #category : #'mouse commands' }
PS2Keyboard >> enable1in1Scaling [
	^self mouseCommand: 16rE6.
]

{ #category : #'mouse commands' }
PS2Keyboard >> enable2in1Scaling [
	^self mouseCommand: 16rE7.
]

{ #category : #'keyboard commands' }
PS2Keyboard >> enableKeyboard [
	self keyboardCommand: 16rF4.
	^ self waitKeyboardAck
]

{ #category : #'command byte' }
PS2Keyboard >> enableKeyboardInputBufferFullInterrupt [
	^ self setCommandBit: 0
]

{ #category : #'keyboard commands' }
PS2Keyboard >> enableKeyboardInterface [
	self controllerCommand: 16rAE.

]

{ #category : #'mouse commands' }
PS2Keyboard >> enableMouse [
	^ self mouseCommand: 16rF4.
]

{ #category : #'command byte' }
PS2Keyboard >> enableMouseInputBufferFullInterrupt [
	^ self setCommandBit: 1
]

{ #category : #'mouse commands' }
PS2Keyboard >> enableMouseInterface [
	self controllerCommand: 16rA8.

]

{ #category : #accessing }
PS2Keyboard >> enableMouseScrollingParsing [
	configBits := configBits bitOr: 1
]

{ #category : #'mouse commands' }
PS2Keyboard >> enableRemoteMode [
	^ self mouseCommand: 16rF0.
]

{ #category : #'command byte' }
PS2Keyboard >> enableScancodeTranslation [
	^ self setCommandBit: 6
]

{ #category : #'mouse commands' }
PS2Keyboard >> enableStreamMode [
	^ self mouseCommand: 16rEA.
]

{ #category : #'mouse commands' }
PS2Keyboard >> enableWrapMode [
	^ self mouseCommand: 16rEE.
]

{ #category : #'irq handling' }
PS2Keyboard >> handleIRQ [
	[self keyboardOutputBufferFull] whileTrue: [
		self mouseOutputBufferFull
			ifTrue: [self handleMouseIRQ]
			ifFalse: [self handleKeyboardIRQ]]


]

{ #category : #'irq handling' }
PS2Keyboard >> handleKeyboardIRQ [
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
		
	


]

{ #category : #'irq handling' }
PS2Keyboard >> handleMouseIRQ [
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
]

{ #category : #'controller commands' }
PS2Keyboard >> hasPassword [
	self controllerCommand: 16rA4.
	^ self readKeyboardData == 16rFA
]

{ #category : #initialization }
PS2Keyboard >> initialize [
	super initialize.

	mouseDataCount := modifiersAndButtons := 0.
	mouseCoord := DisplayScreen actualScreenSize // 2.
	configBits := 0.
	
	keysMapping := self class generatedEnglishKeysMapping.
	decoder :=  ScancodeDecoder new.

	self initializeHardware.
	self initializeEventsQueue.
]

{ #category : #initialization }
PS2Keyboard >> initializeEventsQueue [
	| p block |
	events := SharedQueue new.
	Computer isPharo
			   ifTrue: [ block := [ Sensor handleEvent: events next ] ]
			   ifFalse: [ block := [ Sensor processEvent: events next] ].
	p := [ block repeat] forkAt: Processor highIOPriority.
	
	p name: 'PS2Keboard shared queue poll'
]

{ #category : #initialization }
PS2Keyboard >> initializeHardware [
	self
		initializeKeyboardHardware;
		initializeMouseHardware.

"	self enableKeyboardInputBufferFullInterrupt;	not needed, commandByte: 16r47 enables all
		enableKeyboardInterface.
"
	self commandByte: 16r47.	" enable mouse and keyboard, and set scan code 1 "

]

{ #category : #initialization }
PS2Keyboard >> initializeKeyboardHardware [

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

]

{ #category : #initialization }
PS2Keyboard >> initializeMouseHardware [

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

]

{ #category : #'hardware status' }
PS2Keyboard >> inputBufferFull [
	^ self statusPort anyMask: 2
]

{ #category : #'controller commands' }
PS2Keyboard >> inputPort [
	self controllerCommand: 16rCO.
	^ self readKeyboardData.
]

{ #category : #'keyboard commands' }
PS2Keyboard >> keyboardBuffer: value [
	self controllerCommand: 16rD2.
	self keyboardCommand: value.
	
]

{ #category : #'low level protocol' }
PS2Keyboard >> keyboardCommand: cmd [
	self waitToWrite ifFalse: [^false].
	self dataPort: cmd.
	^true
]

{ #category : #'keyboard commands' }
PS2Keyboard >> keyboardId [
	self keyboardCommand: 16rF2.
	self waitKeyboardAck.
	^(self readKeyboardData bitShift: 8) bitOr: self keyboardData.
]

{ #category : #'hardware status' }
PS2Keyboard >> keyboardInhibited [
	^ (self statusPort anyMask: 16) not
]

{ #category : #'keyboard commands' }
PS2Keyboard >> keyboardLeds: value [
	self keyboardCommand: 16rED.
	self waitKeyboardAck.
	self keyboardCommand: value.
	^self waitKeyboardAck.

]

{ #category : #'hardware status' }
PS2Keyboard >> keyboardOutputBufferFull [
	^ self statusPort anyMask: 1
]

{ #category : #'keyboard commands' }
PS2Keyboard >> keyboardScanCodeSet: value [
	value == 1
		ifTrue: [self setCommandBit: 6]
		ifFalse: [self clearCommandBit: 6].
"	self keyboardCommand: 16rF0.
	self waitKeyboardAck.
	self keyboardCommand: value.
	^self waitKeyboardAck.
"
]

{ #category : #'keyboard commands' }
PS2Keyboard >> keyboardTypematicRateDelay: value [
	self keyboardCommand: 16rF3.
	self waitKeyboardAck.
	self keyboardCommand: value.
	^self waitKeyboardAck
]

{ #category : #'mouse commands' }
PS2Keyboard >> mouseBuffer: value [
	self controllerCommand: 16rD3.
	self keyboardCommand: value.
	
]

{ #category : #'mouse commands' }
PS2Keyboard >> mouseCommand: value [
	self controllerCommand: 16rD4.
	self keyboardCommand: value.
	^ self waitMouseAck.
]

{ #category : #'mouse commands' }
PS2Keyboard >> mouseCommandNoAck: value [
	self controllerCommand: 16rD4.
	self keyboardCommand: value.
]

{ #category : #'mouse commands' }
PS2Keyboard >> mouseId [
	self mouseCommand: 16rF2.
	^self readMouseData
]

{ #category : #'command byte' }
PS2Keyboard >> mouseInputBufferInterruptEnabled [
	^ self testCommandBit: 2
]

{ #category : #'hardware status' }
PS2Keyboard >> mouseOutputBufferFull [
	^ self statusPort anyMask: 32
]

{ #category : #'mouse commands' }
PS2Keyboard >> mouseResolution: value [
	^ (self mouseCommand: 16rE8) and: [self mouseCommand: value]
]

{ #category : #'mouse commands' }
PS2Keyboard >> mouseSampleRate: value [
	^ (self mouseCommand: 16rF3) and: [self mouseCommand: value]
]

{ #category : #accessing }
PS2Keyboard >> mouseScrollingEnabled [
	^ configBits anyMask: 1
]

{ #category : #'irq handling' }
PS2Keyboard >> newKeyboardControlCharEvent: char [
	modifiersAndButtons  := (modifiersAndButtons  bitOr: 16r10).
	self newKeyboardEvent: char type: EventKeyChar.
	modifiersAndButtons := modifiersAndButtons bitClear: 16r10.

]

{ #category : #'irq handling' }
PS2Keyboard >> newKeyboardDownEvent: aCharacter [
	self newKeyboardEvent: aCharacter type: EventKeyDown.
	self newKeyboardEvent: aCharacter type: EventKeyChar.

]

{ #category : #'irq handling' }
PS2Keyboard >> newKeyboardEvent: aCharacter type: byteType [
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
]

{ #category : #'irq handling' }
PS2Keyboard >> newKeyboardUpEvent: aCharacter [
	self newKeyboardEvent: aCharacter type: EventKeyUp
]

{ #category : #'irq handling' }
PS2Keyboard >> newMouseEvent [
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

]

{ #category : #'controller commands' }
PS2Keyboard >> outputPort [
	self controllerCommand: 16rDO.
	^ self readKeyboardData.
]

{ #category : #'controller commands' }
PS2Keyboard >> outputPort: value [
	self controllerCommand: 16rD1.
	self keyboardCommand: value.
	
]

{ #category : #'controller commands' }
PS2Keyboard >> outputPortLow: value [
	self controllerCommand: 16r90 + (value bitAnd: 15).
	
]

{ #category : #'hardware status' }
PS2Keyboard >> paryityError [
	^ self statusPort anyMask: 128
]

{ #category : #'mouse commands' }
PS2Keyboard >> pollMouseDataPacket [
	self mouseCommand: 16rEB.
	^self readMouseDataPacket
]

{ #category : #'controller commands' }
PS2Keyboard >> pulseOutputPortLow: value [
	self controllerCommand: 16rF0 + (value bitAnd: 15).
]

{ #category : #'low level protocol' }
PS2Keyboard >> readKeyboardData [
	self waitToReadKeyboard ifFalse: [^nil].
	^self dataPort
]

{ #category : #'low level protocol' }
PS2Keyboard >> readMouseData [
	self waitToReadMouse ifFalse: [^nil].
	^self dataPort.
]

{ #category : #'mouse commands' }
PS2Keyboard >> readMouseDataPacket [
	^ Array with: self readMouseData with: self readMouseData with: self readMouseData
]

{ #category : #'mouse commands' }
PS2Keyboard >> readMouseStatus [
	self mouseCommand: 16rE9.
	^self readMouseData
]

{ #category : #'keyboard commands' }
PS2Keyboard >> resendKeyboardCommand [
	self keyboardCommand: 16rFE.
	^ self readKeyboardData
]

{ #category : #'mouse commands' }
PS2Keyboard >> resendMouseCommand [
	^ self mouseCommand: 16rFE.
]

{ #category : #'keyboard commands' }
PS2Keyboard >> resetKeyboard [
	| answer |
	self keyboardCommand: 16rFF.
	self waitKeyboardAck ifFalse: [^false].
	(answer := self readKeyboardData) ifNil: [^ false].
	answer == 16rAA ifTrue: [^true].
	answer ~~ 16rFC ifTrue: [self report: 'Unexpected answer to reset command: ', answer hex].
	^ false
]

{ #category : #'mouse commands' }
PS2Keyboard >> resetMouse [
	| answer |
	(self mouseCommand: 16rFF) ifFalse: [^false].
	answer := self readMouseData.
	answer == 16rAA ifTrue: [^self readMouseData == 0 " mouse sends device ID after reset "].
	answer ~~ 16rFC ifTrue: [self report: 'Unexpected answer to reset command: ', answer hex].
	^ false
]

{ #category : #'command byte' }
PS2Keyboard >> scancodeTranslationEnabled [
	^ self testCommandBit: 16r40
]

{ #category : #'command byte' }
PS2Keyboard >> setCommandBit: bit [
	^ self commandByte: (self commandByte bitOr: 1 << bit)
]

{ #category : #'keyboard commands' }
PS2Keyboard >> setKeyboardDefaults [
	self keyboardCommand: 16rF6.
	^ self waitKeyboardAck
]

{ #category : #'mouse commands' }
PS2Keyboard >> setMouseDefaults [
	^ self mouseCommand: 16rF6.
]

{ #category : #'keyboard access' }
PS2Keyboard >> shiftPressed [
	^ modifiersAndButtons anyMask: 8
]

{ #category : #'I/O' }
PS2Keyboard >> statusPort [
	^ self byteAt: 4
]

{ #category : #'hardware status' }
PS2Keyboard >> systemInitialized [
	^ self statusPort anyMask: 4
]

{ #category : #'command byte' }
PS2Keyboard >> testCommandBit: mask [
	^ self commandByte anyMask: mask
]

{ #category : #'controller commands' }
PS2Keyboard >> testController [
	self controllerCommand: 16rAA.
	^ self readKeyboardData == 16r55

]

{ #category : #'keyboard commands' }
PS2Keyboard >> testKeyboardEcho [
	self keyboardCommand: 16rEE.
	^ self readKeyboardData == 16rEE
]

{ #category : #'keyboard commands' }
PS2Keyboard >> testKeyboardInterface [
	self controllerCommand: 16rAB.
	^ self readKeyboardData isZero

]

{ #category : #'mouse commands' }
PS2Keyboard >> testMouseInterface [
	self controllerCommand: 16rA9.
	^ self readKeyboardData isZero

]

{ #category : #'controller commands' }
PS2Keyboard >> testPort [
	self controllerCommand: 16rE0.
	^ self readKeyboardData
]

{ #category : #'hardware status' }
PS2Keyboard >> timeoutError [
	^ self statusPort anyMask: 64
]

{ #category : #'controller commands' }
PS2Keyboard >> version [
	self controllerCommand: 16rAD.
"	^ self readData."
]

{ #category : #'controller commands' }
PS2Keyboard >> versionNumber [
	self controllerCommand: 16rA1.
"	^ self readData."
]

{ #category : #'low level protocol' }
PS2Keyboard >> waitKeyboardAck [
	^ self readKeyboardData == 16rFA
]

{ #category : #'low level protocol' }
PS2Keyboard >> waitMouseAck [
	^ self readMouseData == 16rFA
]

{ #category : #'low level protocol' }
PS2Keyboard >> waitToReadKeyboard [
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
	
]

{ #category : #'low level protocol' }
PS2Keyboard >> waitToReadMouse [
	| delay |
	self mouseOutputBufferFull ifTrue: [^true].
	delay := Delay forMilliseconds: 1.
	250 timesRepeat: [
		delay wait.
		self mouseOutputBufferFull ifTrue: [^true]
	].
	self report: 'timedout out witing for mouse input.'.
	^false
	
]

{ #category : #'low level protocol' }
PS2Keyboard >> waitToWrite [
	| delay |
	self inputBufferFull ifFalse: [^true].
	delay := Delay forMilliseconds: 1.
	250 timesRepeat: [
		delay wait.
		self inputBufferFull ifFalse: [^true]
	].
	self report: 'timedout out witing to write.'.
	^false
	
]
