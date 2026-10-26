"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #NativizerModule,
	#superclass : #Module,
	#instVars : [
		'environment'
	],
	#category : #Nativization
}


{ #category : #spec }
NativizerModule >> environment [
	^environment
]

{ #category : #spec }
NativizerModule >> imports [
	^{
		#Kernel -> #(Behavior CallbackBehavior CallbackMethod CharacterArray Closure CompiledBlock CompiledMethod Error Float OrderedCollection Process ProtoObject Species String).
		#'Kernel.LMR' -> #(LMRProtoObject LMRFloat LMRSpecies).
		#LMR -> #(CriticalArray GCSpace GlobalDispatchCache Memory NativeCode SendSite Thread).
		#'LMR.SExpressions' -> #(SExpression SMethod SBlock SBinding SInstVarBinding SLocalBinding SArgumentBinding STemporaryBinding SDynamicBinding SAssociationBinding SLiteral SIdentifier SReturn SAssignment SCascade SMessage SPragma TreecodeDecoder).
		#'LMR.Nativizer.Assembly.Intel' -> #(AMD64CodeGenerator AMD64TemplateAssembler SysVX64ABI WinX64ABI Register).
		#'LMR.Nativizer.Assembly.Aarch64' -> #(ARM64CodeGenerator ARM64Register ARM64MemoryOperand ARM64BranchFixup AAPCS64ABI).
		#'LMR.Nativizer.OCompiler' -> #(OptimizingNativizer)
	}
]

{ #category : #accessing }
NativizerModule >> inlinedMethods [
	| map |
	map := {
		(ProtoObject -> #(#basicObjectIndexOf: #class #objectAtValid: #objectAtValid:put:)).
		(LMRProtoObject -> #(#behavior #primitiveAt: #_cachedLookup: #_cachedLookup:in:)).
		(Object -> #(#byteAtValid: #byteAtValid:put: #at:put:)).
		(Species -> #(#instSize #_instancesAreArrayed #_instancesHavePointers #instanceBehavior)).
		(LMRSpecies -> #(#memory #primitiveNew #primitiveNew:)).
		(CompiledMethod -> #(#prepareForExecution #isNativized #optimizedCode #blockCount #literalIndexFrom:)).
		(CompiledBlock -> #(#argumentCount #blockNumber #blockCode #method)).
		(NativeCode -> #(#code)).
		(GCSpace -> #(#commitedLimit #nextFree #nextFree:)).
		(CharacterArray -> #(#characterAtValid:))}.
	^self undermethods , (self methodSubset: map)
]

{ #category : #accessing }
NativizerModule >> invokedMethods [
	| map |
	map := {
		(ProtoObject -> #(class)).
		(LMRProtoObject -> #(behavior #initializeExtended:contentSize: primitiveAt:)).
		(Object -> #(_replaceFrom:to:with:)).
		(Species -> #(instanceBehavior _instancesAreArrayed _instancesHavePointers)).
		(LMRSpecies -> #(allocate:size: nil:slotsOf: memory primitiveNewBytes: primitiveNewPointers: zero:bytesOf:))}.
	^self undermethods , (self methodSubset: map)
]

{ #category : #accessing }
NativizerModule >> justLoaded [
	InlineMessageLinker initializeInlineMessageLinkerFlags
]

{ #category : #accessing }
NativizerModule >> methodSubset: associations [
	| result dict |
	result := OrderedCollection new.
	dict := Dictionary withAll: associations.
	dict keysAndValuesDo: [ :species :selectors |
		selectors collect: [:sel | | m |
			m := species >> sel.
			m isNil ifTrue: [self error: 'method not found: ', species name, ' >> #', sel].
			m] in: result].
	^result
]

{ #category : #accessing }
NativizerModule >> optimizedMethods [
	| map |
	map := {
		(ProtoObject -> #(basicByteAt: #basicByteAt:put: basicObjectAt: #basicObjectAt:put: class)).
		(LMRProtoObject -> #(behavior primitiveAt: #primitiveAt:put: #initializeExtended:contentSize:)).
		(Object -> #(at: #at:put: byteAtValid: #byteAtValid:put: #replaceBytesForwardFrom:to:with:startingAt:)).
		(SendSite -> #(_dispatchOn: #_dispatchOn:startingAt: _dispatchDebuggableOn: #_dispatchDebuggableOn:startingAt:)).
		(Species -> #(instSize)).
		(LMRSpecies -> #(allocate:size: primitiveNew primitiveNew: primitiveNewBytes: primitiveNewPointers:)).
		(LMRFloat class -> #(new)).
		(CompiledBlock -> #(argumentCount arity blockCode method)).
		(Closure -> #(value value: #value:value:)).
		(CompiledMethod -> #(blockCount isNativized)).
		(String -> #(at: #at:put: byteAt: #byteAt:put:)).
		(GCSpace -> #(lockedAllocateIfPossible: shallowCopy:)).
		(Memory -> #(shallowCopy:))}.
	^self undermethods , (self methodSubset: map)
]


{ #category : #services }
NativizerModule >> newNativizationEnvironmentFor: aPlatform [
	^NativizationEnvironment new
		platform: aPlatform;
		inlinedMethods: self inlinedMethods;
		invokedMethods: self invokedMethods;
		optimizedMethods: self optimizedMethods
]

{ #category : #services }
NativizerModule >> undermethods [
	^SendSite undermethods
]