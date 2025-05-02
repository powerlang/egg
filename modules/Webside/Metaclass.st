"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Metaclass }

{ #category : #'*webside' }
Metaclass >> fileOutOn: aStream [
	aStream
		nextPutAll: self name;
		nextPutAll: ' instanceVariableNames: ';
		nextPutAll: self instanceVariableString storeString
]
