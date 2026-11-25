'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestResource category: #SUnit!
Object subclass: #TestResource
	instanceVariableNames: 'name description'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!TestResource commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!TestResource methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
beAvailable
	self isAvailable ifFalse: [self signalInitializationError]
! !

!TestResource methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
beAvailableFor: aTestSuite
	self beAvailable
! !

!TestResource methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description
	description isNil ifTrue: [^''].
	^description
! !

!TestResource methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description: aString
	description := aStrin
! !

!TestResource methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	self setUp
! !

!TestResource methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isAvailable
	^true
! !

!TestResource methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isUnavailable
	^self isAvailable not
! !

!TestResource methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name
	name isNil ifTrue: [^self printString].
	^name
! !

!TestResource methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name: aString
	name := aString
! !

!TestResource methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printOn: aStream
	aStream nextPutAll: self class printString
! !

!TestResource methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
resources
	^self class resources
! !

!TestResource methodsFor:  'set up' stamp: 'KenD 28/Jun/2026 13:27:37'!
setUp
! !

!TestResource methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
signalInitializationError
	^self class signalInitializationError
! !

!TestResource methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
tearDown
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestResource class' category: #SUnit!
TestResource class
	instanceVariableNames: ''!

!TestResource class methodsFor:  'pm support' stamp: 'KenD 28/Jun/2026 13:27:37'!
aboutToSaveLibraryOn: aCodeSegmentBuilder
	aCodeSegmentBuilder map: current to: nil
! !

!TestResource class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
beAvailableFor: aTestSuite
	^self current notNil and: [self current beAvailableFor: aTestSuite]
! !

!TestResource class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
current
	current isNil ifTrue: [current := self new].
	^current
! !

!TestResource class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
current: aTestResource
	current := aTestResource
! !

!TestResource class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isAbstract
	"Override to true if a TestResource subclass is Abstract and should not have TestCase
	instances built from it"
	^self name = 'TestResource'
! !

!TestResource class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isUnavailable
	^self isAvailable not
! !

!TestResource class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
reset
	current notNil ifTrue: [[current tearDown] ensure: [current := nil]]
! !

!TestResource class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
resources
	^#()
! !

!TestResource class methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
signalInitializationError
	^TestResult
		signalErrorWith: 'Resource ' , self name , ' could not be initialized'
! !


TestResource initialize!

