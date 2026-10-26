'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #CMOS category: 'SqueakNOS-Devices-Base'!
HardwareDevice subclass: #CMOS
	instanceVariableNames: 'computer alarmBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!CMOS commentStamp: '<historical>' prior: 0!

Information on CMOS:

DS14285/DS14287 Real-Time Clock with NV RAM Control Control (PDF datasheet)
http://www.maxim-ic.com/getds.cfm?qv_pk=2717

Ralph's Brown CMOS and ports description (From his Interrupt List)
http://oopweb.com/Assembly/Documents/InterList/VolumeFrames.html

BiosCentral. CMOS memory map, no more information than the map
http://www.bioscentral.com/misc/cmosmap.htm

CMOS RAM Bank 0. Some more information on different RTC IRQs handling
http://ps-2.kev009.com:8080/ohlandl/config/cmos_bank_0.html

!

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarm
	^ Time
		hour: self alarmHour
		minute: self alarmMinute
		second: self alarmSecond
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarm: aTime
	self alarmHour: aTime hour;
		 alarmMinute: aTime minute;
		 alarmSecond: aTime second
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmBlock
	^ alarmBlock
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmBlock: aBlock
	alarmBlock := aBlock
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmHour
	^ self valueAt: 5
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmHour: aNumber
	^ self valueAt: 5 put: aNumber
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmMinute
	^ self valueAt: 3
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmMinute: aNumber
	^ self valueAt: 3 put: aNumber
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmSecond
	^ self valueAt: 1
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
alarmSecond: aNumber
	^ self valueAt: 1 put: aNumber
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: index
	self byteAt: 0 put: index.
	^ self byteAt: 1
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: index put: value
	self byteAt: 0 put: index.
	^ self byteAt: 1 put: value
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
bcdAt: index
	| value |
	value := self at: index.
	^ value // 16 * 10 + (value \\ 16)
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
bcdAt: index put: value
	^ self at: index put: value // 10 * 16 + (value \\ 10)
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
century
	^ self valueAt: 16r32
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
century: aNumber
	^ self valueAt: 16r32 put: aNumber
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
computer
	^ computer
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
computer: aComputer
	computer := aComputer
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
date
	^ Date
		newDay: self day
		month: self month
		year: self year
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
date: aDate
	self day: aDate day;
		 month: aDate month;
		 year: aDate year
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
day
	^ self valueAt: 7
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
day: aNumber
	^ self valueAt: 7 put: aNumber
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
dayOfWeek
	^ self at: 6
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
dayOfWeek: aNumber
	^ self at: 6 put: aNumber
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableAlarm
	self statusB: (self statusB bitAnd: 16rDF)
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableAlarm
	self statusB: (self statusB bitOr: 16r20)
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleIRQ
	| flags |
	flags := self statusC.
	(flags anyMask: 16r20) ifTrue: [
		"registerC must be read to clear the interrupt bits,
		 otherwise, the interrupt is generated again"
		self alarmBlock value.
	].
	self uninstallAlarm.
! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
hour
	^ self valueAt: 4
! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
hour: aNumber
	^ self valueAt: 4 put: aNumber
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
installAlarm
	self computer interruptController addHandler: self forIRQ: 8.
	self enableAlarm.
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
isBCD
	^ (self statusB anyMask: 4) not
! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
minute
	^ self valueAt: 2
! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
minute: aNumber
	^ self valueAt: 2 put: aNumber
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
month
	^ self valueAt: 8
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
month: aNumber
	^ self valueAt: 8 put: aNumber
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
onAlarmDo: aBlock
	self alarmBlock: aBlock.

! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
second
	^ (self valueAt: 0)
		bitAnd: 127
! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
second: aNumber
	^ self valueAt: 0 put: aNumber
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusA
	^ self at: 10
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusA: value
	^ self at: 10 put: value
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusB
	^ self at: 11
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusB: value
	^ self at: 11 put: value
! !

!CMOS methodsFor:  'status' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusC
	^ self at: 16rC
! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
time
	^ Time
		hour: self hour
		minute: self minute
		second: self second
! !

!CMOS methodsFor:  'time' stamp: 'KenD 28/Jun/2026 13:32:24'!
time: aTime
	self hour: aTime hour;
		 minute: aTime minute;
		 second: aTime second
! !

!CMOS methodsFor:  'alarm' stamp: 'KenD 28/Jun/2026 13:32:24'!
uninstallAlarm
	self computer interruptController removeHandler: self forIRQ: 8.
	self disableAlarm.
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
valueAt: index
	^ self isBCD
		ifTrue: [self bcdAt: index]
		ifFalse: [self at: index]
! !

!CMOS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
valueAt: index put: value
	^ self isBCD
		ifTrue: [self bcdAt: index put: value]
		ifFalse: [self at: index put: value]
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
year
	| year |
	year := self valueAt: 9.
	^ self century * 100 + year
! !

!CMOS methodsFor:  'date' stamp: 'KenD 28/Jun/2026 13:32:24'!
year: aNumber
	self valueAt: 9 put: aNumber \\ 100.
	self century: aNumber // 100.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CMOS class' category: 'SqueakNOS-Devices-Base'!
CMOS class
	instanceVariableNames: ''!

!CMOS class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	^ aComputer
		cmos: ((self onPort: 112)
				computer: aComputer)
! !


