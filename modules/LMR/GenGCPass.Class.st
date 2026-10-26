'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #GenGCPass category: #Kernel!
Object subclass: #GenGCPass
	instanceVariableNames: 'time oldSize youngSize cradled tenured rememberedBefore rememberedAfter rescued'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!GenGCPass commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cradled
	^cradled
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cradled: anInteger
	cradled := anInteger
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
oldSize
	^oldSize
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
oldSize: anInteger
	oldSize := anInteger
! !

!GenGCPass methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printCSVOn: aStream
	aStream
		print: time;
		nextPutAll: ',';
		nextPutAll: (youngSize / 1024.0 printFraction: 2);
		nextPutAll: ',';
		nextPutAll: (cradled / 1024.0 printFraction: 2);
		nextPutAll: ',';
		nextPutAll: (tenured / 1024.0 printFraction: 2);
		nextPutAll: ',';
		nextPutAll: (self survivalRate * 100 printFraction: 2);
		nextPutAll: ',';
		print: rememberedBefore;
		nextPutAll: ',';
		print: rememberedAfter;
		nextPutAll: ',';
		nextPutAll: (self throughput printFraction: 2);
		nextPutAll: ',';
		print: rescued
! !

!GenGCPass methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: 'GC run took ';
		print: time;
		nextPutAll: 'ms';
		cr;
		nextPutAll: 'Young before: ';
		nextPutAll: (youngSize / 1024.0 / 1024.0 printFraction: 2);
		nextPutAll: 'mb';
		cr;
		nextPutAll: 'Young after: ';
		nextPutAll: (cradled / 1 mbytes printFraction: 2);
		nextPutAll: 'mb';
		cr;
		nextPutAll: 'Tenured: ';
		nextPutAll: (tenured / 1 mbytes printFraction: 2);
		nextPutAll: 'mb';
		cr;
		nextPutAll: 'Survival rate: ';
		nextPutAll: (self survivalRate * 100 printFraction: 2);
		nextPutAll: '%';
		cr;
		nextPutAll: 'Remembered before: ';
		print: rememberedBefore;
		cr;
		nextPutAll: 'Remembered after: ';
		print: rememberedAfter;
		cr;
		nextPutAll: 'Throughput: ~';
		nextPutAll: (self throughput printFraction: 2);
		nextPutAll: 'mb/s';
		cr;
		nextPutAll: 'Rescued ';
		print: rescued;
		nextPutAll: ' ephemerons.'
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberedAfter
	^rememberedAfter
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberedAfter: anInteger
	rememberedAfter := anInteger
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberedBefore
	^rememberedBefore
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberedBefore: anInteger
	rememberedBefore := anInteger
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rescued
	^rescued
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rescued: anInteger
	rescued := anInteger
! !

!GenGCPass methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
survivalRate
	^cradled + tenured / youngSize asFloat
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
tenured
	^tenured
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
tenured: anInteger
	tenured := anInteger
! !

!GenGCPass methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
throughput
	"
	in MBs per second
	"
	^time = 0
		ifTrue: [0]
		ifFalse: [cradled + tenured * 1000 / time mbytes asFloat]
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
time
	^time
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
time: anInteger
	time := anInteger
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
youngSize
	^youngSize
! !

!GenGCPass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
youngSize: anInteger
	youngSize := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'GenGCPass class' category: #Kernel!
GenGCPass class
	instanceVariableNames: ''!


