"
	Copyright (c) 2025, Quorum Software.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : #'*webside' }
Object >> groupBy: aspect [
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

]

