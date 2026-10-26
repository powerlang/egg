'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SBlock category: 'Powerlang-Core-SExpressions'!
SScript subclass: #SBlock
	instanceVariableNames: 'index capturedVariables inlinedArgs'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SBlock methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^visitor visitBlock: self
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
capturedVariables
	^capturedVariables
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
capturedVariables: aCollection
	capturedVariables := aCollection
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
capturesHome
	^compiledCode capturesHome
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
	^index
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: anInteger
	index := anInteger
! !

!SBlock methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	capturedVariables := #()
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlinedArgs
	^ inlinedArgs
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlinedArgs: anArray
	inlinedArgs:= anArray 
! !

!SBlock methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
isBlock
	^true
! !

!SBlock methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInlined
	^ compiledCode isNil
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
offsetOfCurrentEnvironment
	^ 2
! !

!SBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
optimizedCode
	^compiledCode optimizedCode
! !

!SBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	aStream
		tab: anInteger;
		nextPutAll: '{BlockId. capturedVariables: ';
		print: capturedVariables;
		cr.
	super printOn: aStream indent: anInteger.
	aStream nextPutAll: '}'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SBlock class' category: 'Powerlang-Core-SExpressions'!
SBlock class
	instanceVariableNames: ''!

!SBlock class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeBlock
! !


SBlock initialize!

