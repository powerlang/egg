'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Object category: #Kernel!
ProtoObject subclass: #Object
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Object commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Object methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
-> anObject
	^Association key: self value: anObject
! !

!Object methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
!!= anObject
	^(self = anObject) not
! !

!Object methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
_replaceFrom: start to: end with: other
	^self _basicCopyFrom: start to: end with: other
! !

!Object methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
~ anObject
	^self isCloseTo: anObject
! !

!Object methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
~= anObject
	^(self = anObject) not
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
actionForEvent: aSymbol
	^self eventAt: aSymbol ifAbsent: nil
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
actionsForEvent: aSymbol
	| action |
	action := self eventAt: aSymbol ifAbsent: [^ActionSequence new].
	^action asActionSequence
! !

!Object methodsFor:  'instance behavior' stamp: 'KenD 28/Jun/2026 13:27:38'!
addInstanceMethods: aMethodDictionary
	| behavior |
	behavior := self behavior enhancedWith: aMethodDictionary.
	self behavior: behavior
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
asActionSequence
	^ActionSequence with: self
! !

!Object methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:38'!
aspects
	^self class aspects
! !

!Object methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:38'!
ASSERT: aBoolean
	aBoolean value ifFalse: [AssertionFailure signal].
	^aBoolean
! !

!Object methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asString
	^self printString
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger
	^self primitiveAt: anInteger
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: anObject
	^self primitiveAt: anInteger put: anObject
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: anInteger
	^self at: anInteger
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
beWeak
	self _beSpecial
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
beWeak: aBoolean
	aBoolean ifTrue: [self _beSpecial] ifFalse: [self _beNotSpecial]
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
bindEventTable: aDictionary
	^Smalltalk bindEventTable: aDictionary to: self
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: anInteger
	^self basicAt: anInteger
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: anInteger put: byte
	^self basicAt: anInteger put: byte
! !

!Object methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAtValid: anInteger
	^self _byteAt: anInteger
! !

!Object methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAtValid: anInteger put: value
	^self _byteAt: anInteger put: value
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBePrintedAsLiteral
	^false
! !

!Object methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
cannotReturn
	self error: 'Closure cannot return'
! !

!Object methodsFor:  'instance behavior' stamp: 'KenD 28/Jun/2026 13:27:38'!
changeClassTo: aClass
	self class == aClass ifFalse: [self behavior: aClass instanceBehavior]
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
changed
	self triggerEvent: #changed
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
changed: argument
	self triggerEvent: #changed: with: argument
! !

!Object methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copy
	^self shallowCopy postCopy
! !

!Object methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	^self objectDeepCopy postCopy
! !

!Object methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:38'!
DENY: aBoolean
	aBoolean value ifTrue: [AssertionFailure signal].
	^aBoolean
! !

!Object methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:38'!
disableCode: aBlock
	"do not evaluate the code inside the block"
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
ensurePropertyTable
	^Kernel ensurePropertyTableFor: self
! !

!Object methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluate
	^self
! !

!Object methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: anObject
	^self evaluateWithArguments: {anObject}
! !

!Object methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: arg1 with: arg2
	^self evaluateWithArguments: {arg1. arg2}
! !

!Object methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWithArguments: anArray
	^self evaluate
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
eventAt: aSymbol ifAbsent: aBlock
	| table |
	table := self eventTable ifNil: [^aBlock value].
	^table at: aSymbol asSymbol ifAbsent: aBlock
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
eventAt: aSymbol put: action
	| table |
	table := self eventTable.
	table isNil ifTrue: [
		table := IdentityDictionary new: 1.
		self bindEventTable: table].
	table at: aSymbol asSymbol put: action
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
eventTable
	^Smalltalk eventTableFor: self
! !

!Object methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
finalize: anObject
	
! !

!Object methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:38'!
halt: errorMessage
	Halt signal: errorMessage
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
handledEvents
	| table |
	table := self eventTable.
	table isNil ifTrue: [^#()].
	^table keys
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasActionForEvent: aSymbol
	| table |
	table := self eventTable ifNil: [^false].
	^table includesKey: aSymbol asSymbol
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasBytes
	^self isBytes
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasInstanceBehavior
	^self behavior isInstanceBehavior
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash: anInteger
	self basicHash: anInteger
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashedWith: a with: b with: c with: d with: e with: f count: n
	| hash |
	hash := n hashMultiply bitXor: self hash.
	hash := hash hashMultiply bitXor: a hash.
	n = 2 ifTrue: [^hash].
	hash := hash hashMultiply bitXor: b hash.
	n = 3 ifTrue: [^hash].
	hash := hash hashMultiply bitXor: c hash.
	n = 4 ifTrue: [^hash].
	hash := hash hashMultiply bitXor: d hash.
	n = 5 ifTrue: [^hash].
	hash := hash hashMultiply bitXor: e hash.
	n = 6 ifTrue: [^hash].
	hash := hash hashMultiply bitXor: f hash.
	n = 7 ifTrue: [^hash].
	self error: 'Invalid argument count'
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashWith: a
	^self
		hashedWith: a
		with: nil
		with: nil
		with: nil
		with: nil
		with: nil
		count: 2
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashWith: a with: b
	^self
		hashedWith: a
		with: b
		with: nil
		with: nil
		with: nil
		with: nil
		count: 3
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashWith: a with: b with: c
	^self
		hashedWith: a
		with: b
		with: c
		with: nil
		with: nil
		with: nil
		count: 4
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashWith: a with: b with: c with: d
	^self
		hashedWith: a
		with: b
		with: c
		with: d
		with: nil
		with: nil
		count: 5
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashWith: a with: b with: c with: d with: e
	^self
		hashedWith: a
		with: b
		with: c
		with: d
		with: e
		with: nil
		count: 6
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashWith: a with: b with: c with: d with: e with: f
	^self
		hashedWith: a
		with: b
		with: c
		with: d
		with: e
		with: f
		count: 7
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasRegisteredEvent: aSymbol
	^self class hasRegisteredEvent: aSymbol
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNil: aBlock ifNotNil: anotherBlock
	"
	This method is inlined
	"
	^anotherBlock evaluateWith: self
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
ifNotNil: aBlock ifNil: anotherBlock
	"
	This method is inlined
	"
	^aBlock evaluateWith: self
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
imageSegment
	^ImageSegment segmentAt: self _oop
! !

!Object methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isArray
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isAssociation
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBlock
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBlockClosure
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBoolean
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBytes
	^self class isBytes
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isByteArray
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCharacter
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isClass
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isClosure
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCollection
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCompiledMethod
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDate
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDictionary
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDirectory
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmptyOrNil
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFile
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFilename
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFileStream
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFixedObject
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFloat
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFraction
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInKernel
	^ImageSegment kernel includesAddress: self _oop
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInSegment
	^self imageSegment ifNil: [false] ifNotNil: [:bsl | bsl ordinal > 1]
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInteger
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isKindOf: aClass
	^self class inheritsFrom: aClass
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isLargeInteger
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMemberOf: aClass
	^self class == aClass
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMemoryBuffer
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMessage
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMetaclass
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMethodDictionary
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isModule
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNativeCode
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNumber
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isPoint
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isRectangle
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSequenceableCollection
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSmallInteger
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSpecies
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isStream
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isString
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSymbol
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isTime
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isTimestamp
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWideString
	^false
! !

!Object methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWideSymbol
	^false
! !

!Object methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
literalString
	^self canBePrintedAsLiteral ifTrue: [self storeString]
! !

!Object methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
marshalOn: aStream
	| s |
	s := self sizeInBytes.
	aStream putBytesFrom: self from: 1 to: s.
	s < WordSize
		ifTrue: [aStream putBytesFrom: #[0 0 0 0 0 0 0 0] from: 1 to: WordSize - s]
! !

!Object methodsFor:  'instance behavior' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodFor: aSymbol
	^self behavior findMethodFor: aSymbol
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodFor: aSymbol in: aClass
	^self behavior findMethodFor: aSymbol in: aClass
! !

!Object methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
mustBeBoolean
	^Error signal: 'not a Boolean receiver'
! !

!Object methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
objectDeepCopy
	| class ivars copy |
	class := self class.
	class _instancesAreFixed
		ifTrue: [
			ivars := 0.
			copy := class basicNew]
		ifFalse: [
			ivars := self basicSize.
			copy := class basicNew: ivars].
	class _instancesHavePointers
		ifTrue: [
			1 to: ivars + class instSize do: [:index | | ivar |
				ivar := self instVarAt: index.
				copy instVarAt: index put: ivar copy]]
		ifFalse: [
			1 to: ivars do: [:index | | byte |
				byte := self basicAt: index.
				copy basicAt: index put: byte]].
	^copy
! !

!Object methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
objectShallowCopy
	| copy class |
	class := self class.
	copy := class _instancesAreArrayed
		ifTrue: [class basicNew: self basicSize]
		ifFalse: [class basicNew].
	self shallowCopyTo: copy.
	^copy
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
onEvent: aSymbol do: anActionSequence
	anActionSequence compressed
		ifNil: [self removeActionsForEvent: aSymbol]
		ifNotNil: [:action | self eventAt: aSymbol asSymbol put: action]
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
oop
	^self _oop
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
perform: aSymbol with: firstObject with: secondObject
	^self perform: aSymbol withArguments: {firstObject. secondObject}
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
perform: aSymbol with: arg1 with: arg2 with: arg3
	^self perform: aSymbol withArguments: {arg1. arg2. arg3}
! !

!Object methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	
! !

!Object methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: self class name withArticle
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
propertyAt: aSymbol
	^self propertyTable at: aSymbol ifAbsent: nil
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
propertyAt: aSymbol ifAbsent: aBlock
	^self propertyTable at: aSymbol ifAbsent: aBlock
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
propertyAt: aSymbol ifAbsentPut: aBlock
	self ensurePropertyTable.
	^self propertyTable at: aSymbol ifAbsentPut: aBlock
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
propertyAt: aSymbol put: anObject
	self ensurePropertyTable.
	^self propertyTable at: aSymbol put: anObject
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
propertyTable
	^(Kernel propertiesFor: self) ifNil: [IdentityDictionary new]
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
registeredEvents
	^self class registeredEvents
! !

!Object methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
release
	self releaseEventTable
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
releaseEventTable
	self bindEventTable: nil
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAction: anAction forEvent: aSymbol
	self
		removeActionsSatisfying: [:action | action = anAction]
		forEvent: aSymbol
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeActionsForEvent: eventName
	| table |
	table := self eventTable.
	table isNil ifTrue: [^self].
	table removeKey: eventName asSymbol ifAbsent: [].
	table isEmpty ifTrue: [self releaseEventTable]
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeActionsSatisfying: aBlock forEvent: aSymbol
	| actions |
	actions := (self actionsForEvent: aSymbol)
		reject: [:action | aBlock value: action].
	self onEvent: aSymbol do: actions
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeActionsWithReceiver: anObject forEvent: aSymbol
	self
		removeActionsSatisfying: [:action | (action respondsTo: #receiver)
			and: [action receiver == anObject]]
		forEvent: aSymbol
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAllActionsFor: anObject
	self handledEvents
		do: [:event | self removeActionsWithReceiver: anObject forEvent: event]
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeDependent: anObject
	self removeActionsWithReceiver: anObject forEvent: #changed
! !

!Object methodsFor:  'instance behavior' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeInstanceBehavior
	self behavior: self class instanceBehavior
! !

!Object methodsFor:  'instance behavior' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeMethods: aMethodDictionary
	| behavior copy |
	self hasInstanceBehavior ifFalse: [^self].
	behavior := self behavior.
	copy := behavior copyWithout: aMethodDictionary.
	copy == behavior ifFalse: [self behavior: copy]
! !

!Object methodsFor:  'accessing-properties' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeProperty: aSymbol
	self
		removeProperty: aSymbol
		ifAbsent: [self error: 'property is not in the collection']
! !

!Object methodsFor:  'accessing-properties' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeProperty: aSymbol ifAbsent: aBlock
	| t |
	t := Kernel propertiesFor: self.
	t notNil ifTrue: [t removeKey: aSymbol ifAbsent: aBlock]
! !

!Object methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceBytesBackwardFrom: stop to: start with: aCollection startingAt: position
	| i j |
	i := stop.
	j := position.
	[start <= i] whileTrue: [
		self byteAt: i put: (aCollection byteAt: j).
		i := i - 1.
		j := j - 1]
! !

!Object methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceBytesForwardFrom: start to: stop with: aCollection startingAt: position
	| i j |
	i := start.
	j := position.
	[i <= stop] whileTrue: [
		self byteAt: i put: (aCollection byteAt: j).
		i := i + 1.
		j := j + 1]
! !

!Object methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceBytesFrom: start to: stop with: aCollection startingAt: position
	| end |
	(self == aCollection and: [
		end := position + stop - start.
		start between: position and: end])
		ifTrue: [
			self
				replaceBytesBackwardFrom: stop
				to: start
				with: aCollection
				startingAt: end]
		ifFalse: [
			self
				replaceBytesForwardFrom: start
				to: stop
				with: aCollection
				startingAt: position]
! !

!Object methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
respondsTo: aSymbol
	| cm |
	cm := self methodFor: aSymbol.
	^cm !!== nil
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
sender
	^StackFrameCursor top moveNext moveNext receiver
! !

!Object methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
sessionShutdown
	"
	Default is do nothing.
	"
	
! !

!Object methodsFor:  'startup' stamp: 'KenD 28/Jun/2026 13:27:38'!
sessionStartup
	^self
! !

!Object methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
shallowCopy
	^self objectShallowCopy
! !

!Object methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
shallowCopyTo: anObject
	| n |
	self class isBytes ifTrue: [
		anObject class isBytes ifFalse: [self error: 'cannot copy'].
		n := self sizeInBytes min: anObject sizeInBytes.
		1 to: n do: [:i | | byte |
			byte := self byteAt: i.
			anObject byteAt: i put: byte].
		^anObject].
	anObject class isBytes ifTrue: [self error: 'cannot copy'].
	n := self class instSize min: anObject class instSize.
	1 to: n do: [:index | | slot |
		slot := self instVarAt: index.
		anObject instVarAt: index put: slot].
	self class _instancesAreArrayed ifTrue: [
		n := self basicSize min: anObject basicSize.
		1 to: n do: [:index | | slot |
			slot := self basicAt: index.
			anObject basicAt: index put: slot]].
	^anObject
! !

!Object methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
shouldNotImplement
	self error: 'inappropriate message for this object'
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^self primitiveSize
! !

!Object methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	self _isBytes ifFalse: [^nil].
	^self _size
! !

!Object methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
species
	^self class
! !

!Object methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
	| class yourself |
	Recursion checkOn: self while: [
		class := self class.
		aStream
			nextPutAll: '((';
			nextPutAll: class name;
			nextPutAll: ' basicNew'.
		class _instancesAreArrayed ifTrue: [
			aStream nextPut: $:.
			self basicSize printOn: aStream].
		aStream nextPut: $).
		yourself := false.
		(1 to: class instSize + self basicSize)
			do: [:i | | ivar |
				yourself := true.
				aStream nextPutAll: ' instVarAt: '.
				i printOn: aStream.
				aStream nextPutAll: ' put: '.
				ivar := self instVarAt: i.
				ivar storeOn: aStream]
			separatedBy: [aStream nextPutAll: '; '].
		yourself ifTrue: [aStream nextPutAll: '; yourself'].
		aStream nextPut: $)]
! !

!Object methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeString
	| stream |
	stream := '' writeStream.
	self storeOn: stream.
	^stream contents
! !

!Object methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
subclassResponsibility
	^self error: 'subclass responsibility'
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol
	^self triggerEvent: aSymbol withArguments: #() defaultHandler: nil
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol defaultHandler: aBlock
	^self triggerEvent: aSymbol withArguments: #() defaultHandler: aBlock
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol with: anObject
	^self triggerEvent: aSymbol withArguments: {anObject} defaultHandler: nil
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol with: anObject defaultHandler: aBlock
	^self
		triggerEvent: aSymbol
		withArguments: {anObject}
		defaultHandler: aBlock
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol with: anObject with: anotherObject
	^self triggerEvent: aSymbol withArguments: {anObject. anotherObject}
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol with: arg1 with: arg2 defaultHandler: aBlock
	^self
		triggerEvent: aSymbol
		withArguments: {arg1. arg2}
		defaultHandler: aBlock
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol withArguments: aCollection
	^self triggerEvent: aSymbol withArguments: aCollection defaultHandler: nil
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
triggerEvent: aSymbol withArguments: aCollection defaultHandler: aBlock
	| action |
	action := self eventAt: aSymbol ifAbsent: [^aBlock value].
	^action evaluateWithArguments: aCollection
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
unregisteredEvent: aSymbol
	^self error: 'Unregistered event ' , aSymbol storeString
! !

!Object methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
value
	^self
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
when: aSymbol do: aBlock
	self when: aSymbol evaluate: aBlock
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
when: aSymbol evaluate: action
	| actions |
	(self hasRegisteredEvent: aSymbol) ifFalse: [self
		unregisteredEvent: aSymbol].
	actions := self actionsForEvent: aSymbol.
	(actions includes: action) ifTrue: [^self].
	actions := actions copyWith: action.
	self onEvent: aSymbol do: actions
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
when: event send: selector to: receiver
	| args msg |
	args := Array new: selector arity.
	msg := EventHandlerMessage
		receiver: receiver
		selector: selector asSymbol
		arguments: args.
	self when: event evaluate: msg
! !

!Object methodsFor:  'event handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
when: event send: selector to: receiver with: argument
	| arguments msg |
	arguments := Array new: selector arity.
	arguments at: arguments size put: argument.
	msg := EventHandlerMessage
		receiver: receiver
		selector: selector
		arguments: arguments.
	self when: event evaluate: msg
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Object class' category: #Kernel!
Object class
	instanceVariableNames: ''!

!Object class methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:38'!
aspects
	^#()
! !

!Object class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
availableEvents
	^Set with: #changed with: #changed:
! !

!Object class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasRegisteredEvent: aSymbol
	^self registeredEvents includes: aSymbol asSymbol
! !

!Object class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
registeredEvents
	| events |
	events := Smalltalk registeredEventsFor: self.
	events isNil ifTrue: [self registerEvents].
	^Smalltalk registeredEventsFor: self
! !

!Object class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
registerEvents
	Smalltalk register: self availableEvents for: self
! !


Object initialize!

