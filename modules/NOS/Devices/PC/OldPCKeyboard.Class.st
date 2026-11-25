'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #OldPCKeyboard category: 'SqueakNOS-Devices-Base'!
HardwareDevice subclass: #OldPCKeyboard
	instanceVariableNames: 'pressedKeys replyExpected lastScanCode status buttonsState mousePoint mouseCount prevScanCode underCursorForm event'
	classVariableNames: 'ShiftedTranslationTable TranslationTable'
	poolDictionaries: 'EventSensorConstants'
	category: 'SqueakNOS-Devices-Base'!
!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
ackReceived
	^ lastScanCode = 16rFA
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
acknowledge
	| read |
	read := self acknowledgePort.
	self acknowledgePort: (read bitOr: 16r80).
	self acknowledgePort: read
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
acknowledgePort
	^ self byteAt: 1
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
acknowledgePort: aByte
	^ self byteAt: 1 put: aByte
! !

!OldPCKeyboard methodsFor:  'mouse access' stamp: 'KenD 28/Jun/2026 13:32:24'!
anyButtonPressed
	"Answer whether a mouse button is being pressed."

	^self buttons > 0
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
anyModifierKeyPressed
	^ self commandKeyPressed | self controlKeyPressed | self macOptionKeyPressed
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
auxEnable
	self controllerCommand: 16rA8
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
auxEnableDevice
	self auxWriteAndWaitAck: 16rF4.
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
auxOutputBufferFull
	^ status anyMask: 16r20
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
auxSelfTest
	self controllerCommand: 16rA9.
	^ self waitData = 0
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
auxWrite: aByte
	self controllerCommand: 16rD4 data: aByte
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
auxWriteAndWaitAck: aByte
	self auxWrite: aByte.
	^self waitData = 16rFA
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
auxWriteToOutBuffer: aByte
	self controllerCommand: 16rD3 data: aByte
! !

!OldPCKeyboard methodsFor:  'mouse access' stamp: 'KenD 28/Jun/2026 13:32:24'!
blueButtonPressed
	"Answer whether only the blue mouse button is being pressed. This is the third mouse button or cmd+click on the Mac."

	^self buttons = 1
! !

!OldPCKeyboard methodsFor:  'mouse access' stamp: 'KenD 28/Jun/2026 13:32:24'!
buttons

	^ buttonsState bitAnd: 7
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
byteAt: index
	| r |
	r := super byteAt: index.
"	self report: ' at: ', index printString, ' -> ', r hex.
"	^ r
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
byteAt: index put: value
"	self report: ' at: ', index printString, ' <- ', value hex.
"	^ super byteAt: index put: value
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
checkError
	^ self parityError | self timeout
! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
checkUserInterrupt: key
	| answer |
	answer := self commandKeyPressed and: [key = $.].
	answer ifTrue: [Sensor signalUserInterrupt].
	^answer
! !

!OldPCKeyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearInput
	100 timesRepeat: [self readData ifNil: [^ self]]
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
commandKeyPressed
	^ buttonsState anyMask: 16r40
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
controlKeyPressed
	^ buttonsState anyMask: 16r10
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
controllerCommand: aByte
	^ self byteAt: 4 put: aByte
! !

!OldPCKeyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
controllerCommand: cmd data: aByte
	self controllerCommand: cmd.
	self safeDelay.
	self dataPort: aByte
! !

!OldPCKeyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
controllerSelfTest
	self controllerCommand: 16rAA.
	^ self waitData = 16r55 
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
controllerStatus
	^ self byteAt: 4
! !

!OldPCKeyboard methodsFor:  'mouse access' stamp: 'KenD 28/Jun/2026 13:32:24'!
cursorPoint: aPoint
	self hideCursor.
	self mousePoint: aPoint.
	self showCursor.

! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
dataPort
	^ self byteAt: 0
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
dataPort: aByte
	^ self byteAt: 0 put: aByte
! !

!OldPCKeyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableScanning
	^ self keyboardCommand: 16rF5
! !

!OldPCKeyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableKeyboard
	self controllerCommand: 16rAE
	
! !

!OldPCKeyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableScanning
	^ self keyboardCommand: 16rF4.

! !

!OldPCKeyboard methodsFor:  'translation' stamp: 'KenD 28/Jun/2026 13:32:24'!
extendedTranslation: scanCode
	scanCode = 75 ifTrue: [^Character value: 28].
	scanCode = 77 ifTrue: [^Character value: 29].
	scanCode = 72 ifTrue: [^Character value: 30].
	scanCode = 80 ifTrue: [^Character value: 31].
	scanCode = 71 ifTrue: [^Character value: 1].
	scanCode = 79 ifTrue: [^Character value: 4].
	scanCode = 73 ifTrue: [^Character value: 11].
	scanCode = 81 ifTrue: [^Character value: 12].
	^ Character value: 0

! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleIRQ
	self report: 'IRQ'.
	self handleKbdEvent.

! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleKbdEvent
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
! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
hideCursor
	"underCursorForm ifNotNil: [underCursorForm displayOn: Display at: mousePoint]"
	self showCursor
! !

!OldPCKeyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializationHandleIRQOn: aComputer
! !

!OldPCKeyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
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

! !

!OldPCKeyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeAux
	self
		auxEnable;
		mouseSetStandard;
		auxEnableDevice
! !

!OldPCKeyboard methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeHardware
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

! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
inputBufferFull
	^ status anyMask: 2
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isAuxPortPresent
	self auxWriteToOutBuffer: 16r5A.
	10
		timesRepeat: 
			[self readStatus.
			self nextData.
			self auxOutputBufferFull ifTrue: [^ true].
			(Delay forMilliseconds: 1) wait].
	^false
! !

!OldPCKeyboard methodsFor:  'ports' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardCommand: cmd
	
	[self dataPort: cmd.
	self waitData.
	self ackReceived ifTrue: [^ true].
	self resendReceived] whileTrue.
	^ false
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardLocked
	^ (status anyMask: 16r10) not
! !

!OldPCKeyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyboardSelfTest
	self controllerCommand: 16rAB.
	^ self waitData = 0
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
lastWriteCommand
	^ status anyMask: 8
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
leftShiftDown
	^ self leftShiftPressed
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
leftShiftPressed
	^ buttonsState anyMask: 8
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
macOptionKeyPressed
	^ false
! !

!OldPCKeyboard methodsFor:  'mouse access' stamp: 'KenD 28/Jun/2026 13:32:24'!
mousePoint: aPoint
	mousePoint := aPoint adhereTo: Display boundingBox
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
mouseSetStandard
	self auxWrite: 16rF6.
! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newKeyboardDownEvent: aCharacter
	self newKeyboardEvent: aCharacter type: EventKeyDown.
	self newKeyboardEvent: aCharacter type: EventKeyChar.

! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newKeyboardEvent: aCharacter type: byteType
	" taken from EventSensor >> #nextEventSynthesized "
	event
		at: 1 put: EventTypeKeyboard; "evt type"
		at: 2 put: Time millisecondClockValue; "time stamp"
		at: 3 put: aCharacter asciiValue; "char code"
		at: 4 put: byteType; "key press/release"
		at: 5 put: buttonsState >> 3. "modifier keys"

	Sensor processEvent: event.
	self report: event.
! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newKeyboardUpEvent: aCharacter
	self newKeyboardEvent: aCharacter type: EventKeyUp
! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
newMouseEvent
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
! !

!OldPCKeyboard methodsFor:  'commands support' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextData
	^ lastScanCode := self dataPort.

! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextKey
	^ pressedKeys next
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
outputBufferFull
	^ status anyMask: 1
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
parityError
	^ status anyMask: 16r80
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
peekKey
	^ pressedKeys peek
! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
processMouseScanCode: aByte
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
! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
processScanCode: scanCode
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


! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rawMacOptionKeyPressed
	^ false
! !

!OldPCKeyboard methodsFor:  'commands support' stamp: 'KenD 28/Jun/2026 13:32:24'!
readData
	| answer |
	self readStatus.
	self outputBufferFull ifFalse: [^ nil].
	answer := self nextData.
	^ self checkError
		ifTrue: 
			[Transcript cr; show: 'Error in #readData: ', (status printStringBase: 2).
			nil]
		ifFalse: [answer]
! !

!OldPCKeyboard methodsFor:  'commands support' stamp: 'KenD 28/Jun/2026 13:32:24'!
readStatus
	^ status := self controllerStatus
! !

!OldPCKeyboard methodsFor:  'mouse access' stamp: 'KenD 28/Jun/2026 13:32:24'!
redButtonPressed
	"Answer true if the red mouse button is being pressed. This is the first mouse button."

	^self buttons = 4
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
resendReceived
	^ lastScanCode = 16rFE
! !

!OldPCKeyboard methodsFor:  'keyboard commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetKeyboard
	^ self keyboardCommand: 16rFF.

! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
rightShiftPressed
	^ buttonsState anyMask: 8
! !

!OldPCKeyboard methodsFor:  'commands support' stamp: 'KenD 28/Jun/2026 13:32:24'!
safeDelay
	250
		timesRepeat: 
			[self handleKbdEvent.
			self inputBufferFull ifFalse: [^ self].
			(Delay forMilliseconds: 1) wait]
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
setAuxResolution: value
	self auxWriteAndWaitAck: 16rE8.
	self auxWriteAndWaitAck: value. 
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
setAuxSample: value
	self auxWriteAndWaitAck: 16rF3.
	self auxWriteAndWaitAck: value. 
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
setAuxScale11
	self auxWriteAndWaitAck: 16rE6. 
! !

!OldPCKeyboard methodsFor:  'mouse commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
setAuxScale21
	self auxWriteAndWaitAck: 16rE7. 
! !

!OldPCKeyboard methodsFor:  'controller commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
setInitialMode: auxPortPresent
	#(keyboardGenerateIRQ1 auxGenerateIRQ12 systemFlag disableKeboardInterface disableMouseInterface  scanCodeConversionToPCFormat ).
	#(1 2 4 16 32 64 ).
	self disableScanning.
	self setMode: (auxPortPresent ifTrue: [16r47] ifFalse: [16r65]).
	self enableScanning


! !

!OldPCKeyboard methodsFor:  'commands support' stamp: 'KenD 28/Jun/2026 13:32:24'!
setMode: aByte
	self controllerCommand: 16r60 data: aByte
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
shiftPressed
	^ self leftShiftPressed or: [self rightShiftPressed]
! !

!OldPCKeyboard methodsFor:  'translation' stamp: 'KenD 28/Jun/2026 13:32:24'!
shiftTranslation: scanCode
	scanCode = 16r2A & (prevScanCode ~= 16rE0) ifTrue: ["left shift"	^ 8].
	scanCode = 16r36 & (prevScanCode ~= 16rE0) ifTrue: ["right shift"	^ 8].
	scanCode = 16r38 ifTrue: ["left ALT (command key)"	^ 16r40].
	scanCode = 16r1D ifTrue: ["left CTRL"	^ 16r10].

"	Transcript show: scanCode hex; space."
	^ 0
! !

!OldPCKeyboard methodsFor:  'translation' stamp: 'KenD 28/Jun/2026 13:32:24'!
shiftedTranslation: scanCode
	^ ShiftedTranslationTable at: scanCode + 1 ifAbsent: [Character value: 0]

! !

!OldPCKeyboard methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
showCursor
"	underCursorForm := Form fromDisplay: (mousePoint extent: Cursor currentCursor extent).
	Cursor currentCursor asCursorForm displayOn: Display at: mousePoint rule: Form reverse.
"
! !

!OldPCKeyboard methodsFor:  'translation' stamp: 'KenD 28/Jun/2026 13:32:24'!
simpleTranslation: scanCode
	^ TranslationTable at: scanCode + 1 ifAbsent: [Character value: 0]


! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
testSuccessful
	^ status anyMask: 4
! !

!OldPCKeyboard methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
timeout
	^ status anyMask: 16r40
! !

!OldPCKeyboard methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
waitData
	| answer |
	2
		timesRepeat: 
			[(answer := self readData) ifNotNil: [^ answer].
			" (Delay forMilliseconds: 1) wait "].
	Transcript cr; show: ' wait data timedout.'.
	^ nil
! !

!OldPCKeyboard methodsFor:  'mouse access' stamp: 'KenD 28/Jun/2026 13:32:24'!
yellowButtonPressed
	"Answer whether only the yellow mouse button is being pressed. This is the second mouse button or option+click on the Mac."

	^self buttons = 2
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OldPCKeyboard class' category: 'SqueakNOS-Devices-Base'!
OldPCKeyboard class
	instanceVariableNames: 'ShiftedTranslationTable TranslationTable'!

!OldPCKeyboard class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
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

!OldPCKeyboard class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	self initializeTranslationTables
! !

!OldPCKeyboard class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeTranslationTables
	TranslationTable := self cCharsToArray: 
		'\000\0331234567890-=\010\t' ,
		'qwertyuiop[]\r\000as' ,
		'dfghjkl;''`\000\\zxcv' ,
		'bnm,./\000*\000 \000\201\202\203\204\205' ,
		'\206\207\210\211\212\000\000789-456+1' ,
		'230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000' ,
		'\r\000/'.
	ShiftedTranslationTable := self cCharsToArray: 
		'\000\033!!@#$%^&*()_+\010\t' ,
		'QWERTYUIOP{}\r\000AS' ,
		'DFGHJKL:"~\000|ZXCV' ,
		'BNM<>?\000*\000 \000\201\202\203\204\205' ,
		'\206\207\210\211\212\000\000789-456+1' ,
		'230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000' ,
		'\r\000/'.

! !

!OldPCKeyboard class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
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

! !

!OldPCKeyboard class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
unescapeCharacter: char
	char = $t ifTrue: [^ Character tab].
	char = $r ifTrue: [^ Character cr].
	char = $n ifTrue: [^ Character lf].
	^ char
! !


OldPCKeyboard initialize!

