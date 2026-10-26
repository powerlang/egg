'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!


!Metaclass methodsFor:  '*webside' stamp: 'KenD 28/Jun/2026 13:32:24'!
fileOutOn: aStream
	aStream
		nextPutAll: self name;
		nextPutAll: ' instanceVariableNames: ';
		nextPutAll: self instanceVariableString storeString
! !


