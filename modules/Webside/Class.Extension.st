'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!


!Class methodsFor:  '*webside' stamp: 'KenD 28/Jun/2026 13:32:24'!
fileOutOn: aStream
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
! !


