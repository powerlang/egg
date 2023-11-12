Class {
	#name : #SymbolTable,
	#superclass : #ExternalStructure,
	#category : #'SqueakNOS-External-Structures'
}

{ #category : #accessing }
SymbolTable class >> fields [
	^#(
		(tabSize 'ulong')
		(strSize 'ulong')
		(address 'ulong')
		(reserved 'ulong')
	   )
	

]

{ #category : #accessing }
SymbolTable >> address [
	"This method was automatically generated"
	^handle unsignedLongAt: 9
]

{ #category : #accessing }
SymbolTable >> address: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
]

{ #category : #accessing }
SymbolTable >> reserved [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #accessing }
SymbolTable >> reserved: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #accessing }
SymbolTable >> strSize [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #accessing }
SymbolTable >> strSize: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]

{ #category : #accessing }
SymbolTable >> tabSize [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
SymbolTable >> tabSize: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
