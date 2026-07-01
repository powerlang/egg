'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #BinaryMessageNativizer category: #Nativization!
Object subclass: #BinaryMessageNativizer
	instanceVariableNames: 'message assembler nativizer done failed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
argumentAt: index in: environment
	nativizer argumentAt: index in: environment 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembler: anAssembler
	assembler := anAssembler 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
failLabel
	^failed 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineBitAnd
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		andRwithA;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #bitAnd:.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineBitAnd: selector
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		andRwithA;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: selector.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineBitOr: selector
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		orRwithA;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: selector.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineBitXor
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		xorRwithA;
		setRintegerBit;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #bitXor:.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineEquals
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		loadTwithR;
		loadRwithTrue;
		compareTwithA;
		jumpIfEqualTo: done;
		loadRwithFalse;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #=.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineGreaterEqualThan
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		loadTwithR;
		loadRwithTrue;
		compareTwithA;
		jumpIfGreaterOrEqualSignedTo: done;
		loadRwithFalse;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #<.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineGreaterThan
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		loadTwithR;
		loadRwithTrue;
		compareTwithA;
		jumpIfGreaterSignedTo: done;
		loadRwithFalse;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #<.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineIdentityEquals
	done := assembler newLabel.
	self loadOperands.
	assembler loadTwithR; loadRwithTrue;
		compareTwithA;
		jumpIfEqualTo: done; loadRwithFalse; @ done
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineLessEqualThan
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		loadTwithR;
		loadRwithTrue;
		compareTwithA;
		jumpIfLessOrEqualSignedTo: done;
		loadRwithFalse;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #<.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineLessThan
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		loadTwithR;
		loadRwithTrue;
		compareTwithA;
		jumpIfLessSignedTo: done;
		loadRwithFalse;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #<.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineMessage
	| selector s |
	s := message selector.
	selector := s isSymbol
		ifTrue: [ s ]
		ifFalse: [ nativizer method at: s ].
	selector = #==
		ifTrue: [ ^ self inlineIdentityEquals ].
	selector = #=
		ifTrue: [ ^ self inlineEquals ].
	selector = #+
		ifTrue: [ ^ self inlinePlus ].
	selector = #<
		ifTrue: [ ^ self inlineLessThan ].
	selector = #<=
		ifTrue: [ ^ self inlineLessEqualThan ].
	selector = #>=
		ifTrue: [ ^ self inlineGreaterEqualThan ].
	selector = #>
		ifTrue: [ ^ self inlineGreaterThan ].
	selector = #-
		ifTrue: [ ^ self inlineMinus ].
	selector = #*
		ifTrue: [ ^ self inlineMultiply ].
	selector = #//
		ifTrue: [ ^ self inlineQuotient ].
	selector = #\\
		ifTrue: [ ^ self inlineRemainder ].
	selector = #|
		ifTrue: [ ^ self inlineBitOr: #| ].
	selector = #&
		ifTrue: [ ^ self inlineBitAnd: #& ].
	"	selector = #'>>' ifTrue: [^self inlineBitShiftLeft: #>>].
	selector = #'<<' ifTrue: [^self inlineBitShiftRight: #<<]."
	selector = #bitOr:
		ifTrue: [ ^ self inlineBitOr: #bitOr: ].
	selector = #bitAnd:
		ifTrue: [ ^ self inlineBitAnd: #bitAnd: ].
	selector = #bitXor:
		ifTrue: [ ^ self inlineBitXor ].
	"	selector = #bitShift: ifTrue: [^self inlineBitShift]."
	self ASSERT: false
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineMinus
	| overflow |
	done := assembler newLabel.
	failed := assembler newLabel.
	overflow := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		subAfromR;
		jumpIfOverflowTo: overflow;
		setRintegerBit;
		@ done.
	nativizer addFallback: [
		assembler
			@ overflow;
			addAtoR;
			@ failed;
			pushA.
		nativizer emitSend: #'-'.
		assembler jumpTo: done] 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineMultiply
	| overflow |
	done := assembler newLabel.
	failed := assembler newLabel.
	overflow := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		pushA;
		convertAtoNativeInteger;
		loadTwithR;
		clearRintegerBit;
		multiplyRbyAwideningToA;
		popA;
		jumpIfOverflowTo: overflow;
		setRintegerBit;
		@ done.
	nativizer
		addFallback: [ assembler
				@ overflow;
				loadRwithT;
				@ failed;
				pushA.
			nativizer emitSend: #*.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlinePlus
	| overflow |
	done := assembler newLabel.
	failed := assembler newLabel.
	overflow := assembler newLabel.
	self loadOperands.
	nativizer saveContextSwitchPoint.
	assembler
		clearRintegerBit;
		addAtoR;
		jumpIfOverflowTo: overflow;
		@ done.
	nativizer addFallback: [
		assembler
			@ overflow;
			subAfromR;
			setRintegerBit;
			@ failed;
			pushA.
		nativizer emitSend: #'+'.
		assembler jumpTo: done] 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineQuotient
	| |
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	assembler
		compareRwithSmallInteger: 0;
		jumpIfLessOrEqualSignedTo: failed.
	nativizer saveContextSwitchPoint.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		loadTwithA;
		extendRtoAandDividebyT;
		convertRtoSmallInteger;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #//.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlineRemainder
	done := assembler newLabel.
	failed := assembler newLabel.
	self loadOperands.
	assembler
		compareRwithSmallInteger: 0;
		jumpIfLessOrEqualSignedTo: failed.
	nativizer saveContextSwitchPoint.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		loadTwithA;
		extendRtoAandDividebyT;
		loadRwithA;
		convertRtoSmallInteger;
		@ done.
	nativizer
		addFallback: [ assembler
				@ failed;
				pushA.
			nativizer emitSend: #//.
			assembler jumpTo: done ]
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithArgument: index in: environment
	nativizer loadAwithArgument: index in: environment 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithTemporary: index in: environment
	nativizer loadAwithTemporary: index in: environment 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadOperands
	message opcodes
		do: [:hintcode | hintcode nativizeUsing: assembler for: self] 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRvisitingArgument
	message arguments first acceptVisitor: nativizer
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRvisitingReceiver
	message receiver acceptVisitor: nativizer 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithTemporary: index env: environment
	nativizer temporaryAt: index in: environment
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
message: aMessageTreecode
	message := aMessageTreecode 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
method
	^nativizer method 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodLiteralAt: index
	^nativizer methodLiteralAt: index
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizer: aTreecodeNativizer
	nativizer := aTreecodeNativizer 
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
popR
	^ nativizer popR
! !

!BinaryMessageNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushR
	^nativizer pushR
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BinaryMessageNativizer class' category: #Nativization!
BinaryMessageNativizer class
	instanceVariableNames: ''!


