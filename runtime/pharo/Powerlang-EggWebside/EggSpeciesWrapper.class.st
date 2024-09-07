Class {
	#name : 'EggSpeciesWrapper',
	#superclass : 'EggObjectWrapper',
	#category : 'Powerlang-EggWebside-Base',
	#package : 'Powerlang-EggWebside',
	#tag : 'Base'
}

{ #category : 'inquiries' }
EggSpeciesWrapper >> >> aSymbol [
	
	| symbol |
	symbol := runtime symbolFromLocal: aSymbol.
	^ EggMethodWrapper
		  on: (super >> symbol) wrappee
		  runtime: runtime
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> allInstVarNames [

	^ super allInstVarNames collect: [ :s | s asLocalObject ]
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> allSubclasses [
	^ super allSubclasses collect: [ :c | c asSpeciesWrapper ]
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> allSuperclasses [

	^ super allSuperclasses collect: [ :c | c asSpeciesWrapper ]
]

{ #category : 'converting' }
EggSpeciesWrapper >> asWebsideJson [

	^ super asWebsideJson
		  at: 'name' put: self name;
		  at: 'definition' put: self definition;
		  at: 'superclass'
		  put: (self superclass wrappee != runtime nil ifTrue: [ 
					   self superclass name ]);
		  at: 'comment' put: self instanceClass comment;
		  at: 'variable' put: false;
		  at: 'project' put: '';
		  yourself
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> categories [

	^ super categories collect: [ :c | c asLocalObject ]
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> classVarNames [
	^ super classVarNames asArray wrappee slots
		collect: [ :s | s asLocalString ]
]

{ #category : 'private' }
EggSpeciesWrapper >> classVariablesString [
	^ String
		streamContents: [ :s | 
			self classVarNames
				do: [ :n | s nextPutAll: n ]
				separatedBy: [ s space ] ]
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> comment [
	^ super comment wrappee asLocalString
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> definition [

	| highest |
	^ String streamContents: [ :strm | 
		  highest := self superclass wrappee = runtime nil.
		  highest
			  ifTrue: [ strm nextPutAll: 'ProtoObject' ]
			  ifFalse: [ strm nextPutAll: self superclass name ].
		  strm
			  space;
			  nextPutAll: self kindOfSubclass wrappee asLocalString;
			  space;
			  store: self name;
			  cr;
			  tab;
			  nextPutAll: 'instanceVariableNames: ';
			  store: self instanceVariablesString;
			  cr;
			  tab;
			  nextPutAll: 'classVariableNames: ';
			  store: self classVariablesString;
			  cr;
			  tab;
			  nextPutAll: 'poolDictionaries: ';
			  store: self sharedPoolsString;
			  cr;
			  tab;
			  nextPutAll: 'category: ';
			  store: ''.
		  highest ifTrue: [ 
			  strm
				  nextPutAll: '.';
				  cr;
				  nextPutAll: self name;
				  space;
				  nextPutAll: 'superclass: nil' ] ]
]

{ #category : 'testing' }
EggSpeciesWrapper >> includesSelector: aSymbol [
	| symbol |
	symbol := runtime addSymbol: aSymbol.
	^(super includesSelector: symbol) asLocalObject
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> instVarNames [
	^ super instVarNames asArray wrappee slots
		collect: [ :s |  s asLocalString]
]

{ #category : 'services' }
EggSpeciesWrapper >> installMethod: smethod category: categoryName [

	| size kernel name class method treecodes selector format code md organizer category |
	size := runtime newInteger: smethod size.
	kernel := runtime sendLocal: #namespace to: runtime kernel.
	name := runtime symbolFromLocal: #CompiledMethod.
	class := runtime sendLocal: #at: to: kernel with: { name }.
	method := runtime sendLocal: #new: to: class with: { size }.
	treecodes := runtime newByteArray: smethod treecodes.
	selector := runtime addSymbol: smethod selector.
	format := runtime newInteger: smethod format.
	code := runtime newString: smethod source.
	runtime
		sendLocal: #treecodes: to: method with: { treecodes };
		sendLocal: #classBinding: to: method with: { wrappee };
		sendLocal: #selector: to: method with: { selector };
		sendLocal: #format: to: method with: { format };
		sendLocal: #sourceObject: to: method with: { code }.
	smethod withIndexDo: [ :literal :i |
		| tliteral |
		tliteral := runtime bootstrapper transferLiteral: literal.
		method at: i put: tliteral ].
	md := runtime sendLocal: #methodDictionary to: wrappee.
	runtime sendLocal: #at:put: to: md with: {
			selector.
			method }.
	organizer := runtime sendLocal: #organization to: wrappee.
	category := runtime addSymbol: categoryName.
	runtime sendLocal: #classify:under: to: organizer with: {
			selector.
			category }.
	^ method
]

{ #category : 'private' }
EggSpeciesWrapper >> instanceVariablesString [
	^ String
		streamContents: [ :s | 
			self instVarNames
				do: [ :n | s nextPutAll: n  ]
				separatedBy: [ s space ] ]
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> metaclass [
	^self class on: (runtime sendLocal: #class to: wrappee) runtime: runtime 
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> methods [
	| md |
	md := self methodDictionary.
	^ md keys asSet asArray wrappee slots
		collect:
			[ :k | EggMethodWrapper on: (md at: k) wrappee runtime: runtime ]
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> name [
	^super name wrappee asLocalString
]

{ #category : 'services' }
EggSpeciesWrapper >> removeSelector: aSymbol [

	| symbol md |
	symbol := runtime symbolFromLocal: aSymbol.
	md := runtime sendLocal: #methodDictionary to: wrappee.
	runtime sendLocal: #removeKey: to: md with: {	symbol }.

]

{ #category : 'private' }
EggSpeciesWrapper >> sharedPoolsString [

	^ ''
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> subclasses [
	^ super subclasses asArray wrappee slots
		collect: [ :c | EggSpeciesWrapper on: c runtime: runtime ]
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> withAllSubclasses [
	^ OrderedCollection with: self withAll: self allSubclasses
]

{ #category : 'inquiries' }
EggSpeciesWrapper >> withAllSuperclasses [
	^ OrderedCollection with:
		self withAll: self allSuperclasses
]
