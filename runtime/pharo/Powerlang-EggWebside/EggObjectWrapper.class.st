Class {
	#name : 'EggObjectWrapper',
	#superclass : 'ProtoObject',
	#instVars : [
		'wrappee',
		'runtime'
	],
	#category : 'Powerlang-EggWebside-Base',
	#package : 'Powerlang-EggWebside',
	#tag : 'Base'
}

{ #category : 'instance creation' }
EggObjectWrapper class >> on: anLMRObject runtime: aPowerlangLMR [ 
^self new wrappee: anLMRObject ; runtime: aPowerlangLMR 
]

{ #category : 'comparing' }
EggObjectWrapper >> = anObject [

	| object  |
	object := (anObject isKindOf: EggObjectWrapper)
		          ifTrue: [ anObject wrappee ]
		          ifFalse: [ anObject ].
	^ wrappee = object
]

{ #category : 'converting' }
EggObjectWrapper >> asLocalObject [
	wrappee == runtime nil ifTrue: [ ^nil ].
	wrappee == runtime true ifTrue: [ ^true ].
	wrappee == runtime false ifTrue: [ ^false ].
	wrappee class == EggSmallInteger ifTrue: [ ^wrappee value ].
	wrappee class == EggByteObject ifTrue: [ ^wrappee asLocalString ].
	self error: 'Cannot determine local equivalent of ', wrappee printString.
	^nil
]

{ #category : 'converting' }
EggObjectWrapper >> asWebsideJson [

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

{ #category : 'comparing' }
EggObjectWrapper >> collect: aBlock [

	^ wrappee slots collect: [ :slot |aBlock value: slot ]
]

{ #category : 'printing' }
EggObjectWrapper >> displayString [

	^ self printString
]

{ #category : 'accessing' }
EggObjectWrapper >> doesNotUnderstand: aMessage [
	| arguments result class |
	arguments := aMessage arguments collect: [ :a | (a class == EggObjectWrapper or: [ a class inheritsFrom: EggObjectWrapper]) ifTrue: [a wrappee] ifFalse: [ a ]].
	result := runtime
		sendLocal: aMessage selector
		to: wrappee
		with: arguments.
	(result isKindOf: EggObject)
		ifFalse: [ ^ result ].
	class := (runtime sendLocal: #isSpecies to: result) = runtime true
		ifTrue: [ EggSpeciesWrapper ]
		ifFalse: [ EggObjectWrapper ].
	^ class on: result runtime: runtime
]

{ #category : 'comparing' }
EggObjectWrapper >> hash [
	^wrappee hash
]

{ #category : 'inspecting' }
EggObjectWrapper >> inspect [

	^ wrappee inspect
]

{ #category : 'testing' }
EggObjectWrapper >> isKindOf: aClass [

	^ self class == aClass or: [ self class inheritsFrom: aClass ]
]

{ #category : 'testing' }
EggObjectWrapper >> notNil [
	^(runtime sendLocal: #notNil to: wrappee) != runtime nil
]

{ #category : 'inquiries' }
EggObjectWrapper >> object [
	^wrappee
]

{ #category : 'inquiries' }
EggObjectWrapper >> objectClass [
	| class |
	class := runtime sendLocal: #class to: wrappee.
	^ EggSpeciesWrapper on: class runtime: runtime
]

{ #category : 'printing' }
EggObjectWrapper >> printOn: aStream [
	"aStream
		nextPutAll: (runtime sendLocal: #printString to: wrappee) wrappee asLocalString"
		wrappee printOn: aStream
]

{ #category : 'printing' }
EggObjectWrapper >> printString [
	^ String streamContents: [ :strm | self printOn: strm ]
]

{ #category : 'testing' }
EggObjectWrapper >> respondsTo: aSymbol [

	^ self class canUnderstand: aSymbol
]

{ #category : 'accessing' }
EggObjectWrapper >> runtime: aPowerlangLMR [
	runtime := aPowerlangLMR
]

{ #category : 'testing' }
EggObjectWrapper >> slotAt: index [
	^self class on: (wrappee slotAt: index) runtime: runtime 
]

{ #category : 'printing' }
EggObjectWrapper >> stDisplayString [

	^ self printString
]

{ #category : 'accessing' }
EggObjectWrapper >> wrappee [
	^wrappee 
]

{ #category : 'accessing' }
EggObjectWrapper >> wrappee: anLMRObject [
	wrappee := anLMRObject
]
