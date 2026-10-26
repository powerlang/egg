'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #Binding category: #'Powerlang-Core-SCompiler-Bindings'!
Object subclass: #Binding
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!Binding methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:40'!
beReferencedFrom: aScriptNode
	
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canBeAssigned
	^true
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
declaration
	^self
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEncoder
	self ASSERT: false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isArgument
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isClassBinding
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isClassVariable
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isConstantBinding
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDynamic
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isGlobal
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isInStack
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isInstVar
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLiteral
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLocal
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isPoolVariableBinding
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSelf
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSelfOrSuper
	^self isSelf or: [self isSuper]
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSuper
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isTemporary
	^false
! !

!Binding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
literal
	^nil
! !

!Binding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^name
! !

!Binding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name: aString
	name := aString
! !

!Binding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printNameOn: aStream
		aStream
		print: name

! !

!Binding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	self printNameOn: aStream.
	aStream
		nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPutAll: ')'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Binding class' category: #'Powerlang-Core-SCompiler-Bindings'!
Binding class
	instanceVariableNames: ''!


