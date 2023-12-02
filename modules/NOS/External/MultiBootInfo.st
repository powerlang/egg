Class {
	#name : #MultiBootInfo,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-External-Structures'
}

{ #category : #accessing }
MultiBootInfo class >> fields [
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
	

]

{ #category : #accessing }
MultiBootInfo >> aoutSymbol [
	"This method was automatically generated"
	^SymbolTable fromHandle: (handle structAt: 29 length: 16)
]

{ #category : #accessing }
MultiBootInfo >> aoutSymbol: anObject [
	"This method was automatically generated"
	handle structAt: 29 put: anObject getHandle length: 16.
]

{ #category : #accessing }
MultiBootInfo >> apmTable [
	"This method was automatically generated"
	^handle unsignedLongAt: 85
]

{ #category : #accessing }
MultiBootInfo >> apmTable: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 85 put: anObject
]

{ #category : #testing }
MultiBootInfo >> areMemoryAddressesValid [
	"Addresses are valid if first bit of the flags is set"
	^(self flags bitAnd: 16r00000001) = 16r00000001
]

{ #category : #testing }
MultiBootInfo >> areModulesValid [
	"Modules are valid if third bit of the flags is set"
	^(self flags bitAnd: 16r00000004) = 16r00000004
]

{ #category : #accessing }
MultiBootInfo >> bootDevice [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #accessing }
MultiBootInfo >> bootDevice: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> bootLoaderName [
	"This method was automatically generated"
	^handle unsignedLongAt: 81
]

{ #category : #accessing }
MultiBootInfo >> bootLoaderName: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 81 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> cmdLine [
	"This method was automatically generated"
	^handle unsignedLongAt: 17
]

{ #category : #accessing }
MultiBootInfo >> cmdLine: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 17 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> configTable [
	"This method was automatically generated"
	^handle unsignedLongAt: 77
]

{ #category : #accessing }
MultiBootInfo >> configTable: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 77 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> drivesAddress [
	"This method was automatically generated"
	^handle unsignedLongAt: 73
]

{ #category : #accessing }
MultiBootInfo >> drivesAddress: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 73 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> drivesLength [
	"This method was automatically generated"
	^handle unsignedLongAt: 69
]

{ #category : #accessing }
MultiBootInfo >> drivesLength: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 69 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> elfSection [
	"This method was automatically generated"
	^ElfSectionHeaderTable fromHandle: (handle structAt: 45 length: 16)
]

{ #category : #accessing }
MultiBootInfo >> elfSection: anObject [
	"This method was automatically generated"
	handle structAt: 45 put: anObject getHandle length: 16.
]

{ #category : #accessing }
MultiBootInfo >> flags [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
MultiBootInfo >> flags: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]

{ #category : #testing }
MultiBootInfo >> isMemoryMapValid [
	"Modules are valid if six bit of the flags is set"
	^(self flags bitAnd: 16r00000020) = 16r00000020
]

{ #category : #accessing }
MultiBootInfo >> memLower [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #accessing }
MultiBootInfo >> memLower: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> memUpper [
	"This method was automatically generated"
	^handle unsignedLongAt: 9
]

{ #category : #accessing }
MultiBootInfo >> memUpper: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> mmapAddress [
	"This method was automatically generated"
	^handle unsignedLongAt: 65
]

{ #category : #accessing }
MultiBootInfo >> mmapAddress: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 65 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> mmapLength [
	"This method was automatically generated"
	^handle unsignedLongAt: 61
]

{ #category : #accessing }
MultiBootInfo >> mmapLength: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 61 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> modsAddress [
	"This method was automatically generated"
	^handle unsignedLongAt: 25
]

{ #category : #accessing }
MultiBootInfo >> modsAddress: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 25 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> modsCount [
	"This method was automatically generated"
	^handle unsignedLongAt: 21
]

{ #category : #accessing }
MultiBootInfo >> modsCount: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 21 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> vbeControlInfo [
	"This method was automatically generated"
	^handle unsignedLongAt: 89
]

{ #category : #accessing }
MultiBootInfo >> vbeControlInfo: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 89 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> vbeInterfaceName [
	"This method was automatically generated"
	^handle unsignedLongAt: 109
]

{ #category : #accessing }
MultiBootInfo >> vbeInterfaceName: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 109 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> vbeInterfaceOffset [
	"This method was automatically generated"
	^handle unsignedLongAt: 105
]

{ #category : #accessing }
MultiBootInfo >> vbeInterfaceOffset: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 105 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> vbeInterfaceSegment [
	"This method was automatically generated"
	^handle unsignedLongAt: 101
]

{ #category : #accessing }
MultiBootInfo >> vbeInterfaceSegment: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 101 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> vbeMode [
	"This method was automatically generated"
	^handle unsignedLongAt: 97
]

{ #category : #accessing }
MultiBootInfo >> vbeMode: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 97 put: anObject
]

{ #category : #accessing }
MultiBootInfo >> vbeModeInfo [
	"This method was automatically generated"
	^handle unsignedLongAt: 93
]

{ #category : #accessing }
MultiBootInfo >> vbeModeInfo: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 93 put: anObject
]
