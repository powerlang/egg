'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #SymbolicReference category: #Kernel!
Object subclass: #SymbolicReference
	instanceVariableNames: 'linker token object'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!SymbolicReference commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!SymbolicReference methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aSymbolicReference
	aSymbolicReference class == self class ifFalse: [^false].
	^linker = aSymbolicReference linker and: [token = aSymbolicReference token]
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
asBehavior
	^self asClass instanceBehavior
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
asCharacter
	^(Integer fromString: token) asCharacter
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
asClass
	| module |
	module := Kernel load: token first.
	^module namespace at: token second
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
asMetaclass
	^self asClass class
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
asMetaclassBehavior
	^self asClass behavior
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
asModule
	^Kernel load: token
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSymbol
	^token asSymbol
! !

!SymbolicReference methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasBeenLinked
	^object notNil or: [token == #nil]
! !

!SymbolicReference methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
link
	^self hasBeenLinked ifTrue: [object] ifFalse: [object := self referredValue].
! !

!SymbolicReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
linker
	^linker
! !

!SymbolicReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
linker: aSymbol
	linker := aSymbol
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
false
	^false
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
nil
	^nil
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
nilToken
	^HashTable nilToken
! !

!SymbolicReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
object
	^object
! !

!SymbolicReference methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		nextPutAll: self type;
		nextPutAll: ' (';
		nextPutAll: token printString;
		nextPut: $)
! !

!SymbolicReference methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
referredValue
	^self perform: linker
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
symbolTable
	^Symbol symbolTable
! !

!SymbolicReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
token
	^token
! !

!SymbolicReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
token: string
	token := string
! !

!SymbolicReference methodsFor:  'linking' stamp: 'KenD 28/Jun/2026 13:27:38'!
true
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SymbolicReference class' category: #Kernel!
SymbolicReference class
	instanceVariableNames: ''!

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
forBehavior: aBehavior
	| species linker |
	species :=  aBehavior classBinding.
	linker := species isMetaclass ifTrue: [#asMetaclassBehavior] ifFalse: [#asBehavior].
	^(self forClass: species instanceClass) linker: linker
! !

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
forClass: aClass
	^self new linker: #asClass; token: {aClass module name. aClass name}
! !

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
forMetaclass: aMetaclass
	^(self forClass: aMetaclass instanceClass) linker: #asMetaclass
! !

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
forCharacter: aCharacter
	^self new linker: #asCharacter; token: aCharacter codePoint asString
! !

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
forModule: aModule
	^self new linker: #asModule; token: aModule name
! !

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
forSymbol: aSymbol
	^self new linker: #asSymbol; token: aSymbol
! !

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
nilToken
	^self new linker: #nilToken
! !

!SymbolicReference class methodsFor:  'knownObjects' stamp: 'KenD 28/Jun/2026 13:27:38'!
symbolTable
	^self new linker: #symbolTable
! !

!SymbolicReference class methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
linker: anObject token: anotherObject
	^self new linker: anObject; token: anotherObject
! !


