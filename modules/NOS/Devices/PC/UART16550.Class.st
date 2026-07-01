'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #UART16550 category: 'SqueakNOS-Devices-Base'!
UART8250 subclass: #UART16550
	instanceVariableNames: 'fifoStatus'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!UART16550 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
close
	super close.
	self fifoControlRegister: 0
	
! !

!UART16550 methodsFor:  '*SqueakNOS-BenchSupport' stamp: 'KenD 28/Jun/2026 13:32:24'!
closed
	^ false.
! !

!UART16550 methodsFor:  'FIFO control' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableFIFO
	fifoStatus := fifoStatus bitClear: 1.
	self fifoControlRegister: fifoStatus.
! !

!UART16550 methodsFor:  'FIFO control' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableFIFO
	fifoStatus := fifoStatus bitOr: 1.
	self fifoControlRegister: fifoStatus.
! !

!UART16550 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
fifoControlRegister
	^ self byteAt: 2
! !

!UART16550 methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
fifoControlRegister: aByte
	^ self byteAt: 2 put: aByte
! !

!UART16550 methodsFor:  'device protocol' stamp: 'KenD 28/Jun/2026 13:32:24'!
open
	" tiene comentarios!! "
	fifoStatus := 0.
	super open.
	self enableFIFO;
		triggerLevel: 4;
		resetInputQueue;
		resetOutputQueue.

		
		
	

! !

!UART16550 methodsFor:  'FIFO control' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetInputQueue
	self fifoControlRegister: (fifoStatus bitOr: 2).
! !

!UART16550 methodsFor:  'FIFO control' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetOutputQueue
	self fifoControlRegister: (fifoStatus bitOr: 4).
! !

!UART16550 methodsFor:  'FIFO control' stamp: 'KenD 28/Jun/2026 13:32:24'!
triggerLevel: integer
	| idx |
	idx := #(1 4 8 14) indexOf: integer.
	idx = 0 ifTrue: [idx := 3]. "default value"
	fifoStatus := fifoStatus bitOr: ((idx - 1) bitShift: 6).
	self fifoControlRegister:	fifoStatus
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UART16550 class' category: 'SqueakNOS-Devices-Base'!
UART16550 class
	instanceVariableNames: ''!

!UART16550 class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	| first |
	first := nil.
	self detectedUARTS with: #(4 3 4 3) do: [:uart :irq |
		uart notNil ifTrue: [
			first isNil ifTrue: [first := uart].
			aComputer interruptController
				addHandler: uart
				forIRQ: irq]].
	^ aComputer defaultSerialPort: first.
! !


