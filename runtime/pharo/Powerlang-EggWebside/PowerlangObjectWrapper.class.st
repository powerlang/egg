Class {
	#name : #PowerlangObjectWrapper,
	#superclass : #ProtoObject,
	#instVars : [
		'wrappee',
		'runtime'
	],
	#category : #'Powerlang-EggWebside-Base'
}

{ #category : #'instance creation' }
PowerlangObjectWrapper class >> on: anLMRObject runtime: aPowerlangLMR [ 
^self new wrappee: anLMRObject ; runtime: aPowerlangLMR 
]

{ #category : #comparing }
PowerlangObjectWrapper >> = anObject [

	| object  |
	object := (anObject isKindOf: PowerlangObjectWrapper)
		          ifTrue: [ anObject wrappee ]
		          ifFalse: [ anObject ].
	^ wrappee = object
]

{ #category : #converting }
PowerlangObjectWrapper >> asLocalObject [
	wrappee == runtime nil ifTrue: [ ^nil ].
	wrappee == runtime true ifTrue: [ ^true ].
	wrappee == runtime false ifTrue: [ ^false ].
	wrappee class == LMRSmallInteger ifTrue: [ ^wrappee value ].
	wrappee class == LMRByteObject ifTrue: [ ^wrappee asLocalString ].
	self error: 'Cannot determine local equivalent of ', wrappee printString.
	^nil
]

{ #category : #converting }
PowerlangObjectWrapper >> asWebsideJson [

	| variable printed |
	variable := self objectClass isVariable wrappee = runtime true.
	printed := runtime sendLocal: #printString to: wrappee.
	^ NeoJSONObject new
		  at: 'class' put: self objectClass name;
		  at: 'indexable' put: variable;
		  at: 'size' put: (variable
				   ifTrue: [ self size wrappee value ]
				   ifFalse: [ 0 ]);
		  at: 'printString' put: printed asLocalString;
		  yourself
]

{ #category : #printing }
PowerlangObjectWrapper >> displayString [

	^ self printString
]

{ #category : #accessing }
PowerlangObjectWrapper >> doesNotUnderstand: aMessage [
	| arguments result class |
	arguments := aMessage arguments collect: [ :a | (a class == PowerlangObjectWrapper or: [ a class inheritsFrom: PowerlangObjectWrapper]) ifTrue: [a wrappee] ifFalse: [ a ]].
	result := runtime
		sendLocal: aMessage selector
		to: wrappee
		with: arguments.
	(result isKindOf: LMRObject)
		ifFalse: [ ^ result ].
	class := (runtime sendLocal: #isSpecies to: result) = runtime true
		ifTrue: [ PowerlangSpeciesWrapper ]
		ifFalse: [ PowerlangObjectWrapper ].
	^ class on: result runtime: runtime
]

{ #category : #comparing }
PowerlangObjectWrapper >> hash [
	^wrappee hash
]

{ #category : #inspecting }
PowerlangObjectWrapper >> inspect [

	^ wrappee inspect
]

{ #category : #testing }
PowerlangObjectWrapper >> isKindOf: aClass [

	^ self class == aClass or: [ self class inheritsFrom: aClass ]
]

{ #category : #testing }
PowerlangObjectWrapper >> notNil [
	^(runtime sendLocal: #notNil to: wrappee) != runtime nil
]

{ #category : #inquiries }
PowerlangObjectWrapper >> object [
	^wrappee
]

{ #category : #inquiries }
PowerlangObjectWrapper >> objectClass [
	| class |
	class := runtime sendLocal: #class to: wrappee.
	^ PowerlangSpeciesWrapper on: class runtime: runtime
]

{ #category : #printing }
PowerlangObjectWrapper >> printOn: aStream [
	"aStream
		nextPutAll: (runtime sendLocal: #printString to: wrappee) wrappee asLocalString"
		wrappee printOn: aStream
]

{ #category : #printing }
PowerlangObjectWrapper >> printString [
	^ String streamContents: [ :strm | self printOn: strm ]
]

{ #category : #testing }
PowerlangObjectWrapper >> respondsTo: aSymbol [

	^ self class canUnderstand: aSymbol
]

{ #category : #accessing }
PowerlangObjectWrapper >> runtime: aPowerlangLMR [
	runtime := aPowerlangLMR
]

{ #category : #testing }
PowerlangObjectWrapper >> slotAt: index [
	^self class on: (wrappee slotAt: index) runtime: runtime 
]

{ #category : #printing }
PowerlangObjectWrapper >> stDisplayString [

	^ self printString
]

{ #category : #accessing }
PowerlangObjectWrapper >> wrappee [
	^wrappee 
]

{ #category : #accessing }
PowerlangObjectWrapper >> wrappee: anLMRObject [
	wrappee := anLMRObject
]
