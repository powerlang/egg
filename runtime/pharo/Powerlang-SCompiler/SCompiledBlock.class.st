Class {
	#name : 'SCompiledBlock',
	#superclass : 'Object',
	#type : 'variable',
	#instVars : [
		'format',
		'optimizedCode',
		'method'
	],
	#pools : [
		'SCompiledBlockFlags'
	],
	#category : 'Powerlang-SCompiler-Backend',
	#package : 'Powerlang-SCompiler',
	#tag : 'Backend'
}

{ #category : 'instance creation' }
SCompiledBlock class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'constants' }
SCompiledBlock >> argumentCount [
	^format bitsAt: BlockArgCount
]

{ #category : 'constants' }
SCompiledBlock >> argumentCount: anInteger [
	format := format bitsAt: BlockArgCount put: anInteger
]

{ #category : 'constants' }
SCompiledBlock >> capturesHome [
	^ format anyMask: BlockCapturesHome
]

{ #category : 'constants' }
SCompiledBlock >> capturesHome: aBoolean [
	format := aBoolean
				  ifTrue: [ format bitOr: BlockCapturesHome ]
				  ifFalse: [ format bitClear: BlockCapturesHome ]
]

{ #category : 'constants' }
SCompiledBlock >> capturesSelf [
	^format anyMask: BlockCapturesSelf
]

{ #category : 'constants' }
SCompiledBlock >> capturesSelf: aBoolean [
	format := aBoolean
		ifTrue: [ format bitOr: BlockCapturesSelf ]
		ifFalse: [ format bitClear: BlockCapturesSelf ]
]

{ #category : 'constants' }
SCompiledBlock >> environmentCount [
	^ format bitsAt: BlockEnvCount
]

{ #category : 'constants' }
SCompiledBlock >> environmentCount: anInteger [
	format := format bitsAt: BlockEnvCount put: anInteger
]

{ #category : 'constants' }
SCompiledBlock >> format [
	^ format
]

{ #category : 'constants' }
SCompiledBlock >> id [
	^format bitsAt: BlockId
]

{ #category : 'constants' }
SCompiledBlock >> id: anInteger [
	format := format bitsAt: BlockId put: anInteger
]

{ #category : 'constants' }
SCompiledBlock >> initialize [
	super initialize.
	format := 0
]

{ #category : 'constants' }
SCompiledBlock >> isBlock [
	^true
]

{ #category : 'constants' }
SCompiledBlock >> method [
	^method
]

{ #category : 'accessing' }
SCompiledBlock >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : 'constants' }
SCompiledBlock >> optimizedCode [
	^optimizedCode
]

{ #category : 'constants' }
SCompiledBlock >> optimizedCode: anObject [
	optimizedCode := anObject
]

{ #category : 'constants' }
SCompiledBlock >> printOn: aStream [
	aStream
		print: method classBinding;
		nextPutAll: '>>';
		print: method selector;
		nextPutAll: ' [block ';
		print: self id;
		nextPutAll: ']'

]

{ #category : 'constants' }
SCompiledBlock >> tempCount [
	^format bitsAt: BlockTempCount
]

{ #category : 'constants' }
SCompiledBlock >> tempCount: anInteger [
	format := format bitsAt: BlockTempCount put: anInteger
]

{ #category : 'constants' }
SCompiledBlock >> value [
self halt
"	<primitive: BlockValue>
	^ self primitiveFailed" 
]
