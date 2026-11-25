'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #CodeSearchResult category: #Development!
Object subclass: #CodeSearchResult
	instanceVariableNames: 'type contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!CodeSearchResult commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!CodeSearchResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
contents
	^contents
! !

!CodeSearchResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
contents: anObject
	contents := anObject
! !

!CodeSearchResult methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	aStream
		print: type;
		nextPut: $:;
		space;
		print: contents
! !

!CodeSearchResult methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:32:24'!
text
	^contents asString
! !

!CodeSearchResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
type
	^type
! !

!CodeSearchResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
type: aSymbol
	type := aSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CodeSearchResult class' category: #Development!
CodeSearchResult class
	instanceVariableNames: ''!

!CodeSearchResult class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
class: aClass
	^self new type: #class; contents: aClass
! !

!CodeSearchResult class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
method: aCompiledMethod
	^self new type: #method; contents: aCompiledMethod
! !

!CodeSearchResult class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
pool: aString
	^self new type: #pool; contents: aString
! !

!CodeSearchResult class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
project: aBeeProject
	^self new type: #project; contents: aBeeProject
! !

!CodeSearchResult class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
selector: aSymbol
	^self new type: #selector; contents: aSymbol
! !


