Class {
	#name : 'CompiledMethodMirror',
	#superclass : 'ObjectMirror',
	#classVars : [
		'Flags'
	],
	#pools : [
		'CompiledMethodFormatMasks'
	],
	#category : 'Powerlang-Core-Mirrors',
	#package : 'Powerlang-Core',
	#tag : 'Mirrors'
}

{ #category : 'constants' }
CompiledMethodMirror >> argumentCount [
	^self flags asLocalInteger bitAnd: ArgCount
]

{ #category : 'accessing' }
CompiledMethodMirror >> at: index [
	^ self slotAt: self fixedInstSize + index
]

{ #category : 'constants' }
CompiledMethodMirror >> classBinding [
	| class |
	class := self getInstVarNamed: #class.
	^class asSpeciesMirror
]

{ #category : 'constants' }
CompiledMethodMirror >> compiler [
	^self ASSERT: false
]

{ #category : 'testing' }
CompiledMethodMirror >> currentVersion [
	^self classBinding compiledMethodFor: self selector asLocalString asSymbol
]

{ #category : 'constants' }
CompiledMethodMirror >> decodedTreecodes [
	| treecodes |
	treecodes := self treecodes localDeepCopy.
	^ TreecodeDecoder new
		stream: treecodes readStream;
		method: self;
		decodeMethod
]

{ #category : 'private' }
CompiledMethodMirror >> fixedInstSize [
	^ self reflectedClass instSize
]

{ #category : 'constants' }
CompiledMethodMirror >> flags [
	^self getInstVarNamed: #flags
]

{ #category : 'printing' }
CompiledMethodMirror >> fullName [
	^self classBinding localName , '>>#' , self selector asLocalString
]

{ #category : 'constants' }
CompiledMethodMirror >> isExpression [
	^false
]

{ #category : 'testing' }
CompiledMethodMirror >> isValid [
	[^self reflectedClass localEquivalent inheritsFrom: CompiledMethod]
		on: Error
		do: [^false]
]

{ #category : 'constants' }
CompiledMethodMirror >> nativeCodeBytes [
	^self optimizedCode slotAt: 1
]

{ #category : 'constants' }
CompiledMethodMirror >> optimizedCode [
	^self getInstVarNamed: #optimizedCode
]

{ #category : 'printing' }
CompiledMethodMirror >> printOn: aStream [
	| signature |
	signature := ([ self fullName ]
						on: StorageReadError
						do: [ handle printString ]).
	aStream
		nextPutAll:
			'a CMMirror ('
			; nextPutAll: signature; nextPut: $)
]

{ #category : 'constants' }
CompiledMethodMirror >> readSourceFrom: encodedPosition [
	self ASSERT: false
]

{ #category : 'constants' }
CompiledMethodMirror >> selector [
	| selector |
	selector := self getInstVarNamed: #selector.
	^selector asStringMirror
]

{ #category : 'accessing' }
CompiledMethodMirror >> size [
	^ handle size - self fixedInstSize
]

{ #category : 'constants' }
CompiledMethodMirror >> source [
	^self sourceCode
]

{ #category : 'constants' }
CompiledMethodMirror >> sourceCode [
	| source |
	source := self getInstVarNamed: #source.
	source reflectsNil ifTrue: [^nil].
	source reflectsInteger ifFalse: [^source asString].
	^self readSourceFrom: source
]

{ #category : 'private' }
CompiledMethodMirror >> structureType [
	^#CompiledMethod
]

{ #category : 'testing' }
CompiledMethodMirror >> timestamp [
	^nil
]

{ #category : 'constants' }
CompiledMethodMirror >> treecodes [
	^self getInstVarNamed: #treecodes.
]
