"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #EdenCollector,
	#superclass : #CopyingCollector,
	#instVars : [
		'oldZone',
		'edenSpace',
		'youngBase',
		'youngLimit',
		'rememberedSet',
		'rememberedNext'
	],
	#category : #Kernel
}

{ #category : #cleaning }
EdenCollector >> aboutToSaveImage [
	Kernel os release: forwarders * 2.
	forwarders := nil
]

{ #category : #cleaning }
EdenCollector >> checkEphemeron: ephemeron [
	| key |
	key := ephemeron key.
	(toSpace includes: key) ifTrue: [self _error: 'Re-tracing ephemeron'].
	(ephemeron registry == ProcessLMRStack registeredInstances
		andNot: [key class == ProcessLMRStack])
		ifTrue: [self _error: 'Invalid ephemeron']
]

{ #category : #ephemerons }
EdenCollector >> copyRescuedEphemerons [
	| copy contents |
	copy := toSpace shallowCopyCommiting: rescuedEphemerons.
	copy ifNil: [copy := oldZone shallowCopyCommiting: rescuedEphemerons].
	rescuedEphemerons := copy.
	contents := toSpace shallowCopyCommiting: rescuedEphemerons contents.
	^contents ifNil: [oldZone shallowCopyCommiting: rescuedEphemerons contents]
]

{ #category : #cleaning }
EdenCollector >> copyToOld: object [
	| copy |
	copy := oldZone shallowCopyCommiting: object.
	copy == nil
		ifTrue: [self _error: 'Could not copy young object to old space'].
	(self shouldBeRememberedWhenTenuring: object) ifTrue: [self remember: copy].
	self forward: object to: copy.
	^copy
]

{ #category : #cleaning }
EdenCollector >> copyToTo: object [
	| copy |
	copy := toSpace shallowCopyCommiting: object.
	copy == nil ifTrue: [^self copyToOld: object].
	copy _beSecondGeneration.
	self forward: object to: copy.
	^copy
]

{ #category : #cleaning }
EdenCollector >> doCollect [
	self rememberOldStacks; purgeRememberedSet.
	super doCollect.
	self restoreRememberedSet; swapMemoryFromAndTo
]

{ #category : #cleaning }
EdenCollector >> doCopy: object [
	^object _isSecondGeneration
		ifTrue: [self copyToOld: object]
		ifFalse: [self copyToTo: object]
]

{ #category : #cleaning }
EdenCollector >> followRememberedAt: index [
	| object |
	object := rememberedSet at: index.
	(self newspaceIncludes: object)
		ifTrue: [self _error: 'Young object found in remembered set'].
	self scanRemembered: object
]

{ #category : #cleaning }
EdenCollector >> forwardersSize [
	^edenSpace commitedLimit - memory youngBase * 2
]

{ #category : #cleaning }
EdenCollector >> forwardingIndexOf: anObject [
	^(anObject _asPointer - youngBase bitShift: 0 - WordSizeShift + 1) + 1
]

{ #category : #cleaning }
EdenCollector >> hasToPurge: object [
	| class |
	class := object class.
	(class == ProcessLMRStack and: [self newspaceIsRefererredByStack: object])
		ifTrue: [^false].
	^(self newspaceIncludes: object)
		or: [(self newspaceIsReferredBy: object) not]
]

{ #category : #cleaning }
EdenCollector >> initializeForwarders [
	| offset result base size |
	forwarders ifNil: [
		forwarders := Kernel os reserve: youngLimit - youngBase * 2.
		forwarders = 0
			ifTrue: [self _error: 'GC could not reserve space for young forwarders'].
		forwarders := forwarders // 2].
	offset := forwarders - youngBase.
	fromSpace commitedSize > 0 ifTrue: [
		base := fromSpace base + offset * 2.
		size := fromSpace commitedSize * 2.
		result := Kernel os commit: size at: base.
		result = 0
			ifTrue: [self
				_error: 'GC could not commit space for from-space forwarders'].
		(base // 2) _asObject _nilSlots: size // WordSize].
	base := edenSpace base + offset * 2.
	size := edenSpace commitedSize * 2.
	result := Kernel os commit: size at: base.
	result = 0
		ifTrue: [self
			_error: 'GC could not commit space for eden-space forwarders'].
	(base // 2) _asObject _nilSlots: size // WordSize
]

{ #category : #cleaning }
EdenCollector >> initializeLocals [
	| remember |
	remember := RememberedSet new initialize: 1024.
	memory rememberedSet: remember.
	rememberedNext := 1.
	super initializeLocals
]

{ #category : #cleaning }
EdenCollector >> movableBytes [
	^fromSpace commitedSize + edenSpace commitedSize * 2
]

{ #category : #cleaning }
EdenCollector >> newspaceIncludes: object [
	^object _asPointer between: youngBase and: youngLimit
]

{ #category : #cleaning }
EdenCollector >> newspaceIsRefererredByStack: aProcessStack [
	aProcessStack isValid ifFalse: [^false].
	aProcessStack isActive ifTrue: [self updateStackPointer: aProcessStack].
	aProcessStack objectsDo: [:o | 
		(o _isSmallInteger not
			and: [o _asPointer between: youngBase and: youngLimit])
			ifTrue: [^true]].
	^false
]

{ #category : #cleaning }
EdenCollector >> newspaceIsReferredBy: object [
	| max slot |
	object _isSmallInteger ifTrue: [^false].
	max := object _isBytes ifTrue: [0] ifFalse: [object _size].
	slot := object _longSlotAt: 0.
	(slot _isSmallInteger not
		and: [slot _asPointer between: youngBase and: youngLimit])
		ifTrue: [^true].
	1 to: max do: [:i | 
		slot := object _basicAt: i.
		(slot _isSmallInteger not
			and: [slot _asPointer between: youngBase and: youngLimit])
			ifTrue: [^true]].
	^false
]

{ #category : #cleaning }
EdenCollector >> postInitialize [
	rememberedSet := memory rememberedSet.
	edenSpace := memory eden.
	oldZone := memory old.
	youngBase := memory youngBase.
	youngLimit := memory youngLimit.
	super postInitialize
]

{ #category : #cleaning }
EdenCollector >> purgeCurrentRememberedSet [
	"
	In typical cases, the GC does not add any useful
	object to the remembered set while collecting.
	However, it sometimes does: for example, when
	method used by gc is changed, the corresponding
	send site in gc code will be flushed; during collection
	the SS cache is updated and pointed to the (new)
	code and remembered. In a case like that, the
	addition to the remembered set should not be
	forgotten (pun intended) after the GC pass finishes
	"
	| current |
	current := memory rememberedSet.
	1 to: current size do: [:i | | remembered |
		remembered := current at: i.
		(workSpace includes: remembered) ifFalse: [rememberedSet add: remembered]].
	current size: 0
]

{ #category : #cleaning }
EdenCollector >> purgeRememberedSet [
	| object kept |
	kept := 0.
	1 to: rememberedSet size do: [:index | 
		object := rememberedSet at: index.
		rememberedSet at: index put: nil.
		(self hasToPurge: object)
			ifFalse: [
				kept := kept + 1.
				rememberedSet at: kept put: object]
			ifTrue: [object _beNotRemembered]].
	rememberedSet size: kept
]

{ #category : #cleaning }
EdenCollector >> releaseLocals [
	"
	we do not decommit unless we were using lots of memory,
	because recommitting later can become a bottleneck
	"
	edenSpace commitedSize * 2 > 8 mbytes ifTrue: [Kernel os decommit: forwarders * 2].
	super releaseLocals
]

{ #category : #cleaning }
EdenCollector >> remember: anObject [
	anObject _beRemembered.
	rememberedSet add: anObject
]

{ #category : #cleaning }
EdenCollector >> rememberOldStacks [
	ProcessStack registeredInstances
		do: [:stack | self rememberStackIfNeeded: stack]
]

{ #category : #cleaning }
EdenCollector >> rememberStackIfNeeded: stack [
	stack _isRemembered ifTrue: [^self].
	(memory isYoung: stack) ifTrue: [^self].
	(self newspaceIsRefererredByStack: stack) ifFalse: [^self].
	rememberedSet add: stack _beRemembered
]

{ #category : #cleaning }
EdenCollector >> restoreRememberedSet [
	"
	we must do a last scan to avoid missing objects remembered in the
	lapse between the last scan cycle (just before handling ephemerons 
	and this point)
	"
	| current |
	self scanRememberedSet.
	current := memory rememberedSet.
	memory rememberedSet: rememberedSet.
	current release
]

{ #category : #cleaning }
EdenCollector >> scanBehavior: current [
	| behavior moved |
	behavior := current _longSlotAt: 0.
	behavior _isSmallInteger ifTrue: [^behavior].
	(self newspaceIncludes: behavior) ifTrue: [
		moved := self copyOf: behavior.
		^current _longSlotAt: 0 put: moved].
	^behavior
]

{ #category : #cleaning }
EdenCollector >> scanExternals [
	self scanRememberedSet
]

{ #category : #cleaning }
EdenCollector >> scanRemembered: current [
	current _isSpecial ifTrue: [self rememberSpecial: current].
	self
		scanBehavior: current;
		scanRemembered: current from: 1 to: current _strongPointersSize
]

{ #category : #cleaning }
EdenCollector >> scanRemembered: current from: start to: limit [
	| index |
	index := start.
	[index <= limit] whileTrue: [
		self updateRemembered: current at: index.
		index := index + 1]
]

{ #category : #cleaning }
EdenCollector >> scanRememberedSet [
	[
		self purgeCurrentRememberedSet.
		rememberedNext <= rememberedSet size]
		whileTrue: [
			self followRememberedAt: rememberedNext.
			rememberedNext := rememberedNext + 1]
]

{ #category : #cleaning }
EdenCollector >> scanThreadLocalStorage: thread [
	thread localStorageIndices do: [:index | | object moved |
		object := thread tlsAt: index.
		object _isSmallInteger ifTrue: [^object].
		(self newspaceIncludes: object) ifTrue: [
			moved := self copyOf: object.
			thread tlsAt: index put: moved]]
]

{ #category : #cleaning }
EdenCollector >> shouldBeRememberedWhenTenuring: object [
	^(memory pointsToYoungObjects: object)
		or: [object _isSpecial and: object class == ProcessLMRStack]
]

{ #category : #cleaning }
EdenCollector >> swapMemoryFromAndTo [
	"
	self validate.
	"
	edenSpace wipeOut; reset; leaveDispenseSpace: 0x4000 _asPointer.
	memory from wipeOut; copyFrom: toSpace.
	memory to copyFrom: fromSpace; reset
]

{ #category : #cleaning }
EdenCollector >> unmarkAll [
	
]

{ #category : #cleaning }
EdenCollector >> unscannedExternalsRemain [
	^rememberedNext <= rememberedSet size
]

{ #category : #cleaning }
EdenCollector >> update: current at: index [
	"
	fetch the object and copy it if needed. `current` MUST be in
	eden or from (never in to nor old spaces)
	"
	| object moved |
	object := current _basicAt: index.
	object _isSmallInteger ifTrue: [^object].
	(self newspaceIncludes: object) ifFalse: [^object].
	(toSpace includes: object)
		ifTrue: [self _error: 'GC is trying to update an object in to-space'].
	moved := self copyOf: object.
	^current _basicAt: index put: moved
]

{ #category : #cleaning }
EdenCollector >> updateRemembered: current at: index [
	"
	only objects in remembered set might have been updated and have
	pointers to young area in _to_ space. Therefore, we don't consider it
	an error that situation
	"
	| object moved |
	object := current _basicAt: index.
	object _isSmallInteger ifTrue: [^object].
	(self newspaceIncludes: object) ifFalse: [^object].
	^(toSpace includes: object) ifTrue: [object] ifFalse: [
		moved := self copyOf: object.
		current _basicAt: index put: moved]
]

{ #category : #cleaning }
EdenCollector >> validate [
	"
	check that no slot has been left pointing to
    wiped out space (anything in new space not pointing to to).
	"
	memory spaces do: [:space | 
		(space != memory from and: [space != edenSpace and: [space != workSpace]])
			ifTrue: [space objectsDo: [:obj | self validate: obj]]]
]

{ #category : #cleaning }
EdenCollector >> validate: anObject [
	"
	Check that no slot has been left pointing to wiped out space (anything in new space not pointing to toSpace).
	"
	| behavior |
	behavior := anObject _longSlotAt: 0.
	((self newspaceIncludes: behavior) andNot: [toSpace includes: behavior])
		ifTrue: [anObject _error: 'A young object was left outside of to-space'].
	1 to: anObject _pointersSize do: [:i | | slot |
		slot := anObject _basicAt: i.
		(slot _isSmallInteger not
			and: [(self newspaceIncludes: slot) andNot: [toSpace includes: slot]])
			ifTrue: [anObject _error: 'A young object was left outside of to-space']]
]

{ #category : #private }
EdenCollector >> workSpaceSize [
	^self forwardersSize
]

