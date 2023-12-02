"
I'm a HadwareDevice. My subclasses implement support for different devices, for example, Keyboard, Mouse, Network cards, PCI support, etc.

My baseResource dictates whether I use ExternalMemory or ExternalOPort to talk to the hardware.

All accessors #(byteAt: shortAt: longAt: byteAt:put: shortAt:put: longAt:put:) are zero based. This is different from Smalltalk convention, and it was not an easy decision, but we finally opted for 0 based accessors to match all existing documentation for devices, so it's a lot easy to follow from code to documentation and back.

To do this zero based accessing we are playing silly and processor consuming tricks right now, we'll probably improve this in the future. The trick is: ExternalAddress (as implemented by stock Squeak) is 1 based, so we have to add one to the index before accessing the resources, howerver, in the native implementation, 1 has to be substracted back from the index to access the right memory address. To match this behaviour we had to make ExternalIOPort also be 1 based, so, before calling the primitives for ExternalIOPort we substract 1 to the index, and before calling the public accessors we have to add 1 to it... in short, if we could make ExternalAddress be zero based (or if we reimplement it in our own class) we could remove all this +/- 1 overhead. However, right now, we only want to make it work, and take note for the future.

"
Class {
	#name : #HardwareDevice,
	#superclass : #Object,
	#instVars : [
		'resource'
	],
	#category : 'SqueakNOS-Devices-Base'
}

{ #category : #'instance creation' }
HardwareDevice class >> atMemoryAddress: anInteger [ 
	^ self basicNew resource: (ExternalAddress new fromInteger: anInteger);
		 initialize
]

{ #category : #'instance creation' }
HardwareDevice class >> installOn: aComputer [
	" detect if hardware is present, if so, instantiate, initialize and install on aComputer"
]

{ #category : #'instance creation' }
HardwareDevice class >> new [

	^ super new initialize
]

{ #category : #'instance creation' }
HardwareDevice class >> onPort: portNumber [ 
	^ self basicNew resource: (ExternalIOPort address: portNumber);
		 initialize
]

{ #category : #'I/O' }
HardwareDevice >> byteAt: index [
	^ resource unsignedByteAt: index + 1
]

{ #category : #'I/O' }
HardwareDevice >> byteAt: index put: value [
	^ resource unsignedByteAt: index + 1put: value
]

{ #category : #'I/O' }
HardwareDevice >> byteStringAt: index put: aString [
	^ resource unsignedByteStringAt: index + 1 put: aString
]

{ #category : #'I/O' }
HardwareDevice >> byteStringAt: index size: anInteger [
	^ resource unsignedByteStringAt: index + 1 size: anInteger
]

{ #category : #'irq handling' }
HardwareDevice >> handleIRQ [
	self report: 'IRQ'
]

{ #category : #'irq handling' }
HardwareDevice >> handleIRQfor: anIRQDispatcher [
	^ self handleIRQ
]

{ #category : #'irq handling' }
HardwareDevice >> handleIRQfor: anIRQDispatcher on: aComputer [
	^ self handleIRQfor: anIRQDispatcher
]

{ #category : #initialization }
HardwareDevice >> initialize [
]

{ #category : #'I/O' }
HardwareDevice >> longAt: index [
	^ resource unsignedLongAt: index + 1
]

{ #category : #'I/O' }
HardwareDevice >> longAt: index put: value [
	^ resource unsignedLongAt: index + 1 put: value
]

{ #category : #'I/O' }
HardwareDevice >> longStringAt: index put: aString [
	^ resource unsignedLongStringAt: index + 1 put: aString
]

{ #category : #'I/O' }
HardwareDevice >> longStringAt: index size: anInteger [
	^ resource unsignedLongStringAt: index + 1 size: anInteger
]

{ #category : #reporting }
HardwareDevice >> report: msg [
	Transcript
		cr;
		show: self;
		nextPutAll: ': ', msg asString;
		flush.
]

{ #category : #initialization }
HardwareDevice >> resource: anExternalIOPortOrZeroBasedAddress [
	resource := anExternalIOPortOrZeroBasedAddress
]

{ #category : #'I/O' }
HardwareDevice >> shortAt: index [
	^ resource unsignedShortAt: index + 1
]

{ #category : #'I/O' }
HardwareDevice >> shortAt: index put: value [
	^ resource unsignedShortAt: index + 1 put: value
]

{ #category : #'I/O' }
HardwareDevice >> shortStringAt: index put: aString [
	^ resource unsignedShortStringAt: index + 1 put: aString
]

{ #category : #'I/O' }
HardwareDevice >> shortStringAt: index size: anInteger [
	^ resource unsignedShortStringAt: index + 1 size: anInteger
]

{ #category : #'I/O' }
HardwareDevice >> unsignedByteAt: index [
	^ resource unsignedByteAt: index + 1
]

{ #category : #'I/O' }
HardwareDevice >> unsignedByteAt: index put: value [
	^ resource unsignedByteAt: index + 1 put: value
]

{ #category : #'I/O' }
HardwareDevice >> unsignedShoftAt: index put: value [
	^ resource unsignedShortAt: index + 1 put: value
]

{ #category : #'I/O' }
HardwareDevice >> unsignedShortAt: index [
	^ resource unsignedShortAt: index + 1
]
