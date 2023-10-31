Class {
	#name : #NativizationPlatform,
	#superclass : #Object,
	#instVars : [
		'name',
		'wordSize',
		'abi',
		'codeGeneratorClass'
	],
	#classVars : [
		'Default'
	],
	#category : #'Powerlang-Core-Nativization'
}

{ #category : #accessing }
NativizationPlatform class >> default [
	"Return the default platform to use for tests. Defaults to host.

	 NEVER, EVER use this for anything but testing!"

	^ Default ifNil: [ self host ]
]

{ #category : #accessing }
NativizationPlatform class >> default: aNativizationPlatform [
	"Set the default platform to use in tests."

	Default := aNativizationPlatform.
]

{ #category : #accessing }
NativizationPlatform class >> host [
	"Return platform for the machine this code is running on."

	| host |

	host := Smalltalk host.
	host = 'x86_64-linux-gnu' ifTrue:[ ^ self x86_64_linux_gnu ].
	host = 'x86_64-darwin' ifTrue:[ ^ self x86_64_darwin ].
	host = 'x86_64-win32' ifTrue:[ ^self x86_64_win32 ].

	host = 'riscv64-linux-gnu' ifTrue:[ ^ self riscv64_linux_gnu ].

	self error:'Unssuported host: ', host.
]

{ #category : #accessing }
NativizationPlatform class >> x86_64_darwin [
	^ self new
		name: 'x86_64-darwin';
		wordSize: 8;
		abi: SysVX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;
		yourself
]

{ #category : #accessing }
NativizationPlatform class >> x86_64_linux_gnu [
	^ self new
		name: 'x86_64-linux-gnu';
		wordSize: 8;
		abi: SysVX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;   
		yourself
]

{ #category : #accessing }
NativizationPlatform class >> x86_64_win32 [
	^ self new
		name: 'x86_64-win32';
		wordSize: 8;
		abi: WinX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;   
		yourself
]

{ #category : #accessing }
NativizationPlatform >> abi [
	self ASSERT: abi notNil.  
	^ abi
]

{ #category : #initialization }
NativizationPlatform >> abi: anABI [
	self ASSERT: abi isNil.
	self ASSERT: anABI notNil.

	abi := anABI.
]

{ #category : #initialization }
NativizationPlatform >> codeGeneratorClass: aClass [
	self ASSERT: codeGeneratorClass isNil.
	self ASSERT: aClass notNil.

	codeGeneratorClass := aClass.
]

{ #category : #initialization }
NativizationPlatform >> initialize [
	"super initialize.   -- commented since inherited method does nothing"
]

{ #category : #accessing }
NativizationPlatform >> name [
	self ASSERT: name notNil.
	^ name
]

{ #category : #initialization }
NativizationPlatform >> name: aString [
	self ASSERT: name isNil.
	self ASSERT: aString notNil.

	name := aString.
]

{ #category : #'instance creation' }
NativizationPlatform >> newCodeGenerator [
	self ASSERT: codeGeneratorClass notNil.

	^ codeGeneratorClass new platform: self.
]

{ #category : #'instance creation' }
NativizationPlatform >> newAssembler [
	^ Assembler new platform: self
]

{ #category : #'printing & storing' }
NativizationPlatform >> printOn: aStream [
	super printOn:aStream.
	aStream nextPut: $(.
	name printOn:aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
NativizationPlatform >> wordSize [
	self ASSERT: wordSize notNil.
	^ wordSize
]

{ #category : #initialization }
NativizationPlatform >> wordSize: anInteger [
	self ASSERT: wordSize isNil.
	self ASSERT:(anInteger == 8 or:[ anInteger == 4]).

	wordSize := anInteger.
]

{ #category : #accessing }
NativizationPlatform >> wordSizeShift [
	^ #(0 0 0 2 0 0 0 3) at: self wordSize
]

