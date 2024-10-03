Class {
	#name : #SFFIDescriptor,
	#superclass : #ByteArray,
	#type : #bytes,
	#classVars : [
		'FFICallingConventions',
		'FFITypes'
	],
	#category : #'Powerlang-Core-SCompiler'
}

{ #category : #'class initialization' }
SFFIDescriptor class >> initialize [
	self initializeFFITypes; initializeCallingConventions
]

{ #category : #'class initialization' }
SFFIDescriptor class >> initializeCallingConventions [
	FFICallingConventions := Dictionary new.
	FFICallingConventions
		at: 'cdecl' put: 20;
		at: 'com' put: 21;
		at: 'callback' put: 22
]

{ #category : #'class initialization' }
SFFIDescriptor class >> initializeFFITypes [
	FFITypes := Dictionary new.
	FFITypes
		at: 'uint8' put: 0;
		at: 'sint8' put: 1;
		at: 'uint16' put: 2;
		at: 'sint16' put: 3;
		at: 'uint32' put: 4;
		at: 'sint32' put: 5;
		at: 'uint64' put: 6;
		at: 'sint64' put: 7;

		at: 'float' put: 8;
		at: 'double' put: 9;

		at: 'uchar' put: 10;
		at: 'schar' put: 11;
		at: 'ushort' put: 12;
		at: 'sshort' put: 13;
		at: 'ulong' put: 14;
		at: 'slong' put: 15;
		at: 'ularge' put: 16;
		at: 'large' put: 17;
		at: 'longdouble' put: 18;
		at: 'pointer' put: 19;
		at: 'complex-float' put: 20;
		at: 'complex-double' put: 21;
		at: 'complex-longdouble' put: 22;

		at: 'void' put: 23
]

{ #category : #'as yet unclassified' }
SFFIDescriptor class >> ret: aString args: aCollection cc: ccName [
	| args return cc result |
	args := aCollection
		collect: [ :argname | 
			FFITypes
				at: argname asString
				ifAbsent: [ self error: 'undefined argument type ' , argname ] ].
	return := FFITypes
		at: aString
		ifAbsent: [ self error: 'undefined result type ' , aString ].
	cc := FFICallingConventions
		at: ccName
		ifAbsent: [ self error: 'unsupported calling convention ' , ccName ].
	result := self new: args size + 2.
	^ result
		callingConvention: cc;
		return: return;
		arguments: args
]

{ #category : #calls }
SFFIDescriptor >> arguments: aCollection [
	self replaceFrom: 1 to: aCollection size with: aCollection
]

{ #category : #calls }
SFFIDescriptor >> callingConvention: anInteger [
	self at: self size put: anInteger
]

{ #category : #calls }
SFFIDescriptor >> return: anInteger [
	self at: self size - 1 put: anInteger
]
