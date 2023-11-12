Class {
	#name : #USBUHCIController,
	#superclass : #HardwareDevice,
	#instVars : [
		'frameList'
	],
	#category : #'SqueakNOS-Devices-USB'
}

{ #category : #'as yet unclassified' }
USBUHCIController class >> classCode [
	^12
]

{ #category : #'as yet unclassified' }
USBUHCIController class >> classSubCode [
	^3
]

{ #category : #'as yet unclassified' }
USBUHCIController class >> installOn: aComputer [
	| pciEntry |
	pciEntry := PCIBusEntry allValid
		detect: [:e |
			e classCode == self classCode and: [
			e classSubCode == self classSubCode and: [
			e programmingInterface == self programmingInterface]]]
		ifNone: [^ self].

	^ self onPCIEntry: pciEntry computer: aComputer.

]

{ #category : #'as yet unclassified' }
USBUHCIController class >> onPCIEntry: aPCIBusEntry computer: aComputer [
	| answer |
	answer := self onPort: aPCIBusEntry allIORanges first key.

	aPCIBusEntry
		enableBusMastering;
		enableIO;
		" enable IRQ routing (legacy support)"
		configShort: 16rC0 put: ((aPCIBusEntry configShort: 16rC0) bitOr: 1 << 13).

	" copyed from GRUB, not sure if needed or not:"
	aPCIBusEntry latencyTimer < 32 ifTrue: [aPCIBusEntry latencyTimer: 32].

	aComputer interruptController
		addHandler: answer
		forIRQ: aPCIBusEntry interruptLine.

	aComputer usbUHCIController: answer.
	^ answer


]

{ #category : #'as yet unclassified' }
USBUHCIController class >> programmingInterface [
	^0
]

{ #category : #'accessing - command register' }
USBUHCIController >> acknowledgeForceGlobalResume [
	^self clearCommandBit: 4
]

{ #category : #'accessing - command register' }
USBUHCIController >> clearCommandBit: bit [
	^ self command: (self command bitClear: 1 << bit)
]

{ #category : #'accessing - frame list' }
USBUHCIController >> clearFrameListAt: index [
	self frameListValueAt: index put: 1	" 1 = termiator "
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> clearInterruptBit: bit [
	^ self interruptEnable: (self interruptEnable bitClear: 1 << bit)

]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> clearPort1ConnectStatusChange [
	^self setPort1ControlBit: 1
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> clearPort1ControlBit: bit [
	^ self port1StatusControl: (self port1StatusControl bitClear: 1 << bit)
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> clearPort1EnableStatusChange [
	^self setPort1ControlBit: 3
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> clearPort2ConnectStatusChange [
	^self setPort2ControlBit: 1
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> clearPort2ControlBit: bit [
	^ self port2StatusControl: (self port2StatusControl bitClear: 1 << bit)
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> clearPort2EnableStatusChange [
	^self setPort2ControlBit: 3
]

{ #category : #'accessing - registers' }
USBUHCIController >> command [
	^self shortAt: 0
]

{ #category : #'accessing - registers' }
USBUHCIController >> command: anInteger [
	^self shortAt: 0 put: anInteger
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> disableAllInterrupts [
	self interruptEnable: 0
]

{ #category : #'accessing - command register' }
USBUHCIController >> disableConfigureFlag [
	^self clearCommandBit: 6
]

{ #category : #'accessing - command register' }
USBUHCIController >> disableGlobalReset [
	^self clearCommandBit: 2
]

{ #category : #'accessing - command register' }
USBUHCIController >> disableGlobalSuspendMode [
	^self setCommandBit: 3

]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> disableInterruptOnComplete [
	self clearInterruptBit: 2
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort1 [
	^self clearPort1ControlBit: 2
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort1Reset [
	self clearPort1ControlBit: 9
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort1ResumeSignaling [
	self clearPort1ControlBit: 6
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort1Suspend [
	self clearPort1ControlBit: 12
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort2 [
	^self clearPort2ControlBit: 2
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort2Reset [
	self clearPort2ControlBit: 9
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort2ResumeSignaling [
	self clearPort2ControlBit: 6
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> disablePort2Suspend [
	self clearPort2ControlBit: 12
]

{ #category : #'accessing - command register' }
USBUHCIController >> disableScheduling [
	^self clearCommandBit: 0
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> disableShortPacketInterrupt [
	self clearInterruptBit: 3
]

{ #category : #'accessing - command register' }
USBUHCIController >> disableSoftwareDebug [
	^self clearCommandBit: 5
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> disableTimeoutCRCInterrupt [
	self clearInterruptBit: 0
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> enableAllInterrupts [
	self interruptEnable: 2r1111
]

{ #category : #'accessing - command register' }
USBUHCIController >> enableConfigureFlag [
	^self setCommandBit: 6
]

{ #category : #'accessing - command register' }
USBUHCIController >> enableGlobalReset [
	^self setCommandBit: 2
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> enableInterruptOnComplete [
	self setInterruptBit: 2
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort1 [
	^self setPort1ControlBit: 2
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort1Reset [
	self setPort1ControlBit: 9
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort1ResumeSignaling [
	self setPort1ControlBit: 6
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort1Suspend [
	self setPort1ControlBit: 12
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort2 [
	^self setPort2ControlBit: 2
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort2Reset [
	self setPort2ControlBit: 9
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort2ResumeSignaling [
	self setPort2ControlBit: 6
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> enablePort2Suspend [
	self setPort2ControlBit: 12
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> enableResumeInterrupt [
	self setInterruptBit: 1
]

{ #category : #'accessing - command register' }
USBUHCIController >> enableScheduling [
	^self setCommandBit: 0
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> enableShortPacketInterrupt [
	self setInterruptBit: 3
]

{ #category : #'accessing - command register' }
USBUHCIController >> enableSoftwareDebug [
	^self setCommandBit: 5
]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> enableTimeoutCRCInterrupt [
	self setInterruptBit: 0
]

{ #category : #'accessing - status' }
USBUHCIController >> errorInterruptPending [
	^self testStatusBit: 1
]

{ #category : #'accessing - command register' }
USBUHCIController >> forceGlobalResumeRequested [
	^self testCommandBit: 4
]

{ #category : #'accessing - frame list' }
USBUHCIController >> frameList [
	^ frameList
]

{ #category : #'accessing - frame list' }
USBUHCIController >> frameListAddressAt: index [
	^ ExternalAddress fromInteger: ((self frameListValueAt: index) bitClear: 2r1111)
]

{ #category : #'accessing - frame list' }
USBUHCIController >> frameListAt: index [
	(self isTerminatorAt: index) ifTrue: [^nil].
	^ (self isPointingToQueueHeadAt: index) 
		ifTrue: [USBQueueHead fromHandle: (self frameListAddressAt: index)]
		ifFalse: [USBTransferDescriptor fromHandle: (self frameListAddressAt: index)]
]

{ #category : #'accessing - frame list' }
USBUHCIController >> frameListAt: index put: aListElement [
	aListElement ifNil: [^ self clearFrameListAt: index].
	self frameListValueAt: index put: aListElement address.	" this clears the [next] terminator flag "
	aListElement isQueueHead
		ifTrue: [self pointToQueueHeadAt: index]
		ifFalse: [self pointToTransferDescriptorAt: index]

]

{ #category : #'accessing - registers' }
USBUHCIController >> frameListBaseAddress [
	^self longAt: 8
]

{ #category : #'accessing - registers' }
USBUHCIController >> frameListBaseAddress: anInteger [
	^self longAt: 8 put: anInteger
]

{ #category : #'accessing - frame list' }
USBUHCIController >> frameListValueAt: index [
	^frameList unsignedLongAt: index * 4 - 3
]

{ #category : #'accessing - frame list' }
USBUHCIController >> frameListValueAt: index put: anInteger [
	frameList unsignedLongAt: index * 4 - 3 put: anInteger
]

{ #category : #'accessing - registers' }
USBUHCIController >> frameNumber [
	^self shortAt: 6
]

{ #category : #'accessing - registers' }
USBUHCIController >> frameNumber: anInteger [
	^self shortAt: 6 put: anInteger
]

{ #category : #'irq handling' }
USBUHCIController >> handleIRQ [
	self report: 'Command: ', self command hex, ' Status: ', self status hex.
	self resetStatus.

]

{ #category : #'accessing - command register' }
USBUHCIController >> hasBeenConfigured [
	^self testCommandBit: 6
]

{ #category : #'accessing - command register' }
USBUHCIController >> hasSchedulingEnabled [
	^self testCommandBit: 0
]

{ #category : #'accessing - command register' }
USBUHCIController >> hasSoftwareDebugEnabled [
	^self testCommandBit: 5
]

{ #category : #'accessing - command register' }
USBUHCIController >> hostControllerResetHasFinished [
	^(self testCommandBit: 1) not
]

{ #category : #initialization }
USBUHCIController >> initialize [
	| delay10ms |
	delay10ms := Delay forMilliseconds: 10.
	self enableGlobalReset.
	delay10ms wait.
	self
		disableGlobalReset;
		startHostControllerReset.
	[self hostControllerResetHasFinished] whileFalse: [delay10ms wait].
	self
		disableScheduling;
		disableAllInterrupts;
		disableConfigureFlag;
		initializeFrameList;
		maxPacketSize: 64;
		enableAllInterrupts;
		enableScheduling;
		enableConfigureFlag.
	self initializeRootHubs.
]

{ #category : #initialization }
USBUHCIController >> initializeFrameList [
	frameList := ExternalAddress allocate: 4*1024 aligned: 4*1024.
	1 to: 1024 do: [:i | self clearFrameListAt: i].
	self frameListBaseAddress: frameList asInteger.
	self frameNumber: 0.
]

{ #category : #initialization }
USBUHCIController >> initializeRootHubs [
	"
\ We mustn't wait more than 3 ms between releasing the reset and enabling
\ the port to begin the SOF stream, otherwise some devices (e.g. pl2303)
\ will go into suspend state and then not respond to set-address.
: reset-root-hub-port  ( port -- )
   dup >r  portsc@ h# 20e invert and    ( value r: port )  \ Clear reset, enable, status
   dup h# 200 or  r@ portsc!	        ( value r: port )  \ Reset port
   d# 30 ms                             ( value r: port )  \ > 10 ms - reset time
   dup r@ portsc!                       ( value r: port )  \ Release reset
   1 ms                                 ( value r: port )  \ > 5.3 uS - reconnect time
   h# e or  r> portsc!	                ( )  \ Enable port and clear status
;

: probe-root-hub-port  ( port -- )
   dup reset-root-hub-port
   dup portsc@ 1 and 0=  if  drop exit  then		\ No device-connected
   ok-to-add-device? 0=  if  drop exit  then		\ Can't add another device

   new-address				( port dev )
   over portsc@ 100 and  if  speed-low  else  speed-full  then
   over di-speed!			( port dev )

   0 set-target				( port dev )    \ Address it as device 0
   dup set-address  if  2drop exit  then ( port dev )	\ Assign it usb addr dev
   dup set-target			( port dev )    \ Address it as device dev
   make-device-node			( )
;

external
: power-ports  ( -- )  ;

: probe-root-hub  ( -- )
   \ Set active-package so device nodes can be added and removed
   my-self ihandle>phandle push-package

   alloc-pkt-buf
   2 0  do
      i portsc@ h# a and  if
         i rm-obsolete-children			\ Remove obsolete device nodes
         i ['] probe-root-hub-port catch  if
            drop .' Failed to probe root port ' i .d cr
         then
         i portsc@ i portsc!			\ Clear change bits
      then
   loop
   free-pkt-buf

   pop-package
;
	"
]

{ #category : #'accessing - registers' }
USBUHCIController >> interruptEnable [
	^self shortAt: 4
]

{ #category : #'accessing - registers' }
USBUHCIController >> interruptEnable: anInteger [
	^self shortAt: 4 put: anInteger
]

{ #category : #'accessing - status' }
USBUHCIController >> interruptPending [
	^self testStatusBit: 0
]

{ #category : #'accessing - status' }
USBUHCIController >> isHalted [
	^self testStatusBit: 5
]

{ #category : #'accessing - command register' }
USBUHCIController >> isInGlobalSuspendMode [
	^self testCommandBit: 3
]

{ #category : #'accessing - frame list' }
USBUHCIController >> isPointingToQueueHeadAt: index [
	^ (self frameListValueAt: index) anyMask: 2
]

{ #category : #'accessing - frame list' }
USBUHCIController >> isPointingToTransferDescriptorAt: index [
	^ ((self frameListValueAt: index) anyMask: 2) not
]

{ #category : #'accessing - frame list' }
USBUHCIController >> isTerminatorAt: index [
	^ (self frameListValueAt: index) anyMask: 1
]

{ #category : #'accessing - command register' }
USBUHCIController >> maxPacketSize [
	^(self testCommandBit: 7)
		ifTrue: [64]
		ifFalse: [32]
]

{ #category : #'accessing - command register' }
USBUHCIController >> maxPacketSize: anInteger [
	anInteger == 32 ifTrue: [^self clearCommandBit: 7].
	anInteger == 64 ifTrue: [^self setCommandBit: 7].
	self error: 'Invalid maxPacketSize. Only 32 or 64 bytes allowed'
]

{ #category : #'accessing - frame list' }
USBUHCIController >> pointToQueueHeadAt: index [
	^ self
		frameListValueAt: index
		put: ((self frameListValueAt: index) bitOr: 2) 
]

{ #category : #'accessing - frame list' }
USBUHCIController >> pointToQueueHeaderAt: index [
	^ self
		frameListValueAt: index
		put: ((self frameListValueAt: index) bitOr: 2) 
]

{ #category : #'accessing - frame list' }
USBUHCIController >> pointToTransferDescriptorAt: index [
	^ self
		frameListValueAt: index
		put: ((self frameListValueAt: index) bitAnd: 2 bitInvert) 
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port1ConnectStatusHasChanged [
	^self testPort1StatusBit: 1
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port1EnableStatusHasChanged [
	^self testPort1StatusBit: 3
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port1HasDeviceConnected [
	^self testPort1StatusBit: 0
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port1HasLowSpeedDeviceAttached [
	^self testPort1StatusBit: 8
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port1IsReset [
	^self testPort1StatusBit: 9
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port1IsSuspended [
	^self testPort1StatusBit: 12
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port1LineStatus [
	^(self testPort1StatusBit: 5) * 2 + (self testPort1StatusBit: 4)
]

{ #category : #'accessing - registers' }
USBUHCIController >> port1StatusControl [
	^self shortAt: 16
]

{ #category : #'accessing - registers' }
USBUHCIController >> port1StatusControl: anInteger [
	^self shortAt: 16 put: anInteger
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port2ConnectStatusHasChanged [
	^self testPort2StatusBit: 1
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port2EnableStatusHasChanged [
	^self testPort2StatusBit: 3
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port2HasDeviceConnected [
	^self testPort2StatusBit: 0
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port2HasLowSpeedDeviceAttached [
	^self testPort2StatusBit: 8
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port2IsReset [
	^self testPort2StatusBit: 9
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port2IsSuspended [
	^self testPort2StatusBit: 12
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> port2LineStatus [
	^(self testPort2StatusBit: 5) * 2 + (self testPort2StatusBit: 4)
]

{ #category : #'accessing - registers' }
USBUHCIController >> port2StatusControl [
	^self shortAt: 18
]

{ #category : #'accessing - registers' }
USBUHCIController >> port2StatusControl: anInteger [
	^self shortAt: 18 put: anInteger
]

{ #category : #'accessing - registers' }
USBUHCIController >> power1StatusControl [
	^self shortAt: 16
]

{ #category : #'accessing - registers' }
USBUHCIController >> power1StatusControl: anInteger [
	^self shortAt: 16 put: anInteger
]

{ #category : #'accessing - registers' }
USBUHCIController >> power2StatusControl [
	^self shortAt: 18
]

{ #category : #'accessing - registers' }
USBUHCIController >> power2StatusControl: anInteger [
	^self shortAt: 18 put: anInteger
]

{ #category : #'accessing - status' }
USBUHCIController >> processError [
	^self testStatusBit: 4
]

{ #category : #'accessing - status' }
USBUHCIController >> resetStatus [
	" Writing a 1 clears that bit status "
	^self status: self status
]

{ #category : #'accessing - status' }
USBUHCIController >> resumeRequestedByDevice [
	^self testStatusBit: 2
]

{ #category : #'accessing - command register' }
USBUHCIController >> setCommandBit: bit [
	^ self command: (self command bitOr: 1 << bit)

]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> setInterruptBit: bit [
	^ self interruptEnable: (self interruptEnable bitOr: 1 << bit)

]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> setPort1ControlBit: bit [
	^ self port1StatusControl: (self port1StatusControl bitOr: 1 << bit)

]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> setPort2ControlBit: bit [
	^ self port2StatusControl: (self port2StatusControl bitOr: 1 << bit)

]

{ #category : #'accessing - command register' }
USBUHCIController >> startHostControllerReset [
	^self setCommandBit: 1
]

{ #category : #'accessing - registers' }
USBUHCIController >> startOfFrameModify [
	^self byteAt: 12
]

{ #category : #'accessing - registers' }
USBUHCIController >> startOfFrameModify: anInteger [
	^self byteAt: 12 put: anInteger
]

{ #category : #'accessing - registers' }
USBUHCIController >> status [
	^self shortAt: 2
]

{ #category : #'accessing - registers' }
USBUHCIController >> status: anInteger [
	^self shortAt: 2 put: anInteger
]

{ #category : #'accessing - status' }
USBUHCIController >> systemError [
	^self testStatusBit: 3
]

{ #category : #'accessing - command register' }
USBUHCIController >> testCommandBit: bit [
	^ self command anyMask: 1 << bit
]

{ #category : #initialization }
USBUHCIController >> testGetDeviceDescriptor [
	| qh tdSetup tdData tdStatus buf |
	self enablePort1Reset.
	(Delay forMilliseconds: 10) wait.
	self disablePort1Reset.
	self enablePort1.
	self clearPort1ConnectStatusChange; clearPort1EnableStatusChange.

	qh := USBQueueHead externalNew.
	tdSetup := USBTransferDescriptor externalNew.
	tdData := USBTransferDescriptor externalNew.
	tdStatus := USBTransferDescriptor externalNew.
	buf := ExternalAddress allocate: 2000.

	qh beTerminator; beEmpty; next: qh.

	1 to: 1024 do: [:i | self frameListAt: i put: qh].

	tdSetup next: tdData.
	tdData next: tdStatus.

	tdSetup beData0; beSetup; activate; errorCount: 3; bufferPointer: buf asInteger; enableInterruptOnComplete.
	tdData beData1; beInput; activate; errorCount: 3; bufferPointer: buf asInteger; enableInterruptOnComplete.
	tdStatus beData1; beOutput; activate; errorCount: 3; beTerminator; enableInterruptOnComplete.

	tdSetup maxLength: 8.
	tdData maxLength: 1000.

	buf
		byteAt: 1 put: 16r80;		" Input. Standard. Device "
		byteAt: 2 put: 6;			" GET_DESCRIPTOR "
		unsignedByteAt: 3 put: 0;	" wValue: idx"
		unsignedByteAt: 4 put: 1;	" wValue: DEVICE"
		unsignedShortAt: 5 put: 0;
		unsignedShortAt: 7 put: 18.

	qh first: tdSetup.

	^ Array with: qh with: buf.
]

{ #category : #initialization }
USBUHCIController >> testGetStringDescriptor: idx [
	| td buf |
	td := USBTransferDescriptor externalNew.
	buf := ExternalAddress allocate: 1280.
	td bufferPointer: buf asInteger.
	td packetIdentification: 16r2D.
	td maxLength: 1280.
	td errorCount: 3.
	td activate.
	buf
		byteAt: 1 put: 16r80;			" bmRequestType: Direction=Device to Host | Type=Standard | Recipient=Device "
		byteAt: 2 put: 6;				" bRequest: GET_DESCRIPTOR "
		unsignedByteAt: 3 put: idx;	" wValue: idx"
		unsignedByteAt: 4 put: 3;	" wValue: STRING"
		unsignedShortAt: 5 put: 0;	" wIndex: LANGUAGE"
		unsignedShortAt: 7 put: 1000." wLength: 1000 "
	self frameListAt: 90 put: td.
	^ Array with: td with: buf.

]

{ #category : #initialization }
USBUHCIController >> testInput [
	| td buf |
	td := USBTransferDescriptor externalNew.
	buf := ExternalAddress allocate: 1500.
	td bufferPointer: buf asInteger.
	td beInput.
	td maxLength: 1280.
	td errorCount: 3.
	td enableInterruptOnComplete.
	td beTerminator.
	td activate.
	self frameListAt: 100 put: td.
	^ Array with: td with: buf.

]

{ #category : #'accessing - interrupt register' }
USBUHCIController >> testInterruptBit: bit [
	^ self interruptEnable anyMask: 1 << bit
]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> testPort1StatusBit: bit [
	^ self port1StatusControl anyMask: 1 << bit

]

{ #category : #'accessing - port status/controll' }
USBUHCIController >> testPort2StatusBit: bit [
	^ self port2StatusControl anyMask: 1 << bit

]

{ #category : #'accessing - status' }
USBUHCIController >> testStatusBit: bit [
	^ self status anyMask: 1 << bit
]
