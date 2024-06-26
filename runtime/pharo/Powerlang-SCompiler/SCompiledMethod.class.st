Class {
	#name : 'SCompiledMethod',
	#superclass : 'Array',
	#type : 'variable',
	#instVars : [
		'format',
		'optimizedCode',
		'treecodes',
		'class',
		'selector',
		'source'
	],
	#pools : [
		'SCompiledMethodFlags'
	],
	#category : 'Powerlang-SCompiler-Backend',
	#package : 'Powerlang-SCompiler',
	#tag : 'Backend'
}

{ #category : 'instance creation' }
SCompiledMethod class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'instance creation' }
SCompiledMethod class >> new: anInteger [
	^ (self basicNew: anInteger) initialize
]

{ #category : 'constants' }
SCompiledMethod >> argumentCount [
	^format bitsAt: ArgCount
]

{ #category : 'constants' }
SCompiledMethod >> argumentCount: anInteger [
	format := format bitsAt: ArgCount put: anInteger
]

{ #category : 'constants' }
SCompiledMethod >> beDebugabble [
	format := format bitOr: Debuggable
]

{ #category : 'constants' }
SCompiledMethod >> blockCount [
	^format bitsAt: BlockCount
]

{ #category : 'constants' }
SCompiledMethod >> blockCount: anInteger [
	format := format bitsAt: BlockCount put: anInteger
]

{ #category : 'constants' }
SCompiledMethod >> blocks [
	self hasBlocks ifFalse: [^#()].
	^self select: [:literal | literal isBlock]
]

{ #category : 'constants' }
SCompiledMethod >> capturesSelf [ 
	^ format anyMask: CapturesSelf
]

{ #category : 'constants' }
SCompiledMethod >> capturesSelf: aBoolean [
	format := aBoolean
				  ifTrue: [ format bitOr: CapturesSelf ]
				  ifFalse: [ format bitClear: CapturesSelf ]
]

{ #category : 'constants' }
SCompiledMethod >> classBinding [
	^class
]

{ #category : 'constants' }
SCompiledMethod >> classBinding: aClass [
	class := aClass
]

{ #category : 'constants' }
SCompiledMethod >> copyWithLiterals: aCollection [
	| result |
	result := self species withAll: aCollection.
	^ result
		treecodes: treecodes;
		classBinding: class;
		format: format;
		optimizedCode: optimizedCode;
		selector: selector;
		source: source;
		yourself
]

{ #category : 'constants' }
SCompiledMethod >> dynamicVariableNamed: aSymbol [
	^class dynamicVariableNamed: aSymbol
]

{ #category : 'constants' }
SCompiledMethod >> environmentCount [
	^format bitsAt: EnvCount
]

{ #category : 'constants' }
SCompiledMethod >> environmentCount: anInteger [
	format := format bitsAt: EnvCount put: anInteger
]

{ #category : 'accessing' }
SCompiledMethod >> format [
	^format
]

{ #category : 'accessing' }
SCompiledMethod >> format: anInteger [
	format := anInteger
]

{ #category : 'printing' }
SCompiledMethod >> gtDisplayOn: stream [
stream
		nextPutAll: self classBinding name;
		nextPutAll: '>>';
		print: selector
]

{ #category : 'constants' }
SCompiledMethod >> hasBlocks [
	^self blockCount > 0
]

{ #category : 'constants' }
SCompiledMethod >> hasEnvironment [
	^ format anyMask: HasEnvironment
]

{ #category : 'constants' }
SCompiledMethod >> hasEnvironment: aBoolean [
	format := aBoolean
				  ifTrue: [ format bitOr: HasEnvironment ]
				  ifFalse: [ format bitClear: HasEnvironment ]
]

{ #category : 'constants' }
SCompiledMethod >> hasFrame [
	^ format anyMask: HasFrame
]

{ #category : 'constants' }
SCompiledMethod >> hasFrame: aBoolean [
	format := aBoolean
				  ifTrue: [ format bitOr: HasFrame ]
				  ifFalse: [ format bitClear: HasFrame ]
]

{ #category : 'constants' }
SCompiledMethod >> initialize [
	super initialize.
	format := 0
]

{ #category : 'constants' }
SCompiledMethod >> isCallback [
	^false
]

{ #category : 'constants' }
SCompiledMethod >> isCalloutMethod [
	^ false
]

{ #category : 'constants' }
SCompiledMethod >> isDebuggable [
	^ format anyMask: Debuggable
]

{ #category : 'constants' }
SCompiledMethod >> isExtension [

	^ format anyMask: IsExtension
]

{ #category : 'constants' }
SCompiledMethod >> isFrameless [
	^ self hasFrame not
]

{ #category : 'constants' }
SCompiledMethod >> literals [
	^Array withAll: self
]

{ #category : 'accessing' }
SCompiledMethod >> module [
	| association |
	self isExtension ifFalse: [^class module].
 	association := self last.
	(association isAssociation and: [association key == #module])
		ifFalse: [self error: 'extension method ', self signature , ' without module'].
	^association value
]

{ #category : 'accessing' }
SCompiledMethod >> optimizedCode [
	^optimizedCode
]

{ #category : 'accessing' }
SCompiledMethod >> optimizedCode: anObject [
	optimizedCode := anObject
]

{ #category : 'constants' }
SCompiledMethod >> pragma: aPragmaNode [

]

{ #category : 'accessing' }
SCompiledMethod >> prepareForExecution [
	optimizedCode ifNil: [ optimizedCode := self sexpressions ].
	^ optimizedCode
]

{ #category : 'printing' }
SCompiledMethod >> printOn: aStream [
	aStream
		print: self classBinding;
		nextPutAll: '>>';
		print: selector;
		cr.
	source
		ifNotNil: [ aStream
				cr;
				nextPutAll: source ]
]

{ #category : 'constants' }
SCompiledMethod >> selector [
	^selector
]

{ #category : 'constants' }
SCompiledMethod >> selector: aSymbol [
	selector := aSymbol
]

{ #category : 'constants' }
SCompiledMethod >> signature [
	^class-> selector
]

{ #category : 'constants' }
SCompiledMethod >> source [
	^source
]

{ #category : 'constants' }
SCompiledMethod >> source: aString [
	source := aString
]

{ #category : 'constants' }
SCompiledMethod >> tempCount [
	^format bitsAt: TempCount
]

{ #category : 'constants' }
SCompiledMethod >> tempCount: anInteger [
	format := format bitsAt: TempCount put: anInteger
]

{ #category : 'constants' }
SCompiledMethod >> treecodes [
	^treecodes
]

{ #category : 'constants' }
SCompiledMethod >> treecodes: aCollection [
	treecodes := aCollection
]
