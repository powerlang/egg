Class {
	#name : #ATABenchmarker,
	#superclass : #Object,
	#instVars : [
		'results',
		'controller'
	],
	#category : 'SqueakNOS-Devices-Storage'
}

{ #category : #services }
ATABenchmarker >> at: aTitle benchmark: aBlock [
	| startTime |
	startTime := Time millisecondsToRun: aBlock.
	results at: aTitle put: startTime.
	

]

{ #category : #services }
ATABenchmarker >> at: benchTitle benchmark: aBlock size: size [
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
]

{ #category : #'as yet unclassified' }
ATABenchmarker >> controller: aController [
	controller := aController.
]

{ #category : #initialization }
ATABenchmarker >> initialize [
	results := Dictionary new.
	controller := ATAController primary
]

{ #category : #services }
ATABenchmarker >> issueRead102400BlocksOf512Bytes [
	self at: 'Read 102400 blocks of 512 Bytes' benchmark: [ | offset | offset := 0.
		102400 timesRepeat: [
			controller issueReadFrom: offset count: 1 device: 0 timeout: 5000.
			offset := offset + 1.
		]
	] size: 102400 * 512.
	

]

{ #category : #services }
ATABenchmarker >> issueRead1024BlocksOf4KB [
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
]

{ #category : #services }
ATABenchmarker >> issueRead1024BlocksOf64KB [
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
]

{ #category : #services }
ATABenchmarker >> issueRead1BlockOf50MB [
	| magic |
	self
		at: 'Read 1 block of 50 MB'
		benchmark: [ magic := (controller at: 1 count: 102400 of: 0) unsignedShortAt: 511 ]
		size: 102400 * 512.
		self validateResult: magic
]

{ #category : #services }
ATABenchmarker >> issueWrite102400BlocksOf512Bytes [
	| array |
	array := ByteArray new: 512.
	self at: 'Write 102400 blocks of 512 Bytes' benchmark: [ | offset | offset := 0.
		102400 timesRepeat: [
			controller issueWrite: array at: offset device: 0 timeout: 5000.
			offset := offset + 1.
		]
	]  size: 102400 * 512
	

]

{ #category : #services }
ATABenchmarker >> issueWrite1024BlocksOf50KB [
	| array |
	array := ByteArray new: 50*1024.
	self at: 'Write 1024 blocks of 50 KB' benchmark: [ | offset | offset := 0.
		1024 timesRepeat: [
			controller issueWrite: array at: offset device: 0 timeout: 5000.
			offset := offset + 100.
		]
	]  size: 102400 * 512
	

]

{ #category : #services }
ATABenchmarker >> issueWrite1BlockOf50MB [
	| array |
	array := ByteArray new: 50*1024*1024.
	self at: 'Write 1 block of 50 MB' benchmark: [
		controller at: 1 of: 0 putAll: array.
	]  size: 102400 * 512
	

]

{ #category : #'as yet unclassified' }
ATABenchmarker >> run [
	self issueWrite1BlockOf50MB.
	self issueRead1BlockOf50MB.
	self issueWrite1024BlocksOf50KB.
	self issueRead1024BlocksOf50KB.
]

{ #category : #'as yet unclassified' }
ATABenchmarker >> runRead [
	self issueRead1BlockOf50MB;
	issueRead1024BlocksOf64KB;
	issueRead1024BlocksOf4KB
]

{ #category : #services }
ATABenchmarker >> validateResult: magic [
	magic = 16rAA55 ifFalse: [ self error: 'read failed' ]
]
