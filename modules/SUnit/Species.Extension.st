'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!Species methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
selectorsUpTo: aClass
	| cls |
	^Array streamContents: [:strm | 
		cls := self.
		[
			cls notNil
				ifTrue: [cls methodDictionary keysAndValuesDo: [:k :v | strm nextPut: k]].
			cls == aClass]
			whileFalse: [cls := cls superclass]]
! !

!Species methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
selectorsUpTo: aClass satisfying: aBlock
	| cls set |
	set := IdentitySet new: 100.
	cls := self.
	[
		cls notNil ifTrue: [
			cls methodDictionary
				keysAndValuesDo: [:k :v | (aBlock value: k) ifTrue: [set add: k]]].
		cls == aClass]
		whileFalse: [cls := cls superclass].
	^set
! !

!Species methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitAllSelectors
	| answer |
	answer := self superclass == Object
		ifTrue: [self selectors]
		ifFalse: [self superclass sunitAllSelectors addAll: self selectors; yourself].
	^answer asOrderedCollection
! !

!Species methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitSelectors
	^self selectors asOrderedCollection sort
! !


