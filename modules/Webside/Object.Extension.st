'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!


!Object methodsFor:  '*webside' stamp: 'KenD 28/Jun/2026 13:32:24'!
groupBy: aspect
	| answer key copy remove |
	answer := Dictionary new.
	(aspect arity = 0 or: [aspect isClosure and: [aspect arity = 1]]) ifTrue: [
		self do: [:each | 
			key := aspect evaluateWith: each.
			(answer at: key ifAbsentPut: [OrderedCollection new]) add: each].
		^answer].
	copy := IdentitySet withAll: self.
	remove := IdentitySet new.
	self do: [:each | 
		copy do: [:e | 
			(aspect evaluateWith: each with: e) ifTrue: [
				remove add: e.
				(answer at: each ifAbsentPut: [OrderedCollection new]) add: e]].
		copy removeAll: remove.
		remove removeAll].
	^answer

! !


