Class {
	#name : #OldPCKeyboard,
	#superclass : #HardwareDevice,
	#instVars : [
		'pressedKeys',
		'replyExpected',
		'lastScanCode',
		'status',
		'buttonsState',
		'mousePoint',
		'mouseCount',
		'prevScanCode',
		'underCursorForm',
		'event'
	],
	#classVars : [
		'ShiftedTranslationTable',
		'TranslationTable'
	],
	#pools : [
		'EventSensorConstants'
	],
	#category : 'SqueakNOS-Devices-Base'
}

{ #category : #'system startup' }
OldPCKeyboard class >> cCharsToArray: aString [
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

{ #category : #'system startup' }
OldPCKeyboard class >> initialize [
	self initializeTranslationTables
]

{ #category : #'system startup' }
OldPCKeyboard class >> initializeTranslationTables [
	TranslationTable := self cCharsToArray: 
		'\000\0331234567890-=\010\t' ,
		'qwertyuiop[]\r\000as' ,
		'dfghjkl;''`\000\\zxcv' ,
		'bnm,./\000*\000 \000\201\202\203\204\205' ,
		'\206\207\210\211\212\000\000789-456+1' ,
		'230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000' ,
		'\r\000/'.
	ShiftedTranslationTable := self cCharsToArray: 
		'\000\033!@#$%^&*()_+\010\t' ,
		'QWERTYUIOP{}\r\000AS' ,
		'DFGHJKL:"~\000|ZXCV' ,
		'BNM<>?\000*\000 \000\201\202\203\204\205' ,
		'\206\207\210\211\212\000\000789-456+1' ,
		'230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000' ,
		'\r\000/'.

]

{ #category : #'system startup' }
OldPCKeyboard class >> installOn: aComputer [
	| keyboard |
	keyboard := self onPort: 16r60.
	aComputer interruptController addHandler: keyboard forIRQ: 1.
	aComputer keyboard: keyboard.
	aComputer interruptController addHandler: keyboard forIRQ: 12.
	HandMorph allInstances do: [:each |
		each hasUserInformation ifFalse: [
			each userInitials: ' ' andPicture: each userPicture]].
	Sensor eventTicklerProcess terminate.
	^ aComputer mouse: keyboard.

]

{ #category : #'system startup' }
OldPCKeyboard class >> unescapeCharacter: char [ 
	char = $t ifTrue: [^ Character tab].
	char = $r ifTrue: [^ Character cr].
	char = $n ifTrue: [^ Character lf].
	^ char
]

{ #category : #testing }
OldPCKeyboard >> ackReceived [
	^ lastScanCode = 16rFA
]

{ #category : #ports }
OldPCKeyboard >> acknowledge [
	| read |
	read := self acknowledgePort.
	self acknowledgePort: (read bitOr: 16r80).
	self acknowledgePort: read
]

{ #category : #ports }
OldPCKeyboard >> acknowledgePort [
	^ self byteAt: 1
]

{ #category : #ports }
OldPCKeyboard >> acknowledgePort: aByte [
	^ self byteAt: 1 put: aByte
]

{ #category : #'mouse access' }
OldPCKeyboard >> anyButtonPressed [
	"Answer whether a mouse button is being pressed."

	^self buttons > 0
]

{ #category : #accessing }
OldPCKeyboard >> anyModifierKeyPressed [
	^ self commandKeyPressed | self controlKeyPressed | self macOptionKeyPressed
]

{ #category : #'mouse commands' }
OldPCKeyboard >> auxEnable [
	self controllerCommand: 16rA8
]

{ #category : #'mouse commands' }
OldPCKeyboard >> auxEnableDevice [
	self auxWriteAndWaitAck: 16rF4.
]

{ #category : #testing }
OldPCKeyboard >> auxOutputBufferFull [
	^ status anyMask: 16r20
]

{ #category : #'mouse commands' }
OldPCKeyboard >> auxSelfTest [
	self controllerCommand: 16rA9.
	^ self waitData = 0
]

{ #category : #'mouse commands' }
OldPCKeyboard >> auxWrite: aByte [
	self controllerCommand: 16rD4 data: aByte
]

{ #category : #'mouse commands' }
OldPCKeyboard >> auxWriteAndWaitAck: aByte [
	self auxWrite: aByte.
	^self waitData = 16rFA
]

{ #category : #'mouse commands' }
OldPCKeyboard >> auxWriteToOutBuffer: aByte [
	self controllerCommand: 16rD3 data: aByte
]

{ #category : #'mouse access' }
OldPCKeyboard >> blueButtonPressed [
	"Answer whether only the blue mouse button is being pressed. This is the third mouse button or cmd+click on the Mac."

	^self buttons = 1
]

{ #category : #'mouse access' }
OldPCKeyboard >> buttons [

	^ buttonsState bitAnd: 7
]

{ #category : #ports }
OldPCKeyboard >> byteAt: index [
	| r |
	r := super byteAt: index.
"	self report: ' at: ', index printString, ' -> ', r hex.
"	^ r
]

{ #category : #ports }
OldPCKeyboard >> byteAt: index put: value [
"	self report: ' at: ', index printString, ' <- ', value hex.
"	^ super byteAt: index put: value
]

{ #category : #testing }
OldPCKeyboard >> checkError [
	^ self parityError | self timeout
]

{ #category : #'irq handling' }
OldPCKeyboard >> checkUserInterrupt: key [
	| answer |
	answer := self commandKeyPressed and: [key = $.].
	answer ifTrue: [Sensor signalUserInterrupt].
	^answer
]

{ #category : #'controller commands' }
OldPCKeyboard >> clearInput [
	100 timesRepeat: [self readData ifNil: [^ self]]
]

{ #category : #accessing }
OldPCKeyboard >> commandKeyPressed [
	^ buttonsState anyMask: 16r40
]

{ #category : #accessing }
OldPCKeyboard >> controlKeyPressed [
	^ buttonsState anyMask: 16r10
]

{ #category : #ports }
OldPCKeyboard >> controllerCommand: aByte [
	^ self byteAt: 4 put: aByte
]

{ #category : #'controller commands' }
OldPCKeyboard >> controllerCommand: cmd data: aByte [
	self controllerCommand: cmd.
	self safeDelay.
	self dataPort: aByte
]

{ #category : #'controller commands' }
OldPCKeyboard >> controllerSelfTest [
	self controllerCommand: 16rAA.
	^ self waitData = 16r55 
]

{ #category : #ports }
OldPCKeyboard >> controllerStatus [
	^ self byteAt: 4
]

{ #category : #'mouse access' }
OldPCKeyboard >> cursorPoint: aPoint [
	self hideCursor.
	self mousePoint: aPoint.
	self showCursor.

]

{ #category : #ports }
OldPCKeyboard >> dataPort [
	^ self byteAt: 0
]

{ #category : #ports }
OldPCKeyboard >> dataPort: aByte [
	^ self byteAt: 0 put: aByte
]

{ #category : #'keyboard commands' }
OldPCKeyboard >> disableScanning [
	^ self keyboardCommand: 16rF5
]

{ #category : #'controller commands' }
OldPCKeyboard >> enableKeyboard [
	self controllerCommand: 16rAE
	
]

{ #category : #'keyboard commands' }
OldPCKeyboard >> enableScanning [
	^ self keyboardCommand: 16rF4.

]

{ #category : #translation }
OldPCKeyboard >> extendedTranslation: scanCode [
	scanCode = 75 ifTrue: [^Character value: 28].
	scanCode = 77 ifTrue: [^Character value: 29].
	scanCode = 72 ifTrue: [^Character value: 30].
	scanCode = 80 ifTrue: [^Character value: 31].
	scanCode = 71 ifTrue: [^Character value: 1].
	scanCode = 79 ifTrue: [^Character value: 4].
	scanCode = 73 ifTrue: [^Character value: 11].
	scanCode = 81 ifTrue: [^Character value: 12].
	^ Character value: 0

]

{ #category : #'irq handling' }
OldPCKeyboard >> handleIRQ [
	self report: 'IRQ'.
	self handleKbdEvent.

]

{ #category : #'irq handling' }
OldPCKeyboard >> handleKbdEvent [
	| count |
	count := 1.
	self readStatus.
	[self outputBufferFull]
		whileTrue: 
			[self nextData.
			self checkError
				ifFalse: [self auxOutputBufferFull
					ifTrue: [self processMouseScanCode: lastScanCode]
					ifFalse: [self processScanCode: lastScanCode]].
			count := count + 1.
			count = 1000
				ifTrue: 
					[Transcript cr; show: 'Error de teclado'.
					^ self].
			self readStatus]
]

{ #category : #'irq handling' }
OldPCKeyboard >> hideCursor [
	"underCursorForm ifNotNil: [underCursorForm displayOn: Display at: mousePoint]"
	self showCursor
]

{ #category : #initialization }
OldPCKeyboard >> initializationHandleIRQOn: aComputer [
]

{ #category : #initialization }
OldPCKeyboard >> initialize [
	| auxPortPresent |
	super initialize.
	pressedKeys := SharedQueue new.
	event := Array new: 8.
	mousePoint := 320 @ 320.
	buttonsState := 0.
	mouseCount := 2.
	prevScanCode := 0.
	underCursorForm := nil.
	lastScanCode := 0.
	self clearInput.

	self setMode: 0.
	self initializeHardware.

	(auxPortPresent := true "self isAuxPortPresent") ifTrue: [
		self report: 'Detected PS/2 Mouse port'.
		self initializeAux].
	self setInitialMode: auxPortPresent

]

{ #category : #initialization }
OldPCKeyboard >> initializeAux [
	self
		auxEnable;
		mouseSetStandard;
		auxEnableDevice
]

{ #category : #initialization }
OldPCKeyboard >> initializeHardware [
	self report: 'Performing keyboard initialization'.
	self controllerSelfTest
		ifFalse: 
			[self report: 'controller self test: failed.'.
			^ false].
	self report: 'controller self test: Ok'.
	self keyboardSelfTest
		ifFalse: 
			[self report: 'keyboard self test: failed.'.
			^ false].
	self report: 'keyboard self test: Ok'.
	self enableKeyboard.
	self report: 'keyboard enabled'.
	self resetKeyboard. 
	self report: 'keyboard reset'.

]

{ #category : #testing }
OldPCKeyboard >> inputBufferFull [
	^ status anyMask: 2
]

{ #category : #testing }
OldPCKeyboard >> isAuxPortPresent [
	self auxWriteToOutBuffer: 16r5A.
	10
		timesRepeat: 
			[self readStatus.
			self nextData.
			self auxOutputBufferFull ifTrue: [^ true].
			(Delay forMilliseconds: 1) wait].
	^false
]

{ #category : #ports }
OldPCKeyboard >> keyboardCommand: cmd [ 
	
	[self dataPort: cmd.
	self waitData.
	self ackReceived ifTrue: [^ true].
	self resendReceived] whileTrue.
	^ false
]

{ #category : #testing }
OldPCKeyboard >> keyboardLocked [
	^ (status anyMask: 16r10) not
]

{ #category : #'controller commands' }
OldPCKeyboard >> keyboardSelfTest [
	self controllerCommand: 16rAB.
	^ self waitData = 0
]

{ #category : #testing }
OldPCKeyboard >> lastWriteCommand [
	^ status anyMask: 8
]

{ #category : #accessing }
OldPCKeyboard >> leftShiftDown [
	^ self leftShiftPressed
]

{ #category : #accessing }
OldPCKeyboard >> leftShiftPressed [
	^ buttonsState anyMask: 8
]

{ #category : #accessing }
OldPCKeyboard >> macOptionKeyPressed [
	^ false
]

{ #category : #'mouse access' }
OldPCKeyboard >> mousePoint: aPoint [
	mousePoint := aPoint adhereTo: Display boundingBox
]

{ #category : #'mouse commands' }
OldPCKeyboard >> mouseSetStandard [
	self auxWrite: 16rF6.
]

{ #category : #'irq handling' }
OldPCKeyboard >> newKeyboardDownEvent: aCharacter [
	self newKeyboardEvent: aCharacter type: EventKeyDown.
	self newKeyboardEvent: aCharacter type: EventKeyChar.

]

{ #category : #'irq handling' }
OldPCKeyboard >> newKeyboardEvent: aCharacter type: byteType [
	" taken from EventSensor >> #nextEventSynthesized "
	event
		at: 1 put: EventTypeKeyboard; "evt type"
		at: 2 put: Time millisecondClockValue; "time stamp"
		at: 3 put: aCharacter asciiValue; "char code"
		at: 4 put: byteType; "key press/release"
		at: 5 put: buttonsState >> 3. "modifier keys"

	Sensor processEvent: event.
	self report: event.
]

{ #category : #'irq handling' }
OldPCKeyboard >> newKeyboardUpEvent: aCharacter [
	self newKeyboardEvent: aCharacter type: EventKeyUp
]

{ #category : #'irq handling' }
OldPCKeyboard >> newMouseEvent [
	| modifiers buttons mapped |
	modifiers := buttonsState bitShift: -3.
	buttons := buttonsState bitAnd: 7.
	mapped := Sensor mapButtons: buttons modifiers: modifiers.
	event
		at: 1 put: EventTypeMouse;
		at: 2 put: Time millisecondClockValue;
		at: 3 put: mousePoint x;
		at: 4 put: mousePoint y;
		at: 5 put: mapped;
		at: 6 put: modifiers.
	Sensor processEvent: event.
	self report: event.
]

{ #category : #'commands support' }
OldPCKeyboard >> nextData [
	^ lastScanCode := self dataPort.

]

{ #category : #accessing }
OldPCKeyboard >> nextKey [
	^ pressedKeys next
]

{ #category : #testing }
OldPCKeyboard >> outputBufferFull [
	^ status anyMask: 1
]

{ #category : #testing }
OldPCKeyboard >> parityError [
	^ status anyMask: 16r80
]

{ #category : #accessing }
OldPCKeyboard >> peekKey [
	^ pressedKeys peek
]

{ #category : #'irq handling' }
OldPCKeyboard >> processMouseScanCode: aByte [
	| scanCode |
	scanCode := aByte.
	mouseCount := mouseCount + 1.
	mouseCount = 1 ifTrue: [ "button state"
		buttonsState := (((buttonsState bitClear: 7)
			bitOr: (scanCode bitAnd: 2))
			bitOr: (scanCode bitAnd: 1) << 2)
			bitOr: (scanCode bitAnd: 4) >> 2.].
	mouseCount = 2 ifTrue: [ "x delta"	
		scanCode > 127 ifTrue: [scanCode := scanCode - 256].
		self hideCursor.
		self mousePoint: scanCode @ 0 + mousePoint].
	mouseCount = 3 ifTrue: [ "y delta"
		scanCode > 127 ifTrue: [scanCode := scanCode - 256].
		self mousePoint: mousePoint - (0 @ scanCode).
		mouseCount := 0.
		self showCursor].
	self newMouseEvent
]

{ #category : #'irq handling' }
OldPCKeyboard >> processScanCode: scanCode [
	| key code |
	scanCode = 0 | (scanCode = 16rFF)	" extended keys "
		ifTrue: 
			[prevScanCode := 0.
			^ self].
	(scanCode anyMask: 16r80)
		ifTrue: "key up"
			[scanCode = 16rE0 | (scanCode = 16rE1)	" special keys (SysReq) "
				ifTrue: 
					[prevScanCode := scanCode.
					^ self].
			code := scanCode bitClear: 16r80.
			(key := self simpleTranslation: code) asciiValue = 0
				ifTrue: [buttonsState := buttonsState bitClear: (self shiftTranslation: code)]
				ifFalse: [self newKeyboardUpEvent: key].
			prevScanCode := scanCode.
			^ self]
		ifFalse: "key down"
			[prevScanCode = 16rE0
				ifTrue: [key := self extendedTranslation: scanCode]
				ifFalse: 
					[key := self shiftPressed
								ifTrue: [self shiftedTranslation: scanCode]
								ifFalse: [self simpleTranslation: scanCode].
					key asciiValue = 0
					 ifTrue: [buttonsState := buttonsState bitOr: (self shiftTranslation: scanCode)]].
				key asciiValue = 0 ifFalse: [self newKeyboardDownEvent: key]. 
				prevScanCode := 0].


]

{ #category : #accessing }
OldPCKeyboard >> rawMacOptionKeyPressed [
	^ false
]

{ #category : #'commands support' }
OldPCKeyboard >> readData [
	| answer |
	self readStatus.
	self outputBufferFull ifFalse: [^ nil].
	answer := self nextData.
	^ self checkError
		ifTrue: 
			[Transcript cr; show: 'Error in #readData: ', (status printStringBase: 2).
			nil]
		ifFalse: [answer]
]

{ #category : #'commands support' }
OldPCKeyboard >> readStatus [
	^ status := self controllerStatus
]

{ #category : #'mouse access' }
OldPCKeyboard >> redButtonPressed [
	"Answer true if the red mouse button is being pressed. This is the first mouse button."

	^self buttons = 4
]

{ #category : #testing }
OldPCKeyboard >> resendReceived [
	^ lastScanCode = 16rFE
]

{ #category : #'keyboard commands' }
OldPCKeyboard >> resetKeyboard [
	^ self keyboardCommand: 16rFF.

]

{ #category : #accessing }
OldPCKeyboard >> rightShiftPressed [
	^ buttonsState anyMask: 8
]

{ #category : #'commands support' }
OldPCKeyboard >> safeDelay [
	250
		timesRepeat: 
			[self handleKbdEvent.
			self inputBufferFull ifFalse: [^ self].
			(Delay forMilliseconds: 1) wait]
]

{ #category : #'mouse commands' }
OldPCKeyboard >> setAuxResolution: value [
	self auxWriteAndWaitAck: 16rE8.
	self auxWriteAndWaitAck: value. 
]

{ #category : #'mouse commands' }
OldPCKeyboard >> setAuxSample: value [
	self auxWriteAndWaitAck: 16rF3.
	self auxWriteAndWaitAck: value. 
]

{ #category : #'mouse commands' }
OldPCKeyboard >> setAuxScale11 [
	self auxWriteAndWaitAck: 16rE6. 
]

{ #category : #'mouse commands' }
OldPCKeyboard >> setAuxScale21 [
	self auxWriteAndWaitAck: 16rE7. 
]

{ #category : #'controller commands' }
OldPCKeyboard >> setInitialMode: auxPortPresent [
	#(keyboardGenerateIRQ1 auxGenerateIRQ12 systemFlag disableKeboardInterface disableMouseInterface  scanCodeConversionToPCFormat ).
	#(1 2 4 16 32 64 ).
	self disableScanning.
	self setMode: (auxPortPresent ifTrue: [16r47] ifFalse: [16r65]).
	self enableScanning


]

{ #category : #'commands support' }
OldPCKeyboard >> setMode: aByte [
	self controllerCommand: 16r60 data: aByte
]

{ #category : #accessing }
OldPCKeyboard >> shiftPressed [
	^ self leftShiftPressed or: [self rightShiftPressed]
]

{ #category : #translation }
OldPCKeyboard >> shiftTranslation: scanCode [
	scanCode = 16r2A & (prevScanCode ~= 16rE0) ifTrue: ["left shift"	^ 8].
	scanCode = 16r36 & (prevScanCode ~= 16rE0) ifTrue: ["right shift"	^ 8].
	scanCode = 16r38 ifTrue: ["left ALT (command key)"	^ 16r40].
	scanCode = 16r1D ifTrue: ["left CTRL"	^ 16r10].

"	Transcript show: scanCode hex; space."
	^ 0
]

{ #category : #translation }
OldPCKeyboard >> shiftedTranslation: scanCode [
	^ ShiftedTranslationTable at: scanCode + 1 ifAbsent: [Character value: 0]

]

{ #category : #'irq handling' }
OldPCKeyboard >> showCursor [
"	underCursorForm := Form fromDisplay: (mousePoint extent: Cursor currentCursor extent).
	Cursor currentCursor asCursorForm displayOn: Display at: mousePoint rule: Form reverse.
"
]

{ #category : #translation }
OldPCKeyboard >> simpleTranslation: scanCode [
	^ TranslationTable at: scanCode + 1 ifAbsent: [Character value: 0]


]

{ #category : #testing }
OldPCKeyboard >> testSuccessful [
	^ status anyMask: 4
]

{ #category : #testing }
OldPCKeyboard >> timeout [
	^ status anyMask: 16r40
]

{ #category : #accessing }
OldPCKeyboard >> waitData [
	| answer |
	2
		timesRepeat: 
			[(answer := self readData) ifNotNil: [^ answer].
			" (Delay forMilliseconds: 1) wait "].
	Transcript cr; show: ' wait data timedout.'.
	^ nil
]

{ #category : #'mouse access' }
OldPCKeyboard >> yellowButtonPressed [
	"Answer whether only the yellow mouse button is being pressed. This is the second mouse button or option+click on the Mac."

	^self buttons = 2
]
