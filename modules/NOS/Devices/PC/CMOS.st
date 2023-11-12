"
Information on CMOS:

DS14285/DS14287 Real-Time Clock with NV RAM Control Control (PDF datasheet)
http://www.maxim-ic.com/getds.cfm?qv_pk=2717

Ralph's Brown CMOS and ports description (From his Interrupt List)
http://oopweb.com/Assembly/Documents/InterList/VolumeFrames.html

BiosCentral. CMOS memory map, no more information than the map
http://www.bioscentral.com/misc/cmosmap.htm

CMOS RAM Bank 0. Some more information on different RTC IRQs handling
http://ps-2.kev009.com:8080/ohlandl/config/cmos_bank_0.html

"
Class {
	#name : #CMOS,
	#superclass : #HardwareDevice,
	#instVars : [
		'computer',
		'alarmBlock'
	],
	#category : #'SqueakNOS-Devices-Base'
}

{ #category : #'as yet unclassified' }
CMOS class >> installOn: aComputer [ 
	^ aComputer
		cmos: ((self onPort: 112)
				computer: aComputer)
]

{ #category : #alarm }
CMOS >> alarm [
	^ Time
		hour: self alarmHour
		minute: self alarmMinute
		second: self alarmSecond
]

{ #category : #alarm }
CMOS >> alarm: aTime [ 
	self alarmHour: aTime hour;
		 alarmMinute: aTime minute;
		 alarmSecond: aTime second
]

{ #category : #accessing }
CMOS >> alarmBlock [
	^ alarmBlock
]

{ #category : #accessing }
CMOS >> alarmBlock: aBlock [
	alarmBlock := aBlock
]

{ #category : #alarm }
CMOS >> alarmHour [
	^ self valueAt: 5
]

{ #category : #alarm }
CMOS >> alarmHour: aNumber [ 
	^ self valueAt: 5 put: aNumber
]

{ #category : #alarm }
CMOS >> alarmMinute [
	^ self valueAt: 3
]

{ #category : #alarm }
CMOS >> alarmMinute: aNumber [ 
	^ self valueAt: 3 put: aNumber
]

{ #category : #alarm }
CMOS >> alarmSecond [
	^ self valueAt: 1
]

{ #category : #alarm }
CMOS >> alarmSecond: aNumber [ 
	^ self valueAt: 1 put: aNumber
]

{ #category : #accessing }
CMOS >> at: index [ 
	self byteAt: 0 put: index.
	^ self byteAt: 1
]

{ #category : #accessing }
CMOS >> at: index put: value [ 
	self byteAt: 0 put: index.
	^ self byteAt: 1 put: value
]

{ #category : #accessing }
CMOS >> bcdAt: index [ 
	| value |
	value := self at: index.
	^ value // 16 * 10 + (value \\ 16)
]

{ #category : #accessing }
CMOS >> bcdAt: index put: value [ 
	^ self at: index put: value // 10 * 16 + (value \\ 10)
]

{ #category : #date }
CMOS >> century [
	^ self valueAt: 16r32
]

{ #category : #date }
CMOS >> century: aNumber [
	^ self valueAt: 16r32 put: aNumber
]

{ #category : #accessing }
CMOS >> computer [
	^ computer
]

{ #category : #accessing }
CMOS >> computer: aComputer [ 
	computer := aComputer
]

{ #category : #date }
CMOS >> date [
	^ Date
		newDay: self day
		month: self month
		year: self year
]

{ #category : #date }
CMOS >> date: aDate [ 
	self day: aDate day;
		 month: aDate month;
		 year: aDate year
]

{ #category : #date }
CMOS >> day [
	^ self valueAt: 7
]

{ #category : #date }
CMOS >> day: aNumber [ 
	^ self valueAt: 7 put: aNumber
]

{ #category : #date }
CMOS >> dayOfWeek [
	^ self at: 6
]

{ #category : #date }
CMOS >> dayOfWeek: aNumber [ 
	^ self at: 6 put: aNumber
]

{ #category : #status }
CMOS >> disableAlarm [
	self statusB: (self statusB bitAnd: 16rDF)
]

{ #category : #status }
CMOS >> enableAlarm [
	self statusB: (self statusB bitOr: 16r20)
]

{ #category : #alarm }
CMOS >> handleIRQ [
	| flags |
	flags := self statusC.
	(flags anyMask: 16r20) ifTrue: [
		"registerC must be read to clear the interrupt bits,
		 otherwise, the interrupt is generated again"
		self alarmBlock value.
	].
	self uninstallAlarm.
]

{ #category : #time }
CMOS >> hour [
	^ self valueAt: 4
]

{ #category : #time }
CMOS >> hour: aNumber [ 
	^ self valueAt: 4 put: aNumber
]

{ #category : #alarm }
CMOS >> installAlarm [
	self computer interruptController addHandler: self forIRQ: 8.
	self enableAlarm.
]

{ #category : #status }
CMOS >> isBCD [
	^ (self statusB anyMask: 4) not
]

{ #category : #time }
CMOS >> minute [
	^ self valueAt: 2
]

{ #category : #time }
CMOS >> minute: aNumber [ 
	^ self valueAt: 2 put: aNumber
]

{ #category : #date }
CMOS >> month [
	^ self valueAt: 8
]

{ #category : #date }
CMOS >> month: aNumber [ 
	^ self valueAt: 8 put: aNumber
]

{ #category : #alarm }
CMOS >> onAlarmDo: aBlock [
	self alarmBlock: aBlock.

]

{ #category : #time }
CMOS >> second [
	^ (self valueAt: 0)
		bitAnd: 127
]

{ #category : #time }
CMOS >> second: aNumber [ 
	^ self valueAt: 0 put: aNumber
]

{ #category : #status }
CMOS >> statusA [
	^ self at: 10
]

{ #category : #status }
CMOS >> statusA: value [ 
	^ self at: 10 put: value
]

{ #category : #status }
CMOS >> statusB [
	^ self at: 11
]

{ #category : #status }
CMOS >> statusB: value [ 
	^ self at: 11 put: value
]

{ #category : #status }
CMOS >> statusC [
	^ self at: 16rC
]

{ #category : #time }
CMOS >> time [
	^ Time
		hour: self hour
		minute: self minute
		second: self second
]

{ #category : #time }
CMOS >> time: aTime [ 
	self hour: aTime hour;
		 minute: aTime minute;
		 second: aTime second
]

{ #category : #alarm }
CMOS >> uninstallAlarm [
	self computer interruptController removeHandler: self forIRQ: 8.
	self disableAlarm.
]

{ #category : #accessing }
CMOS >> valueAt: index [ 
	^ self isBCD
		ifTrue: [self bcdAt: index]
		ifFalse: [self at: index]
]

{ #category : #accessing }
CMOS >> valueAt: index put: value [ 
	^ self isBCD
		ifTrue: [self bcdAt: index put: value]
		ifFalse: [self at: index put: value]
]

{ #category : #date }
CMOS >> year [
	| year |
	year := self valueAt: 9.
	^ self century * 100 + year
]

{ #category : #date }
CMOS >> year: aNumber [ 
	self valueAt: 9 put: aNumber \\ 100.
	self century: aNumber // 100.
]
