"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #GenGCPass,
	#superclass : #Object,
	#instVars : [
		'time',
		'oldSize',
		'youngSize',
		'cradled',
		'tenured',
		'rememberedBefore',
		'rememberedAfter',
		'rescued'
	],
	#category : #Kernel
}

{ #category : #accessing }
GenGCPass >> cradled [
	^cradled
]

{ #category : #accessing }
GenGCPass >> cradled: anInteger [
	cradled := anInteger
]

{ #category : #accessing }
GenGCPass >> oldSize [
	^oldSize
]

{ #category : #accessing }
GenGCPass >> oldSize: anInteger [
	oldSize := anInteger
]

{ #category : #printing }
GenGCPass >> printCSVOn: aStream [
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
]

{ #category : #printing }
GenGCPass >> printOn: aStream [
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
]

{ #category : #accessing }
GenGCPass >> rememberedAfter [
	^rememberedAfter
]

{ #category : #accessing }
GenGCPass >> rememberedAfter: anInteger [
	rememberedAfter := anInteger
]

{ #category : #accessing }
GenGCPass >> rememberedBefore [
	^rememberedBefore
]

{ #category : #accessing }
GenGCPass >> rememberedBefore: anInteger [
	rememberedBefore := anInteger
]

{ #category : #accessing }
GenGCPass >> rescued [
	^rescued
]

{ #category : #accessing }
GenGCPass >> rescued: anInteger [
	rescued := anInteger
]

{ #category : #inquiries }
GenGCPass >> survivalRate [
	^cradled + tenured / youngSize asFloat
]

{ #category : #accessing }
GenGCPass >> tenured [
	^tenured
]

{ #category : #accessing }
GenGCPass >> tenured: anInteger [
	tenured := anInteger
]

{ #category : #inquiries }
GenGCPass >> throughput [
	"
	in MBs per second
	"
	^time = 0
		ifTrue: [0]
		ifFalse: [cradled + tenured * 1000 / time mbytes asFloat]
]

{ #category : #accessing }
GenGCPass >> time [
	^time
]

{ #category : #accessing }
GenGCPass >> time: anInteger [
	time := anInteger
]

{ #category : #accessing }
GenGCPass >> youngSize [
	^youngSize
]

{ #category : #accessing }
GenGCPass >> youngSize: anInteger [
	youngSize := anInteger
]

