'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ScriptScope category: #'Powerlang-Core-SCompiler'!
Object subclass: #ScriptScope
	instanceVariableNames: 'script arguments temporaries stackSize envSize captureSelf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!ScriptScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
capturesSelf
	^ captureSelf
! !

!ScriptScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
defineArgument: identifier
	| binding |
	(self resolves: identifier) ifTrue: [self redefinitionError: identifier].
	binding := ArgumentBinding new name: identifier.
	arguments define: identifier as: binding.
	^binding
! !

!ScriptScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
defineTemporary: identifier
	| binding |
	(temporaries defines: identifier)
		ifTrue: [self redefinitionError: identifier].
	binding := TemporaryBinding new name: identifier.
	temporaries define: identifier as: binding.
	^binding
! !

!ScriptScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
defines: aString
	^(temporaries defines: aString) or: [arguments defines: aString]
! !

!ScriptScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
describe: identifier
	| binding type |
	binding := self resolve: identifier.
	type := self class name asLowercase allButLast: 'scope' size.
	^binding description , ' of ' , type
! !

!ScriptScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentSize
	^envSize
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
growEnvironment
	^envSize := envSize + 1
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
growStack
	^stackSize := stackSize + 1
! !

!ScriptScope methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	arguments := StaticBinder new.
	temporaries := StaticBinder new.
	stackSize := envSize := 0.
		captureSelf := false.
! !

!ScriptScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
localBindings
	^arguments values , temporaries values
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionDefinedArguments
	arguments withIndexDo: [:binding :index | binding index: index]
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionDefinedLocals
	self positionDefinedTemporariesIn: self; positionDefinedArguments
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionDefinedTemporariesIn: aScriptScope
	temporaries do: [:binding | | position |
		position := binding isInStack
			ifTrue: [aScriptScope growStack]
			ifFalse: [aScriptScope growEnvironment].
		binding index: position]
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionLocals
	self positionDefinedLocals
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
realScope
	^script realScript scope
! !

!ScriptScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
redefinitionError: name
	| scope description |
	scope := self scopeOf: name.
	description := scope describe: name.
	script compiler
		warning: name , ' already declared as ' , description
		at: script stretch
! !

!ScriptScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolveLocal: aString
	(temporaries at: aString) ifNotNil: [:binding | ^binding].
	^arguments at: aString
! !

!ScriptScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolves: aString
	^(self resolve: aString) isDynamic not
! !

!ScriptScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
scopeOf: aString
	| s |
	s := self scriptDefining: aString.
	^s notNil ifTrue: [s scope]
! !

!ScriptScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
script: aScriptNode
	script := aScriptNode
! !

!ScriptScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
stackSize
	^stackSize
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ScriptScope class' category: #'Powerlang-Core-SCompiler'!
ScriptScope class
	instanceVariableNames: ''!

!ScriptScope class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
on: aScriptNode
	^self new script: aScriptNode
! !


ScriptScope initialize!

