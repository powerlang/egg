'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPToken category: #PetitParser!
Object subclass: #PPToken
	instanceVariableNames: 'collection start stop'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PetitParser'!
!PPToken commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPToken methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
= anObject
	^ self class = anObject class and: [ self value = anObject value ]
! !

!PPToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
collection
	"Answer the underlying collection of this token."

	^ collection
! !

!PPToken methodsFor:  'querying' stamp: 'KenD 28/Jun/2026 13:27:39'!
column
	"Answer the column number of this token in the underlying collection."
	
	| position |
	position := 0.
	(self newline , [ :stream |
		start <= stream position
			ifTrue: [ ^ start - position ].
		position := stream position ] asParser
		/ #any asParser) star
			parse: collection.
	^ start - position
! !

!PPToken methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyFrom: aStartInteger to: aStopInteger
	^ self class on: collection start: start + aStartInteger - 1 stop: stop + aStopInteger - 3
! !

!PPToken methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hash
	^ self value hash
! !

!PPToken methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeOn: aSequenceableCollection start: aStartInteger stop: aStopInteger
	collection := aSequenceableCollection.
	start := aStartInteger.
	stop := aStopInteger
! !

!PPToken methodsFor:  'querying' stamp: 'KenD 28/Jun/2026 13:27:39'!
line
	"Answer the line number of this token in the underlying collection."
	
	| line |
	line := 1.
	(self newline , [ :stream |
		start <= stream position
			ifTrue: [ ^ line ].
		line := line + 1 ] asParser
		/ #any asParser) star
			parse: collection.
	^ line
! !

!PPToken methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
newline
	"Parser a platform independent newline sequence. LF: Unix, CR+LF: Windows, and CR: Apple."

	^ (Character lf asParser)
	/ (Character cr asParser , Character lf asParser optional)
! !

!PPToken methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; nextPutAll: self value; nextPut: $)
! !

!PPToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	"Answer the size of this token."

	^ stop - start + 1
! !

!PPToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
start
	"Answer the start position of this token in the underlying collection."

	^ start
! !

!PPToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
stop
	"Answer the stop position of this token in the underlying collection."
	
	^ stop
! !

!PPToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
value
	"Answer the contents of this token."

	^ collection copyFrom: start to: stop
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPToken class' category: #PetitParser!
PPToken class
	instanceVariableNames: ''!

!PPToken class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	self error: 'Token can only be created using a dedicated constructor.'
! !

!PPToken class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aSequenceableCollection
	^ self on: aSequenceableCollection start: 1 stop: aSequenceableCollection size
! !

!PPToken class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aSequenceableCollection start: aStartInteger stop: aStopInteger
	^ self basicNew 
		initializeOn: aSequenceableCollection
		start: aStartInteger stop: aStopInteger
! !


