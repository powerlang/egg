"
This is 1 based to match ExternalAddress accessors, this adds a double stupid overhead on every accessors. Read comment for HardwareDevice class
"
Class {
	#name : #ExternalIOPort,
	#superclass : #Object,
	#instVars : [
		'address'
	],
	#category : #'SqueakNOS-Devices-Base'
}

{ #category : #'as yet unclassified' }
ExternalIOPort class >> address: anInteger [
	^ self new address: anInteger
]

{ #category : #accessing }
ExternalIOPort >> address: anInteger [
	address := anInteger - 1
]

{ #category : #accessing }
ExternalIOPort >> asInteger [
	^ address + 1
]

{ #category : #primitives }
ExternalIOPort >> primInPortByte: portNumber [ 
	<primitive: 'primitiveInPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primInPortByte: portNumber stringLength: length [
	<primitive: 'primitiveInPortByteStringLength' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primInPortDword: portNumber [ 
	<primitive: 'primitiveInPortDword' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primInPortDword: portNumber stringLength: length [
	<primitive: 'primitiveInPortDwordStringLength' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primInPortWord: portNumber [ 
	<primitive: 'primitiveInPortWord' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primInPortWord: portNumber stringLength: length [
	<primitive: 'primitiveInPortWordStringLength' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primOutPort: portNumber byte: byte [ 
	<primitive: 'primitiveOutPortByte' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primOutPort: portNumber byteString: aString [ 
	<primitive: 'primitiveOutPortByteString' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primOutPort: portNumber dword: dword [ 
	<primitive: 'primitiveOutPortDword' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primOutPort: portNumber dwordString: aString [ 
	<primitive: 'primitiveOutPortDwordString' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primOutPort: portNumber word: word [ 
	<primitive: 'primitiveOutPortWord' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #primitives }
ExternalIOPort >> primOutPort: portNumber wordString: aString [ 
	<primitive: 'primitiveOutPortWordString' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^ self primitiveFailed
]

{ #category : #'I/O' }
ExternalIOPort >> uByteAtOffset: offset [
	^ self primInPortByte: address + 1 + offset
]

{ #category : #'I/O' }
ExternalIOPort >> uByteAtOffset: offset put: byte [
	^ self primOutPort: address + 1 + offset byte: byte
]

{ #category : #'I/O' }
ExternalIOPort >> unsignedByteAt: index [
	^ self primInPortByte: address + index


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedByteAt: index put: value [
	^ self primOutPort: address + index byte: value


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedByteStringAt: index put: string [
	^ self primOutPort: address + index byteString: string


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedByteStringAt: index size: size [
	^ self primInPortByte: address + index stringLength: size


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedLongAt: index [
	^ self primInPortDword: address + index

]

{ #category : #'I/O' }
ExternalIOPort >> unsignedLongAt: index put: value [
	^ self primOutPort: address + index dword: value


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedLongStringAt: index put: string [
	^ self primOutPort: address + index dwordString: string


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedLongStringAt: index size: size [
	^ self primInPortDword: address + index stringLength: size


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedShortAt: index [
	^ self primInPortWord: address + index

]

{ #category : #'I/O' }
ExternalIOPort >> unsignedShortAt: index put: value [
	^ self primOutPort: address + index word: value


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedShortStringAt: index put: string [
	^ self primOutPort: address + index wordString: string


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedShortStringAt: index size: size [
	^ self primInPortWord: address + index stringLength: size


]

{ #category : #'I/O' }
ExternalIOPort >> unsignedWordStringAt: index size: size [
	^ self primInPortWord: address + index stringLength: size


]
