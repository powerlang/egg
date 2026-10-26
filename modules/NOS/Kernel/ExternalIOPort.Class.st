'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #ExternalIOPort category: #'SqueakNOS-Devices-Base'!
Object subclass: #ExternalIOPort
	instanceVariableNames: 'address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!ExternalIOPort commentStamp: '<historical>' prior: 0!

This is 1 based to match ExternalAddress accessors, this adds a double stupid overhead on every accessors. Read comment for HardwareDevice class
!

!ExternalIOPort methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
address: anInteger
	address := anInteger - 1
! !

!ExternalIOPort methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
asInteger
	^ address + 1
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primInPortByte: portNumber
	<primitive: 'primitiveInPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primInPortByte: portNumber stringLength: length
	<primitive: 'primitiveInPortByteStringLength' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primInPortDword: portNumber
	<primitive: 'primitiveInPortDword' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primInPortDword: portNumber stringLength: length
	<primitive: 'primitiveInPortDwordStringLength' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primInPortWord: portNumber
	<primitive: 'primitiveInPortWord' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primInPortWord: portNumber stringLength: length
	<primitive: 'primitiveInPortWordStringLength' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primOutPort: portNumber byte: byte
	<primitive: 'primitiveOutPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primOutPort: portNumber byteString: aString
	<primitive: 'primitiveOutPortByteString' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primOutPort: portNumber dword: dword
	<primitive: 'primitiveOutPortDword' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primOutPort: portNumber dwordString: aString
	<primitive: 'primitiveOutPortDwordString' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primOutPort: portNumber word: word
	<primitive: 'primitiveOutPortWord' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primOutPort: portNumber wordString: aString
	<primitive: 'primitiveOutPortWordString' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
uByteAtOffset: offset
	^ self primInPortByte: address + 1 + offset
! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
uByteAtOffset: offset put: byte
	^ self primOutPort: address + 1 + offset byte: byte
! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedByteAt: index
	^ self primInPortByte: address + index


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedByteAt: index put: value
	^ self primOutPort: address + index byte: value


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedByteStringAt: index put: string
	^ self primOutPort: address + index byteString: string


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedByteStringAt: index size: size
	^ self primInPortByte: address + index stringLength: size


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedLongAt: index
	^ self primInPortDword: address + index

! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedLongAt: index put: value
	^ self primOutPort: address + index dword: value


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedLongStringAt: index put: string
	^ self primOutPort: address + index dwordString: string


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedLongStringAt: index size: size
	^ self primInPortDword: address + index stringLength: size


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedShortAt: index
	^ self primInPortWord: address + index

! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedShortAt: index put: value
	^ self primOutPort: address + index word: value


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedShortStringAt: index put: string
	^ self primOutPort: address + index wordString: string


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedShortStringAt: index size: size
	^ self primInPortWord: address + index stringLength: size


! !

!ExternalIOPort methodsFor:  'I/O' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedWordStringAt: index size: size
	^ self primInPortWord: address + index stringLength: size


! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExternalIOPort class' category: #'SqueakNOS-Devices-Base'!
ExternalIOPort class
	instanceVariableNames: ''!

!ExternalIOPort class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
address: anInteger
	^ self new address: anInteger
! !


