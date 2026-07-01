'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #Conduit category: 'SqueakNOS-Net-Conduits'!
Object subclass: #Conduit
	instanceVariableNames: 'left right timer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Conduits'!
!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
< aConduit
	^ aConduit left: self
! !

!Conduit methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
<< anObject
	self output: anObject
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
> aConduit
	^ self add: aConduit
! !

!Conduit methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ true
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: aConduit
	^ right add: aConduit
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
detach
	self unschedule.
	left remove: self
! !

!Conduit methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:32:25'!
do: aBlock
	right do: aBlock
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
findA: aClass
	^ self findA: aClass ifNone: []
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
findA: aClass ifNone: aBlock
	| found |
	(self isKindOf: aClass) ifTrue: [^ self].
	self do: [ :each | (found := each findA: aClass ifNone: []) ifNotNil: [^ found]].
	^ aBlock value
! !

!Conduit methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	right := OrderedCollection new.
	timer := ConduitTimer new
! !

!Conduit methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: anObject
	| delivered |
	anObject isNil ifTrue: [^ self].
	delivered := false.
	self do: [ :each |
		(each accepts: anObject)
			ifTrue: [delivered := true.
					each input: anObject]].
	delivered ifFalse: [self undeliverable: anObject]
! !

!Conduit methodsFor:  'accessing-private' stamp: 'KenD 28/Jun/2026 13:32:25'!
left: aConduit
	left := aConduit
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu
	^ (left ifNil: [^ 0]) mtu
! !

!Conduit methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
output: anObject
	left << anObject
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remove: aConduit
	^ right remove: aConduit
! !

!Conduit methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
schedule
	^ self
! !

!Conduit methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
timer
	^ timer
! !

!Conduit methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
timerDown
	self unschedule.
	timer down
! !

!Conduit methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
timerUp
	timer up.
	self schedule
! !

!Conduit methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
undeliverable: anObject
	^ self "drop it"
! !

!Conduit methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
unschedule
	timer removeAlarmsFor: self
! !

!Conduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
| aConduit
	^ self > aConduit; < aConduit
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Conduit class' category: 'SqueakNOS-Net-Conduits'!
Conduit class
	instanceVariableNames: ''!

!Conduit class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ super new initialize
! !


Conduit initialize!

