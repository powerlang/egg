'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IPTimestamp category: 'SqueakNOS-Net-Options-IP'!
IPOption subclass: #IPTimestamp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Options-IP'!
!IPTimestamp methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: anInteger
	| timestampBytes |
	self length - 4 > self pointer ifFalse: [^ self].
	timestampBytes := (BitArray new: 4*8 with: anInteger) asByteArray.
	1 to: 4 do: [ :each | self at: self pointer + each - 1 put: (timestampBytes at: each)].
	self pointer: self pointer + 4.
	^ anInteger
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
flags
	^ self at: 5
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
flags: anInteger
	self at: 5 put: anInteger
! !

!IPTimestamp methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isPrespecified
	^ self flags = 3
! !

!IPTimestamp methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isTimestampsAndAddresses
	^ self flags = 1
! !

!IPTimestamp methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isTimestampsOnly
	^ self flags = 0
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name
	^ 'timestamp'
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
overflow
	^ self at: 4
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
overflow: anInteger
	self at: 4 put: anInteger
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pointer
	^ self at: 3
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pointer: anInteger
	self at: 3 put: anInteger
! !

!IPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
timestamps
	^ (4 to: self pointer by: 4) collect: [ :each | (BitArray bytes: (self copyFrom: each to: each + 4)) asInteger]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IPTimestamp class' category: 'SqueakNOS-Net-Options-IP'!
IPTimestamp class
	instanceVariableNames: ''!

!IPTimestamp class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 68
! !


