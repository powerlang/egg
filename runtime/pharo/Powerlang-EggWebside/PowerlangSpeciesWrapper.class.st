Class {
	#name : #PowerlangSpeciesWrapper,
	#superclass : #PowerlangObjectWrapper,
	#category : #'Powerlang-EggWebside-Base'
}

{ #category : #inquiries }
PowerlangSpeciesWrapper >> >> aSymbol [
	
	| symbol |
	symbol := runtime symbolFromLocal: aSymbol.
	^ PowerlangMethodWrapper
		  on: (super >> symbol) wrappee
		  runtime: runtime
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> allInstVarNames [

	^ super allInstVarNames asArray wrappee slots collect: [ :s | 
		  s asLocalString ]
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> allSubclasses [
	^ super allSubclasses asArray wrappee slots
		collect: [ :c | PowerlangSpeciesWrapper on: c runtime: runtime ]
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> allSuperclasses [
	^ super allSuperclasses asArray wrappee slots
		collect: [ :c | PowerlangSpeciesWrapper on: c runtime: runtime ]
]

{ #category : #converting }
PowerlangSpeciesWrapper >> asWebsideJson [

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

{ #category : #inquiries }
PowerlangSpeciesWrapper >> categories [
	^ super categories asArray wrappee slots
		collect: [ :c | c asLocalString  ]
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> classVarNames [
	^ super classVarNames asArray wrappee slots
		collect: [ :s | s asLocalString ]
]

{ #category : #private }
PowerlangSpeciesWrapper >> classVariablesString [
	^ String
		streamContents: [ :s | 
			self classVarNames
				do: [ :n | s nextPutAll: n ]
				separatedBy: [ s space ] ]
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> comment [
	^ super comment wrappee asLocalString
]

{ #category : #services }
PowerlangSpeciesWrapper >> compile: aString [

	| local size kernel name class method astcodes selector format code md |
	local := SCompiler new compile: aString.
	size := runtime newInteger: local size.
	kernel := runtime sendLocal: #namespace to: runtime kernel.
	name := runtime symbolFromLocal: #CompiledMethod.
	class := runtime sendLocal: #at: to: kernel with: { name }.
	method := runtime sendLocal: #new: to: class with: { size }.
	astcodes := runtime newByteArray: local astcodes.
	selector := runtime addSymbol: local selector.
	format := runtime newInteger: local format.
	code := runtime newString: local source.
	runtime
		sendLocal: #astcodes: to: method with: { astcodes };
		sendLocal: #classBinding: to: method with: { wrappee };
		sendLocal: #selector: to: method with: { selector };
		sendLocal: #format: to: method with: { format };
		sendLocal: #sourceObject: to: method with: { code }.
	local withIndexDo: [ :literal :i | 
		| tliteral |
		tliteral := runtime bootstrapper transferLiteral: literal.
		method at: i put: tliteral ].
	md := runtime sendLocal: #methodDictionary to: wrappee.
	runtime sendLocal: #at:put: to: md with: { 
			selector.
			method }.
	^ method
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> definition [

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

{ #category : #testing }
PowerlangSpeciesWrapper >> includesSelector: aSymbol [
	| symbol |
	symbol := runtime addSymbol: aSymbol.
	^(super includesSelector: symbol) asLocalObject
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> instVarNames [
	^ super instVarNames asArray wrappee slots
		collect: [ :s |  s asLocalString]
]

{ #category : #private }
PowerlangSpeciesWrapper >> instanceVariablesString [
	^ String
		streamContents: [ :s | 
			self instVarNames
				do: [ :n | s nextPutAll: n  ]
				separatedBy: [ s space ] ]
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> metaclass [
	^self class on: (runtime sendLocal: #class to: wrappee) runtime: runtime 
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> methods [
	| md |
	md := self methodDictionary.
	^ md keys asSet asArray wrappee slots
		collect:
			[ :k | PowerlangMethodWrapper on: (md at: k) wrappee runtime: runtime ]
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> name [
	^super name wrappee asLocalString
]

{ #category : #services }
PowerlangSpeciesWrapper >> removeSelector: aSymbol [

	| symbol |
	symbol := runtime symbolFromLocal: aSymbol.
	super removeSelector: symbol
]

{ #category : #private }
PowerlangSpeciesWrapper >> sharedPoolsString [

	^ ''
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> subclasses [
	^ super subclasses asArray wrappee slots
		collect: [ :c | PowerlangSpeciesWrapper on: c runtime: runtime ]
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> withAllSubclasses [
	^ OrderedCollection with: self withAll: self allSubclasses
]

{ #category : #inquiries }
PowerlangSpeciesWrapper >> withAllSuperclasses [
	^ OrderedCollection with:
		self withAll: self allSuperclasses
]
