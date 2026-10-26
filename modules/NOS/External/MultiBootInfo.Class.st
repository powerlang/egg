'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #MultiBootInfo category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #MultiBootInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
aoutSymbol
	"This method was automatically generated"
	^SymbolTable fromHandle: (handle structAt: 29 length: 16)
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
aoutSymbol: anObject
	"This method was automatically generated"
	handle structAt: 29 put: anObject getHandle length: 16.
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
apmTable
	"This method was automatically generated"
	^handle unsignedLongAt: 85
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
apmTable: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 85 put: anObject
! !

!MultiBootInfo methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
areMemoryAddressesValid
	"Addresses are valid if first bit of the flags is set"
	^(self flags bitAnd: 16r00000001) = 16r00000001
! !

!MultiBootInfo methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
areModulesValid
	"Modules are valid if third bit of the flags is set"
	^(self flags bitAnd: 16r00000004) = 16r00000004
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bootDevice
	"This method was automatically generated"
	^handle unsignedLongAt: 13
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bootDevice: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bootLoaderName
	"This method was automatically generated"
	^handle unsignedLongAt: 81
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bootLoaderName: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 81 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
cmdLine
	"This method was automatically generated"
	^handle unsignedLongAt: 17
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
cmdLine: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 17 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
configTable
	"This method was automatically generated"
	^handle unsignedLongAt: 77
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
configTable: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 77 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
drivesAddress
	"This method was automatically generated"
	^handle unsignedLongAt: 73
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
drivesAddress: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 73 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
drivesLength
	"This method was automatically generated"
	^handle unsignedLongAt: 69
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
drivesLength: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 69 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
elfSection
	"This method was automatically generated"
	^ElfSectionHeaderTable fromHandle: (handle structAt: 45 length: 16)
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
elfSection: anObject
	"This method was automatically generated"
	handle structAt: 45 put: anObject getHandle length: 16.
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
flags
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
flags: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !

!MultiBootInfo methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isMemoryMapValid
	"Modules are valid if six bit of the flags is set"
	^(self flags bitAnd: 16r00000020) = 16r00000020
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memLower
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memLower: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memUpper
	"This method was automatically generated"
	^handle unsignedLongAt: 9
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
memUpper: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mmapAddress
	"This method was automatically generated"
	^handle unsignedLongAt: 65
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mmapAddress: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 65 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mmapLength
	"This method was automatically generated"
	^handle unsignedLongAt: 61
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mmapLength: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 61 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
modsAddress
	"This method was automatically generated"
	^handle unsignedLongAt: 25
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
modsAddress: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 25 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
modsCount
	"This method was automatically generated"
	^handle unsignedLongAt: 21
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
modsCount: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 21 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeControlInfo
	"This method was automatically generated"
	^handle unsignedLongAt: 89
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeControlInfo: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 89 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeInterfaceName
	"This method was automatically generated"
	^handle unsignedLongAt: 109
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeInterfaceName: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 109 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeInterfaceOffset
	"This method was automatically generated"
	^handle unsignedLongAt: 105
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeInterfaceOffset: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 105 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeInterfaceSegment
	"This method was automatically generated"
	^handle unsignedLongAt: 101
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeInterfaceSegment: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 101 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeMode
	"This method was automatically generated"
	^handle unsignedLongAt: 97
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeMode: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 97 put: anObject
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeModeInfo
	"This method was automatically generated"
	^handle unsignedLongAt: 93
! !

!MultiBootInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
vbeModeInfo: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 93 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MultiBootInfo class' category: 'SqueakNOS-External-Structures'!
MultiBootInfo class
	instanceVariableNames: ''!

!MultiBootInfo class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	^#(
		(flags 'ulong')
		(memLower 'ulong')
		(memUpper 'ulong')
		(bootDevice 'ulong')
		(cmdLine 'ulong')
		(modsCount 'ulong')
		(modsAddress 'ulong')
		(aoutSymbol 'SymbolTable')
		(elfSection 'ElfSectionHeaderTable')
		(mmapLength 'ulong')
		(mmapAddress 'ulong')
		(drivesLength 'ulong')
		(drivesAddress 'ulong')
		(configTable 'ulong')
		(bootLoaderName 'ulong')
		(apmTable 'ulong')
		(vbeControlInfo 'ulong')
		(vbeModeInfo 'ulong')
		(vbeMode 'ulong')
		(vbeInterfaceSegment 'ulong')
		(vbeInterfaceOffset 'ulong')
		(vbeInterfaceName 'ulong')
	    )
	

! !


