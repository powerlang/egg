Class {
	#name : 'EggBootstrapWebsideAPITest',
	#superclass : 'TestCase',
	#instVars : [
		'server',
		'client'
	],
	#classVars : [
		'Cache'
	],
	#category : 'Powerlang-EggWebside-Tests',
	#package : 'Powerlang-EggWebside-Tests'
}

{ #category : 'accessing' }
EggBootstrapWebsideAPITest class >> defaultTimeLimit [

	^ 100 seconds
]

{ #category : 'initialization' }
EggBootstrapWebsideAPITest class >> initializeCache [
	"
	self initializeCache 
	"

	Cache := EggBootstrapImage fromSpec
			            wordSize: 8;
			            genesis;
			            bootstrap;
			            fillClasses;
			            fillSymbols
		          
]

{ #category : 'private' }
EggBootstrapWebsideAPITest >> delete: uri [
	| data |
	data := client delete: server baseUrl / uri.
	^ data ifNotNil: [ NeoJSONObject fromString: data ]
]

{ #category : 'private' }
EggBootstrapWebsideAPITest >> get: uri [

	| url data |
	url := server baseUrl asString.
	(uri beginsWith: '/') ifFalse: [ url := url , '/' ].
	url := url , uri.
	data := client get: url.
	client isNotFound ifTrue: [ ^ nil ].
	client isSuccess ifFalse: [ self error: client contents asString ].
	^ data ifNotNil: [ NeoJSONObject fromString: data ]
]

{ #category : 'private' }
EggBootstrapWebsideAPITest >> post: uri [
	^ self post: uri with: ''
]

{ #category : 'private' }
EggBootstrapWebsideAPITest >> post: uri with: body [
	| data |
	data := client post: server baseUrl / uri contents: body asString.
	^ NeoJSONObject fromString: data
]

{ #category : 'running' }
EggBootstrapWebsideAPITest >> setUp [

	| runtime |
	super setUp.
	runtime := Cache runtime.
	server := WebsideServer new.
	server
		apiClass: EggBootstrapWebsideAPI;
		baseUri: '/websideapitest';
		port: 9999;
		resourcesAt: #runtime put: runtime;
		start.
	client := ZnClient new accept: ZnMimeType applicationJson
]

{ #category : 'running' }
EggBootstrapWebsideAPITest >> tearDown [
	super tearDown.
	server stop.
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testAccessors [

	| accessors |
	accessors := self get: 'methods?class=Fraction&accessing=numerator'.
	self
		assert: accessors notEmpty;
		assert:
			(accessors allSatisfy: [ :m |
					 m source includesSubstring: 'numerator' ]).
	accessors := self get: 'methods?class=Fraction&accessing=numerator'.
	self
		assert: accessors notEmpty;
		assert: (accessors allSatisfy: [ :m |
					 m source includesSubstring: 'numerator :=' ])
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testActiveEvaluations [
	| evaluation result id |
	evaluation := NeoJSONObject new
		at: 'expression' put: '(Delay forSeconds: 1) wait';
		at: 'sync' put: false;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	[ | active |
	id := result at: 'id'.
	active := self get: '/evaluations'.
	self
		assert: active notEmpty;
		assert: (active anySatisfy: [ :e | (e at: 'id') = id ]) ]
		ensure: [ self delete: '/evaluations/' , id asString ]
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testAsynchronousEvaluation [
	| evaluation result id |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 + 4';
		at: 'sync' put: false;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	[ | attempts object |
	id := result at: 'id'.
	self
		assert: (result includesKey: 'id');
		deny: (result at: 'printString' ifAbsent: '') equals: '7'.
	attempts := 0.
	object := nil.
	[ attempts <= 3 and: [ object isNil ] ]
		whileTrue: [ attempts := attempts + 1.
			(Delay forMilliseconds: 200) wait.
			object := self get: '/objects/' , id asString ].
	self
		assert: object notNil;
		assert: (object at: 'id') equals: id;
		assert: (object at: 'class') equals: 'SmallInteger';
		assert: (object at: 'printString') equals: '7' ]
		ensure: [ self delete: '/objects/' , id asString ]
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testCancelEvaluation [
	| evaluation result id active |
	evaluation := NeoJSONObject new
		at: 'expression' put: 'Delay wait: 10000';
		at: 'sync' put: false;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	id := result at: 'id'.
	self delete: '/evaluations/' , id asString.
	active := self get: '/evaluations'.
	self assert: (active noneSatisfy: [ :e | (e at: 'id') = id ])
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testCassDefinition [
	| definition |
	definition := NeoJSONObject new
		at: 'type' put: 'ClassDefinition';
		at: 'class' put: 'TestCassDefinition';
		at: 'definition'
			put:
			'Object
	subclass: #TestCassDefinition
	instanceVariableNames: ''x''
	classVariableNames: ''''
	poolDictionaries: ''''';
		at: 'author' put: self class name;
		yourself.
	[ | class |
	self post: '/changes' with: definition.
	class := self get: '/classes/TestCassDefinition'.
	self
		assert: class notNil;
		assert: class name equals: 'TestCassDefinition' ]
		ensure: [ | remotion |
			remotion := NeoJSONObject new
				at: 'type' put: 'ClassRemove';
				at: 'class' put: 'TestCassDefinition';
				yourself.
			self post: '/changes' with: remotion ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testCategories [

	| categories |
	categories := self get: 'classes/Number/categories'.
	self
		assert: categories notEmpty;
		assert: (categories allSatisfy: #isString);
		assert: (categories includes: 'arithmetic')
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testCategoryRemove [
	| class method remotion |
	class := NeoJSONObject new
		at: 'type' put: 'ClassDefinition';
		at: 'class' put: 'TestCategoryRemove';
		at: 'definition'
			put:
			'Object
	subclass: #TestCategoryRemove
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		at: 'author' put: self class name;
		yourself.
	method := NeoJSONObject new
		at: 'type' put: 'MethodDefinition';
		at: 'class' put: 'TestCategoryRemove';
		at: 'category' put: 'x';
		at: 'sourceCode' put: 'testCategoryRemove';
		at: 'author' put: self class name;
		yourself.
	remotion := NeoJSONObject new
		at: 'type' put: 'CategoryRemove';
		at: 'class' put: 'TestCategoryRemove';
		at: 'category' put: 'x';
		yourself.
	[ | categories |
	self
		post: '/changes' with: class;
		post: '/changes' with: method;
		post: '/changes' with: remotion.
	categories := self get: '/classes/TestCategoryRemove/categories'.
	self deny: (categories includes: 'x') ]
		ensure: [ remotion := NeoJSONObject new
				at: 'type' put: 'ClassRemove';
				at: 'class' put: 'TestCategoryRemove';
				yourself.
			self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testCategoryRename [
	| class method renaming |
	class := NeoJSONObject new
		at: 'type' put: 'ClassDefinition';
		at: 'class' put: 'TestCategoryRename';
		at: 'definition'
			put:
			'Object
	subclass: #TestCategoryRename
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		at: 'author' put: self class name;
		yourself.
	method := NeoJSONObject new
		at: 'type' put: 'MethodDefinition';
		at: 'class' put: 'TestCategoryRename';
		at: 'category' put: 'x';
		at: 'sourceCode' put: 'testCategoryRename';
		at: 'author' put: self class name;
		yourself.
	renaming := NeoJSONObject new
		at: 'type' put: 'CategoryRename';
		at: 'class' put: 'TestCategoryRename';
		at: 'category' put: 'x';
		at: 'newName' put: 'y';
		yourself.
	[ | categories |
	self
		post: '/changes' with: class;
		post: '/changes' with: method;
		post: '/changes' with: renaming.
	categories := self get: '/classes/TestCategoryRename/categories'.
	self
		assert: categories size equals: 1;
		assert: categories first name equals: 'y' ]
		ensure: [ | remotion |
			remotion := NeoJSONObject new
				at: 'type' put: 'ClassRemove';
				at: 'class' put: 'TestCategoryRename';
				yourself.
			self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testChanges [

	| change changes |
	change := NeoJSONObject new
		          at: 'type' put: 'AddMethod';
		          at: 'class' put: 'Point';
		          at: 'category' put: self class name;
		          at: 'sourceCode' put: 'testChanges
	^x + 1';
		          at: 'author' put: self class name;
		          yourself.
	[ 
	| retrieved |
	self post: '/changes' with: change.
	changes := self get: '/changes'.
	self assert: changes notEmpty.
	retrieved := changes last.
	self
		assert: (retrieved at: 'type') equals: 'AddMethod';
		assert: (retrieved at: 'class') equals: 'Point';
		assert: (retrieved at: 'selector') equals: 'testChanges' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveMethod';
			            at: 'class' put: 'Point';
			            at: 'selector' put: 'testChanges';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testClassCommentDefinition [

	| definition comment |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestClassCommentDefinition';
		              at: 'definition' put: 'Object
	subclass: #TestClassCommentDefinition
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	comment := NeoJSONObject new
		           at: 'type' put: 'CommentClass';
		           at: 'class' put: 'TestClassCommentDefinition';
		           at: 'comment' put: 'Testing class comment';
		           yourself.
	[ 
	| class |
	self
		post: '/changes' with: definition;
		post: '/changes' with: comment.
	class := self get: '/classes/TestClassCommentDefinition'.
	self
		assert: class notNil;
		assert: class comment equals: 'Testing class comment' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestClassCommentDefinition';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testClassDefinition [
	| definition |
	definition := self get: 'classes/Point'.
	self
		assert: definition name equals: 'Point';
		assert: (definition definition includesSubstring: 'x');
		assert: (definition definition includesSubstring: 'y')
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testClassRemove [

	| definition remotion class |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestClassRemove';
		              definition: 'Object
	subclass: #TestClassRemove
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	remotion := NeoJSONObject new
		            at: 'type' put: 'RemoveClass';
		            at: 'class' put: 'TestClassRemove';
		            yourself.
	self
		post: '/changes' with: definition;
		post: '/changes' with: remotion.
	class := self get: '/classes/TestClassRemove'.
	self assert: class isNil
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testClassRename [

	| definition renaming class |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestClassRename';
		              definition: 'Object
	subclass: #TestClassRename
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	renaming := NeoJSONObject new
		            at: 'type' put: 'RenameClass';
		            at: 'class' put: 'TestClassRename';
		            at: 'newName' put: 'TestClassRename2';
		            yourself.
	[ 
	self
		post: '/changes' with: definition;
		post: '/changes' with: renaming.
	class := self get: '/classes/TestClassRename'.
	self assert: class isNil.
	class := self get: '/classes/TestClassRename2'.
	self assert: class notNil ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestClassRename2';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testClassVariables [
	| variables |
	variables := self get: 'classes/Float/class-variables'.
	self assert: (variables anySatisfy: [ :v | v name = 'Infinity' ])
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testClasses [
	| classes names tree root integer |
	classes := self get: 'classes'.
	self assert: classes notEmpty.
	classes := self get: 'classes?root=Magnitude'.
	self
		assert:
			(classes
				anySatisfy: [ :c | 
					c name = 'Fraction'
						and: [ c definition includesSubstring: 'denominator' ] ]).
	names := self get: 'classes?root=Magnitude&names=true'.
	self
		assert: names notEmpty;
		assert: (names allSatisfy: #isString).
	tree := self get: 'classes?root=Number&tree=true'.
	self
		assert: tree isCollection;
		assert: tree size equals: 1.
	root := tree first.
	self
		assert: root name = 'Number';
		assert: (root subclasses anySatisfy: [ :c | c name = 'Integer' ]).
	integer := root subclasses detect: [ :c | c name = 'Integer' ].
	self
		assert: (integer subclasses anySatisfy: [ :c | c name = 'SmallInteger' ])
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testCodeSuggestion [

	| change method error changes |
	change := NeoJSONObject new
		          at: 'type' put: 'AddMethod';
		          at: 'class' put: 'Point';
		          at: 'category' put: self class name;
		          at: 'sourceCode' put: 'testMethodDefinition
	^t + 1';
		          at: 'author' put: self class name;
		          yourself.
	[ 
	self
		post: '/changes' with: change;
		deny: client isSuccess.
	error := NeoJSONObject fromString: client contents.
	self assert: error notNil.
	changes := error at: 'changes'.
	self post: '/changes' with: changes first.
	method := self get: '/classes/Point/methods/testMethodDefinition'.
	self
		assert: method notNil;
		assert: method selector equals: 'testMethodDefinition';
		assert: method category equals: self class name;
		assert: method source equals: 'testMethodDefinition
	| t |
	^t + 1' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveMethod';
			            at: 'class' put: 'Point';
			            at: 'selector' put: 'testMethodDefinition';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'debugging endpoints' }
EggBootstrapWebsideAPITest >> testCreateDebugger [
	| evaluation halt id debugger |
	evaluation := NeoJSONObject new
		at: 'expression' put: '1 halt factorial';
		at: 'sync' put: true;
		yourself.
	halt := false.
	[ self post: '/evaluations' with: evaluation ]
		on: Error
		do: [ :e | 
			| error |
			halt := true.
			self
				assert: (e isKindOf: Error);
				assert: e hasData.
			error := e data.
			self
				assert: ((error at: 'description') asLowercase includesSubstring: 'halt');
				assert: (error includesKey: 'evaluation').
			id := error at: 'evaluation' ].
	self
		assert: halt;
		assert: id notNil.
	[ | target frames |
	target := NeoJSONObject new
		at: 'evaluation' put: id;
		yourself.
	debugger := self post: '/debuggers' with: target.
	self assert: debugger notNil.
	frames := self get: '/debuggers/' , debugger , '/frames'.
	self assert: frames notEmpty ]
		ensure: [ debugger notNil
				ifTrue: [ self delete: '/debuggers/' , debugger asString ] ]
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testDebuggerContext [
	| evaluation id debugger error |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 halt factorial';
		at: 'sync' put: true;
		yourself.
	self post: '/evaluations' with: evaluation.
	self deny: client isSuccess .
	error := NeoJSONObject fromString: client response entity string.
	id := error at: 'evaluation'.
	self assert: id notNil.
	[ | target context receiver |
	target := NeoJSONObject new
		at: 'evaluation' put: id;
		yourself.
	debugger := self post: '/debuggers' with: target.
	self post: '/debuggers/' , debugger , '/frames/1/stepinto'.
	context := NeoJSONObject new
		at: 'debugger' put: debugger asString;
		at: 'frame' put: 1;
		yourself.
	evaluation := NeoJSONObject new
		at: 'expression' put: 'self';
		at: 'sync' put: true;
		at: 'pin' put: false;
		at: 'context' put: context;
		yourself.
	receiver := self post: '/evaluations' with: evaluation.
	self
		assert: (receiver at: 'class') equals: 'SmallInteger';
		assert: (receiver at: 'printString') equals: '3' ]
		ensure: [ self delete: '/debuggers/' , debugger asString ]
]

{ #category : 'debugging endpoints' }
EggBootstrapWebsideAPITest >> testDebuggerFrames [
	| evaluation id debugger |
	evaluation := NeoJSONObject new
		at: 'expression' put: '1 halt factorial';
		at: 'sync' put: true;
		yourself.
	[ self post: '/evaluations' with: evaluation ]
		on: Error
		do: [ :e | id := e data at: 'evaluation' ].
	self assert: id notNil.
	[ | target frames |
	target := NeoJSONObject new
		at: 'evaluation' put: id;
		yourself.
	debugger := self post: '/debuggers' with: target.
	frames := self get: '/debuggers/' , debugger , '/frames'.
	self
		assert: frames notEmpty;
		assert: (frames anySatisfy: [ :f | (f at: 'label') notEmpty ]) ]
		ensure: [ self delete: '/debuggers/' , debugger asString ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testDialect [

	| dialect |
	dialect := self get: 'dialect'.
	self assert: dialect equals: 'Egg'
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testEvaluationError [
	| evaluation error description |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 + ';
		at: 'sync' put: true;
		yourself.
	self post: '/evaluations' with: evaluation.
	self deny: client isSuccess.
	error := NeoJSONObject fromString: client response entity string.
	description := (error at: 'description') asLowercase.
	self
		assert:
			(description includesSubstring: 'primary missing')
				| (description includesSubstring: 'variable or expression expected')
]

{ #category : 'debugging endpoints' }
EggBootstrapWebsideAPITest >> testFrameBindings [
	| evaluation id debugger |
	evaluation := NeoJSONObject new
		at: 'expression' put: '1 halt factorial';
		at: 'sync' put: true;
		yourself.
	[ self post: '/evaluations' with: evaluation ]
		on: Error
		do: [ :e | id := e data at: 'evaluation' ].
	self assert: id notNil.
	[ | target frames bindings |
	target := NeoJSONObject new
		at: 'evaluation' put: id;
		yourself.
	debugger := self post: '/debuggers' with: target.
	frames := self get: '/debuggers/' , debugger , '/frames'.
	self assert: frames notEmpty.
	bindings := self get: '/debuggers/' , debugger , '/frames/1/bindings'.
	self
		assert: bindings notEmpty;
		assert: (bindings anySatisfy: [ :b | (b at: 'name') = 'self' ]) ]
		ensure: [ self delete: '/debuggers/' , debugger asString ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testImplementors [

	| implementors local |
	implementors := self get: 'methods?selector=reciprocal'.
	self
		assert: implementors notEmpty;
		assert:
			(implementors allSatisfy: [ :m | m selector = 'reciprocal' ]);
		assert:
			(implementors anySatisfy: [ :m | (m at: 'methodClass') = 'Fraction' ]).
	local := self get: 'methods?selector=reciprocal&class=Fraction'.
	self
		assert: local notEmpty;
		assert: (local allSatisfy: [ :m | m selector = 'reciprocal' ]);
		assert: (local allSatisfy: [ :m | (m at: 'methodClass') = 'Fraction' ])
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testInstanceVariableAddition [

	| definition addition |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestInstanceVariableAddition';
		              definition: 'Object
	subclass: #TestInstanceVariableAddition
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	addition := NeoJSONObject new
		            at: 'type' put: 'AddInstanceVariable';
		            at: 'class' put: 'TestInstanceVariableAddition';
		            at: 'variable' put: 'x';
		            yourself.
	[ 
	| variables |
	self
		post: '/changes' with: definition;
		post: '/changes' with: addition.
	variables := self get:
		             '/classes/TestInstanceVariableAddition/instance-variables'.
	self
		assert: variables size equals: 1;
		assert: variables first name equals: 'x' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestInstanceVariableAddition';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testInstanceVariableMoveDown [

	| superclass class movement |
	superclass := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestInstanceVariableMoveDown';
		              at: 'definition' put: 'Object
	subclass: #TestInstanceVariableMoveDown
	instanceVariableNames: ''x''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	class := NeoJSONObject new
		         at: 'type' put: 'AddClass';
		         at: 'class' put: 'TestInstanceVariableMoveDown2';
		         at: 'definition' put: 'TestInstanceVariableMoveDown
	subclass: #TestInstanceVariableMoveDown2
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		         at: 'author' put: self class name;
		         yourself.
	movement := NeoJSONObject new
		            at: 'type' put: 'MoveDownInstanceVariable';
		            at: 'class' put: 'TestInstanceVariableMoveDown';
		            at: 'variable' put: 'x';
		            at: 'target' put: 'TestInstanceVariableMoveDown2';
		            yourself.
	[ 
	| variables |
	self
		post: '/changes' with: superclass;
		post: '/changes' with: class;
		post: '/changes' with: movement.
	variables := self get:
		             '/classes/TestInstanceVariableMoveDown/instance-variables'.
	self assert: variables isEmpty.
	variables := self get:
		             '/classes/TestInstanceVariableMoveDown2/instance-variables'.
	self
		assert: variables size equals: 1;
		assert: variables first name equals: 'x' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestInstanceVariableMoveDown2';
			            yourself.
		self post: '/changes' with: remotion.
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestInstanceVariableMoveDown';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testInstanceVariableMoveUp [

	| superclass class movement |
	superclass := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestInstanceVariableMoveUp';
		              definition: 'Object
	subclass: #TestInstanceVariableMoveUp
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	class := NeoJSONObject new
		         at: 'type' put: 'AddClass';
		         at: 'class' put: 'TestInstanceVariableMoveUp2';
		         at: 'definition' put: 'TestInstanceVariableMoveUp
	subclass: #TestInstanceVariableMoveUp2
	instanceVariableNames: ''x''
	classVariableNames: ''''
	poolDictionaries: ''''';
		         at: 'author' put: self class name;
		         yourself.
	movement := NeoJSONObject new
		            at: 'type' put: 'MoveUpInstanceVariable';
		            at: 'class' put: 'TestInstanceVariableMoveUp2';
		            at: 'variable' put: 'x';
		            yourself.
	[ 
	| variables |
	self
		post: '/changes' with: superclass;
		post: '/changes' with: class;
		post: '/changes' with: movement.
	variables := self get:
		             '/classes/TestInstanceVariableMoveUp/instance-variables'.
	self
		assert: variables size equals: 1;
		assert: variables first name equals: 'x'.
	variables := self get:
		             '/classes/TestInstanceVariableMoveUp2/instance-variables'.
	self
		assert: variables size equals: 1;
		assert: variables first name equals: 'x';
		assert: (variables first at: 'class')
		equals: 'TestInstanceVariableMoveUp' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestInstanceVariableMoveUp2';
			            yourself.
		self post: '/changes' with: remotion.
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestInstanceVariableMoveUp';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testInstanceVariableRemove [

	| definition remotion |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestInstanceVariableRemove';
		              at: 'definition' put: 'Object
	subclass: #TestInstanceVariableRemove
	instanceVariableNames: ''x''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	remotion := NeoJSONObject new
		            at: 'type' put: 'RemoveInstanceVariable';
		            at: 'class' put: 'TestInstanceVariableRemove';
		            at: 'variable' put: 'x';
		            yourself.
	[ 
	| variables |
	self
		post: '/changes' with: definition;
		post: '/changes' with: remotion.
	variables := self get:
		             '/classes/TestInstanceVariableRemove/instance-variables'.
	self assert: variables isEmpty ] ensure: [ 
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestInstanceVariableRemove';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testInstanceVariableRename [

	| definition renaming |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddClass';
		              at: 'class' put: 'TestInstanceVariableRename';
		              at: 'definition' put: 'Object
	subclass: #TestInstanceVariableRename
	instanceVariableNames: ''x''
	classVariableNames: ''''
	poolDictionaries: ''''';
		              at: 'author' put: self class name;
		              yourself.
	renaming := NeoJSONObject new
		            at: 'type' put: 'RenameInstanceVariable';
		            at: 'class' put: 'TestInstanceVariableRename';
		            at: 'variable' put: 'x';
		            at: 'newName' put: 'y';
		            yourself.
	[ 
	| variables |
	self
		post: '/changes' with: definition;
		post: '/changes' with: renaming.
	variables := self get:
		             '/classes/TestInstanceVariableRename/instance-variables'.
	self
		assert: variables size equals: 1;
		assert: variables first name equals: 'y' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveClass';
			            at: 'class' put: 'TestInstanceVariableRename';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testInstanceVariables [
	| variables |
	variables := self get: 'classes/Fraction/instance-variables'.
	self
		assert: (variables anySatisfy: [ :v | v name = 'numerator' ]);
		assert: (variables anySatisfy: [ :v | v name = 'denominator' ])
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testMethod [
	| method |
	method := self get: 'classes/Point/methods/x'.
	self
		assert: method selector equals: 'x';
		assert:
			((method source includesSubstring: '^x')
				or: [ method source includesSubstring: '^ x' ])
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testMethodDefinition [

	| change method |
	change := NeoJSONObject new
		          at: 'type' put: 'AddMethod';
		          at: 'class' put: 'Point';
		          at: 'category' put: self class name;
		          at: 'sourceCode' put: 'testMethodDefinition
	^x + 1';
		          at: 'author' put: self class name;
		          yourself.
	[ 
	self post: '/changes' with: change.
	method := self get: '/classes/Point/methods/testMethodDefinition'.
	self
		assert: method notNil;
		assert: method selector equals: 'testMethodDefinition';
		assert: method category equals: self class name;
		assert: method source equals: 'testMethodDefinition
	^x + 1' ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveMethod';
			            at: 'class' put: 'Point';
			            at: 'selector' put: 'testMethodDefinition';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testMethodRemove [

	| definition remotion method |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddMethod';
		              at: 'class' put: 'Point';
		              at: 'category' put: self class name;
		              at: 'sourceCode' put: 'testMethodRemove
	^x + 1';
		              at: 'author' put: self class name;
		              yourself.
	remotion := NeoJSONObject new
		            at: 'type' put: 'RemoveMethod';
		            at: 'class' put: 'Point';
		            at: 'selector' put: 'testMethodRemove';
		            yourself.
	self
		post: '/changes' with: definition;
		post: '/changes' with: remotion.
	method := self get: '/classes/Point/methods/testMethodRemove'.
	self assert: method isNil
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testMethods [
	| methods |
	methods := self get: 'classes/Point/methods'.
	self
		assert: methods notEmpty;
		assert: (methods allSatisfy: [ :m | (m at: 'class') = 'Point' ])
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testObjectContext [
	| evaluation object |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 @ 4';
		at: 'sync' put: true;
		at: 'pin' put: true;
		yourself.
	object := self post: '/evaluations' with: evaluation.
	[ | context x |
	context := NeoJSONObject new
		at: 'object' put: (object at: 'id');
		yourself.
	evaluation := NeoJSONObject new
		at: 'expression' put: 'x';
		at: 'sync' put: true;
		at: 'pin' put: false;
		at: 'context' put: context;
		yourself.
	x := self post: '/evaluations' with: evaluation.
	self
		assert: (x at: 'class') equals: 'SmallInteger';
		assert: (x at: 'printString') equals: '3' ]
		ensure: [ self delete: '/objects/' , (object at: 'id') asString ]
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testPinEvaluationResult [
	| evaluation result |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 + 4';
		at: 'sync' put: true;
		at: 'pin' put: true;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	[ self
		assert: (result includesKey: 'id');
		assert: (result at: 'class') equals: 'SmallInteger';
		assert: (result at: 'printString') equals: '7' ]
		ensure: [ self delete: '/objects/' , (result at: 'id') asString ]
]

{ #category : 'objects endpoints' }
EggBootstrapWebsideAPITest >> testPinnedObject [
	| evaluation result id |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 + 4';
		at: 'sync' put: true;
		at: 'pin' put: true;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	[ | pinned |
	id := result at: 'id'.
	pinned := self get: '/objects/' , id asString.
	self
		assert: (pinned at: 'id') equals: id;
		assert: (pinned at: 'class') equals: 'SmallInteger';
		assert: (pinned at: 'printString') equals: '7' ]
		ensure: [ self delete: '/objects/' , id asString ]
]

{ #category : 'objects endpoints' }
EggBootstrapWebsideAPITest >> testPinnedObjectInstanceVariables [
	| evaluation result id vars |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 @ 4 extent: 1 @ 1';
		at: 'sync' put: true;
		at: 'pin' put: true;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	id := result at: 'id'.
	self assert: (result at: 'class') equals: 'Rectangle'.
	vars := self get: '/objects/' , id asString , '/instance-variables'.
	self
		assert: vars size equals: Rectangle allInstVarNames size;
		assert:
			(Rectangle allInstVarNames
				allSatisfy: [ :n | vars anySatisfy: [ :v | (v at: 'name') = n ] ]).
	vars := self
		get: '/objects/' , id asString , '/corner/instance-variables'.
	self
		assert: vars size equals: Point allInstVarNames size;
		assert:
			(Point allInstVarNames
				allSatisfy: [ :n | vars anySatisfy: [ :v | (v at: 'name') = n ] ])
]

{ #category : 'objects endpoints' }
EggBootstrapWebsideAPITest >> testPinnedObjectSlot [
	| evaluation result id x |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 @ 4';
		at: 'sync' put: true;
		at: 'pin' put: true;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	id := result at: 'id'.
	self assert: (result at: 'class') equals: 'Point'.
	x := self get: '/objects/' , id asString , '/x'.
	self
		assert: (x at: 'class') equals: 'SmallInteger';
		assert: (x at: 'printString') equals: '3'
]

{ #category : 'objects endpoints' }
EggBootstrapWebsideAPITest >> testPinnedObjects [
	| evaluation result id |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 + 4';
		at: 'sync' put: true;
		at: 'pin' put: true;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	[ | pinned |
	id := result at: 'id'.
	pinned := self get: '/objects'.
	self
		assert:
			(pinned
				anySatisfy: [ :o | 
					(o at: 'id') = id
						and: [ (o at: 'class') = 'SmallInteger' 
						and: [ (o at: 'printString') = '7' ]] ]) ]
		ensure: [ self delete: '/objects/' , id asString ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testReferencesToClass [

	| references |
	references := self get: 'methods?referencingClass=Fraction'.
	self
		assert: references notEmpty;
		assert:
			(references allSatisfy: [ :m |
					 m source includesSubstring: 'Fraction' ])
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testReferencesToString [

	| references |
	references := self get: 'methods?referencingString=referencingString'.
	self
		assert: references notEmpty;
		assert: (references allSatisfy: [ :m |
					 m source includesSubstring: 'referencingString' ])
]

{ #category : 'changes endpoints' }
EggBootstrapWebsideAPITest >> testSelectorRename2 [

	| definition renaming |
	definition := NeoJSONObject new
		              at: 'type' put: 'AddMethod';
		              at: 'class' put: 'Point';
		              at: 'category' put: self class name;
		              at: 'sourceCode' put: 'testSelectorRename
	^x + 1';
		              at: 'author' put: self class name;
		              yourself.
	renaming := NeoJSONObject new
		            at: 'type' put: 'RenameMethod';
		            at: 'class' put: 'Point';
		            at: 'selector' put: 'testSelectorRename';
		            at: 'newSelector' put: 'testSelectorRename2';
		            at: 'author' put: self class name;
		            yourself.
	[ 
	| method |
	self
		post: '/changes' with: definition;
		post: '/changes' with: renaming.
	method := self get: '/classes/Point/methods/testSelectorRename'.
	self assert: method isNil.
	method := self get: '/classes/Point/methods/testSelectorRename2'.
	self assert: method notNil ] ensure: [ 
		| remotion |
		remotion := NeoJSONObject new
			            at: 'type' put: 'RemoveMethod';
			            at: 'class' put: 'Point';
			            at: 'selector' put: 'testSelectorRename2';
			            yourself.
		self post: '/changes' with: remotion ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testSenders [
	| senders local |
	senders := self get: 'methods?sending=reciprocal'.
	self
		assert: senders notEmpty;
		assert: (senders allSatisfy: [ :m | m source includesSubstring: 'reciprocal' ]);
		assert: (senders anySatisfy: [ :m | (m at: 'class') = 'Fraction' ]).
	local := self get: 'methods?sending=reciprocal&class=Fraction'.
	self
		assert: local notEmpty;
		assert: (local allSatisfy: [ :m | m source includesSubstring: ' reciprocal' ]);
		assert: (local allSatisfy: [ :m | (m at: 'class') = 'Fraction' ])
]

{ #category : 'debugging endpoints' }
EggBootstrapWebsideAPITest >> testStepInto [
	| evaluation id debugger |
	evaluation := NeoJSONObject new
		at: 'expression' put: '1 halt factorial';
		at: 'sync' put: true;
		yourself.
	[ self post: '/evaluations' with: evaluation ]
		on: Error
		do: [ :e | id := e data at: 'evaluation' ].
	self assert: id notNil.
	[ | target frame |
	target := NeoJSONObject new
		at: 'evaluation' put: id;
		yourself.
	debugger := self post: '/debuggers' with: target.
	self post: '/debuggers/' , debugger , '/frames/1/stepinto'.
	frame := self get: '/debuggers/' , debugger , '/frames/1'.
	self assert: ((frame at: 'method') at: 'selector') equals: 'factorial' ]
		ensure: [ self delete: '/debuggers/' , debugger asString ]
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testSubclasses [
	| subclasses |
	subclasses := self get: 'classes/Magnitude/subclasses'.
	self
		assert: (subclasses anySatisfy: [ :c | c name = 'Character' ]);
		assert: (subclasses anySatisfy: [ :c | c name = 'Number' ])
]

{ #category : 'evaluation  endpoints' }
EggBootstrapWebsideAPITest >> testSynchronousEvaluation [
	| evaluation result |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 + 4';
		at: 'sync' put: true;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	self
		assert: (result at: 'class') equals: 'SmallInteger';
		assert: (result at: 'printString') equals: '7'
]

{ #category : 'objects endpoints' }
EggBootstrapWebsideAPITest >> testUnpinObject [
	| evaluation result id pinned |
	evaluation := NeoJSONObject new
		at: 'expression' put: '3 + 4';
		at: 'sync' put: true;
		at: 'pin' put: true;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	id := result at: 'id'.
	self delete: '/objects/' , id asString.
	pinned := self get: '/objects'.
	self assert: (pinned noneSatisfy: [ :o | (o at: 'id') = id ])
]

{ #category : 'code endpoints' }
EggBootstrapWebsideAPITest >> testVariables [
	| variables |
	variables := self get: 'classes/Float/variables'.
	self assert: (variables anySatisfy: [ :v | v name = 'Infinity' ]).
	variables := self get: 'classes/Fraction/variables'.
	self
		assert: (variables anySatisfy: [ :v | v name = 'numerator' ]);
		assert: (variables anySatisfy: [ :v | v name = 'denominator' ])
]

{ #category : 'workspaces endpoints' }
EggBootstrapWebsideAPITest >> testWorkspace [
	| id |
	id := self post: '/workspaces'.
	[ | context assignment evaluation result |
	context := NeoJSONObject new
		at: 'workspace' put: id;
		yourself.
	assignment := NeoJSONObject new
		at: 'expression' put: 'a := 1';
		at: 'sync' put: true;
		context: context;
		yourself.
	self post: '/evaluations' with: assignment.
	evaluation := NeoJSONObject new
		at: 'expression' put: 'a';
		at: 'sync' put: true;
		context: context;
		yourself.
	result := self post: '/evaluations' with: evaluation.
	self
		assert: (result at: 'class') equals: 'SmallInteger';
		assert: (result at: 'printString') equals: '1' ]
		ensure: [ self delete: '/workspaces/' , id ]
]

{ #category : 'workspaces endpoints' }
EggBootstrapWebsideAPITest >> testWorkspaces [
	| id result |
	id := self post: '/workspaces'.
	[result := self get: '/workspaces'.
	self
		assert: (result anySatisfy: [:w | (w at: 'id') = id])]
		ensure: [ self delete: '/workspaces/' , id ]
]
