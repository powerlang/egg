'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PIC8259 category: 'SqueakNOS-Devices-Base'!
HardwareDevice subclass: #PIC8259
	instanceVariableNames: 'computer slave dispatchers savedMask'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!PIC8259 methodsFor:  'dispatching' stamp: 'KenD 28/Jun/2026 13:32:24'!
addHandler: anObject forIRQ: aNumber
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
! !

!PIC8259 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
computer
	^ computer
! !

!PIC8259 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
computer: aComputer
	computer := aComputer.
	slave ifNotNil: [slave computer: aComputer]
! !

!PIC8259 methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableAll
	0 to: 7 do: [:i | self disableIRQ: i].
	slave ifNotNil: [slave disableAll]
! !

!PIC8259 methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableIRQ: aNumber
	aNumber > 7
		ifTrue: [
			slave disableIRQ: aNumber - 8.
			slave isAnyEnabled ifFalse: [self disableIRQ: 2]]
		ifFalse: [
			savedMask := savedMask bitOr: 1 << aNumber.
			self byteAt: 1 put: savedMask].

"	Transcript cr; show: 'IRQ #', aNumber printString, ' disabled. Mask: ',savedMask hex.
"
! !

!PIC8259 methodsFor:  'dispatching' stamp: 'KenD 28/Jun/2026 13:32:24'!
dispatcher: anIRQDispatcher forIRQ: aNumber
	^ aNumber > 7
		ifTrue: [slave dispatcher: anIRQDispatcher forIRQ: aNumber - 8]
		ifFalse: [dispatchers at: aNumber + 1 put: anIRQDispatcher]
! !

!PIC8259 methodsFor:  'dispatching' stamp: 'KenD 28/Jun/2026 13:32:24'!
dispatcherForIRQ: aNumber
	^ aNumber > 7
		ifTrue: [slave dispatcherForIRQ: aNumber - 8]
		ifFalse: [dispatchers at: aNumber + 1].
! !

!PIC8259 methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableIRQ: aNumber
	aNumber > 7
		ifTrue: [
			slave enableIRQ: aNumber - 8.
			self enableIRQ: 2]
		ifFalse: [
			savedMask := savedMask bitClear: 1 << aNumber.
			self byteAt: 1 put: savedMask].

"	Transcript cr; show: 'IRQ #', aNumber printString, ' enabled. Mask: ',savedMask printStringHex
"
! !

!PIC8259 methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	dispatchers := Array new: 8.
	savedMask := 0.
	self disableAll.

! !

!PIC8259 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isAnyEnabled
	^ savedMask ~= 16rFF
! !

!PIC8259 methodsFor:  'dispatching' stamp: 'KenD 28/Jun/2026 13:32:24'!
removeDispatcher: anIRQDispatcher
	^ self dispatcher: nil forIRQ: anIRQDispatcher interruptNumber
! !

!PIC8259 methodsFor:  'dispatching' stamp: 'KenD 28/Jun/2026 13:32:24'!
removeHandler: anObject forIRQ: aNumber
	" the master mantains the array of dispatchers"
	| dispatcher |

	dispatcher := self dispatcherForIRQ: aNumber.
	dispatcher ifNotNil: [dispatcher removeHandler: anObject].

	Transcript cr; show:
		'handler for IRQ #',
		aNumber printString,
		' removed: ',
		anObject printString.
! !

!PIC8259 methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
signalEndOfInterrupt: interruptNumber
	interruptNumber > 7 ifTrue: [slave signalEndOfInterrupt: interruptNumber - 8].
	self byteAt: 0 put: 16r20.
"	Transcript cr; show: 'end of IRQ #', interruptNumber printString.
"
! !

!PIC8259 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
slave
	^ slave
! !

!PIC8259 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
slave: aPIC8259
	slave := aPIC8259.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PIC8259 class' category: 'SqueakNOS-Devices-Base'!
PIC8259 class
	instanceVariableNames: ''!

!PIC8259 class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	^ (aComputer has: #interruptController)
		ifFalse: [aComputer
				interruptController: (self master computer: aComputer)]
! !

!PIC8259 class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
master
	^ ((self onPort: 16r20)
		slave: self slave) enableIRQ: 0
! !

!PIC8259 class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
slave
	^ self onPort: 16rA0
! !


PIC8259 initialize!

