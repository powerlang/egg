'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SMessage category: 'Powerlang-Core-SExpressions'!
SExpression subclass: #SMessage
	instanceVariableNames: 'selector receiver arguments cache inlined'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^visitor visitMessage: self
! !

!SMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentCount
	^arguments size
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
arguments
	^arguments
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
arguments: aCollection
	arguments := aCollection
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cache: anSCompiledMethod when: type
	cache
		ifNil: [ ^ cache := Array with: type with:
			anSCompiledMethod].
	cache := cache
		,
			(Array with: type with: 
			anSCompiledMethod)
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cacheUndermessage: aBlockClosure
	cache := aBlockClosure
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cachedUndermessage
	^cache isBlock ifTrue: [ cache ]
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
flushCache
	cache := nil
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	arguments := #().
	inlined := false
! !

!SMessage methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlined: aBoolean
	inlined := aBoolean
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInlined
	^ inlined
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMessage
	^true
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
methodFor: requiredType
	| type |
	cache ifNil: [ ^ nil ].
	1 to: cache size by: 2 do: [ :i | 
		type := cache at: i.
		type == requiredType
			ifTrue: [ ^ cache at: i + 1 ] ].
	^ nil
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPutAll: '{MessageId. '; print: selector; nextPutAll: '. '; cr.
	receiver printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '.'; cr.
	arguments
		do: [:statement | statement printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '. '; cr].
	aStream nextPutAll: '}'
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver
	^receiver
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: anSExpression
	receiver := anSExpression
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
registerCacheWith: runtime
	cache ifNil: [ runtime registerCache: self for: selector ]
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector
	^selector
! !

!SMessage methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector: aSelector
	selector := aSelector
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMessage class' category: 'Powerlang-Core-SExpressions'!
SMessage class
	instanceVariableNames: ''!

!SMessage class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeMessage
! !

!SMessage class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !


SMessage initialize!

