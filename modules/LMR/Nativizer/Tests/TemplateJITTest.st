Class {
	#name : #TemplateJIT,
	#superclass : #Object,
	#instVars : [
		'environment'
	]
	#category : #'Nativization-Tests'
}

{ #category : #'instance creation' }
TemplateJITTest >> nativize: aCompiledMethod [
	^ NativizationEnvironment forTesting newTemplateJIT
		nativize: aCompiledMethod
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyFor: aCompiledMethod [
	^ NativizationEnvironment forTesting
		newTemplateJIT nativize: aCompiledMethod
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForBlock [
	^self assemblyForSource: 'foo [1] value'
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForIfTrue [
	^self assemblyForSource: 'foo x ifTrue: [1]' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForMessage [
	^self assemblyForSource: 'foo self bar'
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForMessageCascade [
	^self assemblyForSource: 'foo self bar; baz'
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForMethod: aCompiledMethod [

^	self
		assemblyForSource: aCompiledMethod sourceCode
		in: aCompiledMethod classBinding value.

]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForPoint_1_plus_y [
	^self assemblyForSource: 'foo 1 + y' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForPoint_ret_x_eq_1 [
	^ self assemblyForSource: 'foo ^x = 1' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForPoint_x [
	^ self assemblyForMethod: Point >> #x
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForPoint_x_eq_1 [
	^self assemblyForSource: 'foo x = 1' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForPoint_x_eq_eq_1 [
	^self assemblyForSource: 'foo x == 1' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForPoint_x_plus_1 [
	^self assemblyForSource: 'foo x + 1' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForPoint_x_plus_y [
	^self assemblyForSource: 'foo x + y' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForSource: aString [
	^self assemblyForSource: aString in: UndefinedObject
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForSource: aString in: aSpecies [
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self assemblyFor: method
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForSourceOrig: aString [
	^self assemblyForSourceOrig: aString in: UndefinedObject
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForSourceOrig: aString in: aSpecies [
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self assemblyOrigFor: method
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyForWhileTrue [
	^self assemblyForSource: 'foo [x := x + 1. true] whileTrue' in: Point
]

{ #category : #'instance creation' }
TemplateJITTest >> assemblyOrigFor: aCompiledMethod [
	^ NativizationEnvironment forTesting nativize:
		  aCompiledMethod
]

{ #category : #'instance creation' }
TemplateJITTest >> methodBasicAdd [
	| source |
	source := 'basicAdd: anObject
	end = contents size ifTrue: [self makeRoomBehind].
	end := end + 1.
	contents at: end put: anObject.
	^anObject'.
	^self methodForSource: source in: OrderedCollection
]

{ #category : #'instance creation' }
TemplateJITTest >> methodForSource: aString [
	^self methodForSource: aString in: UndefinedObject
]

{ #category : #'instance creation' }
TemplateJITTest >> methodForSource: aString in: aSpecies [
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self nativize: method
]

{ #category : #'instance creation' }
TemplateJITTest >> methodWithBlock [
	^self methodForSource: 'foo [1] value'
]
