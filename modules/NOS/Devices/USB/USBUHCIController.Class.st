'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #USBUHCIController category: 'SqueakNOS-Devices-USB'!
HardwareDevice subclass: #USBUHCIController
	instanceVariableNames: 'frameList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-USB'!
!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
acknowledgeForceGlobalResume
	^self clearCommandBit: 4
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearCommandBit: bit
	^ self command: (self command bitClear: 1 << bit)
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearFrameListAt: index
	self frameListValueAt: index put: 1	" 1 = termiator "
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearInterruptBit: bit
	^ self interruptEnable: (self interruptEnable bitClear: 1 << bit)

! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearPort1ConnectStatusChange
	^self setPort1ControlBit: 1
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearPort1ControlBit: bit
	^ self port1StatusControl: (self port1StatusControl bitClear: 1 << bit)
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearPort1EnableStatusChange
	^self setPort1ControlBit: 3
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearPort2ConnectStatusChange
	^self setPort2ControlBit: 1
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearPort2ControlBit: bit
	^ self port2StatusControl: (self port2StatusControl bitClear: 1 << bit)
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearPort2EnableStatusChange
	^self setPort2ControlBit: 3
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
command
	^self shortAt: 0
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
command: anInteger
	^self shortAt: 0 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableAllInterrupts
	self interruptEnable: 0
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableConfigureFlag
	^self clearCommandBit: 6
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableGlobalReset
	^self clearCommandBit: 2
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableGlobalSuspendMode
	^self setCommandBit: 3

! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableInterruptOnComplete
	self clearInterruptBit: 2
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort1
	^self clearPort1ControlBit: 2
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort1Reset
	self clearPort1ControlBit: 9
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort1ResumeSignaling
	self clearPort1ControlBit: 6
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort1Suspend
	self clearPort1ControlBit: 12
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort2
	^self clearPort2ControlBit: 2
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort2Reset
	self clearPort2ControlBit: 9
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort2ResumeSignaling
	self clearPort2ControlBit: 6
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
disablePort2Suspend
	self clearPort2ControlBit: 12
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableScheduling
	^self clearCommandBit: 0
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableShortPacketInterrupt
	self clearInterruptBit: 3
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableSoftwareDebug
	^self clearCommandBit: 5
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableTimeoutCRCInterrupt
	self clearInterruptBit: 0
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableAllInterrupts
	self interruptEnable: 2r1111
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableConfigureFlag
	^self setCommandBit: 6
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableGlobalReset
	^self setCommandBit: 2
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableInterruptOnComplete
	self setInterruptBit: 2
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort1
	^self setPort1ControlBit: 2
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort1Reset
	self setPort1ControlBit: 9
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort1ResumeSignaling
	self setPort1ControlBit: 6
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort1Suspend
	self setPort1ControlBit: 12
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort2
	^self setPort2ControlBit: 2
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort2Reset
	self setPort2ControlBit: 9
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort2ResumeSignaling
	self setPort2ControlBit: 6
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePort2Suspend
	self setPort2ControlBit: 12
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableResumeInterrupt
	self setInterruptBit: 1
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableScheduling
	^self setCommandBit: 0
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableShortPacketInterrupt
	self setInterruptBit: 3
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableSoftwareDebug
	^self setCommandBit: 5
! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableTimeoutCRCInterrupt
	self setInterruptBit: 0
! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
errorInterruptPending
	^self testStatusBit: 1
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
forceGlobalResumeRequested
	^self testCommandBit: 4
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameList
	^ frameList
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameListAddressAt: index
	^ ExternalAddress new fromInteger: ((self frameListValueAt: index) bitClear: 2r1111)
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameListAt: index
	(self isTerminatorAt: index) ifTrue: [^nil].
	^ (self isPointingToQueueHeadAt: index) 
		ifTrue: [USBQueueHead fromHandle: (self frameListAddressAt: index)]
		ifFalse: [USBTransferDescriptor fromHandle: (self frameListAddressAt: index)]
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameListAt: index put: aListElement
	aListElement ifNil: [^ self clearFrameListAt: index].
	self frameListValueAt: index put: aListElement address.	" this clears the [next] terminator flag "
	aListElement isQueueHead
		ifTrue: [self pointToQueueHeadAt: index]
		ifFalse: [self pointToTransferDescriptorAt: index]

! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameListBaseAddress
	^self longAt: 8
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameListBaseAddress: anInteger
	^self longAt: 8 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameListValueAt: index
	^frameList unsignedLongAt: index * 4 - 3
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameListValueAt: index put: anInteger
	frameList unsignedLongAt: index * 4 - 3 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameNumber
	^self shortAt: 6
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
frameNumber: anInteger
	^self shortAt: 6 put: anInteger
! !

!USBUHCIController methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleIRQ
	self report: 'Command: ', self command hex, ' Status: ', self status hex.
	self resetStatus.

! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasBeenConfigured
	^self testCommandBit: 6
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasSchedulingEnabled
	^self testCommandBit: 0
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasSoftwareDebugEnabled
	^self testCommandBit: 5
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hostControllerResetHasFinished
	^(self testCommandBit: 1) not
! !

!USBUHCIController methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
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
! !

!USBUHCIController methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeFrameList
	frameList := ExternalAddress allocate: 4*1024 aligned: 4*1024.
	1 to: 1024 do: [:i | self clearFrameListAt: i].
	self frameListBaseAddress: frameList asInteger.
	self frameNumber: 0.
! !

!USBUHCIController methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeRootHubs
	"
\ We mustn't wait more than 3 ms between releasing the reset and enabling
\ the port to begin the SOF stream, otherwise some devices (e.g. pl2303)
\ will go into suspend state and then not respond to set-address.
: reset-root-hub-port  ( port -- )
   dup >r  portsc@ h# 20e invert and    ( value r: port )  \ Clear reset, enable, status
   dup h# 200 or  r@ portsc!!	        ( value r: port )  \ Reset port
   d# 30 ms                             ( value r: port )  \ > 10 ms - reset time
   dup r@ portsc!!                       ( value r: port )  \ Release reset
   1 ms                                 ( value r: port )  \ > 5.3 uS - reconnect time
   h# e or  r> portsc!!	                ( )  \ Enable port and clear status
;

: probe-root-hub-port  ( port -- )
   dup reset-root-hub-port
   dup portsc@ 1 and 0=  if  drop exit  then		\ No device-connected
   ok-to-add-device? 0=  if  drop exit  then		\ Can't add another device

   new-address				( port dev )
   over portsc@ 100 and  if  speed-low  else  speed-full  then
   over di-speed!!			( port dev )

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
         i portsc@ i portsc!!			\ Clear change bits
      then
   loop
   free-pkt-buf

   pop-package
;
	"
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptEnable
	^self shortAt: 4
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptEnable: anInteger
	^self shortAt: 4 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptPending
	^self testStatusBit: 0
! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
isHalted
	^self testStatusBit: 5
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
isInGlobalSuspendMode
	^self testCommandBit: 3
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
isPointingToQueueHeadAt: index
	^ (self frameListValueAt: index) anyMask: 2
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
isPointingToTransferDescriptorAt: index
	^ ((self frameListValueAt: index) anyMask: 2) not
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
isTerminatorAt: index
	^ (self frameListValueAt: index) anyMask: 1
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
maxPacketSize
	^(self testCommandBit: 7)
		ifTrue: [64]
		ifFalse: [32]
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
maxPacketSize: anInteger
	anInteger == 32 ifTrue: [^self clearCommandBit: 7].
	anInteger == 64 ifTrue: [^self setCommandBit: 7].
	self error: 'Invalid maxPacketSize. Only 32 or 64 bytes allowed'
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
pointToQueueHeadAt: index
	^ self
		frameListValueAt: index
		put: ((self frameListValueAt: index) bitOr: 2) 
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
pointToQueueHeaderAt: index
	^ self
		frameListValueAt: index
		put: ((self frameListValueAt: index) bitOr: 2) 
! !

!USBUHCIController methodsFor:  'accessing - frame list' stamp: 'KenD 28/Jun/2026 13:32:24'!
pointToTransferDescriptorAt: index
	^ self
		frameListValueAt: index
		put: ((self frameListValueAt: index) bitAnd: 2 bitInvert) 
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1ConnectStatusHasChanged
	^self testPort1StatusBit: 1
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1EnableStatusHasChanged
	^self testPort1StatusBit: 3
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1HasDeviceConnected
	^self testPort1StatusBit: 0
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1HasLowSpeedDeviceAttached
	^self testPort1StatusBit: 8
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1IsReset
	^self testPort1StatusBit: 9
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1IsSuspended
	^self testPort1StatusBit: 12
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1LineStatus
	^(self testPort1StatusBit: 5) * 2 + (self testPort1StatusBit: 4)
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1StatusControl
	^self shortAt: 16
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
port1StatusControl: anInteger
	^self shortAt: 16 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2ConnectStatusHasChanged
	^self testPort2StatusBit: 1
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2EnableStatusHasChanged
	^self testPort2StatusBit: 3
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2HasDeviceConnected
	^self testPort2StatusBit: 0
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2HasLowSpeedDeviceAttached
	^self testPort2StatusBit: 8
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2IsReset
	^self testPort2StatusBit: 9
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2IsSuspended
	^self testPort2StatusBit: 12
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2LineStatus
	^(self testPort2StatusBit: 5) * 2 + (self testPort2StatusBit: 4)
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2StatusControl
	^self shortAt: 18
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
port2StatusControl: anInteger
	^self shortAt: 18 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
power1StatusControl
	^self shortAt: 16
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
power1StatusControl: anInteger
	^self shortAt: 16 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
power2StatusControl
	^self shortAt: 18
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
power2StatusControl: anInteger
	^self shortAt: 18 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
processError
	^self testStatusBit: 4
! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetStatus
	" Writing a 1 clears that bit status "
	^self status: self status
! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resumeRequestedByDevice
	^self testStatusBit: 2
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
setCommandBit: bit
	^ self command: (self command bitOr: 1 << bit)

! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
setInterruptBit: bit
	^ self interruptEnable: (self interruptEnable bitOr: 1 << bit)

! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
setPort1ControlBit: bit
	^ self port1StatusControl: (self port1StatusControl bitOr: 1 << bit)

! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
setPort2ControlBit: bit
	^ self port2StatusControl: (self port2StatusControl bitOr: 1 << bit)

! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
startHostControllerReset
	^self setCommandBit: 1
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
startOfFrameModify
	^self byteAt: 12
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
startOfFrameModify: anInteger
	^self byteAt: 12 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
status
	^self shortAt: 2
! !

!USBUHCIController methodsFor:  'accessing - registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
status: anInteger
	^self shortAt: 2 put: anInteger
! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
systemError
	^self testStatusBit: 3
! !

!USBUHCIController methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
testCommandBit: bit
	^ self command anyMask: 1 << bit
! !

!USBUHCIController methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
testGetDeviceDescriptor
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
! !

!USBUHCIController methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
testGetStringDescriptor: idx
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

! !

!USBUHCIController methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
testInput
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

! !

!USBUHCIController methodsFor:  'accessing - interrupt register' stamp: 'KenD 28/Jun/2026 13:32:24'!
testInterruptBit: bit
	^ self interruptEnable anyMask: 1 << bit
! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
testPort1StatusBit: bit
	^ self port1StatusControl anyMask: 1 << bit

! !

!USBUHCIController methodsFor:  'accessing - port status/controll' stamp: 'KenD 28/Jun/2026 13:32:24'!
testPort2StatusBit: bit
	^ self port2StatusControl anyMask: 1 << bit

! !

!USBUHCIController methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
testStatusBit: bit
	^ self status anyMask: 1 << bit
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'USBUHCIController class' category: 'SqueakNOS-Devices-USB'!
USBUHCIController class
	instanceVariableNames: ''!

!USBUHCIController class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
classCode
	^12
! !

!USBUHCIController class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
classSubCode
	^3
! !

!USBUHCIController class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	| pciEntry |
	pciEntry := PCIBusEntry allValid
		detect: [:e |
			e classCode == self classCode and: [
			e classSubCode == self classSubCode and: [
			e programmingInterface == self programmingInterface]]]
		ifNone: [^ self].

	^ self onPCIEntry: pciEntry computer: aComputer.

! !

!USBUHCIController class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
onPCIEntry: aPCIBusEntry computer: aComputer
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


! !

!USBUHCIController class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
programmingInterface
	^0
! !


USBUHCIController initialize!

