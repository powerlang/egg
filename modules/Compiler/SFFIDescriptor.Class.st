'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SFFIDescriptor category: #'Powerlang-Core-SCompiler'!
ByteArray subclass: #SFFIDescriptor
	instanceVariableNames: ''
	classVariableNames: 'FFICallingConventions FFITypes'
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!SFFIDescriptor methodsFor:  'calls' stamp: 'KenD 28/Jun/2026 13:27:40'!
arguments: aCollection
	self replaceFrom: 1 to: aCollection size with: aCollection
! !

!SFFIDescriptor methodsFor:  'calls' stamp: 'KenD 28/Jun/2026 13:27:40'!
callingConvention: anInteger
	self at: self size put: anInteger
! !

!SFFIDescriptor methodsFor:  'calls' stamp: 'KenD 28/Jun/2026 13:27:40'!
return: anInteger
	self at: self size - 1 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SFFIDescriptor class' category: #'Powerlang-Core-SCompiler'!
SFFIDescriptor class
	instanceVariableNames: 'FFICallingConventions FFITypes'!

!SFFIDescriptor class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	self initializeFFITypes; initializeCallingConventions
! !

!SFFIDescriptor class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeCallingConventions
	FFICallingConventions := Dictionary new.
	FFICallingConventions
		at: 'cdecl' put: 20;
		at: 'com' put: 21;
		at: 'callback' put: 22
! !

!SFFIDescriptor class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeFFITypes
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
! !

!SFFIDescriptor class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
ret: aString args: aCollection cc: ccName
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
! !


SFFIDescriptor initialize!

