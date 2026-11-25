'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #WebsideAPI category: #Webside!
Object subclass: #WebsideAPI
	instanceVariableNames: 'request response'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Webside'!
!WebsideAPI commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Javier Pimás, Guillermo Amaral.
	See (MIT) license in root directory.
!

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
annotationsForMethod: method
	^OrderedCollection new
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
categories
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class categories
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
classDefinition
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class asWebsideJson
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
classes
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
classNamed: aString
	| name metaclass class |
	name := aString.
	metaclass := name endsWith: ' class'.
	metaclass ifTrue: [name := name trimTail: ' class'].
	class := Kernel namespace at: name asSymbol ifAbsent: [^nil].
	class isSpecies ifFalse: [^nil].
	^metaclass ifTrue: [class class] ifFalse: [class]
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
classTreeFrom: aClass depth: anInteger
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
classVariables
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
colors
	^JsonObject new
		at: 'primary' put: '#81C784';
		at: 'secondary' put: '#2E7D32';
		yourself
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultRootClass
	^ProtoObject
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
dialect
	^'Egg'
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
instanceVariables
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
jsonFromMethods: aCollection
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
logo
	^(Kernel host readFile: 'logo.png') asByteArray asBase64 -> 'image/png'
! !

!WebsideAPI methodsFor:  'code endpoints' stamp: 'KenD 28/Jun/2026 13:32:24'!
method
	| method json |
	method := self requestedMethod.
	method ifNil: [^self notFound].
	json := self jsonFromMethods: (Array with: method).
	^json anyone
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
methods
	| search methods |
	search := self methodSearch.
	search ifNil: [^#()].
	methods := search search collect: #contents.
	(self queryAt: 'count') = 'true' ifTrue: [^methods size].
	^self jsonFromMethods: methods
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
methodSearch
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
methodsRedefinedFrom: aCollection
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
methodsRedefiningFrom: aCollection
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
methodSearchScope
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
newJsonObject
	^JsonObject new
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
notFound
	response notFound.
	^nil
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
queryAt: aString
	^self queryAt: aString ifAbsent: nil
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
queryAt: aString ifAbsent: aBlock
	^self queryAt: aString ifPresent: nil ifAbsent: aBlock
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
queryAt: aString ifPresent: aBlock
	^self queryAt: aString ifPresent: aBlock ifAbsent: nil
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
queryAt: aString ifPresent: aBlock ifAbsent: anotherBlock
	| value |
	value := request queryAt: aString.
	(value isNil or: [value isEmpty]) ifTrue: [^anotherBlock value].
	^aBlock notNil ifTrue: [aBlock evaluateWith: value] ifFalse: [value]! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
request: aRequest
	request := aRequest
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
requestedClass
	| name |
	name := self urlAt: 'name'.
	^name ifNotNil: [self classNamed: name]
! !

!WebsideAPI methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
requestedMethod
	| class selector json |
	class := self requestedClass.
	class ifNil: [^nil].
	selector := self requestedSelector.
	selector ifNil: [^nil].
	^class >> selector
! !

!WebsideAPI methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
requestedSelector
	| selector |
	selector := self urlAt: 'selector'.
	^selector ifNotNil: [selector asSymbol]
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
response: aResponse
	response := aResponse
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
search
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
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
subclasses
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class subclasses collect: [:c | c asWebsideJson]
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
superclasses
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^class allSuperclasses collect: [:c | c asWebsideJson]
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
urlAt: aString
	^request paramAt: aString
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
usedCategories
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^self instanceVariables , self classVariables
! !

!WebsideAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
usualCategories
	| meta |
	meta := self queryAt: 'meta'.
	^meta = 'true'
		ifTrue: [#(#'instance creation'  #accessing  #validation  #initialization  #testing  #'gui support'  #constants  #private  #defaults  #events  #services  #examples)]
		ifFalse: [#(#accessing #actions #construction #'event handlers' #initialization #inquiries #printing #private #services #testing #updating #validation)]
! !

!WebsideAPI methodsFor:  'code endpoints' stamp: 'KenD 28/Jun/2026 13:32:24'!
variables
	| class |
	class := self requestedClass.
	class ifNil: [^self notFound].
	^self instanceVariables , self classVariables
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WebsideAPI class' category: #Webside!
WebsideAPI class
	instanceVariableNames: ''!

!WebsideAPI class methodsFor:  'routes' stamp: 'KenD 28/Jun/2026 13:32:24'!
addChangesRoutesTo: aWebApplication
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
! !

!WebsideAPI class methodsFor:  'routes' stamp: 'KenD 28/Jun/2026 13:32:24'!
addCodeRoutesTo: aWebApplication
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
! !

!WebsideAPI class methodsFor:  'routes' stamp: 'KenD 28/Jun/2026 13:32:24'!
addGeneralRoutesTo: aWebApplication
	aWebApplication
		routeGET: '/dialect' to: #dialect;
		routeGET: '/logo' to: #logo;
		routeGET: '/colors' to: #colors
! !

!WebsideAPI class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
addRoutesTo: aWebApplication
	self
		addGeneralRoutesTo: aWebApplication;
		addCodeRoutesTo: aWebApplication;
		addChangesRoutesTo: aWebApplication
! !


