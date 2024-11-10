"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Object,
	#superclass : #ProtoObject,
	#category : #Kernel
}

{ #category : #inspecting }
Object class >> aspects [
	^#()
]

{ #category : #initialization }
Object class >> availableEvents [
	^Set with: #changed with: #changed:
]

{ #category : #testing }
Object class >> hasRegisteredEvent: aSymbol [
	^self registeredEvents includes: aSymbol asSymbol
]

{ #category : #accessing }
Object class >> registeredEvents [
	| events |
	events := Smalltalk registeredEventsFor: self.
	events isNil ifTrue: [self registerEvents].
	^Smalltalk registeredEventsFor: self
]

{ #category : #initialization }
Object class >> registerEvents [
	Smalltalk register: self availableEvents for: self
]

{ #category : #converting }
Object >> -> anObject [
	^Association key: self value: anObject
]

{ #category : #comparing }
Object >> != anObject [
	^(self = anObject) not
]

{ #category : #unclassified }
Object >> _replaceFrom: start to: end with: other [
	^self _basicCopyFrom: start to: end with: other
]

{ #category : #comparing }
Object >> ~ anObject [
	^self isCloseTo: anObject
]

{ #category : #comparing }
Object >> ~= anObject [
	^(self = anObject) not
]

{ #category : #'event handling' }
Object >> actionForEvent: aSymbol [
	^self eventAt: aSymbol ifAbsent: nil
]

{ #category : #'event handling' }
Object >> actionsForEvent: aSymbol [
	| action |
	action := self eventAt: aSymbol ifAbsent: [^ActionSequence new].
	^action asActionSequence
]

{ #category : #'instance behavior' }
Object >> addInstanceMethods: aMethodDictionary [
	| behavior |
	behavior := self behavior enhancedWith: aMethodDictionary.
	self behavior: behavior
]

{ #category : #'event handling' }
Object >> asActionSequence [
	^ActionSequence with: self
]

{ #category : #inspecting }
Object >> aspects [
	^self class aspects
]

{ #category : #debugging }
Object >> ASSERT: aBoolean [
	aBoolean value ifFalse: [AssertionFailure signal].
	^aBoolean
]

{ #category : #converting }
Object >> asString [
	^self printString
]

{ #category : #private }
Object >> at: anInteger [
	^self primitiveAt: anInteger
]

{ #category : #private }
Object >> at: anInteger put: anObject [
	^self primitiveAt: anInteger put: anObject
]

{ #category : #private }
Object >> atValid: anInteger [
	^self at: anInteger
]

{ #category : #private }
Object >> beWeak [
	self _beSpecial
]

{ #category : #private }
Object >> beWeak: aBoolean [
	aBoolean ifTrue: [self _beSpecial] ifFalse: [self _beNotSpecial]
]

{ #category : #private }
Object >> bindEventTable: aDictionary [
	^Smalltalk bindEventTable: aDictionary to: self
]

{ #category : #accessing }
Object >> byteAt: anInteger [
	^self basicAt: anInteger
]

{ #category : #accessing }
Object >> byteAt: anInteger put: byte [
	^self basicAt: anInteger put: byte
]

{ #category : #unclassified }
Object >> byteAtValid: anInteger [
	^self _byteAt: anInteger
]

{ #category : #unclassified }
Object >> byteAtValid: anInteger put: value [
	^self _byteAt: anInteger put: value
]

{ #category : #testing }
Object >> canBePrintedAsLiteral [
	^false
]

{ #category : #errors }
Object >> cannotReturn [
	self error: 'Closure cannot return'
]

{ #category : #'instance behavior' }
Object >> changeClassTo: aClass [
	self class == aClass ifFalse: [self behavior: aClass instanceBehavior]
]

{ #category : #'event handling' }
Object >> changed [
	self triggerEvent: #changed
]

{ #category : #'event handling' }
Object >> changed: argument [
	self triggerEvent: #changed: with: argument
]

{ #category : #copying }
Object >> copy [
	^self shallowCopy postCopy
]

{ #category : #copying }
Object >> deepCopy [
	^self objectDeepCopy postCopy
]

{ #category : #debugging }
Object >> DENY: aBoolean [
	aBoolean value ifTrue: [AssertionFailure signal].
	^aBoolean
]

{ #category : #debugging }
Object >> disableCode: aBlock [
	"do not evaluate the code inside the block"
]

{ #category : #private }
Object >> ensurePropertyTable [
	^Smalltalk ensurePropertyTableFor: self
]

{ #category : #unclassified }
Object >> error: message resumable: resumable [
	^self error: message title: 'Error' resumable: resumable
]

{ #category : #evaluating }
Object >> evaluate [
	^self
]

{ #category : #evaluating }
Object >> evaluateWith: anObject [
	^self evaluateWithArguments: {anObject}
]

{ #category : #evaluating }
Object >> evaluateWith: arg1 with: arg2 [
	^self evaluateWithArguments: {arg1. arg2}
]

{ #category : #evaluating }
Object >> evaluateWithArguments: anArray [
	^self evaluate
]

{ #category : #private }
Object >> eventAt: aSymbol ifAbsent: aBlock [
	| table |
	table := self eventTable ifNil: [^aBlock value].
	^table at: aSymbol asSymbol ifAbsent: aBlock
]

{ #category : #private }
Object >> eventAt: aSymbol put: action [
	| table |
	table := self eventTable.
	table isNil ifTrue: [
		table := IdentityDictionary new: 1.
		self bindEventTable: table].
	table at: aSymbol asSymbol put: action
]

{ #category : #private }
Object >> eventTable [
	^Smalltalk eventTableFor: self
]

{ #category : #finalization }
Object >> finalize: anObject [
	
]

{ #category : #debugging }
Object >> halt: errorMessage [
	Halt signal: errorMessage
]

{ #category : #'event handling' }
Object >> handledEvents [
	| table |
	table := self eventTable.
	table isNil ifTrue: [^#()].
	^table keys
]

{ #category : #'event handling' }
Object >> hasActionForEvent: aSymbol [
	| table |
	table := self eventTable ifNil: [^false].
	^table includesKey: aSymbol asSymbol
]

{ #category : #testing }
Object >> hasBytes [
	^self isBytes
]

{ #category : #testing }
Object >> hasInstanceBehavior [
	^self behavior isInstanceBehavior
]

{ #category : #private }
Object >> hash: anInteger [
	self basicHash: anInteger
]

{ #category : #services }
Object >> hashedWith: a
with: b
with: c
with: d
with: e
with: f
count: n [
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
]

{ #category : #services }
Object >> hashWith: a [
	^self
		hashedWith: a
		with: nil
		with: nil
		with: nil
		with: nil
		with: nil
		count: 2
]

{ #category : #services }
Object >> hashWith: a with: b [
	^self
		hashedWith: a
		with: b
		with: nil
		with: nil
		with: nil
		with: nil
		count: 3
]

{ #category : #services }
Object >> hashWith: a with: b with: c [
	^self
		hashedWith: a
		with: b
		with: c
		with: nil
		with: nil
		with: nil
		count: 4
]

{ #category : #services }
Object >> hashWith: a
with: b
with: c
with: d [
	^self
		hashedWith: a
		with: b
		with: c
		with: d
		with: nil
		with: nil
		count: 5
]

{ #category : #services }
Object >> hashWith: a
with: b
with: c
with: d
with: e [
	^self
		hashedWith: a
		with: b
		with: c
		with: d
		with: e
		with: nil
		count: 6
]

{ #category : #services }
Object >> hashWith: a
with: b
with: c
with: d
with: e
with: f [
	^self
		hashedWith: a
		with: b
		with: c
		with: d
		with: e
		with: f
		count: 7
]

{ #category : #testing }
Object >> hasRegisteredEvent: aSymbol [
	^self class hasRegisteredEvent: aSymbol
]

{ #category : #testing }
Object >> ifNil: aBlock ifNotNil: anotherBlock [
	"
	This method is inlined
	"
	^anotherBlock evaluateWith: self
]

{ #category : #testing }
Object >> ifNotNil: aBlock ifNil: anotherBlock [
	"
	This method is inlined
	"
	^aBlock evaluateWith: self
]

{ #category : #accessing }
Object >> imageSegment [
	^ImageSegment segmentAt: self _oop
]

{ #category : #initialization }
Object >> initialize [
	
]

{ #category : #testing }
Object >> isArray [
	^false
]

{ #category : #testing }
Object >> isAssociation [
	^false
]

{ #category : #testing }
Object >> isBlock [
	^false
]

{ #category : #testing }
Object >> isBlockClosure [
	^false
]

{ #category : #testing }
Object >> isBoolean [
	^false
]

{ #category : #testing }
Object >> isBytes [
	^self class isBytes
]

{ #category : #testing }
Object >> isByteArray [
	^false
]

{ #category : #testing }
Object >> isCharacter [
	^false
]

{ #category : #testing }
Object >> isClass [
	^false
]

{ #category : #testing }
Object >> isClosure [
	^false
]

{ #category : #testing }
Object >> isCollection [
	^false
]

{ #category : #testing }
Object >> isCompiledMethod [
	^false
]

{ #category : #testing }
Object >> isDate [
	^false
]

{ #category : #testing }
Object >> isDictionary [
	^false
]

{ #category : #testing }
Object >> isDirectory [
	^false
]

{ #category : #testing }
Object >> isEmptyOrNil [
	^false
]

{ #category : #testing }
Object >> isFile [
	^false
]

{ #category : #testing }
Object >> isFilename [
	^false
]

{ #category : #testing }
Object >> isFileStream [
	^false
]

{ #category : #testing }
Object >> isFixedObject [
	^false
]

{ #category : #testing }
Object >> isFloat [
	^false
]

{ #category : #testing }
Object >> isFraction [
	^false
]

{ #category : #testing }
Object >> isInKernel [
	^ImageSegment kernel includesAddress: self _oop
]

{ #category : #testing }
Object >> isInSegment [
	^self imageSegment ifNil: [false] ifNotNil: [:bsl | bsl ordinal > 1]
]

{ #category : #testing }
Object >> isInteger [
	^false
]

{ #category : #testing }
Object >> isKindOf: aClass [
	^self class inheritsFrom: aClass
]

{ #category : #testing }
Object >> isLargeInteger [
	^false
]

{ #category : #testing }
Object >> isMemberOf: aClass [
	^self class == aClass
]

{ #category : #testing }
Object >> isMemoryBuffer [
	^false
]

{ #category : #testing }
Object >> isMessage [
	^false
]

{ #category : #testing }
Object >> isMetaclass [
	^false
]

{ #category : #testing }
Object >> isMethodDictionary [
	^false
]

{ #category : #testing }
Object >> isModule [
	^false
]

{ #category : #testing }
Object >> isNativeCode [
	^false
]

{ #category : #testing }
Object >> isNumber [
	^false
]

{ #category : #testing }
Object >> isPoint [
	^false
]

{ #category : #testing }
Object >> isRectangle [
	^false
]

{ #category : #testing }
Object >> isSequenceableCollection [
	^false
]

{ #category : #testing }
Object >> isSmallInteger [
	^false
]

{ #category : #testing }
Object >> isSpecies [
	^false
]

{ #category : #testing }
Object >> isStream [
	^false
]

{ #category : #testing }
Object >> isString [
	^false
]

{ #category : #testing }
Object >> isSymbol [
	^false
]

{ #category : #testing }
Object >> isTime [
	^false
]

{ #category : #testing }
Object >> isTimestamp [
	^false
]

{ #category : #testing }
Object >> isWideString [
	^false
]

{ #category : #testing }
Object >> isWideSymbol [
	^false
]

{ #category : #errors }
Object >> literalString [
	^self canBePrintedAsLiteral ifTrue: [self storeString]
]

{ #category : #errors }
Object >> marshalOn: aStream [
	| s |
	s := self sizeInBytes.
	aStream putBytesFrom: self from: 1 to: s.
	s < WordSize
		ifTrue: [aStream putBytesFrom: #[0 0 0 0 0 0 0 0] from: 1 to: WordSize - s]
]

{ #category : #'instance behavior' }
Object >> methodFor: aSymbol [
	^self behavior findMethodFor: aSymbol
]

{ #category : #services }
Object >> methodFor: aSymbol in: aClass [
	^self behavior findMethodFor: aSymbol in: aClass
]

{ #category : #errors }
Object >> mustBeBoolean [
	^Error signal: 'not a Boolean receiver'
]

{ #category : #copying }
Object >> objectDeepCopy [
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
]

{ #category : #copying }
Object >> objectShallowCopy [
	| copy class |
	class := self class.
	copy := class _instancesAreArrayed
		ifTrue: [class basicNew: self basicSize]
		ifFalse: [class basicNew].
	self shallowCopyTo: copy.
	^copy
]

{ #category : #private }
Object >> onEvent: aSymbol do: anActionSequence [
	anActionSequence compressed
		ifNil: [self removeActionsForEvent: aSymbol]
		ifNotNil: [:action | self eventAt: aSymbol asSymbol put: action]
]

{ #category : #accessing }
Object >> oop [
	^self _oop
]

{ #category : #services }
Object >> perform: aSymbol with: firstObject with: secondObject [
	^self perform: aSymbol withArguments: {firstObject. secondObject}
]

{ #category : #services }
Object >> perform: aSymbol
with: arg1
with: arg2
with: arg3 [
	^self perform: aSymbol withArguments: {arg1. arg2. arg3}
]

{ #category : #copying }
Object >> postCopy [
	
]

{ #category : #printing }
Object >> printOn: aStream [
	aStream nextPutAll: self class name withArticle
]

{ #category : #accessing }
Object >> propertyAt: aSymbol [
	^self propertyTable at: aSymbol ifAbsent: nil
]

{ #category : #accessing }
Object >> propertyAt: aSymbol ifAbsent: aBlock [
	^self propertyTable at: aSymbol ifAbsent: aBlock
]

{ #category : #accessing }
Object >> propertyAt: aSymbol ifAbsentPut: aBlock [
	self ensurePropertyTable.
	^self propertyTable at: aSymbol ifAbsentPut: aBlock
]

{ #category : #accessing }
Object >> propertyAt: aSymbol put: anObject [
	self ensurePropertyTable.
	^self propertyTable at: aSymbol put: anObject
]

{ #category : #private }
Object >> propertyTable [
	^(Smalltalk propertiesFor: self) ifNil: [IdentityDictionary new]
]

{ #category : #'event handling' }
Object >> registeredEvents [
	^self class registeredEvents
]

{ #category : #finalization }
Object >> release [
	self releaseEventTable
]

{ #category : #'event handling' }
Object >> releaseEventTable [
	self bindEventTable: nil
]

{ #category : #'event handling' }
Object >> removeAction: anAction forEvent: aSymbol [
	self
		removeActionsSatisfying: [:action | action = anAction]
		forEvent: aSymbol
]

{ #category : #'event handling' }
Object >> removeActionsForEvent: eventName [
	| table |
	table := self eventTable.
	table isNil ifTrue: [^self].
	table removeKey: eventName asSymbol ifAbsent: [].
	table isEmpty ifTrue: [self releaseEventTable]
]

{ #category : #'event handling' }
Object >> removeActionsSatisfying: aBlock forEvent: aSymbol [
	| actions |
	actions := (self actionsForEvent: aSymbol)
		reject: [:action | aBlock value: action].
	self onEvent: aSymbol do: actions
]

{ #category : #'event handling' }
Object >> removeActionsWithReceiver: anObject forEvent: aSymbol [
	self
		removeActionsSatisfying: [:action | (action respondsTo: #receiver)
			and: [action receiver == anObject]]
		forEvent: aSymbol
]

{ #category : #'event handling' }
Object >> removeAllActionsFor: anObject [
	self handledEvents
		do: [:event | self removeActionsWithReceiver: anObject forEvent: event]
]

{ #category : #'event handling' }
Object >> removeDependent: anObject [
	self removeActionsWithReceiver: anObject forEvent: #changed
]

{ #category : #'instance behavior' }
Object >> removeInstanceBehavior [
	self behavior: self class instanceBehavior
]

{ #category : #'instance behavior' }
Object >> removeMethods: aMethodDictionary [
	| behavior copy |
	self hasInstanceBehavior ifFalse: [^self].
	behavior := self behavior.
	copy := behavior copyWithout: aMethodDictionary.
	copy == behavior ifFalse: [self behavior: copy]
]

{ #category : #'accessing-properties' }
Object >> removeProperty: aSymbol [
	self
		removeProperty: aSymbol
		ifAbsent: [self error: 'property is not in the collection']
]

{ #category : #'accessing-properties' }
Object >> removeProperty: aSymbol ifAbsent: aBlock [
	| t |
	t := Smalltalk propertiesFor: self.
	t notNil ifTrue: [t removeKey: aSymbol ifAbsent: aBlock]
]

{ #category : #replacing }
Object >> replaceBytesBackwardFrom: stop
to: start
with: aCollection
startingAt: position [
	| i j |
	i := stop.
	j := position.
	[start <= i] whileTrue: [
		self byteAt: i put: (aCollection byteAt: j).
		i := i - 1.
		j := j - 1]
]

{ #category : #replacing }
Object >> replaceBytesForwardFrom: start
to: stop
with: aCollection
startingAt: position [
	| i j |
	i := start.
	j := position.
	[i <= stop] whileTrue: [
		self byteAt: i put: (aCollection byteAt: j).
		i := i + 1.
		j := j + 1]
]

{ #category : #replacing }
Object >> replaceBytesFrom: start
to: stop
with: aCollection
startingAt: position [
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
]

{ #category : #services }
Object >> respondsTo: aSymbol [
	| cm |
	cm := self methodFor: aSymbol.
	^cm !== nil
]

{ #category : #private }
Object >> sender [
	^StackFrameCursor top moveNext moveNext receiver
]

{ #category : #finalization }
Object >> sessionShutdown [
	"
	Default is do nothing.
	"
	
]

{ #category : #startup }
Object >> sessionStartup [
	^self
]

{ #category : #copying }
Object >> shallowCopy [
	^self objectShallowCopy
]

{ #category : #copying }
Object >> shallowCopyTo: anObject [
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
]

{ #category : #errors }
Object >> shouldNotImplement [
	self error: 'inappropriate message for this object'
]

{ #category : #accessing }
Object >> size [
	^self primitiveSize
]

{ #category : #accessing }
Object >> sizeInBytes [
	self _isBytes ifFalse: [^nil].
	^self _size
]

{ #category : #private }
Object >> species [
	^self class
]

{ #category : #printing }
Object >> storeOn: aStream [
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
]

{ #category : #converting }
Object >> storeString [
	| stream |
	stream := '' writeStream.
	self storeOn: stream.
	^stream contents
]

{ #category : #errors }
Object >> subclassResponsibility [
	^self error: 'subclass responsibility'
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol [
	^self triggerEvent: aSymbol withArguments: #() defaultHandler: nil
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol defaultHandler: aBlock [
	^self triggerEvent: aSymbol withArguments: #() defaultHandler: aBlock
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol with: anObject [
	^self triggerEvent: aSymbol withArguments: {anObject} defaultHandler: nil
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol with: anObject defaultHandler: aBlock [
	^self
		triggerEvent: aSymbol
		withArguments: {anObject}
		defaultHandler: aBlock
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol with: anObject with: anotherObject [
	^self triggerEvent: aSymbol withArguments: {anObject. anotherObject}
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol
with: arg1
with: arg2
defaultHandler: aBlock [
	^self
		triggerEvent: aSymbol
		withArguments: {arg1. arg2}
		defaultHandler: aBlock
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol withArguments: aCollection [
	^self triggerEvent: aSymbol withArguments: aCollection defaultHandler: nil
]

{ #category : #'event handling' }
Object >> triggerEvent: aSymbol withArguments: aCollection defaultHandler: aBlock [
	| action |
	action := self eventAt: aSymbol ifAbsent: [^aBlock value].
	^action evaluateWithArguments: aCollection
]

{ #category : #'event handling' }
Object >> unregisteredEvent: aSymbol [
	^self error: 'Unregistered event ' , aSymbol storeString
]

{ #category : #evaluating }
Object >> value [
	^self
]

{ #category : #'event handling' }
Object >> when: aSymbol do: aBlock [
	self when: aSymbol evaluate: aBlock
]

{ #category : #'event handling' }
Object >> when: aSymbol evaluate: action [
	| actions |
	(self hasRegisteredEvent: aSymbol) ifFalse: [self
		unregisteredEvent: aSymbol].
	actions := self actionsForEvent: aSymbol.
	(actions includes: action) ifTrue: [^self].
	actions := actions copyWith: action.
	self onEvent: aSymbol do: actions
]

{ #category : #'event handling' }
Object >> when: event send: selector to: receiver [
	| args msg |
	args := Array new: selector arity.
	msg := EventHandlerMessage
		receiver: receiver
		selector: selector asSymbol
		arguments: args.
	self when: event evaluate: msg
]

{ #category : #'event handling' }
Object >> when: event
send: selector
to: receiver
with: argument [
	| arguments msg |
	arguments := Array new: selector arity.
	arguments at: arguments size put: argument.
	msg := EventHandlerMessage
		receiver: receiver
		selector: selector
		arguments: arguments.
	self when: event evaluate: msg
]

