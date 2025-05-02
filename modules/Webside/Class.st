"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Class }

{ #category : #'*webside' }
Class >> fileOutOn: aStream [
	| symbol |
	symbol := '#', self symbol printString.
	aStream
		nextPutAll: self superclass printString;
		cr;
		tab;
		nextPutAll: self kindOfSubclass;
		space;
		nextPutAll: symbol;
		cr;
		tab.
	self isBytes ifFalse: [
		aStream
			nextPutAll: 'instanceVariableNames: ';
			nextPutAll: self instanceVariableString storeString;
			cr;
			tab].
	aStream
		nextPutAll: 'classVariableNames: ';
		nextPutAll: self classVariableString storeString
]

