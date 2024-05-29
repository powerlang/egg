"
self startServer


self allInstances
"
Class {
	#name : #EggWebsideAPI,
	#superclass : #Object,
	#instVars : [
		'request',
		'server'
	],
	#classVars : [
		'Debuggers',
		'Evaluations',
		'Objects',
		'Workspaces'
	],
	#category : #'Powerlang-EggWebside-Base'
}

{ #category : #'instance creation' }
EggWebsideAPI class >> new [
	^ super new initialize
]

{ #category : #services }
EggWebsideAPI class >> startServer [

	"
	self startServer
	"

	| runtime |
	runtime := (EggRingImage fromSpec
		            wordSize: 8;
		            genesis;
		            bootstrap;
		            fillClasses;
		            fillSymbols;
		            generateMetacircularImage) result.
	^ WebsideServer new
		  apiClass: EggWebsideAPI;
		  baseUri: '/powerlang';
		  port: 9010;
		  resourcesAt: #runtime put: runtime;
		  start
]

{ #category : #services }
EggWebsideAPI class >> stopServer [
	"
	self stopServer
	"

	WebsideServer allInstances do: #stop
]

{ #category : #'changes endpoints' }
EggWebsideAPI >> addChange [

	| change author |
	change := self requestedChange.
	change ifNil: [ ^ self badRequest: 'Change not supported' ].
	author := self bodyAt: 'author' ifAbsent: [ 'Unknown' ].
	[ self applyChange: change ]
		on: Error , SyntaxErrorNotification , OCUndeclaredVariableWarning
		do: [ :e | ^ self compilationError: e ].
	server changes add: change.
	^ change asWebsideJson
]

{ #category : #'private - changes' }
EggWebsideAPI >> applyAddClassChange: aRBAddClassChange [
self halt.
	
]

{ #category : #'private - changes' }
EggWebsideAPI >> applyAddMethodChange: aRBAddMethodChange [

	| class |
	class := self classNamed: aRBAddMethodChange changeClassName.
	class ifNil: [ self error: 'Unexisting class' ].
	class compile: aRBAddMethodChange source
]

{ #category : #'private - changes' }
EggWebsideAPI >> applyChange: change [

	(change isKindOf: RBAddClassChange) ifTrue: [ 
		^ self applyAddClassChange: change ].
	(change isKindOf: RBAddMethodChange) ifTrue: [ 
		^ self applyAddMethodChange: change ].
	(change isKindOf: RBRemoveMethodChange) ifTrue: [ 
		^ self applyRemoveMethodChange: change ].
	self error: 'Change not supported'
]

{ #category : #'private - changes' }
EggWebsideAPI >> applyRemoveMethodChange: aRBRemoveMethodChange [

	| class |
	self halt.
	class := self classNamed: aRBRemoveMethodChange changeClassName.
	class ifNil: [ self error: 'Unexisting class' ].
	class removeSelector: aRBRemoveMethodChange selector
]

{ #category : #private }
EggWebsideAPI >> bodyAt: aString [

	^ self bodyAt: aString ifAbsent: nil
]

{ #category : #private }
EggWebsideAPI >> bodyAt: aString ifAbsent: aBlock [

	| json |
	json := NeoJSONReader fromString: request entity.
	^ json at: aString ifAbsent: aBlock
]

{ #category : #'code endpoints' }
EggWebsideAPI >> categories [
	| class |
	class := self requestedClass.
	class ifNil: [ ^ self notFound ].
	^ class categories
]

{ #category : #'code endpoints' }
EggWebsideAPI >> classDefinition [

	| class |
	class := self requestedClass.
	class ifNil: [ ^ self notFound ].
	^ class asWebsideJson
]

{ #category : #private }
EggWebsideAPI >> classNamed: aString [

	| name metaclass root class |
	name := aString.
	metaclass := name endsWith: ' class'.
	metaclass ifTrue: [ name := name withoutSuffix: ' class' ].
	root := self defaultRootClass.
	class := root withAllSubclasses
		         detect: [ :c | c name = name ]
		         ifNone: [ ^ nil ].
	^ metaclass
		  ifTrue: [ class metaclass ]
		  ifFalse: [ class ]
]

{ #category : #private }
EggWebsideAPI >> classTreeFrom: aPowerlangSpeciesWrapper depth: anInteger [
	| json subclasses depth names superclass |
	names := self queryAt: 'names'.
	json := names = 'true'
		ifTrue: [ superclass := aPowerlangSpeciesWrapper superclass.
			NeoJSONObject new
				at: 'name' put: aPowerlangSpeciesWrapper name;
				at: 'superclass'
					put:
					(superclass = self runtime nil
						ifFalse: [ superclass name ]);
				yourself ]
		ifFalse: [ aPowerlangSpeciesWrapper asWebsideJson ].
	(anInteger notNil and: [ anInteger = 0 ])
		ifTrue: [ ^ json ].
	depth := anInteger notNil
		ifTrue: [ anInteger - 1 ].
	subclasses := (aPowerlangSpeciesWrapper subclasses
		sort: [ :a :b | a name <= b name ])
		collect: [ :c | self classTreeFrom: c depth: depth ].
	json at: 'subclasses' put: subclasses.
	^ json
]

{ #category : #'code endpoints' }
EggWebsideAPI >> classVariables [
	| class |
	class := self requestedClass.
	class ifNil: [ ^ self notFound ].
	^ class withAllSuperclasses
		gather: [ :c | 
			c classVarNames asArray sort
				collect: [ :v | 
					NeoJSONObject new
						at: 'name' put: v;
						at: 'class' put: c name , ' class';
						at: 'type' put: 'class';
						yourself ] ]
]

{ #category : #'code endpoints' }
EggWebsideAPI >> classes [

	| root tree classes names depth json |
	root := self queryAt: 'root'.
	root := root notNil
		        ifTrue: [ self classNamed: root ]
		        ifFalse: [ self defaultRootClass ].
	root ifNil: [ ^ self notFound ].
	tree := self queryAt: 'tree'.
	tree = 'true' ifTrue: [ 
		depth := self queryAt: 'depth' ifPresent: [ :d | d asInteger ].
		json := self classTreeFrom: root depth: depth.
		^ Array with: json ].
	classes := Array with: root withAll: root allSubclasses.
	names := self queryAt: 'names'.
	names = 'true' ifTrue: [ ^ (classes collect: [ :c | c name ]) sort ].
	^ classes collect: [ :c | c asWebsideJson ]
]

{ #category : #private }
EggWebsideAPI >> compilationError: error [

	| entity json suggestions |
	json := error asWebsideJson.
	(error isKindOf: OCUndeclaredVariableWarning) ifTrue: [ 
		suggestions := self declareVariableSuggestionsFrom: error.
		suggestions ifNotNil: [ json at: 'suggestions' put: suggestions ] ].
	entity := ZnStringEntity
		          with: (NeoJSONWriter toString: json)
		          type: (ZnMimeType applicationJson
				           charSet: 'utf-8';
				           yourself).
	^ (ZnResponse statusCode: 409) entity: entity
]

{ #category : #'debugging endpoints' }
EggWebsideAPI >> createDebugger [

	| id process exception context debugger |
	id := self bodyAt: 'evaluation' ifAbsent: [ ^ self notFound ].
	id := UUID fromString: id.
	process := self evaluations at: id ifAbsent: [ ^ self notFound ].
	exception := process suspendedContext exception.
	context := exception signalerContext.
	debugger := EggDebuggerWrapper new context: exception context.
	self debuggers at: id put: debugger.
	^ debugger asWebsideJson
		  at: 'id' put: id asString;
		  at: 'description' put: exception description;
		  yourself
]

{ #category : #'debugging endpoints' }
EggWebsideAPI >> debuggerFrame [

	| debugger index frame interval runtime method receiver class |
	debugger := self debuggers
		            at: self requestedId
		            ifAbsent: [ ^ self notFound ].
	index := self requestedIndex.
	frame := debugger context backtrace
		         at: index
		         ifAbsent: [ ^ self notFound ].
	interval := self newJsonObject
		            at: 'start' put: 0;
		            at: 'end' put: 0;
		            yourself.
	runtime := self runtime.
	method := EggMethodWrapper on: frame first runtime: runtime.
	receiver := EggObjectWrapper on: frame second runtime: runtime.
	class := receiver objectClass.
	^ self newJsonObject
		  at: 'index' put: index;
		  at: 'label' put: class name , ' >> '
			  ,
				  (method selector
					   ifNotNil: [ :s | s asString ]
					   ifNil: [ '_' ]);
		  at: 'class' put: class asWebsideJson;
		  at: 'method' put: method asWebsideJson;
		  at: 'interval' put: interval;
		  yourself
]

{ #category : #'debugging endpoints' }
EggWebsideAPI >> debuggerFrames [

	| debugger runtime method receiver |
	debugger := self debuggers
		            at: self requestedId
		            ifAbsent: [ ^ self notFound ].
	runtime := self runtime.
	^ debugger context backtrace withIndexCollect: [ :array :i | 
		  method := EggMethodWrapper on: array first runtime: runtime.
		  receiver := EggObjectWrapper
			              on: array second
			              runtime: runtime.
		  self newJsonObject
			  at: 'index' put: i;
			  at: 'label' put: receiver objectClass name , ' >> '
				  , (method selector ifNotNil: [ :s | s asString ] ifNil: [ '_' ]);
			  yourself ]
]

{ #category : #private }
EggWebsideAPI >> debuggers [

	^ server debuggers
]

{ #category : #private }
EggWebsideAPI >> defaultRootClass [

	| runtime root |
	runtime := self runtime.
	root := (EggObjectWrapper on: runtime nil runtime: runtime)
		        objectClass.
	[ root superclass wrappee == runtime nil ] whileFalse: [ 
		root := root superclass ].
	^ root
]

{ #category : #'debugging endpoints' }
EggWebsideAPI >> deleteDebugger [

	| id debugger |
	id := self requestedId.
	debugger := self debuggers at: id ifAbsent: nil.
	debugger notNil ifTrue: [ 
		"debugger terminate."
		self debuggers removeKey: id ifAbsent: nil.
		self evaluations removeKey: id ifAbsent: nil ].
	^ id
]

{ #category : #'code endpoints' }
EggWebsideAPI >> dialect [

	^ 'Powerlang'
]

{ #category : #'evaluation  endpoints' }
EggWebsideAPI >> evaluateExpression [

	| debug expression sync pin id semaphore object process block json |
	debug := self bodyAt: 'debug'.
	debug == true ifTrue: [ ^ self debugExpression ].
	expression := self bodyAt: 'expression'.
	sync := (self bodyAt: 'sync') ifNil: true.
	pin := (self bodyAt: 'pin') ifNil: false.
	id := self newID.
	semaphore := Semaphore new.
	block := [ 
	         [ object := self evaluateExpression: expression ]
		         on: Exception
		         do: [ :exception | 
			         semaphore signal.
			         process
				         suspendedContext: exception signalerContext;
				         suspend ].
	         self evaluations removeKey: id ifAbsent: nil.
	         (sync not or: [ pin ]) ifTrue: [ 
		         self objects at: id put: object ].
	         semaphore signal.
	         object ].
	process := block newProcess.
	self evaluations at: id put: process.
	process resume.
	sync ifTrue: [ 
		semaphore wait.
		object ifNil: [ ^ self evaluationError: id ].
		json := object asWebsideJson.
		pin ifTrue: [ json at: 'id' put: id asString ].
		^ json ].
	^ self newJsonObject
		  at: 'id' put: id asString;
		  at: 'expression' put: expression;
		  yourself
]

{ #category : #private }
EggWebsideAPI >> evaluateExpression: aString [

	| class  |
	class := self classNamed: 'Object'.
	class compile: 'doIt ^' , aString.
	^class new doIt
]

{ #category : #private }
EggWebsideAPI >> evaluationError: id [

	| process json entity |
	process := self evaluations at: id.
	json := self newJsonObject
		        at: 'description'
		        put: process suspendedContext exception description;
		        at: 'evaluation' put: id asString;
		        yourself.
	entity := ZnStringEntity
		          with: (NeoJSONWriter toString: json)
		          type: (ZnMimeType applicationJson
				           charSet: 'utf-8';
				           yourself).
	^ ZnResponse serverErrorWithEntity: entity
]

{ #category : #private }
EggWebsideAPI >> evaluations [

	^ server evaluations
]

{ #category : #private }
EggWebsideAPI >> filterByCategory: aCollection [
	| category |
	category := self queriedCategory.
	^ (category notNil and: [ category notEmpty ])
		ifTrue: [ aCollection select: [ :m | m category = category ] ]
		ifFalse: [ aCollection ]
]

{ #category : #private }
EggWebsideAPI >> filterByVariable: aCollection [
	| variable class slot classVar |
	variable := self queriedAccessing.
	variable ifNil: [ ^ aCollection ].
	^ aCollection
		select: [ :m | 
			class := m methodClass.
			(class hasSlotNamed: variable)
				ifTrue: [ slot := class slotNamed: variable ].
			(class classVarNames includes: variable)
				ifTrue: [ classVar := class classVarNamed: variable ].
			(slot notNil
				and: [ (slot isReadIn: m) or: [ slot isWrittenIn: m ] ])
				or: [ classVar notNil and: [ classVar isReferencedIn: m ] ] ]
]

{ #category : #'debugging endpoints' }
EggWebsideAPI >> frameBindings [

	| debugger frame |
	debugger := self debuggers
		            at: self requestedId
		            ifAbsent: [ ^ self notFound ].
	frame := debugger context backtrace
		         at: self requestedIndex
		         ifAbsent: [ ^ self notFound ].

	^ #() collect: [ 
		  :b | 
		  self newJsonObject
			  at: 'name' put: b key asString;
			  at: 'value' put: b value printString;
			  yourself ]
]

{ #category : #private }
EggWebsideAPI >> image [
	^ self runtime image
]

{ #category : #private }
EggWebsideAPI >> implementorsOf: aSymbol [
	| scope root |
	scope := self queriedScope.
	scope
		ifNotNil: [ self halt. ^scope implementorsOf: aSymbol].
	root := self defaultRootClass.
	^root withAllSubclasses
		  select: [ :class | class includesSelector: aSymbol ]
		  thenCollect: [ :class | class >> aSymbol ]
]

{ #category : #private }
EggWebsideAPI >> indexedSlotsOf: anObject [

	| from to slot |
	anObject class isVariable ifFalse: [ ^ self notFound ].
	from := self
		        queryAt: 'from'
		        ifPresent: [ :f | f asInteger ]
		        ifAbsent: [ 1 ].
	to := self
		      queryAt: 'to'
		      ifPresent: [ :t | t asInteger ]
		      ifAbsent: [ anObject size ].
	^ (from to: to) collect: [ :i | 
		  slot := anObject basicAt: i.
		  slot asWebsideJson
			  at: 'slot' put: i;
			  yourself ]
]

{ #category : #'code endpoints' }
EggWebsideAPI >> instanceVariables [
	| class |
	class := self requestedClass.
	class ifNil: [ ^ self notFound ].
	^ class withAllSuperclasses
		gather: [ :c | 
			c instVarNames
				collect: [ :v | 
					NeoJSONObject new
						at: 'name' put: v;
						at: 'class' put: c name;
						at: 'type' put: 'instance';
						yourself ] ]
]

{ #category : #private }
EggWebsideAPI >> instanceVariablesOf: anObject [

	^ anObject objectClass allInstVarNames collect: [ :n | 
		  self newJsonObject
			  at: 'name' put: n;
			  yourself ]
]

{ #category : #'code endpoints' }
EggWebsideAPI >> method [

	| class selector symbol |
	class := self requestedClass.
	class ifNil: [ ^ self notFound ].
	selector := self requestedSelector.
	selector ifNil: [ ^ self notFound ].
	(class includesSelector: selector) ifFalse: [ ^ self notFound ].
	^ (class >> selector) asWebsideJson
]

{ #category : #'code endpoints' }
EggWebsideAPI >> methods [

	| selector methods senders global references class |
	selector := self queriedSelector.
	selector notNil ifTrue: [ methods := self implementorsOf: selector ].
	selector := self queriedSending.
	selector notNil ifTrue: [ 
		senders := self sendersOf: selector.
		methods := methods
			           ifNil: [ senders ]
			           ifNotNil: [ methods intersection: senders ] ].
	global := self queriedReferencingClass.
	global notNil ifTrue: [ 
		references := self referencesTo: global.
		methods := methods
			           ifNil: [ references ]
			           ifNotNil: [ methods intersection: references ] ].
	class := self requestedClass ifNil: [ self queriedClass ].
	(class notNil and: [ methods notNil ]) ifTrue: [ 
		methods := methods select: [ :m | m classBinding = class ] ].
	methods ifNil: [ 
		methods := (class ifNil: [ self defaultRootClass ]) methods ].
	methods := self filterByCategory: methods.
	methods := self filterByVariable: methods.
	^ methods collect: [ :m | m asWebsideJson ]
]

{ #category : #private }
EggWebsideAPI >> namedSlotsOf: anObject [

	| slot |
	^ anObject objectClass allInstVarNames collect: [ :n | 
		  slot := self slot: n of: anObject ifAbsent: nil.
		  slot asWebsideJson
			  at: 'slot' put: n;
			  yourself ]
]

{ #category : #private }
EggWebsideAPI >> newID [

	^ UUID new
]

{ #category : #private }
EggWebsideAPI >> newJsonObject [

	^ NeoJSONObject new
]

{ #category : #private }
EggWebsideAPI >> notFound [
	^ ZnResponse notFound: 'resource not found'
]

{ #category : #private }
EggWebsideAPI >> objects [

	^ server objects
]

{ #category : #'objects endpoints' }
EggWebsideAPI >> pinnedObject [

	| id object |
	id := self requestedId.
	self evaluations at: id ifPresent: [ :process | 
		process isSuspended ifTrue: [ ^ self evaluationError: id ] ].
	object := self objects at: id ifAbsent: [ ^ self notFound ].
	^ object asWebsideJson
		  at: 'id' put: id asString;
		  yourself
]

{ #category : #'objects endpoints' }
EggWebsideAPI >> pinnedObjectSlots [

	| id object path index last |
	id := self requestedId.
	object := self objects at: id ifAbsent: [ ^ self notFound ].
	path := request url segments.
	index := path indexOf: 'objects'.
	path from: index + 2 to: path size - 1 do: [ :s | 
		object := self slot: s of: object ifAbsent: [ ^ self notFound ] ].
	last := path last.
	last = 'instance-variables' ifTrue: [ 
		^ self instanceVariablesOf: object ].
	last = 'named-slots' ifTrue: [ ^ self namedSlotsOf: object ].
	last = 'indexed-slots' ifTrue: [ ^ self indexedSlotsOf: object ].
	object := self slot: last of: object ifAbsent: [ ^ self notFound ].
	^ object asWebsideJson
]

{ #category : #private }
EggWebsideAPI >> queriedAccessing [
	^ self queryAt: 'accessing' 
]

{ #category : #private }
EggWebsideAPI >> queriedCategory [
	| category |
	category := request at: 'category' ifAbsent: nil.
	^ category ifNotNil: [ category asSymbol ]
]

{ #category : #private }
EggWebsideAPI >> queriedClass [
	| name |
	name := request at: 'class' ifAbsent: nil.
	^ name ifNotNil: [ self classNamed: name ]
]

{ #category : #private }
EggWebsideAPI >> queriedReferencingClass [
	^self queryAt: 'referencingClass' ifPresent: [:n | self classNamed: n ]
]

{ #category : #private }
EggWebsideAPI >> queriedReferencingString [
	^self queryAt: 'referencingString'
]

{ #category : #private }
EggWebsideAPI >> queriedScope [
	| scope |
	scope := request at: 'scope' ifAbsent: nil.
	^ scope ifNotNil: [ self classNamed: scope ]
]

{ #category : #private }
EggWebsideAPI >> queriedSelector [
	| selector |
	selector := request at: 'selector' ifAbsent: nil.
	^ selector ifNotNil: [ selector asSymbol ]
]

{ #category : #private }
EggWebsideAPI >> queriedSending [
	| selector |
	selector := request at: 'sending' ifAbsent: nil.
	^ selector ifNotNil: [ selector asSymbol ]
]

{ #category : #private }
EggWebsideAPI >> queryAt: aString [
	^ self queryAt: aString ifAbsent: nil
]

{ #category : #private }
EggWebsideAPI >> queryAt: aString ifAbsent: aBlock [
	^ self queryAt: aString ifPresent: nil ifAbsent: aBlock
]

{ #category : #private }
EggWebsideAPI >> queryAt: aString ifPresent: aBlock [
	^ self queryAt: aString ifPresent: aBlock ifAbsent: nil
]

{ #category : #private }
EggWebsideAPI >> queryAt: aString ifPresent: aBlock ifAbsent: anotherBlock [

	| value |
	value := request at: aString ifAbsent: nil.
	value ifNil: [ ^ anotherBlock value ].
	^ aBlock notNil
		  ifTrue: [ aBlock value: value ]
		  ifFalse: [ value ]
]

{ #category : #private }
EggWebsideAPI >> referencesToClass: aClass [
	| binding |
	binding := Smalltalk bindingOf: aClass name asSymbol.
	^ SystemNavigation default allReferencesTo: binding
]

{ #category : #private }
EggWebsideAPI >> referencesToString: aString [
	| scope |
	scope := self queriedScope ifNil: [ self queriedClass ].
	
		^ SystemNavigation default 
			allMethodsSelect:  [ :m | 
			m
				hasLiteralSuchThat: [ :l | 
					l isString
						and: [ l isSymbol not
								and: [ l includesSubstring: aString caseSensitive: false ] ] ] ]

]

{ #category : #accessing }
EggWebsideAPI >> request: aTeaRequest [
	request := aTeaRequest
]

{ #category : #private }
EggWebsideAPI >> requestedChange [

	| json change |
	json := NeoJSONReader fromString: request entity.
	change := RBRefactoryChange fromWebsideJson: json.
	change ifNil: [ change := RBRefactoring fromWebsideJson: json ].
	^ change
]

{ #category : #private }
EggWebsideAPI >> requestedClass [
	| name |
	name := self urlAt: 'name'.
	^ name ifNotNil: [ self classNamed: name ]
]

{ #category : #private }
EggWebsideAPI >> requestedId [

	| id |
	id := self urlAt: 'id'.
	^ id ifNotNil: [ UUID fromString: id ]
]

{ #category : #private }
EggWebsideAPI >> requestedIndex [

	| index |
	index := self urlAt: 'index'.
	^ index ifNotNil: [ index asInteger ]
]

{ #category : #private }
EggWebsideAPI >> requestedSelector [

	| selector |
	selector := self urlAt: 'selector'.
	^ selector ifNotNil: [ selector asSymbol ]
]

{ #category : #private }
EggWebsideAPI >> runtime [
	^ server resourcesAt: #runtime
]

{ #category : #private }
EggWebsideAPI >> sendersOf: aSymbol [

	| scope |
	scope := self queriedScope.
	scope ifNotNil: [ 
		self halt.
		^ self sendersOf: aSymbol among: scope methods ].
	^ self defaultRootClass withAllSubclasses gather: [ :class | self halt ]
]

{ #category : #private }
EggWebsideAPI >> sendersOf: aSymbol among: aCollection [
	| index |
	index := Smalltalk specialSelectorIndexOrNil: aSymbol.
	^ aCollection
		select: [ :m | m hasSelector: aSymbol specialSelectorIndex: index ]
]

{ #category : #accessing }
EggWebsideAPI >> server: aWebsideServer [
	server := aWebsideServer
]

{ #category : #private }
EggWebsideAPI >> slot: aString of: anObject ifAbsent: aBlock [

	| index |
	aString asInteger asString = aString ifTrue: [ 
		index := aString asInteger.
		anObject isCollection
			ifTrue: [ 
				index > anObject size ifTrue: [ ^ aBlock value ].
				^ [ anObject at: index ]
					  on: Error
					  do: [ anObject basicAt: index ] ]
			ifFalse: [ 
				anObject class isVariable ifTrue: [ 
					^ anObject at: index ].
				index > anObject objectClass instSize ifTrue: [ 
					^ aBlock value ].
				^ anObject instVarAt: index ] ].
	index := anObject objectClass allInstVarNames 
		         indexOf: aString.
	^ index > 0
		  ifTrue: [ anObject slotAt: index ]
		  ifFalse: [ aBlock value ]
]

{ #category : #'code endpoints' }
EggWebsideAPI >> subclasses [

	| class |
	class := self requestedClass.
	class ifNil: [ ^ self notFound ].
	^ class subclasses collect: [ :c | c asWebsideJson ]
]

{ #category : #'objects endpoints' }
EggWebsideAPI >> unpinObject [

	self objects
		removeKey: self requestedId
		ifAbsent: [ ^ self notFound ].
	^ nil
]

{ #category : #private }
EggWebsideAPI >> urlAt: aString [
	^ request at: aString ifAbsent: nil
]

{ #category : #'code endpoints' }
EggWebsideAPI >> variables [
	| class |
	class := self requestedClass.
	class ifNil: [ ^ self notFound ].
	^ self instanceVariables , self classVariables
]
