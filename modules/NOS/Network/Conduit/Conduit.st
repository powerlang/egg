Class {
	#name : #Conduit,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'timer'
	],
	#category : 'SqueakNOS-Net-Conduits'
}

{ #category : #'instance creation' }
Conduit class >> new [
	^ super new initialize
]

{ #category : #accessing }
Conduit >> < aConduit [
	^ aConduit left: self
]

{ #category : #flow }
Conduit >> << anObject [
	self output: anObject
]

{ #category : #accessing }
Conduit >> > aConduit [
	^ self add: aConduit
]

{ #category : #flow }
Conduit >> accepts: aPacket [
	^ true
]

{ #category : #accessing }
Conduit >> add: aConduit [
	^ right add: aConduit
]

{ #category : #accessing }
Conduit >> detach [
	self unschedule.
	left remove: self
]

{ #category : #enumerating }
Conduit >> do: aBlock [
	right do: aBlock
]

{ #category : #accessing }
Conduit >> findA: aClass [
	^ self findA: aClass ifNone: []
]

{ #category : #accessing }
Conduit >> findA: aClass ifNone: aBlock [
	| found |
	(self isKindOf: aClass) ifTrue: [^ self].
	self do: [ :each | (found := each findA: aClass ifNone: []) ifNotNil: [^ found]].
	^ aBlock value
]

{ #category : #initialization }
Conduit >> initialize [
	right := OrderedCollection new.
	timer := ConduitTimer new
]

{ #category : #flow }
Conduit >> input: anObject [
	| delivered |
	anObject isNil ifTrue: [^ self].
	delivered := false.
	self do: [ :each |
		(each accepts: anObject)
			ifTrue: [delivered := true.
					each input: anObject]].
	delivered ifFalse: [self undeliverable: anObject]
]

{ #category : #'accessing-private' }
Conduit >> left: aConduit [
	left := aConduit
]

{ #category : #accessing }
Conduit >> mtu [
	^ (left ifNil: [^ 0]) mtu
]

{ #category : #flow }
Conduit >> output: anObject [
	left << anObject
]

{ #category : #accessing }
Conduit >> remove: aConduit [
	^ right remove: aConduit
]

{ #category : #timer }
Conduit >> schedule [
	^ self
]

{ #category : #timer }
Conduit >> timer [
	^ timer
]

{ #category : #timer }
Conduit >> timerDown [
	self unschedule.
	timer down
]

{ #category : #timer }
Conduit >> timerUp [
	timer up.
	self schedule
]

{ #category : #flow }
Conduit >> undeliverable: anObject [
	^ self "drop it"
]

{ #category : #timer }
Conduit >> unschedule [
	timer removeAlarmsFor: self
]

{ #category : #accessing }
Conduit >> | aConduit [
	^ self > aConduit; < aConduit
]
