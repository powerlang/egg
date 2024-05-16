Class {
	#name : #OptimizingJSCodeEmitter,
	#superclass : #AbstractJSFunctionEmitter,
	#instVars : [
		'ir',
		'names',
		'nextTemp'
	],
	#category : #'PowerlangJS-Core'
}

{ #category : #'own services' }
OptimizingJSCodeEmitter >> >> aString [
	stream nextPutAll: aString
]

{ #category : #'own services' }
OptimizingJSCodeEmitter >> >>> aString [
	stream tab: tabs; nextPutAll: aString
]

{ #category : #'own services' }
OptimizingJSCodeEmitter >> @ anOInstruction [
	^names at: anOInstruction
]

{ #category : #services }
OptimizingJSCodeEmitter >> generate [
	| signature |
	signature := self
		             methodSignature: method selector
		             arguments: method ast argumentNames.
	self >> String tab >> signature >> ' {' >> String cr.
	ir withSuccessorsPostOrder do: [ :bb | 
		bb instructionsDo: [ :inst | inst basicAcceptVisitor: self ] ].
	self >> String cr >> String tab >> '}' >> String cr >> String cr
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> initialize [
	names := IdentityDictionary new.
	tabs := 2.
	stream := '' writeStream.
	nextTemp := 1
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> ir: firstBlock [
	ir := firstBlock
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> name: anONode as: aString [
	names at: anONode put: aString
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> nextTempName [
	| name |
	name := 't', nextTemp asString.
	nextTemp := nextTemp +1.
	^name
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> result [
	^ stream contents
]

{ #category : #'own services' }
OptimizingJSCodeEmitter >> tabs [
	stream tab: tabs
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> visitLoad: anOLoadOperation [
	| base name |
    base := anOLoadOperation base.
    name := anOLoadOperation index.
    base isActivation ifFalse: [name := self @ base , '.', name].
	self name: anOLoadOperation as: name
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> visitLoadConstant: anOLoadConstant [
	| v json |
	v := anOLoadConstant value.
	v ifNil: [ ^ self name: anOLoadConstant as: 'null' ].
	v isCharacter ifTrue: [ v := v asString].
	json := 	STONJSON toString: v.
	self name: anOLoadConstant as: json 

]

{ #category : #accessing }
OptimizingJSCodeEmitter >> visitLoadImplicit: anOLoadImplicit [
	| name |
	name := anOLoadImplicit name.
	name = #activationRecord ifTrue: [ ^self ].
	self assert: name = #self.
	names at: anOLoadImplicit put: 'this'
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> visitMessageSend: anOMessageSend [
	| receiver arguments selector temp |
	temp := self nextTempName.
	self name: anOMessageSend as: temp.
	selector := self transpileSelector: anOMessageSend selector.
	receiver := self @ anOMessageSend receiver.
	arguments := String streamContents: [ :s | 
		             anOMessageSend arguments
			             do: [ :arg | s nextPutAll: self @ arg ]
			             separatedBy: [ s nextPutAll: ', ' ] ].
	self tabs >> temp >> ' = ' >> receiver >> '.' >> selector >> '('
	>> arguments >> ');' >> String cr
]

{ #category : #accessing }
OptimizingJSCodeEmitter >> visitReturn: anOReturnNode [
	self >>> 'return ' >> (self @ anOReturnNode source) >> ';'
]
