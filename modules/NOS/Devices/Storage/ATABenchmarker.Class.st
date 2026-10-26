'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #ATABenchmarker category: 'SqueakNOS-Devices-Storage'!
Object subclass: #ATABenchmarker
	instanceVariableNames: 'results controller'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Storage'!
!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: aTitle benchmark: aBlock
	| startTime |
	startTime := Time millisecondsToRun: aBlock.
	results at: aTitle put: startTime.
	

! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: benchTitle benchmark: aBlock size: size
	| milliseconds bytesPerSecond stream |
	milliseconds := Time millisecondsToRun: aBlock.
	bytesPerSecond := size / milliseconds * 1000.
	stream := WriteStream on: ''.
	stream
		nextPutAll: milliseconds asString;
		nextPutAll: ' ms. Throughput: '.
	(bytesPerSecond / (1024 * 1024)) asFloat absPrintOn: stream base: 10 digitCount: 5.
	stream nextPutAll: ' MB/s'.
	results at: benchTitle put: stream contents
! !

!ATABenchmarker methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
controller: aController
	controller := aController.
! !

!ATABenchmarker methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	results := Dictionary new.
	controller := ATAController primary
! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueRead102400BlocksOf512Bytes
	self at: 'Read 102400 blocks of 512 Bytes' benchmark: [ | offset | offset := 0.
		102400 timesRepeat: [
			controller issueReadFrom: offset count: 1 device: 0 timeout: 5000.
			offset := offset + 1.
		]
	] size: 102400 * 512.
	

! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueRead1024BlocksOf4KB
	| read magic |

	self
		at: 'Read 1024 blocks of 4 KB'
		benchmark: [ | offset |
			offset := 0.
			1024
				timesRepeat: [ read := controller
						issueReadFrom: offset
						count: 8
						device: 0
						timeout: 5000.
					offset = 0
						ifTrue: [ magic := read unsignedShortAt: 511 ].
					offset := offset + 8 ] ]
		size: 1024 * 8 * 512.
	self validateResult: magic
! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueRead1024BlocksOf64KB
	| read magic |
	self
		at: 'Read 1024 blocks of 64 KB'
		benchmark: [ | offset |
			offset := 0.
			1024
				timesRepeat: [ read := controller
						issueReadFrom: offset
						count: 128
						device: 0
						timeout: 5000.
					offset = 0
						ifTrue: [ magic := read unsignedShortAt: 511 ].
					offset := offset + 128 ] ]
		size: 1024 * 128 * 512.
	self validateResult: magic
! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueRead1BlockOf50MB
	| magic |
	self
		at: 'Read 1 block of 50 MB'
		benchmark: [ magic := (controller at: 1 count: 102400 of: 0) unsignedShortAt: 511 ]
		size: 102400 * 512.
		self validateResult: magic
! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueWrite102400BlocksOf512Bytes
	| array |
	array := ByteArray new: 512.
	self at: 'Write 102400 blocks of 512 Bytes' benchmark: [ | offset | offset := 0.
		102400 timesRepeat: [
			controller issueWrite: array at: offset device: 0 timeout: 5000.
			offset := offset + 1.
		]
	]  size: 102400 * 512
	

! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueWrite1024BlocksOf50KB
	| array |
	array := ByteArray new: 50*1024.
	self at: 'Write 1024 blocks of 50 KB' benchmark: [ | offset | offset := 0.
		1024 timesRepeat: [
			controller issueWrite: array at: offset device: 0 timeout: 5000.
			offset := offset + 100.
		]
	]  size: 102400 * 512
	

! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueWrite1BlockOf50MB
	| array |
	array := ByteArray new: 50*1024*1024.
	self at: 'Write 1 block of 50 MB' benchmark: [
		controller at: 1 of: 0 putAll: array.
	]  size: 102400 * 512
	

! !

!ATABenchmarker methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
run
	self issueWrite1BlockOf50MB.
	self issueRead1BlockOf50MB.
	self issueWrite1024BlocksOf50KB.
	self issueRead1024BlocksOf50KB.
! !

!ATABenchmarker methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
runRead
	self issueRead1BlockOf50MB;
	issueRead1024BlocksOf64KB;
	issueRead1024BlocksOf4KB
! !

!ATABenchmarker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
validateResult: magic
	magic = 16rAA55 ifFalse: [ self error: 'read failed' ]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ATABenchmarker class' category: 'SqueakNOS-Devices-Storage'!
ATABenchmarker class
	instanceVariableNames: ''!


ATABenchmarker initialize!

