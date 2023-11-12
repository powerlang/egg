Class {
	#name : #IDEHardDiskDeviceInformation,
	#superclass : #ExternalStructure,
	#category : #'SqueakNOS-Devices-Storage'
}

{ #category : #'as yet unclassified' }
IDEHardDiskDeviceInformation class >> fields [
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
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> capabilities [
	"This method was automatically generated"
	^handle signedLongAt: 99
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> capabilities: anObject [
	"This method was automatically generated"
	handle signedLongAt: 99 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> configuration [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> configuration: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> cylindersCurrent [
	"This method was automatically generated"
	^handle signedShortAt: 109
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> cylindersCurrent: anObject [
	"This method was automatically generated"
	handle signedShortAt: 109 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> cylindersDefault [
	"This method was automatically generated"
	^handle signedShortAt: 3
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> cylindersDefault: anObject [
	"This method was automatically generated"
	handle signedShortAt: 3 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> headsCurrent [
	"This method was automatically generated"
	^handle signedShortAt: 111
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> headsCurrent: anObject [
	"This method was automatically generated"
	handle signedShortAt: 111 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> headsDefault [
	"This method was automatically generated"
	^handle signedShortAt: 7
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> headsDefault: anObject [
	"This method was automatically generated"
	handle signedShortAt: 7 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> minMultiwordDMAtime [
	"This method was automatically generated"
	^handle signedShortAt: 131
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> minMultiwordDMAtime: anObject [
	"This method was automatically generated"
	handle signedShortAt: 131 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> model [
	^self stringAt: 55 length: 40
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> multiwordDMAtransfer [
	"This method was automatically generated"
	^handle signedShortAt: 127
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> multiwordDMAtransfer: anObject [
	"This method was automatically generated"
	handle signedShortAt: 127 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> pioMode [
	"This method was automatically generated"
	^handle signedShortAt: 129
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> pioMode: anObject [
	"This method was automatically generated"
	handle signedShortAt: 129 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectors [
	"This method was automatically generated"
	^handle signedLongAt: 121
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectors: anObject [
	"This method was automatically generated"
	handle signedLongAt: 121 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsCurrent [
	"This method was automatically generated"
	^handle signedShortAt: 113
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsCurrent: anObject [
	"This method was automatically generated"
	handle signedShortAt: 113 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsDefault [
	"This method was automatically generated"
	^handle signedShortAt: 13
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsDefault: anObject [
	"This method was automatically generated"
	handle signedShortAt: 13 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsExtended [
	"writtenByHand"

	| lo hi |
	lo := handle unsignedLongAt: 201.
	hi := handle unsignedShortAt: 205.
	^lo + (hi bitShift: 32)
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsMultiple [
	"This method was automatically generated"
	^handle signedShortAt: 119
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsMultiple: anObject [
	"This method was automatically generated"
	handle signedShortAt: 119 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsMultipleMax [
	"This method was automatically generated"
	^handle signedShortAt: 95
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> sectorsMultipleMax: anObject [
	"This method was automatically generated"
	handle signedShortAt: 95 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> serial [
	^self stringAt: 21 length: 10
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> specific [
	"This method was automatically generated"
	^handle signedShortAt: 5
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> specific: anObject [
	"This method was automatically generated"
	handle signedShortAt: 5 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> stringAt: byteOffset length: length [
	"Return a structure of the given length starting at the indicated byte offset."
	| value |
	value := String new: length.
	1 to: length do:[:i|
		value
			at: i + (i odd ifTrue: [1] ifFalse: [-1])
			put: (handle unsignedCharAt: byteOffset+i-1)].
	^value
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> totalSectorsCurrent [
	"This method was automatically generated"
	^handle signedLongAt: 115
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> totalSectorsCurrent: anObject [
	"This method was automatically generated"
	handle signedLongAt: 115 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> validity [
	"This method was automatically generated"
	^handle signedShortAt: 107
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> validity: anObject [
	"This method was automatically generated"
	handle signedShortAt: 107 put: anObject
]

{ #category : #accessing }
IDEHardDiskDeviceInformation >> version [
	^self stringAt: 47 length: 8

]
