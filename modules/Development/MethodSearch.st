"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodSearch, 
	#superclass : #CodeSearch, 
	#instVars : [
		'scope', 
		'next'
	], 
	#category : #Development
}

{#category : #'instance creation'}
MethodSearch class >> assigningVariable: aString [
	^VariableAccessSearch new type: #assign; text: aString
]

{#category : #'instance creation'}
MethodSearch class >> referencingClass: aClass [
	^ClassReferenceSearch new text: aClass name
]

{#category : #'instance creation'}
MethodSearch class >> referencingString: aString [
	^StringReferenceSearch new text: aString
]

{#category : #'instance creation'}
MethodSearch class >> referencingVariable: aString [
	^VariableAccessSearch new type: #reference; text: aString
]

{#category : #'instance creation'}
MethodSearch class >> sending: aSymbol [
	^SenderSearch new text: aSymbol
]

{#category : #'instance creation'}
MethodSearch class >> underCategory: aString [
	^CategorySearch new text: aString
]

{#category : #'instance creation'}
MethodSearch class >> usingVariable: aString [
	^VariableAccessSearch new type: #use; text: aString
]

{#category : #'instance creation'}
MethodSearch class >> withSelector: aSymbol [
	^ImplementorSearch new text: aSymbol
]

{#category : #'instance creation'}
MethodSearch class >> withSelectorMatching: aString [
	^ImplementorSearch new pattern: aString
]

{#category : #combining}
MethodSearch >> & aMethodSearch [
	self class == MethodSearch ifTrue: [
		scope isDefault ifFalse: [aMethodSearch scope: scope].
		^aMethodSearch].
	next notNil ifTrue: [next & aMethodSearch] ifFalse: [next := aMethodSearch]
]

{#category : #private}
MethodSearch >> addResult: aCompiledMethod [
	| m |
	m := next notNil
		ifTrue: [aCompiledMethod]
		ifFalse: [CodeSearchResult method: aCompiledMethod].
	results add: m
]

{#category : #scope}
MethodSearch >> amongMethods: aCollection [
	scope := aCollection
]

{#category : #combining}
MethodSearch >> assigningVariable: aString [
	^self & (self class assigningVariable: aString)
]

{#category : #private}
MethodSearch >> defaultScope [
	^MethodSearchScope default
]

{#category : #private}
MethodSearch >> doSearch [
	scope methods do: [:m | self addResult: m]
]

{#category : #scope}
MethodSearch >> inClass: class [
	scope := MethodSearchScope class: class
]

{#category : #scope}
MethodSearch >> includeClassSide: aBoolean [
	scope includeClassSide: aBoolean
]

{#category : #initialization}
MethodSearch >> initialize [
	super initialize.
	scope := self defaultScope
]

{#category : #scope}
MethodSearch >> inProject: project [
	scope := MethodSearchScope project: project
]

{#category : #combining}
MethodSearch >> referencingClass: aClass [
	^self & (self class referencingClass: aClass)
]

{#category : #combining}
MethodSearch >> referencingString: aString [
	^self & (self class referencingString: aString)
]

{#category : #combining}
MethodSearch >> referencingVariable: aString [
	^self & (self class referencingVariable: aString)
]

{#category : #initialization}
MethodSearch >> scope [
	^scope
]

{#category : #scope}
MethodSearch >> scope: aMethodSearchScope [
	scope := aMethodSearchScope
]

{#category : #services}
MethodSearch >> search [
	self reset; doSearch.
	^next notNil
		ifTrue: [next amongMethods: results; search]
		ifFalse: [results]
]

{#category : #private}
MethodSearch >> searchEvaluating: aBlock [
	scope do: [:m | (aBlock value: m) ifTrue: [self addResult: m]].
	^results
]

{#category : #combining}
MethodSearch >> sending: aSymbol [
	^self & (self class sending: aSymbol)
]

{#category : #combining}
MethodSearch >> underCategory: aString [
	^self & (self class underCategory: aString)
]

{#category : #combining}
MethodSearch >> usingVariable: aString [
	^self & (self class usingVariable: aString)
]

{#category : #combining}
MethodSearch >> withSelector: aSymbol [
	^self & (self class withSelector: aSymbol)
]

{#category : #combining}
MethodSearch >> withSelectorMatching: aString [
	^self & (self class withSelectorMatching: aString)
]

