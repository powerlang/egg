Class {
	#name : 'SMethodNode',
	#superclass : 'SScriptNode',
	#instVars : [
		'selector',
		'pragma'
	],
	#category : 'Powerlang-SCompiler-Parser',
	#package : 'Powerlang-SCompiler',
	#tag : 'Parser'
}

{ #category : 'visiting' }
SMethodNode >> acceptVisitor: visitor [
	^visitor visitMethod: self
]

{ #category : 'parsing' }
SMethodNode >> buildMethod [
	| cm encoder treecodes |
	cm := self methodClass withAll: self literals.
	cm
		blockCount: compiler blockCount;
		tempCount: scope stackSize;
		argumentCount: arguments size;
		environmentCount: scope environmentSize;
		capturesSelf: scope capturesSelf;
		hasEnvironment: self needsEnvironment;
		hasFrame: self needsFrame;
		selector: self selector;
		source: compiler sourceCode;
		classBinding: compiler frontend classBinding.
	cm pragma: pragma.
	cm blocks do: [ :block | block method: cm ].
	encoder := TreecodeEncoder new method: cm.
	treecodes := self acceptVisitor: encoder.
	^ cm treecodes: treecodes
]

{ #category : 'parsing' }
SMethodNode >> captureHome [
	
]

{ #category : 'accessing' }
SMethodNode >> compiler: aSmalltalkCompiler [
	super compiler: aSmalltalkCompiler.
	scope := MethodScope new script: self.
	pragma := aSmalltalkCompiler pragmaNode
]

{ #category : 'private' }
SMethodNode >> environmentIndexOf: aParseNode [
	^nil
]

{ #category : 'inquiries' }
SMethodNode >> header [
	"
	(Object >> #printOn:) ast header
	"
	| interval |
	interval := selector stretch.
	arguments notEmpty
		ifTrue: [interval := interval start thru: arguments last stretch end].
	^compiler sourceCode copyFrom: interval start to: interval end
]

{ #category : 'testing' }
SMethodNode >> isHeadless [
	^selector isNil
]

{ #category : 'testing' }
SMethodNode >> isMethod [
	^true
]

{ #category : 'parsing' }
SMethodNode >> literals [
	| literals v l literalsWithClasses |
	literals := OrderedCollection new.
	pragma isUsed
		ifTrue: [ literals add: pragma type asSymbol; add: pragma name asSymbol].
	self
		nodesDo: [ :n | 
			n isLiteral
				ifTrue: [ v := n value.
					v isSmallInteger
						ifFalse: [ literals add: v ] ].
			n isMessageNode
				ifTrue: [ literals add: n symbol ].
			n isBraceNode
				ifTrue: [ n isLiteral
						ifTrue: [ self halt ]
						ifFalse: [ literals
								add: #Array;
								add: #new:;
								add: #at:put:;
								add: #yourself ] ].
			(n isIdentifier
				and: [ l := n binding literal.
					l notNil ])
				ifTrue: [ literals add: l ].
			(n isBlockNode andNot: [ n isInlined ])
				ifTrue: [ literals add: n buildBlock ] ].
	"Pharo thinks symbols and strings are the same. We disagree"
	literalsWithClasses := literals collect: [ :n | n -> n class ].
	literalsWithClasses removeDuplicates.
	^ literalsWithClasses collect: [ :n | n key ].
]

{ #category : 'parsing' }
SMethodNode >> methodClass [
	| type |
	type := pragma type.
	type = #callback
		ifTrue: [ ^ SCallbackMethod ].
	type = #cdecl
		ifTrue: [ ^ SCalloutMethod ].
	^ SCompiledMethod
]

{ #category : 'testing' }
SMethodNode >> needsEnvironment [
	^scope environmentSize > 0
		or: [children anySatisfy: [:block | block usesHome]]
]

{ #category : 'testing' }
SMethodNode >> needsFrame [
	scope stackSize > 0 ifTrue: [ ^ true ].
	arguments size > 16 ifTrue: [ ^ true ].
	compiler hasSends ifTrue: [ ^ true ].
	compiler hasBlocks ifTrue: [ ^ true ].
	^ false
]

{ #category : 'enumerating' }
SMethodNode >> nodesDo: aBlock includingDeclarations: aBoolean [
	super nodesDo: aBlock includingDeclarations: aBoolean.
	(aBoolean and: [selector notNil]) ifTrue: [aBlock value: selector]
]

{ #category : 'accessing' }
SMethodNode >> pragma [
	^pragma
]

{ #category : 'accessing' }
SMethodNode >> pragma: anObject [
	pragma := anObject
]

{ #category : 'accessing' }
SMethodNode >> realScript [
	^self
]

{ #category : 'accessing' }
SMethodNode >> selector [
	^selector value
]

{ #category : 'accessing' }
SMethodNode >> selector: aSelectorNode [
	selector := aSelectorNode
]

{ #category : 'accessing' }
SMethodNode >> selectorNode [
	^selector
]
