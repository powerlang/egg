'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #IDEHardDiskDeviceInformation category: 'SqueakNOS-Devices-Storage'!
ExternalStructure subclass: #IDEHardDiskDeviceInformation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Storage'!
!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
capabilities
	"This method was automatically generated"
	^handle signedLongAt: 99
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
capabilities: anObject
	"This method was automatically generated"
	handle signedLongAt: 99 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
configuration
	"This method was automatically generated"
	^handle signedShortAt: 1
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
configuration: anObject
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
cylindersCurrent
	"This method was automatically generated"
	^handle signedShortAt: 109
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
cylindersCurrent: anObject
	"This method was automatically generated"
	handle signedShortAt: 109 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
cylindersDefault
	"This method was automatically generated"
	^handle signedShortAt: 3
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
cylindersDefault: anObject
	"This method was automatically generated"
	handle signedShortAt: 3 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
headsCurrent
	"This method was automatically generated"
	^handle signedShortAt: 111
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
headsCurrent: anObject
	"This method was automatically generated"
	handle signedShortAt: 111 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
headsDefault
	"This method was automatically generated"
	^handle signedShortAt: 7
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
headsDefault: anObject
	"This method was automatically generated"
	handle signedShortAt: 7 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
minMultiwordDMAtime
	"This method was automatically generated"
	^handle signedShortAt: 131
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
minMultiwordDMAtime: anObject
	"This method was automatically generated"
	handle signedShortAt: 131 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
model
	^self stringAt: 55 length: 40
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
multiwordDMAtransfer
	"This method was automatically generated"
	^handle signedShortAt: 127
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
multiwordDMAtransfer: anObject
	"This method was automatically generated"
	handle signedShortAt: 127 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pioMode
	"This method was automatically generated"
	^handle signedShortAt: 129
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pioMode: anObject
	"This method was automatically generated"
	handle signedShortAt: 129 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	aStream << self model; cr;
		<< 'sectors: '; << self sectors; cr;
		<<'capabilities: '; << self capabilities hex ; cr;
		<< 'configuration: '; << self configuration hex; cr;
		<< 'version: '; << self version; cr;
		<< 'serial: '; << self serial; cr;
		<< 'pioMode: '; << self pioMode; cr;
		<< 'multiwordDMAtransfer: '; << self multiwordDMAtransfer
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectors
	"This method was automatically generated"
	^handle signedLongAt: 121
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectors: anObject
	"This method was automatically generated"
	handle signedLongAt: 121 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsCurrent
	"This method was automatically generated"
	^handle signedShortAt: 113
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsCurrent: anObject
	"This method was automatically generated"
	handle signedShortAt: 113 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsDefault
	"This method was automatically generated"
	^handle signedShortAt: 13
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsDefault: anObject
	"This method was automatically generated"
	handle signedShortAt: 13 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsExtended
	"writtenByHand"

	| lo hi |
	lo := handle unsignedLongAt: 201.
	hi := handle unsignedShortAt: 205.
	^lo + (hi bitShift: 32)
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsMultiple
	"This method was automatically generated"
	^handle signedShortAt: 119
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsMultiple: anObject
	"This method was automatically generated"
	handle signedShortAt: 119 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsMultipleMax
	"This method was automatically generated"
	^handle signedShortAt: 95
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sectorsMultipleMax: anObject
	"This method was automatically generated"
	handle signedShortAt: 95 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
serial
	^self stringAt: 21 length: 10
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
specific
	"This method was automatically generated"
	^handle signedShortAt: 5
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
specific: anObject
	"This method was automatically generated"
	handle signedShortAt: 5 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
stringAt: byteOffset length: length
	"Return a structure of the given length starting at the indicated byte offset."
	| value |
	value := String new: length.
	1 to: length do:[:i|
		value
			at: i + (i odd ifTrue: [1] ifFalse: [-1])
			put: (handle unsignedCharAt: byteOffset+i-1)].
	^value
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
totalSectorsCurrent
	"This method was automatically generated"
	^handle signedLongAt: 115
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
totalSectorsCurrent: anObject
	"This method was automatically generated"
	handle signedLongAt: 115 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
validity
	"This method was automatically generated"
	^handle signedShortAt: 107
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
validity: anObject
	"This method was automatically generated"
	handle signedShortAt: 107 put: anObject
! !

!IDEHardDiskDeviceInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
version
	^self stringAt: 47 length: 8

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IDEHardDiskDeviceInformation class' category: 'SqueakNOS-Devices-Storage'!
IDEHardDiskDeviceInformation class
	instanceVariableNames: ''!

!IDEHardDiskDeviceInformation class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
fields
	"self defineFields"
	^#(
		(configuration		'short')		" 0 "
		(cylindersDefault	'short')
		(specific			'short')
		(headsDefault		'short')
		(nil					'long')		" 4-5 "
		(sectorsDefault		'short')		" 6 "
		(nil					'long')		" 7-8 "
		(nil					'short')		" 9 "
		(serial				'string' 20)	" 10-19 "
		(nil					'long')		" 20-21 "
		(nil					'short')
		(version			'string' 8)	" 23-26 "
		(model				'string' 40)	" 27-46 "
		(sectorsMultipleMax	'short')		" 47 "
		(nil					'short')
		(capabilities			'long')
		(nil					'long')
		(validity			'short')		" 53 "
		(cylindersCurrent	'short')
		(headsCurrent		'short')
		(sectorsCurrent		'short')
		(totalSectorsCurrent	'long')
		(sectorsMultiple		'short')
		(sectors				'long')		" 60-61 "
		(nil					'short')
		(multiwordDMAtransfer		'short')
		(pioMode			'short')
		(minMultiwordDMAtime	'short')

	)
! !


