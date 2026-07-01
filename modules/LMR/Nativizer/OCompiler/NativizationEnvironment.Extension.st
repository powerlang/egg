'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!NativizationEnvironment methodsFor:  '*OCompiler' stamp: 'KenD 28/Jun/2026 13:27:39'!
optimizingNativizer
	^OptimizingNativizer
! !

!NativizationEnvironment methodsFor:  '*OCompiler' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldOptimize: method
	method isDebuggable ifTrue: [^false].
	method isCallback ifTrue: [^false].
	(method classBinding == Object
		and: [SendSite isUndermethod: method selector])
		ifTrue: [^true].
	(method classBinding == ProtoObject
		and: [#(behavior class primitiveAt:) includes: method selector])
		ifTrue: [^true].
	(method classBinding == Object and: [
		#(at: at:put: basicByteAt: basicByteAt:put: byteAtValid: byteAtValid:put:
			basicObjectAt: basicObjectAt:put: primitiveAt:put: replaceBytesForwardFrom:to:with:startingAt:)
			includes: method selector])
		ifTrue: [^true].
	(method classBinding == Array
		and: [#(at: at:put:) includes: method selector])
		ifTrue: [^true].
	(method classBinding == SendSite and: [
		#(_dispatchOn: _dispatchOn:startingAt: _dispatchDebuggableOn: _dispatchDebuggableOn:startingAt:)
			includes: method selector])
		ifTrue: [^true].
	(method classBinding == Species
		and: [#(allocate:size: primitiveNew primitiveNew: instSize
			primitiveNewBytes: primitiveNewPointers:)
			includes: method selector])
		ifTrue: [^true].
	(method classBinding == Float class
		and: [#(basicNew new) includes: method selector])
		ifTrue: [^true].
	(method classBinding == CompiledBlock
		and: [#(argumentCount arity blockCode method) includes: method selector])
		ifTrue: [^true].
	(method classBinding == Closure
		and: [#(value value: value:value:) includes: method selector])
		ifTrue: [^true].
	(method classBinding == CompiledMethod
		and: [#(at: blockCount isNativized) includes: method selector])
		ifTrue: [^true].
	(method classBinding == String
		and: [#(at: at:put: byteAt: byteAt:put:) includes: method selector])
		ifTrue: [^true].
	(method classBinding == GCSpace and: [
		#(lockedAllocateIfPossible: lockedAllocateUnsafe: shallowCopy:)
			includes: method selector])
		ifTrue: [^true].
	(method classBinding == Memory
		and: [#(shallowCopy:) includes: method selector])
		ifTrue: [^true].
	^false
! !


