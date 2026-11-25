'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #HardwareDevice category: 'SqueakNOS-Devices-Base'!
Object subclass: #HardwareDevice
	instanceVariableNames: 'resource'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!HardwareDevice commentStamp: '<historical>' prior: 0!

I'm a HadwareDevice. My subclasses implement support for different devices, for example, Keyboard, Mouse, Network cards, PCI support, etc.

My baseResource dictates whether I use ExternalMemory or ExternalOPort to talk to the hardware.

All accessors #(byteAt: shortAt: longAt: byteAt:put: shortAt:put: longAt:put:) are zero based. This is different from Smalltalk convention, and it was not an easy decision, but we finally opted for 0 based accessors to match all existing documentation for devices, so it's a lot easy to follow from code to documentation and back.

To do this zero based accessing we are playing silly and processor consuming tricks right now, we'll probably improve this in the future. The trick is: ExternalAddress (as implemented by stock Squeak) is 1 based, so we have to add one to the index before accessing the resources, howerver, in the native implementation, 1 has to be substracted back from the index to access the right memory address. To match this behaviour we had to make ExternalIOPort also be 1 based, so, before calling the primitives for ExternalIOPort we substract 1 to the index, and before calling the public accessors we have to add 1 to it... in short, if we could make ExternalAddress be zero based (or if we reimplement it in our own class) we could remove all this +/- 1 overhead. However, right now, we only want to make it work, and take note for the future.

!

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index
	^ resource unsignedByteAt: index + 1
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index put: value
	^ resource unsignedByteAt: index + 1put: value
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteStringAt: index put: aString
	^ resource unsignedByteStringAt: index + 1 put: aString
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteStringAt: index size: anInteger
	^ resource unsignedByteStringAt: index + 1 size: anInteger
! !

!HardwareDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleIRQ
	self report: 'IRQ'
! !

!HardwareDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleIRQfor: anIRQDispatcher
	^ self handleIRQ
! !

!HardwareDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleIRQfor: anIRQDispatcher on: aComputer
	^ self handleIRQfor: anIRQDispatcher
! !

!HardwareDevice methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
longAt: index
	^ resource unsignedLongAt: index + 1
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
longAt: index put: value
	^ resource unsignedLongAt: index + 1 put: value
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
longStringAt: index put: aString
	^ resource unsignedLongStringAt: index + 1 put: aString
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
longStringAt: index size: anInteger
	^ resource unsignedLongStringAt: index + 1 size: anInteger
! !

!HardwareDevice methodsFor:  'reporting' stamp: 'KenD 28/Jun/2026 13:32:25'!
report: msg
	Transcript
		cr;
		show: self;
		nextPutAll: ': ', msg asString;
		flush.
! !

!HardwareDevice methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
resource: anExternalIOPortOrZeroBasedAddress
	resource := anExternalIOPortOrZeroBasedAddress
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortAt: index
	^ resource unsignedShortAt: index + 1
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortAt: index put: value
	^ resource unsignedShortAt: index + 1 put: value
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortStringAt: index put: aString
	^ resource unsignedShortStringAt: index + 1 put: aString
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortStringAt: index size: anInteger
	^ resource unsignedShortStringAt: index + 1 size: anInteger
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedByteAt: index
	^ resource unsignedByteAt: index + 1
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedByteAt: index put: value
	^ resource unsignedByteAt: index + 1 put: value
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShoftAt: index put: value
	^ resource unsignedShortAt: index + 1 put: value
! !

!HardwareDevice methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: index
	^ resource unsignedShortAt: index + 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HardwareDevice class' category: 'SqueakNOS-Devices-Base'!
HardwareDevice class
	instanceVariableNames: ''!

!HardwareDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
atMemoryAddress: anInteger
	^ self basicNew resource: (ExternalAddress new fromInteger: anInteger);
		 initialize
! !

!HardwareDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
installOn: aComputer
	" detect if hardware is present, if so, instantiate, initialize and install on aComputer"
! !

!HardwareDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new

	^ super new initialize
! !

!HardwareDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
onPort: portNumber
	^ self basicNew resource: (ExternalIOPort address: portNumber);
		 initialize
! !


HardwareDevice initialize!

