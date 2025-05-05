"
	Copyright (c) 2025, Javier Pimás.
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
WebsideAPI >> classVariables [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class withAllSuperclasses gather: [:c |
		c classVarNames asaArray sort collect: [:v |
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
WebsideAPI >> logo [
	^(Kernel host readFile: 'logo.png') asByteArray asBase64 -> 'image/png'
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
WebsideAPI >> queryAt: aString ifPresent: aBlock ifAbsent: anotherBlock [
	| value |
	value := request paramAt: aString.
	(value isNil or: [value isEmpty]) ifTrue: [^anotherBlock value].
	^aBlock notNil ifTrue: [aBlock evaluateWith: value] ifFalse: [value]]

{ #category : #spec }
WebsideAPI >> request: aRequest [
	request := aRequest
]

{ #category : #spec }
WebsideAPI >> requestedClass [
	| name |
	name := request paramAt: 'name'.
	^name ifNotNil: [self classNamed: name]
]

{ #category : #spec }
WebsideAPI >> response: aResponse [
	response := aResponse
]

{ #category : #spec }
WebsideAPI >> variables [
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^self instanceVariables , self classVariables
]
