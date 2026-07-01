'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NativeCode category: #Kernel!
Object subclass: #NativeCode
	instanceVariableNames: 'machineCode compiledCode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!NativeCode commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
block
	^compiledCode
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
block: aCompiledBlock
	compiledCode := aCompiledBlock
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
bytes
	^machineCode
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
code
	^machineCode
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
code: bytes
	machineCode := bytes
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
compiledCode
	^compiledCode
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
compiledCode: anObject
	compiledCode := anObject
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
disassembledText32
	^machineCode disassembledText32
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
disassembledText64
	^machineCode disassembledText64
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
entryPoint
	^machineCode oop
! !

!NativeCode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isNativeCode
	^true
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
method
	^compiledCode
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
method: aCompiledMethod
	compiledCode := aCompiledMethod
! !

!NativeCode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
nativeCodeAddress
	^machineCode _oop
! !

!NativeCode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
newEnvironment: anInteger
	^Array new: anInteger
! !

!NativeCode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendSites
	^self select: [:obj | obj class == SendSite]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativeCode class' category: #Kernel!
NativeCode class
	instanceVariableNames: ''!

!NativeCode class methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:39'!
aspects
	^#(#disassembledText32 #disassembledText64)
! !


