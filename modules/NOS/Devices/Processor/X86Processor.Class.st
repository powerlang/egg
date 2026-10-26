'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #X86Processor category: 'SqueakNOS-Devices-Processor'!
MicroProcessor subclass: #X86Processor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Processor'!
!X86Processor methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
cr0
	<primitive: 'primitiveRead32bitRegisterCr0' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
! !

!X86Processor methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
cr0: statusWord
	<primitive: 'primitivePutIn32bitRegisterCr0' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
! !

!X86Processor methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
cr3
	<primitive: 'primitiveRead32bitRegisterCr3' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
! !

!X86Processor methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
cr3: memoryAddress
	<primitive: 'primitivePutIn32bitRegisterCr3' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
! !

!X86Processor methodsFor:  'paging' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePaging
	| pagingEnabled |
	pagingEnabled := self cr0 bitAt: 32 put: 1. "Enable paging"
	pagingEnabled := pagingEnabled bitAt: 17 put: 1. "Enable write protect"
	self cr0: pagingEnabled
! !

!X86Processor methodsFor:  'paging' stamp: 'KenD 28/Jun/2026 13:32:24'!
enablePagingWithDirectory: memoryAddress
	self pageDirectory: memoryAddress.
	self enablePaging.
! !

!X86Processor methodsFor:  'paging' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageDirectory: memoryAddress
	self cr3: memoryAddress
! !

!X86Processor methodsFor:  'registers' stamp: 'KenD 28/Jun/2026 13:32:24'!
rdtsc
	<primitive: 'primitiveReadRdtsc' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'X86Processor class' category: 'SqueakNOS-Devices-Processor'!
X86Processor class
	instanceVariableNames: ''!


