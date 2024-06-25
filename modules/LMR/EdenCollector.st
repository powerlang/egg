"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #EdenCollector,
	#superclass : #CopyingCollector,
	#instVars : [
		'oldSpace',
		'edenSpace',
		'youngBase',
		'youngLimit',
		'rememberedSet',
		'rememberedNext'
	],
	#category : #Kernel
}

{ #category : #cleaning }
EdenCollector >> copyToOld: object [
	| copy |
	copy := oldSpace shallowCopy: object.
	copy _isSmallInteger ifTrue: [
		memory commitMoreSpace.
		^self copyToOld: object].
	self remember: copy.
	self forward: object to: copy.
	^copy
]

{ #category : #cleaning }
EdenCollector >> copyToTo: object [
	| copy |
	copy := toSpace shallowCopy: object.
	copy _isSmallInteger ifTrue: [^self copyToOld: object].
	copy _beSecondGeneration.
	self forward: object to: copy.
	^copy
]

{ #category : #cleaning }
EdenCollector >> doCollect [
	self rememberOldStacks; purgeRememberedSet.
	super doCollect.
	self restoreRememberedSet
]

{ #category : #cleaning }
EdenCollector >> doCopy: object [
	^object _isSecondGeneration
		ifTrue: [self copyToOld: object]
		ifFalse: [self copyToTo: object]
]

{ #category : #cleaning }
EdenCollector >> followNativeCodeObject: offset from: bytes [
	| object moved |
	object := bytes _objectAtOffset: offset.
	object _isSmallInteger ifTrue: [^self].
	(self newspaceIncludes: object) ifTrue: [
		moved := self copyOf: object.
		bytes _objectAtOffset: offset put: moved]
]

{ #category : #cleaning }
EdenCollector >> followRemembered: object at: index [
	"
	If the object is old, we have to scan its slots right now. If
	it is new, move it to to and it will be scanned later while
	following internals.
	"
	(self newspaceIncludes: object)
		ifTrue: [self update: rememberedSet contents at: index]
		ifFalse: [self scan: object]
]

{ #category : #cleaning }
EdenCollector >> forwardingIndexOf: anObject [
	^(anObject _asPointer - youngBase bitShift: 0 - WordSizeShift + 1) + 1
]

{ #category : #cleaning }
EdenCollector >> hasToPurge: object [
	"
	We purge the contents of the remembered set if it was added
	to the remembered set itself (this can normally happen during
	become). It is required to avoid scanning twice the remembered
	set contents (which would potentially corrupt its pointers)
	"
	| class |
	class := object class.
	(class == NativeCode and: [self newspaceIsReferredByNativeCode: object])
		ifTrue: [^false].
	(class == StackWrapper and: [self newspaceIsRefererredByStack: object])
		ifTrue: [^false].
	object == rememberedSet contents ifTrue: [^true].
	^(self newspaceIncludes: object)
		or: [(self newspaceIsReferredBy: object) not]
]

{ #category : #cleaning }
EdenCollector >> initializeLocals [
	memory rememberedSet: (CriticalArray on: workSpace reserving: 1024).
	rememberedNext := 1.
	super initializeLocals
]

{ #category : #cleaning }
EdenCollector >> newspaceIncludes: object [
	^object _asPointer between: youngBase and: youngLimit
]

{ #category : #cleaning }
EdenCollector >> newspaceIsRefererredByStack: aStackWrapper [
	aStackWrapper objectsDo: [:o | 
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
	slot := object _basicULongAt: 0.
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
EdenCollector >> newspaceIsReferredByNativeCode: nativeCode [
	nativeCode isFresh ifFalse: [^false].
	nativeCode references do: [:encoded | | code slot |
		code := nativeCode code.
		(nativeCode isObjectReference: encoded) ifTrue: [
			slot := code _objectAtOffset: encoded.
			(slot _isSmallInteger not
				and: [slot _asPointer between: youngBase and: youngLimit])
				ifTrue: [^true]]].
	^false
]

{ #category : #cleaning }
EdenCollector >> nextEden [
	^edenSpace
]

{ #category : #cleaning }
EdenCollector >> postInitialize [
	rememberedSet := memory rememberedSet.
	edenSpace := memory eden.
	oldSpace := memory old.
	youngBase := memory youngBase.
	youngLimit := memory youngLimit.
	super postInitialize
]

{ #category : #cleaning }
EdenCollector >> purgeRememberedSet [
	| object kept |
	kept := 0.
	1 to: rememberedSet size do: [:index | 
		object := rememberedSet at: index.
		rememberedSet unsafeAt: index put: nil.
		(self hasToPurge: object)
			ifFalse: [
				kept := kept + 1.
				rememberedSet unsafeAt: kept put: object]
			ifTrue: [object _beNotRemembered]].
	rememberedSet size: kept
]

{ #category : #cleaning }
EdenCollector >> remember: anObject [
	anObject _beRemembered.
	rememberedSet unsafeAdd: anObject
]

{ #category : #cleaning }
EdenCollector >> rememberOldStacks [
	StackWrapper registeredInstances
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
	memory rememberedSet: rememberedSet
]

{ #category : #cleaning }
EdenCollector >> scanBehavior: current [
	| behavior moved |
	behavior := current _basicULongAt: 0.
	behavior _isSmallInteger ifTrue: [^behavior].
	(self newspaceIncludes: behavior) ifTrue: [
		moved := self copyOf: behavior.
		^current _basicULongAt: 0 put: moved].
	^behavior
]

{ #category : #cleaning }
EdenCollector >> scanExternals [
	self scanRememberedSet
]

{ #category : #cleaning }
EdenCollector >> scanRememberedSet [
	[rememberedNext <= rememberedSet size] whileTrue: [| object |
		object := rememberedSet at: rememberedNext.
		self followRemembered: object at: rememberedNext.
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

{ #category : #ephemerons }
EdenCollector >> strenghtenAndMigrateEphemerons [
	| copy contents |
	copy := toSpace shallowCopy: rescuedEphemerons.
	copy _isSmallInteger
		ifTrue: [copy := oldSpace shallowCopy: rescuedEphemerons].
	rescuedEphemerons := copy.
	contents := toSpace shallowCopy: rescuedEphemerons contents.
	contents _isSmallInteger ifTrue: [
		contents := oldSpace shallowCopy: rescuedEphemerons contents.
		contents _isSmallInteger ifTrue: [self _halt].
		self remember: contents].
	rescuedEphemerons contents: contents.
	rescuedEphemerons do: [:ephemeron | ephemeron _beStrong]
]

{ #category : #cleaning }
EdenCollector >> swapMemoryFromAndTo [
	"
	self validate.
	"
	edenSpace wipeOut; reset; leaveDispenseSpace.
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
	(self newspaceIncludes: object) ifTrue: [
		(toSpace includes: object) ifTrue: [self _halt].
		moved := self copyOf: object.
		^current _basicAt: index put: moved].
	^object
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
	check that no slot has been left pointing to
    wiped out space (anything in new space not pointing to to).
	"
	| behavior |
	behavior := anObject _basicULongAt: 0.
	((self newspaceIncludes: behavior) andNot: [toSpace includes: behavior])
		ifTrue: [anObject _halt].
	1 to: anObject _pointersSize do: [:i | | slot |
		slot := anObject _basicAt: i.
		(slot _isSmallInteger not
			and: [(self newspaceIncludes: slot) andNot: [toSpace includes: slot]])
			ifTrue: [anObject _halt]]
]

{ #category : #private }
EdenCollector >> workSpaceSize [
	^edenSpace reservedSize * 3
]

