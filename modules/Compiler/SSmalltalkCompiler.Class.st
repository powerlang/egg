'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SSmalltalkCompiler category: #'Powerlang-Core-SCompiler-Smalltalk'!
Object subclass: #SSmalltalkCompiler
	instanceVariableNames: 'frontend source ast result headless blocks leaf activeScript'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk'!
!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
activate: aScriptNode while: aBlock
	| current |
	current := activeScript.
	activeScript := aScriptNode.
	aBlock value.
	activeScript := current
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
activeScope
	^activeScript scope
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
activeScript
	^activeScript
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
activeScript: aParseNode
	activeScript := aParseNode
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
assignmentNode
	^SAssignmentNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
ast
	^ast
! !

!SSmalltalkCompiler methodsFor:  'emitting' stamp: 'KenD 28/Jun/2026 13:27:40'!
blockCount
	^blocks
! !

!SSmalltalkCompiler methodsFor:  'emitting' stamp: 'KenD 28/Jun/2026 13:27:40'!
blockIndex
	blocks := blocks + 1.
	^blocks - 1
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
blockNode
	^SBlockNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
braceNode
	^SBraceNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildMethod
	result method: ast buildMethod
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
cascadeMessageNode
	^SCascadeMessageNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
cascadeNode
	^SCascadeNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
commentNode
	^SCommentNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
compilationError: aString stretch: aStretch
	^SCompilationError new
		compiler: self;
		stretch: aStretch;
		description: aString
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
compileMethod: aString
	source := aString.
	frontend protect: [
		self
			parseMethod;
			resolveSemantics;
			buildMethod].
	^result
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
delimiterToken
	^SDelimiterToken new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
endToken
	^SEndToken new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
error: aString at: anInteger
	| stretch |
	stretch := anInteger thru: anInteger.
	^self error: aString stretch: stretch
! !

!SSmalltalkCompiler methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
error: aString stretch: aStretch
	| error |
	error := self compilationError: aString stretch: aStretch.
	^error beFatal; signal
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
frontend
	^frontend
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
frontend: aCompiler
	frontend := aCompiler
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasBlocks
	^ blocks > 0
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasSends
^ leaf not
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
identifierNode
	^SIdentifierNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	self reset

! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
literalNode
	^SLiteralNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
messageNode
	^SMessageNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodNode
	^SMethodNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
noticeSend
	leaf := false
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
numericLiteralNode
	^SNumberNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
parseFragment
	headless := false.
	self reset.
	ast := self parser methodFragment.
	result ast: ast
! !

!SSmalltalkCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
parseFragment: aString
	source := aString.
	[self parseFragment; resolveSemantics] on: SCompilationError do: [].
	^ast
! !

!SSmalltalkCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
parseMethod
	headless := false.
	self reset.
	ast := self parser method.
	result ast: ast
! !

!SSmalltalkCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
parseMethod: aString
	source := aString.
	frontend protect: [self parseMethod; resolveSemantics].
	^result
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
parser
	^SSmalltalkParser new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
pragmaNode
	^SPragmaNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
reset
	self resetResult.
	leaf := true.
	blocks := 0.
! !

!SSmalltalkCompiler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
resetResult
	result := SCompilationResult new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolveSemantics
	ast acceptVisitor: SSemanticVisitor new
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
result
	^result
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
returnNode
	^SReturnNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scanner
	^SSmalltalkScanner new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
selectorNode
	^SSelectorNode new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sourceCode
	^source
! !

!SSmalltalkCompiler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sourceCode: aString
	source := aString
! !

!SSmalltalkCompiler methodsFor:  'nodes' stamp: 'KenD 28/Jun/2026 13:27:40'!
stringToken
	^SStringToken new compiler: self
! !

!SSmalltalkCompiler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
supportsBraceNodes
	^true
! !

!SSmalltalkCompiler methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
warning: aString at: aStretch
	| error |
	error := self compilationError: aString stretch: aStretch.
	error beWarning; signal
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSmalltalkCompiler class' category: #'Powerlang-Core-SCompiler-Smalltalk'!
SSmalltalkCompiler class
	instanceVariableNames: ''!


SSmalltalkCompiler initialize!

