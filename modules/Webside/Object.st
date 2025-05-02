"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : #'*webside' }
Object >> asWebsideJson [
	| printed |
	printed := [self printString]
		on: Error
		do: ['Error while printing ' , self class name , ' instance'].
	^JsonObject new
		at: 'class' put: self class name;
		at: 'hasNamedSlots' put: self class instancesHavePointers;
		at: 'hasIndexedSlots' put: self hasIndexedSlots;
		at: 'size'
		put: (self hasIndexedSlots ifTrue: [self size] ifFalse: [0]);
		at: 'printString' put: printed;
		yourself

]

