'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #CompiledMethod category: #Kernel!
Array subclass: #CompiledMethod
	instanceVariableNames: 'format optimizedCode treecodes class selector source'
	classVariableNames: 'Flags'
	poolDictionaries: ''
	category: 'Kernel'!
!CompiledMethod commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2020 LabWare.
    See (MIT) license in root directory.
!

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
author
	^'Unknown'
! !

!CompiledMethod methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
~ aCompiledMethod
	self literals = aCompiledMethod literals ifFalse: [^false].
	^treecodes = aCompiledMethod treecodes
! !

!CompiledMethod methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= anObject
	^self == anObject
! !

!CompiledMethod methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
addSymbolsIn: anArray to: aSet
	anArray do: [:elem | 
		elem isSymbol
			ifTrue: [aSet add: elem]
			ifFalse: [elem class == Array ifTrue: [self addSymbolsIn: elem to: aSet]]]
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentCount
	^format bitsAt: ArgCount
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentCount: anInteger
	format := format bitsAt: ArgCount put: anInteger
! !

!CompiledMethod methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
asExtensionFor: aModule
	"Note: keep in mind that this service breaks the relationship between the receiver and its blocks."
	| extension |
	extension := self class withAll: self literals , {#module -> aModule}.
	extension
		format: format;
		beExtension;
		selector: selector;
		sourceObject: source;
		classBinding: class;
		treecodes: treecodes.
	extension blocks do: [:block | block method: extension].
	^extension
! !

!CompiledMethod methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asOverridden
	^self
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
beExtension
	format := format bitOr: IsExtension
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockCount
	^format bitsAt: BlockCount
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
blockCount: anInteger
	format := format bitsAt: BlockCount put: anInteger
! !

!CompiledMethod methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
blocks
	self hasBlocks ifFalse: [^#()].
	^self select: [:literal | literal isBlock]
! !

!CompiledMethod methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
blocksDo: aBlock
	self hasBlocks ifFalse: [^self].
	self
		select: [:b | b isBlock and: [b method == self]]
		thenDo: [:b | aBlock evaluateWith: b]
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
treecodes
	^treecodes
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
treecodes: aByteArray
	treecodes := aByteArray
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBeInstalled
	^self isExpression not
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
capturesSelf
	^format isOnBit: CapturesSelf
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
capturesSelf: aBoolean
	format := aBoolean
				ifTrue: [ format bitOr: CapturesSelf ]
				ifFalse: [ format bitClear: CapturesSelf ]
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
category
	^class categoryFor: selector
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
category: category
	^class organization move: selector to: category
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classBinding
	^class
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classBinding: aClass
	class := aClass
! !

!CompiledMethod methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
currentVersion
	^class compiledMethodAt: selector
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
environmentCount
	^format bitsAt: EnvCount
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
environmentCount: anInteger
	format bitsAt: EnvCount put: anInteger
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
executableCode
	^optimizedCode
! !

!CompiledMethod methodsFor:  'evaluation' stamp: 'KenD 28/Jun/2026 13:27:38'!
executeOn: receiver withArguments: anArray
	| size |
	self prepareForExecution.
	size := anArray basicSize.
	self argumentCount = size ifFalse: [^self error: 'incorrect arity'].
	anArray _expandInStackSized: size.
	^receiver _invoke: self validOptimizedCodeAddress _asNative
! !

!CompiledMethod methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
flushFromCaches
	self errorVMSpecific
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
format
	^format
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
format: anInteger
	format := anInteger
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasBlocks
	^self blockCount > 0
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasEnvironment: aBoolean
	format := aBoolean
				ifTrue: [ format bitOr: HasEnvironment ]
				ifFalse: [ format bitClear: HasEnvironment ]
! !

!CompiledMethod methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasEnvironment
	^self environmentCount > 0
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasFrame
	^format isOnBit: HasFrame
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasFrame: aBoolean
	format := aBoolean
				ifTrue: [ format bitOr: HasFrame ]
				ifFalse: [ format bitClear: HasFrame ]
! !

!CompiledMethod methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^selector hashWith: class
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasOptimizedCode
	^optimizedCode !!= nil
! !

!CompiledMethod methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	format := 0
! !

!CompiledMethod methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:38'!
install
	class addSelector: selector withMethod: self
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
invalidateOptimizedCode
	optimizedCode ifNil: [^self].
	optimizedCode := nil.
	self blocksDo: [:b | b invalidateOptimizedCode]
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCallback
	^false
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCompiledMethod
	^true
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCurrentVersion
	^class notNil and: [self == (class compiledMethodAt: selector)]
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDebuggable
	^format isOnBit: Debuggable
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDoit
	^false
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isExpression
	^false
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isExtension
	^format isOnBit: IsExtension
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCalloutMethod
	^false
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFrameless
	^self hasFrame not
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFFIMethod
	^false
! !

!CompiledMethod methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNativized
	^false == (optimizedCode == nil)
! !

!CompiledMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isOverridden
	^false
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
literalIndexFrom: grossIndex
	| instVars index |
	grossIndex _isSmallInteger ifFalse: [^self outOfBoundsIndex: grossIndex].
	instVars := self class instSize.
	(1 <= grossIndex and: [grossIndex <= (self _size - instVars)])
		ifFalse: [^self outOfBoundsIndex: grossIndex].
	index := grossIndex + instVars.
	^index
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
literals
	^Array withAll: self
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
method
	^self
! !

!CompiledMethod methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
module
	| association |
	self isExtension ifFalse: [^class module].
 	association := self last.
	(association isAssociation and: [association key == #module])
		ifFalse: [self error: 'extension method ', self signature , ' without module'].
	^association value
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
optimizedCode
	^optimizedCode
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
optimizedCode: anObject
	anObject method: self.
	optimizedCode := anObject
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
optimizedCodeAddress
	self prepareForExecution.
	^optimizedCode optimizedCodeAddress
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
pragma: aPragmaNode

! !

!CompiledMethod methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	super postCopy.
	self
		withIndexDo: [:b :i | | c |
			b isBlock ifTrue: [
				c := b copy method: self.
				self at: i put: c]];
		invalidateOptimizedCode
! !

!CompiledMethod methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
prepareForExecution
	self isNativized ifFalse: [Kernel prepareForExecution: self].
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveNumber
	^0
! !

!CompiledMethod methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		print: class;
		nextPutAll: '>>';
		print: selector
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector
	^selector
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector: aSymbol
	selector := aSymbol.
	optimizedCode notNil ifTrue: [self invalidateOptimizedCode; nativize]
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selectorAt: index
	^self at: self size - index + 1
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sendSites
	^optimizedCode sendSites
! !

!CompiledMethod methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
signature
	^class -> selector
! !

!CompiledMethod methodsFor:  'source code support' stamp: 'KenD 28/Jun/2026 13:27:38'!
sourceObject
	^source
! !

!CompiledMethod methodsFor:  'source code support' stamp: 'KenD 28/Jun/2026 13:27:38'!
sourceObject: aString
	source := aString
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tempCount
	^format bitsAt: TempCount
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tempCount: anInteger
	format := format bitsAt: TempCount put: anInteger
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
timestamp
	^nil
! !

!CompiledMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
updateOptimizedCode
	optimizedCode ifNil: [^self].
	self invalidateOptimizedCode; prepareForExecution
! !

!CompiledMethod methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
validOptimizedCodeAddress
	^optimizedCode code _asSmallInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CompiledMethod class' category: #Kernel!
CompiledMethod class
	instanceVariableNames: 'Flags'!

!CompiledMethod class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeFormatFlags
	Flags := self addNamespace.
	Flags
		at: #ArgCount put: (1 thru: 6);
		at: #BlockCount put: (7 thru: 13);
		at: #TempCount put: (14 thru: 21);
		at: #CapturesSelf put: (1 bitShift: 22 - 1);
		at: #HasEnvironment put: (1 bitShift: 23 - 1);
		at: #HasFrame put: (1 bitShift: 24 - 1);
		at: #Debuggable put: (1 bitShift: 25 - 1);
		at: #EnvCount put: (26 thru: 31);
		at: #IsExtension put: (1 bitShift: 32 - 1)
! !

!CompiledMethod class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxArgCount
	^(2 raisedTo: ArgCount length) - 1
! !

!CompiledMethod class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxBlockCount
	^(2 raisedTo: BlockCount length) - 1
! !

!CompiledMethod class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxTempCount
	^(2 raisedTo: TempCount length) - 1
! !

!CompiledMethod class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	| cm |
	cm := super new: anInteger.
	^cm initialize
! !


CompiledMethod initialize!

