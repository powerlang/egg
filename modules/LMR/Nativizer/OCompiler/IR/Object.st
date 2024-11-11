"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*IR' }
Object >> isBinaryConstantOperation [
	^false
]

{ #category : '*IR' }
Object >> isBinaryVariableOperation [
	^false
]

{ #category : '*IR' }
Object >> isTernaryOperation [
	^false
]

{ #category : '*IR' }
Object >> isUnaryOperation [
	^false
]

{ #category : '*IR' }
Object >> primitivePrintString [
	^self printString
]

