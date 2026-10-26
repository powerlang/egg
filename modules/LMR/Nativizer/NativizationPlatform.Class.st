'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NativizationPlatform category: #Nativization!
Object subclass: #NativizationPlatform
	instanceVariableNames: 'name wordSize abi codeGeneratorClass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!NativizationPlatform methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi
	self ASSERT: abi notNil.  
	^ abi
! !

!NativizationPlatform methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi: anABI
	self ASSERT: abi isNil.
	self ASSERT: anABI notNil.

	abi := anABI.
! !

!NativizationPlatform methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
codeGeneratorClass: aClass
	self ASSERT: codeGeneratorClass isNil.
	self ASSERT: aClass notNil.

	codeGeneratorClass := aClass.
! !

!NativizationPlatform methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	"super initialize.   -- commented since inherited method does nothing"
! !

!NativizationPlatform methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	self ASSERT: name notNil.
	^ name
! !

!NativizationPlatform methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: aString
	self ASSERT: name isNil.
	self ASSERT: aString notNil.

	name := aString.
! !

!NativizationPlatform methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
newCodeGenerator
	self ASSERT: codeGeneratorClass notNil.

	^ codeGeneratorClass new platform: self.
! !

!NativizationPlatform methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
newAssembler
	^ abi newAssembler platform: self
! !

!NativizationPlatform methodsFor:  'printing & storing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	super printOn:aStream.
	aStream nextPut: $(.
	name printOn:aStream.
	aStream nextPut: $).
! !

!NativizationPlatform methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
wordSize
	self ASSERT: wordSize notNil.
	^ wordSize
! !

!NativizationPlatform methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
wordSize: anInteger
	self ASSERT: wordSize isNil.
	self ASSERT:(anInteger == 8 or:[ anInteger == 4]).

	wordSize := anInteger.
! !

!NativizationPlatform methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
wordSizeShift
	^ #(0 0 0 2 0 0 0 3) at: self wordSize
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativizationPlatform class' category: #Nativization!
NativizationPlatform class
	instanceVariableNames: ''!

!NativizationPlatform class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
host
	"Return platform for the machine this code is running on."

	| host |

	host := Kernel host.
	host = 'x86_64-linux-gnu' ifTrue:[ ^ self x86_64_linux_gnu ].
	host = 'x86_64-darwin' ifTrue:[ ^ self x86_64_darwin ].
	host = 'x86_64-win32' ifTrue:[ ^self x86_64_win32 ].

	host = 'riscv64-linux-gnu' ifTrue:[ ^ self riscv64_linux_gnu ].

	self error:'Unssuported host: ', host.
! !

!NativizationPlatform class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
x86_64_darwin
	^ self new
		name: 'x86_64-darwin';
		wordSize: 8;
		abi: SysVX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;
		yourself
! !

!NativizationPlatform class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
x86_64_linux_gnu
	^ self new
		name: 'x86_64-linux-gnu';
		wordSize: 8;
		abi: SysVX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;   
		yourself
! !

!NativizationPlatform class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
x86_64_win32
	^ self new
		name: 'x86_64-win32';
		wordSize: 8;
		abi: WinX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;   
		yourself
! !


NativizationPlatform initialize!

