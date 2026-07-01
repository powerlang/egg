'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SCascadeMessage category: 'Powerlang-Core-SExpressions'!
SExpression subclass: #SCascadeMessage
	instanceVariableNames: 'selector arguments cascade cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitCascadeMessage: self
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentCount
	^arguments size
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
arguments
	^arguments
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
arguments: aCollection
	arguments := aCollection
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cache: anSCompiledMethod when: type
	cache ifNil: [ ^ cache := Array with: type with: anSCompiledMethod ].
	cache := cache , (Array with: type with: anSCompiledMethod)
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cacheUndermessage: aBlockClosure
	cache := aBlockClosure
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cachedUndermessage
	^ cache isBlock
		ifTrue: [ cache ]
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cascade
	cascade
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cascade: anSCascade
	cascade := anSCascade
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
flushCache
	cache := nil
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isCascadeMessage
	^true
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
methodFor: requiredType
	| type |
	cache ifNil: [ ^ nil ].
	1 to: cache size by: 2 do: [ :i | 
		type := cache at: i.
		type == requiredType
			ifTrue: [ ^ cache at: i + 1 ] ].
	^ nil
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver
	^cascade receiver
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
registerCacheWith: runtime
	cache ifNil: [ runtime registerCache: self for: selector ]
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector
	^selector
! !

!SCascadeMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector: aSymbol
	selector := aSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCascadeMessage class' category: 'Powerlang-Core-SExpressions'!
SCascadeMessage class
	instanceVariableNames: ''!

!SCascadeMessage class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeCascadeMessage
! !


