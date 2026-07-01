'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!


!CompiledMethod methodsFor:  '*Development' stamp: 'KenD 28/Jun/2026 13:32:24'!
ast
	^nil
! !

!CompiledMethod methodsFor:  '*Development' stamp: 'KenD 28/Jun/2026 13:32:24'!
references: anObject
	| literal |
	1 to: self size do: [:i |
		literal := self at: i.
		anObject = literal ifTrue: [^true].
		(self literal: literal includes: anObject) ifTrue: [^true]].
	^false
! !

!CompiledMethod methodsFor:  '*Development' stamp: 'KenD 28/Jun/2026 13:32:24'!
literal: literal includes: anObject
	^literal class == Array and: [
		(literal includes: anObject)
			or: [literal anySatisfy: [:l | self literal: l includes: anObject]]]
! !

!CompiledMethod methodsFor:  '*Development' stamp: 'KenD 28/Jun/2026 13:32:24'!
treecodeString
	^treecodes printString
! !

!CompiledMethod class methodsFor:  '*Development' stamp: 'KenD 28/Jun/2026 13:32:24'!
aspects
	^#(#treecodeString #disassembledText)
! !


