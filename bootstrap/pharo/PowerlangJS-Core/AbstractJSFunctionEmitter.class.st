Class {
	#name : #AbstractJSFunctionEmitter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'method',
		'tabs',
		'currentBlock',
		'imports',
		'classMethod'
	],
	#category : #'PowerlangJS-Core'
}

{ #category : #visiting }
AbstractJSFunctionEmitter class >> translateIdentifier: aString [
	aString = 'arguments'
		ifTrue: [ ^ '_arguments' ].
	aString = 'class'
		ifTrue: [ ^ '_class' ].
	aString = 'Dictionary'
		ifTrue: [ ^ 'Map' ].
	aString = 'IdentityDictionary'
		ifTrue: [ ^ 'Map' ].
		
	aString = 'OrderedCollection'
		ifTrue: [ ^ 'Array' ].
	aString = 'ByteArray'
		ifTrue: [ ^ 'Array' ].
	aString = 'BlockClosure'
		ifTrue: [ ^ 'Function' ].
	^ aString
]

{ #category : #visiting }
AbstractJSFunctionEmitter >> isSpecialSelector: selector [
	"	^ #(ifTrue: ifFalse: #ifTrue:ifFalse: whileTrue whileFalse whileTrue: whileFalse:)"

	^ #(#bitsAt: + - * / & | << >> bitAnd: bitOr: ) includes: selector	" #(ifTrue: ifFalse:) includes: selector"
]

{ #category : #accessing }
AbstractJSFunctionEmitter >> method [
	^ method
]

{ #category : #accessing }
AbstractJSFunctionEmitter >> method: aCompiledMethod [ 
	method := aCompiledMethod 
]

{ #category : #private }
AbstractJSFunctionEmitter >> methodSignature: selector arguments: arguments [
	| translated tselector |
	tselector := self transpileSelector:  selector.
	^ String streamContents: [ :s | 
		  s
			  nextPutAll: tselector;
			  nextPutAll: '('.
		 arguments
			  do: [ :arg | 
				  translated := self translateIdentifier: arg.
				  s nextPutAll: translated ]
			  separatedBy: [ s nextPutAll: ', ' ].
		  s nextPutAll: ')' ]
]

{ #category : #visiting }
AbstractJSFunctionEmitter >> result [
	^stream contents
]

{ #category : #accessing }
AbstractJSFunctionEmitter >> translateIdentifier: aString [
	^self class translateIdentifier: aString
]

{ #category : #private }
AbstractJSFunctionEmitter >> transpileBinarySelector: selector [
	selector = #/
		ifTrue: [ ^ #_slash ].
	selector = #, ifTrue: [ ^#_comma ].
	selector = #!= ifTrue: [ ^#_notEqual ].
	selector = #= ifTrue: [ ^#_equal ].
	selector = #== ifTrue: [ ^#_equalEqual ].
	selector = #+ ifTrue: [ ^#_plus ].
	selector = #- ifTrue: [ ^#_minus ].
	selector = #* ifTrue: [ ^#_times ].
	selector = #// 	ifTrue: [ ^ #_integerQuotient ].
	selector = #< ifTrue: [ ^#_lessThan ].
	selector = #<= ifTrue: [ ^#_lessEqualThan ].
	selector = #> ifTrue: [ ^#_greaterThan ].
	selector = #>= ifTrue: [ ^#_greaterEqualThan ].
	selector = #| ifTrue: [ ^#_or ].
	selector = #-> ifTrue: [ ^#_arrow ].
	selector = #<< ifTrue: [ ^#_shiftLeft ].
	selector = #>> ifTrue: [ ^#_shiftRight ].
	selector = #\\ ifTrue: [ ^#_modulo ].


	self ASSERT: false
]

{ #category : #accessing }
AbstractJSFunctionEmitter >> transpileClassMethod [
	classMethod := true.
	self transpile
]

{ #category : #private }
AbstractJSFunctionEmitter >> transpileSelector: selector [
	selector isBinary ifTrue: [ ^ self transpileBinarySelector: selector ].
	selector isKeyword ifFalse: [ ^ selector ].
	^ String streamContents: [ :s | 
		  (selector findTokens: $:) do: [ :token | 
			  s nextPutAll: token; nextPut: $_ ] ]
]
