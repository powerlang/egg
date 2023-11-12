Class {
	#name : #PIC8259,
	#superclass : #HardwareDevice,
	#instVars : [
		'computer',
		'slave',
		'dispatchers',
		'savedMask'
	],
	#category : #'SqueakNOS-Devices-Base'
}

{ #category : #'instance creation' }
PIC8259 class >> installOn: aComputer [ 
	^ (aComputer has: #interruptController)
		ifFalse: [aComputer
				interruptController: (self master computer: aComputer)]
]

{ #category : #'instance creation' }
PIC8259 class >> master [
	^ ((self onPort: 16r20)
		slave: self slave) enableIRQ: 0
]

{ #category : #'instance creation' }
PIC8259 class >> slave [
	^ self onPort: 16rA0
]

{ #category : #dispatching }
PIC8259 >> addHandler: anObject forIRQ: aNumber [
	" the master mantains the array of dispatchers"
	| dispatcher |

	dispatcher := self dispatcherForIRQ: aNumber.
	dispatcher ifNil: [
		dispatcher := InterruptRequestDispatcher onIRQ: aNumber.
		self dispatcher: dispatcher forIRQ: aNumber.
		dispatcher
			addHandler: anObject;
			installOn: computer.
	] ifNotNil: [
		dispatcher addHandler: anObject].

	Transcript cr; show:
		'handler for IRQ #',
		aNumber printString,
		' installed: ',
		anObject printString.
]

{ #category : #accessing }
PIC8259 >> computer [
	^ computer
]

{ #category : #accessing }
PIC8259 >> computer: aComputer [
	computer := aComputer.
	slave ifNotNil: [slave computer: aComputer]
]

{ #category : #commands }
PIC8259 >> disableAll [
	0 to: 7 do: [:i | self disableIRQ: i].
	slave ifNotNil: [slave disableAll]
]

{ #category : #commands }
PIC8259 >> disableIRQ: aNumber [
	aNumber > 7
		ifTrue: [
			slave disableIRQ: aNumber - 8.
			slave isAnyEnabled ifFalse: [self disableIRQ: 2]]
		ifFalse: [
			savedMask := savedMask bitOr: 1 << aNumber.
			self byteAt: 1 put: savedMask].

"	Transcript cr; show: 'IRQ #', aNumber printString, ' disabled. Mask: ',savedMask hex.
"
]

{ #category : #dispatching }
PIC8259 >> dispatcher: anIRQDispatcher forIRQ: aNumber [
	^ aNumber > 7
		ifTrue: [slave dispatcher: anIRQDispatcher forIRQ: aNumber - 8]
		ifFalse: [dispatchers at: aNumber + 1 put: anIRQDispatcher]
]

{ #category : #dispatching }
PIC8259 >> dispatcherForIRQ: aNumber [
	^ aNumber > 7
		ifTrue: [slave dispatcherForIRQ: aNumber - 8]
		ifFalse: [dispatchers at: aNumber + 1].
]

{ #category : #commands }
PIC8259 >> enableIRQ: aNumber [
	aNumber > 7
		ifTrue: [
			slave enableIRQ: aNumber - 8.
			self enableIRQ: 2]
		ifFalse: [
			savedMask := savedMask bitClear: 1 << aNumber.
			self byteAt: 1 put: savedMask].

"	Transcript cr; show: 'IRQ #', aNumber printString, ' enabled. Mask: ',savedMask printStringHex
"
]

{ #category : #initialization }
PIC8259 >> initialize [
	dispatchers := Array new: 8.
	savedMask := 0.

	self disableAll.
]

{ #category : #accessing }
PIC8259 >> isAnyEnabled [
	^ savedMask ~= 16rFF
]

{ #category : #dispatching }
PIC8259 >> removeDispatcher: anIRQDispatcher [
	^ self dispatcher: nil forIRQ: anIRQDispatcher interruptNumber
]

{ #category : #dispatching }
PIC8259 >> removeHandler: anObject forIRQ: aNumber [
	" the master mantains the array of dispatchers"
	| dispatcher |

	dispatcher := self dispatcherForIRQ: aNumber.
	dispatcher ifNotNil: [dispatcher removeHandler: anObject].

	Transcript cr; show:
		'handler for IRQ #',
		aNumber printString,
		' removed: ',
		anObject printString.
]

{ #category : #commands }
PIC8259 >> signalEndOfInterrupt: interruptNumber [
	interruptNumber > 7 ifTrue: [slave signalEndOfInterrupt: interruptNumber - 8].
	self byteAt: 0 put: 16r20.
"	Transcript cr; show: 'end of IRQ #', interruptNumber printString.
"
]

{ #category : #accessing }
PIC8259 >> slave [
	^ slave
]

{ #category : #accessing }
PIC8259 >> slave: aPIC8259 [
	slave := aPIC8259.
]
