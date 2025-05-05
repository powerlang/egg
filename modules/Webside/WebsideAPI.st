"
	Copyright (c) 2025, Javier Pimás, Guillermo Amaral.
	See (MIT) license in root directory.
"

Class {
	#name : #WebsideAPI, 
	#superclass : #Object, 
	#instVars : [
		'request',
		'response'
	],
	#category : #Webside
}

{#category : #routes}
WebsideAPI class >> addChangesRoutesTo: aWebApplication [
	aWebApplication
		routeGET: '/changes' to: #changes;
		routePOST: '/changes/update' to: #updateChanges;
		routePOST: '/changes/compress' to: #compressChanges;
		routePOST: '/changes' to: #addChange;
		routePOST: '/changesets/download'
		to: #downloadChangeset;
		routePOST: '/changesets/upload'
		to: #uploadChangeset;
		routePOST: '/classes/{name}/methods'
		to: #compileMethod;
		routeDELETE: '/classes/{name}/methods/{selector}'
		to: #removeMethod;
		routePOST: '/classes' to: #defineClass;
		routeDELETE: '/classes/{name}' to: #removeClass;
		routePOST: '/packages' to: #addPackage;
		routeDELETE: '/packages/{name}' to: #removePackage
]

{#category : #routes}
WebsideAPI class >> addCodeRoutesTo: aWebApplication [
	aWebApplication
		routeGET: '/packages' to: #packages;
		routeGET: '/packages/{name}' to: #package;
		routeGET: '/packages/{name}/classes'
		to: #packageClasses;
		routeGET: '/packages/{name}/methods'
		to: #packageMethods;
		routeGET: '/packages/{name}/unsent-methods'
		to: #unsentMethods;
		routeGET: '/packages/{name}/unimplemented-messages'
		to: #unimplementedMessages;
		routeGET: '/classes' to: #classes;
		routeGET: '/classes/{name}' to: #classDefinition;
		routeGET: '/classes/{name}/superclasses'
		to: #superclasses;
		routeGET: '/classes/{name}/subclasses'
		to: #subclasses;
		routeGET: '/classes/{name}/variables'
		to: #variables;
		routeGET: '/classes/{name}/instance-variables'
		to: #instanceVariables;
		routeGET: '/classes/{name}/class-variables'
		to: #classVariables;
		routeGET: '/classes/{name}/categories'
		to: #categories;
		routeGET: '/usual-categories' to: #usualCategories;
		routeGET: '/classes/{name}/used-categories'
		to: #usedCategories;
		routeGET: '/classes/{name}/selectors'
		to: #selectors;
		routeGET: '/classes/{name}/methods' to: #methods;
		routeGET: '/classes/{name}/methods/{selector}'
		to: #method;
		routeGET: '/methods' to: #methods;
		routePOST: '/autocompletions' to: #autocompletions;
		routeGET: '/search' to: #search;
		routeGET: '/classes/{name}/methods/{selector}/history'
		to: #methodHistory;
		routeGET: '/classes/{name}/methods/{selector}/versions'
		to: #methodVersions;
		routeGET: '/classtemplate' to: #classTemplate;
		routeGET: '/methodtemplate' to: #methodTemplate;
		routePOST: '/selectors' to: #selectorInSource
]

{#category : #routes}
WebsideAPI class >> addGeneralRoutesTo: aWebApplication [
	aWebApplication
		routeGET: '/dialect' to: #dialect;
		routeGET: '/logo' to: #logo;
		routeGET: '/colors' to: #colors
]



{#category : #services}
WebsideAPI class >> addRoutesTo: aWebApplication [
	self
		addGeneralRoutesTo: aWebApplication;
		addCodeRoutesTo: aWebApplication;
		addChangesRoutesTo: aWebApplication
]

{ #category : #spec }
WebsideAPI >> annotationsForMethod: method [
	^OrderedCollection new
]

{ #category : #spec }
WebsideAPI >> categories [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class categories
]

{ #category : #spec }
WebsideAPI >> classDefinition [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class asWebsideJson
]

{ #category : #spec }
WebsideAPI >> classes [
	| root tree classes names depth json |
	root := self queryAt: 'root'.
	root := root notNil
		ifTrue: [self classNamed: root]
		ifFalse: [self defaultRootClass].
	root ifNil: [^self notFound].
	tree := self queryAt: 'tree'.
	tree = 'true' ifTrue: [
		depth := self queryAt: 'depth' ifPresent: [:d | d asInteger].
		json := self classTreeFrom: root depth: depth.
		^Array with: json].
	classes := root withAllSubclasses.
	names := self queryAt: 'names'.
	names = 'true' ifTrue: [^(classes collect: [:c | c name]) sort].
	^classes collect: [:c | c asWebsideJson]
]

{ #category : #spec }
WebsideAPI >> classNamed: aString [
	| name metaclass class |
	name := aString.
	metaclass := name endsWith: ' class'.
	metaclass ifTrue: [name := name trimTail: ' class'].
	class := Kernel namespace at: name asSymbol ifAbsent: [^nil].
	class isSpecies ifFalse: [^nil].
	^metaclass ifTrue: [class class] ifFalse: [class]
]

{ #category : #spec }
WebsideAPI >> classTreeFrom: aClass depth: anInteger [
	| json subclasses depth names |
	names := self queryAt: 'names'.
	json := names = 'true'
		ifTrue: [
			self newJsonObject
				at: 'name' put: aClass name;
				at: 'superclass'
				put: (aClass superclass ifNotNil: [:c | c name]);
				yourself]
		ifFalse: [aClass asWebsideJson].
	(anInteger notNil and: [anInteger = 0]) ifTrue: [^json].
	depth := anInteger notNil ifTrue: [anInteger - 1].
	subclasses := (aClass subclasses sortBy: #name)
		collect: [:c | self classTreeFrom: c depth: depth].
	json at: 'subclasses' put: subclasses.
	^json
]

{ #category : #spec }
WebsideAPI >> classVariables [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class withAllSuperclasses gather: [:c |
		c classVarNames asArray sort collect: [:v |
			self newJsonObject
				at: 'name' put: v;
				at: 'class' put: c name , ' class';
				at: 'type' put: 'class';
				yourself]]
]

{ #category : #spec }
WebsideAPI >> colors [
	^JsonObject new
		at: 'primary' put: '#81C784';
		at: 'secondary' put: '#2E7D32';
		yourself
]

{ #category : #spec }
WebsideAPI >> defaultRootClass [
	^ProtoObject
]

{ #category : #spec }
WebsideAPI >> dialect [
	^'Egg'
]

{ #category : #spec }
WebsideAPI >> instanceVariables [
	| class |
	class := self requestedClass.
	class isNil ifTrue: [^self notFound].
	^class withAllSuperclasses
		gather: [:c | 
			c instVarNames collect: [:n | 
				self newJsonObject
					at: 'name' put: n;
					at: 'class' put: c name;
					at: 'type' put: 'instance';
					yourself]]
		in: OrderedCollection new
]

{ #category : #spec }
WebsideAPI >> jsonFromMethods: aCollection [
	| bytecodes disassembly ast annotations overriding overriden |
	(self queryAt: 'basic') = 'true' ifTrue: [
		^aCollection collect: [:m | 
			self newJsonObject
				at: 'selector' put: m selector;
				at: 'methodClass' put: m classBinding name;
				at: 'category' put: m category;
				at: 'package' put: m module name;
				at: 'source' put: m sourceCode;
				yourself]].
	bytecodes := (self queryAt: 'bytecodes') = 'true'.
	disassembly := (self queryAt: 'disassembly') = 'true'.
	ast := (self queryAt: 'ast') = 'true'.
	annotations := (self queryAt: 'annotations') = 'true'.
	overriding := self methodsRedefiningFrom: aCollection.
	overriden := self methodsRedefinedFrom: aCollection.
	^aCollection collect: [:m | | json bcs |
		json := m asWebsideJson.
		json
			at: 'overriding' put: (overriding includes: m);
			at: 'overriden' put: (overriden includes: m).
		bytecodes ifTrue: [
			bcs := [m treecodeString asString] on: Error do: [''].
			json at: 'bytecodes' put: bcs].
		
		ast ifTrue: [json at: 'ast' put: m ast asWebsideJson].
		annotations
			ifTrue: [json at: 'annotations' put: (self annotationsForMethod: m)].
		json]
]

{ #category : #spec }
WebsideAPI >> logo [
	^(Kernel host readFile: 'logo.png') asByteArray asBase64 -> 'image/png'
]

{#category : #'code endpoints'}
WebsideAPI >> method [
	| method json |
	method := self requestedMethod.
	method ifNil: [^self notFound].
	json := self jsonFromMethods: (Array with: method).
	^json anyone
]

{ #category : #spec }
WebsideAPI >> methods [
	| search methods |
	search := self methodSearch.
	search ifNil: [^#()].
	methods := search search collect: #contents.
	(self queryAt: 'count') = 'true' ifTrue: [^methods size].
	^self jsonFromMethods: methods
]

{ #category : #spec }
WebsideAPI >> methodSearch [
	| scope search class |
	scope := self methodSearchScope.
	scope ifNil: [^nil].
	search := MethodSearch new.
	search scope: scope.
	self
		queryAt: 'selector'
		ifPresent: [:s | search := search withSelector: s asSymbol];
		queryAt: 'selectorMatching'
		ifPresent: [:s | search := search withSelectorMatching: s asSymbol].
	self
		queryAt: 'sending'
		ifPresent: [:s | search := search sending: s asSymbol].
	self queryAt: 'referencingClass' ifPresent: [:n | 
		class := self classNamed: n.
		class ifNil: [^nil].
		search := search referencingClass: class].
	self
		queryAt: 'referencingString'
		ifPresent: [:s | search := search referencingString: s].
	self queryAt: 'class' ifPresent: [:n | 
		class := self classNamed: n.
		class ifNil: [^nil].
		search := search inClass: class; includeClassSide: false].
	self
		queryAt: 'category'
		ifPresent: [:c | search := search underCategory: c asSymbol].
	self
		queryAt: 'accessing'
		ifPresent: [:v | search := search referencingVariable: v].
	self queryAt: 'using' ifPresent: [:v | search := search usingVariable: v].
	self
		queryAt: 'assigning'
		ifPresent: [:v | search := search assigningVariable: v].
	^search
]

{ #category : #spec }
WebsideAPI >> methodsRedefinedFrom: aCollection [
	"
	[WebsideAPI new methodsRedefinedFrom: Object methodDictionary values asArray] timeToRun
	"
	| redefined grouped |
	redefined := OrderedCollection new.
	grouped := aCollection groupBy: #classBinding.
	grouped keysAndValuesDo: [:class :methods | 
		class allSubclassesDo: [:subclass | 
			methods removeAllSuchThat: [:m | | found |
				found := subclass includesSelector: m selector.
				found ifTrue: [redefined add: m].
				found]]].
	^redefined
]

{ #category : #spec }
WebsideAPI >> methodsRedefiningFrom: aCollection [
	"
	WebsideAPI new methodsRedefiningFrom: Object methodDictionary values asArray
	"
	| redefining grouped |
	redefining := OrderedCollection new.
	grouped := aCollection groupBy: #classBinding.
	grouped keysAndValuesDo: [:class :methods |
		class allSuperclassesDo: [:subclass |
			methods copy
				select: [:m | subclass includesSelector: m selector]
				thenDo: [:m |
					redefining add: m.
					methods remove: m]]].
	^redefining
]

{ #category : #spec }
WebsideAPI >> methodSearchScope [
	| name class |
	name := (self urlAt: 'name') ifNil: [self queryAt: 'class'].
	name ifNotNil: [
		class := self classNamed: name.
		^class
			ifNotNil: [(MethodSearchScope class: class) includeClassSide: false]
			ifNil: nil].
	self queryAt: 'hierarchy' ifPresent: [:h |
		class := self classNamed: h.
		^class ifNotNil: [MethodSearchScope hierarchy: class] ifNil: nil].
	self queryAt: 'package' ifPresent: [:n | | project |
		project := self packageNamed: n.
		^project ifNotNil: [MethodSearchScope project: project] ifNil: nil].
	^MethodSearchScope new
]

{ #category : #spec }
WebsideAPI >> newJsonObject [
	^JsonObject new
]

{ #category : #spec }
WebsideAPI >> notFound [
	response notFound.
	^nil
]

{ #category : #spec }
WebsideAPI >> queryAt: aString [
	^self queryAt: aString ifAbsent: nil
]

{ #category : #spec }
WebsideAPI >> queryAt: aString ifAbsent: aBlock [
	^self queryAt: aString ifPresent: nil ifAbsent: aBlock
]

{ #category : #spec }
WebsideAPI >> queryAt: aString ifPresent: aBlock [
	^self queryAt: aString ifPresent: aBlock ifAbsent: nil
]

{ #category : #spec }
WebsideAPI >> queryAt: aString ifPresent: aBlock ifAbsent: anotherBlock [
	| value |
	value := request queryAt: aString.
	(value isNil or: [value isEmpty]) ifTrue: [^anotherBlock value].
	^aBlock notNil ifTrue: [aBlock evaluateWith: value] ifFalse: [value]]

{ #category : #spec }
WebsideAPI >> request: aRequest [
	request := aRequest
]

{ #category : #spec }
WebsideAPI >> requestedClass [
	| name |
	name := self urlAt: 'name'.
	^name ifNotNil: [self classNamed: name]
]

{#category : #private}
WebsideAPI >> requestedMethod [
	| class selector json |
	class := self requestedClass.
	class ifNil: [^nil].
	selector := self requestedSelector.
	selector ifNil: [^nil].
	^class >> selector
]

{#category : #private}
WebsideAPI >> requestedSelector [
	| selector |
	selector := self urlAt: 'selector'.
	^selector ifNotNil: [selector asSymbol]
]

{ #category : #spec }
WebsideAPI >> response: aResponse [
	response := aResponse
]

{ #category : #spec }
WebsideAPI >> search [
	| text ignoreCase position type results |
	text := self queryAt: 'text' ifAbsent: [^self badRequest: 'missing text'].
	ignoreCase := (self queryAt: 'ignoreCase') = 'true'.
	position := (self queryAt: 'condition' ifAbsent: [#beginning]) asSymbol.
	type := self queryAt: 'type' ifAbsent: 'all'.
	results := CodeSearch
		search: text
		in: type
		ignoreCase: ignoreCase
		conditionType: position.
	^results collect: #asWebsideJson
]

{ #category : #spec }
WebsideAPI >> subclasses [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class subclasses collect: [:c | c asWebsideJson]
]

{ #category : #spec }
WebsideAPI >> superclasses [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class allSuperclasses collect: [:c | c asWebsideJson]
]

{ #category : #spec }
WebsideAPI >> urlAt: aString [
	^request paramAt: aString
]

{ #category : #spec }
WebsideAPI >> usedCategories [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^self instanceVariables , self classVariables
]

{ #category : #spec }
WebsideAPI >> usualCategories [
	| meta |
	meta := self queryAt: 'meta'.
	^meta = 'true'
		ifTrue: [#(#'instance creation'  #accessing  #validation  #initialization  #testing  #'gui support'  #constants  #private  #defaults  #events  #services  #examples)]
		ifFalse: [#(#accessing #actions #construction #'event handlers' #initialization #inquiries #printing #private #services #testing #updating #validation)]
]

{#category : #'code endpoints'}
WebsideAPI >> variables [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^self instanceVariables , self classVariables
]
