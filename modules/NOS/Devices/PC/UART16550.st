Class {
	#name : #UART16550,
	#superclass : #UART8250,
	#instVars : [
		'fifoStatus'
	],
	#category : 'SqueakNOS-Devices-Base'
}

{ #category : #'system startup' }
UART16550 class >> installOn: aComputer [ 
	| first |
	first := nil.
	self detectedUARTS with: #(4 3 4 3) do: [:uart :irq |
		uart notNil ifTrue: [
			first isNil ifTrue: [first := uart].
			aComputer interruptController
				addHandler: uart
				forIRQ: irq]].
	^ aComputer defaultSerialPort: first.
]

{ #category : #'device protocol' }
UART16550 >> close [
	super close.
	self fifoControlRegister: 0
	
]

{ #category : #'*SqueakNOS-BenchSupport' }
UART16550 >> closed [
	^ false.
]

{ #category : #'FIFO control' }
UART16550 >> disableFIFO [
	fifoStatus := fifoStatus bitClear: 1.
	self fifoControlRegister: fifoStatus.
]

{ #category : #'FIFO control' }
UART16550 >> enableFIFO [
	fifoStatus := fifoStatus bitOr: 1.
	self fifoControlRegister: fifoStatus.
]

{ #category : #registers }
UART16550 >> fifoControlRegister [
	^ self byteAt: 2
]

{ #category : #registers }
UART16550 >> fifoControlRegister: aByte [
	^ self byteAt: 2 put: aByte
]

{ #category : #'device protocol' }
UART16550 >> open [
	" tiene comentarios! "
	fifoStatus := 0.
	super open.
	self enableFIFO;
		triggerLevel: 4;
		resetInputQueue;
		resetOutputQueue.

		
		
	

]

{ #category : #'FIFO control' }
UART16550 >> resetInputQueue [
	self fifoControlRegister: (fifoStatus bitOr: 2).
]

{ #category : #'FIFO control' }
UART16550 >> resetOutputQueue [
	self fifoControlRegister: (fifoStatus bitOr: 4).
]

{ #category : #'FIFO control' }
UART16550 >> triggerLevel: integer [
	| idx |
	idx := #(1 4 8 14) indexOf: integer.
	idx = 0 ifTrue: [idx := 3]. "default value"
	fifoStatus := fifoStatus bitOr: ((idx - 1) bitShift: 6).
	self fifoControlRegister:	fifoStatus
]
