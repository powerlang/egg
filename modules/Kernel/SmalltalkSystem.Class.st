'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #SmalltalkSystem category: #Kernel!
Object subclass: #SmalltalkSystem
	instanceVariableNames: 'globals eventHandlers registeredEvents eventDispatcher'
	classVariableNames: 'Implementors Senders'
	poolDictionaries: ''
	category: 'Kernel'!
!SmalltalkSystem commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anAssociation
	self ASSERT: Smalltalk !!== self.
	^globals add: anAssociation
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationAt: aSymbol
	^globals associationAt: aSymbol
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationAt: aSymbol ifAbsent: aBlock
	^globals associationAt: aSymbol ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationClass
	^globals associationClass
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationsDo: aBlock
	globals associationsDo: aBlock
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: aSymbol
	^globals at: aSymbol
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: aSymbol ifAbsent: aBlock
	^globals at: aSymbol ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: aSymbol ifAbsentPut: aBlock
	^self at: aSymbol ifAbsent: [self at: aSymbol put: aBlock value]
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: aSymbol put: anObject
	| key global |
	key := aSymbol asSymbol.
	global := globals at: key ifAbsent: nil.
	global isClass ifTrue: [
		anObject == global ifTrue: [^self].
		global symbol == key
			ifTrue: [^self error: 'Overriding classes is not allowed']].
	globals at: key put: anObject.
	self justDefined: aSymbol.
	^anObject
! !

!SmalltalkSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAdd: anAssociation
	globals basicAdd: anAssociation.
	self justDefined: anAssociation key.
	^anAssociation
! !

!SmalltalkSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: aSymbol put: anObject
	| assoc |
	assoc := Association key: aSymbol value: anObject.
	self basicAdd: assoc.
	^anObject
! !

!SmalltalkSystem methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicRemoveKey: key ifAbsent: aBlock
	^globals removeKey: key ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beep
	^self operatingSystem beep
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
bindEventTable: aDictionary to: anObject
	aDictionary isNil
		ifTrue: [eventHandlers removeKey: anObject ifAbsent: []]
		ifFalse: [eventHandlers at: anObject put: aDictionary]
! !

!SmalltalkSystem methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canOpenBacktrace
	^true
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classNamed: aString
	| name tag meta global |
	name := aString.
	tag := ' class'.
	meta := aString endsWith: tag.
	meta ifTrue: [name := name allButLast: tag size].
	global := self at: name asSymbol ifAbsent: [^nil].
	^global isSpecies ifTrue: [meta ifTrue: [global class] ifFalse: [global]]
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectGarbage
	memory forceCompact
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
eventDispatcher
	^eventDispatcher
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
eventDispatcher: anEventDispatcher
	eventDispatcher := anEventDispatcher
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
eventTableFor: anObject
	^eventHandlers at: anObject ifAbsent: nil
! !

!SmalltalkSystem methodsFor:  'startup/shutdown' stamp: 'KenD 28/Jun/2026 13:27:38'!
exit
	session exit
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
finalizer
	^finalizer
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
flushNativizedSends
	ImageSegment bound do: [:s | 
		s overriddenMethods ifNotNil: [:overridden | 
			overridden
				do: [:m | m isNativized ifTrue: [m currentVersion prepareForExecution]];
				do: [:m | SendSite flush: m selector]]].
	SendSite flush
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
flushOverriddenSends
	ImageSegment bound do: [:s | s flushOverriddenSends].
	SendSite flush
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
globals
	^globals
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
globals: aNamespace
	globals := aNamespace
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasDebugger
	^false
! !

!SmalltalkSystem methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasDebuggerTool
	^false
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
ignoreHalts: aBoolean
	Halt ignoreSignals: aBoolean.
	AssertionFailure ignoreSignals: aBoolean
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
ignoreOSMessagesWhile: aBlock
	^eventDispatcher isNil
		ifTrue: [aBlock value]
		ifFalse: [aBlock evaluateAtomically]
! !

!SmalltalkSystem methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
includes: anObject
	^globals includes: anObject
! !

!SmalltalkSystem methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
includesKey: aSymbol
	^globals includesKey: aSymbol
! !

!SmalltalkSystem methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	eventHandlers := WeakIdentityDictionary new.
	registeredEvents := WeakIdentityDictionary new
! !

!SmalltalkSystem methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBee
	^true
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyAtValue: anObject
	^globals keyAtValue: anObject
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
keys
	^globals keys
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
messageQueue
	^eventDispatcher messageQueue
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nameOfGlobal: anObject
	^globals keyAtValue: anObject
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nativizer
	^nativizer
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nativizer: anObject
	nativizer := anObject
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveNamed: aString
	^NamedPrimitives at: aString ifAbsent: nil
! !

!SmalltalkSystem methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	self == Smalltalk
		ifTrue: [aStream nextPutAll: 'Smalltalk']
		ifFalse: [super printOn: aStream]
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
processAllMessages
	eventDispatcher processAllMessages
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
register: aSet for: aClass
	registeredEvents at: aClass put: aSet
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
registeredEventsFor: aClass
	^registeredEvents at: aClass ifAbsent: nil
! !

!SmalltalkSystem methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
rehashWeakRegistries
	eventHandlers rehash.
	registeredEvents rehash
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeClass: aClass
	aClass isDeleted ifTrue: [^self].
	self devenv forgetClass: aClass.
	globals basicRemoveKey: aClass symbol ifAbsent: nil.
	aClass class superclass isNil
		ifFalse: [aClass class superclass removeSubclass: aClass class].
	aClass superclass isNil ifFalse: [aClass superclass removeSubclass: aClass].
	aClass beDeleted
! !

!SmalltalkSystem methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeKey: key
	^globals removeKey: key
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeKey: aSymbol from: aMethodDictionary ifAbsent: aBlock
	| cm |
	cm := aMethodDictionary at: aSymbol ifAbsent: [^aBlock value].
	self devenv forgetMethod: cm.
	^aMethodDictionary basicRemoveKey: aSymbol asSymbol ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeKey: aSymbol ifAbsent: aBlock
	| selector global |
	selector := aSymbol asSymbol.
	global := globals at: selector ifAbsent: [^aBlock value].
	(global isClass and: [global symbol == selector]) ifTrue: [
		global allInstances notEmpty
			ifTrue: [^self error: 'The class being removed still has instances'].
		global delete.
		^selector].
	^globals basicRemoveKey: selector ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
renameClass: aClass to: aSymbol
	| symbol token assoc |
	symbol := aSymbol asSymbol.
	(globals includesKey: symbol)
		ifTrue: [self error: 'the global ' , symbol , ' already exists'].
	token := aClass symbol.
	assoc := globals associationAt: token.
	globals basicRemoveKey: token ifAbsent: nil.
	assoc key: symbol.
	globals basicAdd: assoc.
	aClass name: symbol
! !

!SmalltalkSystem methodsFor:  'binding libraries' stamp: 'KenD 28/Jun/2026 13:27:38'!
segmentLoaded: anImageSegment
	
! !

!SmalltalkSystem methodsFor:  'binding libraries' stamp: 'KenD 28/Jun/2026 13:27:38'!
segmentUnloaded: anImageSegment
	
! !

!SmalltalkSystem methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: aBlock thenDo: anotherBlock
	globals select: aBlock thenDo: anotherBlock
! !

!SmalltalkSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
showBacktraceOf: aProcess label: aString
	| writer logger |
	writer := '' writeStream.
	aProcess
		backtraceOn: writer
		maxLevels: 100
		stopWhen: [:cm | cm isDoit]
		filtered: false
		arguments: false.
	logger := self at: #Transcript ifAbsent: nil.
	logger isNil
		ifTrue: [session logError: writer contents]
		ifFalse: [logger nextPutAll: aString; cr; nextPutAll: writer contents].
	aProcess isResumable ifTrue: [aProcess performDeferred: #resume]
! !

!SmalltalkSystem methodsFor:  'startup/shutdown' stamp: 'KenD 28/Jun/2026 13:27:38'!
startUp
	session startUp.
	self ephemeronsDo: [:e | e activate].
	Float startUp.
	memory startUp.
	"platform startUp."
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
transcript
	^globals at: #Transcript
! !

!SmalltalkSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
version
	^'0.1.1'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SmalltalkSystem class' category: #Kernel!
SmalltalkSystem class
	instanceVariableNames: 'Implementors Senders'!


SmalltalkSystem initialize!

