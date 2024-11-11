Class {
	#name : 'EggMethodWrapper',
	#superclass : 'EggObjectWrapper',
	#category : 'Powerlang-EggWebside-Base',
	#package : 'Powerlang-EggWebside',
	#tag : 'Base'
}

{ #category : 'converting' }
EggMethodWrapper >> asWebsideJson [

	^ super asWebsideJson
		  at: 'selector' put: self selector;
		  at: 'methodClass' put: self classBinding name;
		  at: 'category' put: self category asString wrappee asLocalString;
		  at: 'source' put: self sourceCode;
		  at: 'author' put: self author wrappee asLocalString;
		  at: 'timestamp' put: self timestamp  asString wrappee asLocalString;
		  at: 'overriding' put: false;
		  at: 'overriden' put: false;
		  yourself
]

{ #category : 'inquiries' }
EggMethodWrapper >> selector [
	^ super selector ifNotNil: [ :s | s wrappee asLocalString] 
]

{ #category : 'inquiries' }
EggMethodWrapper >> sourceCode [
	| source |
	source := self sourceObject wrappee.
	^source = runtime nil ifTrue: ['no source'] ifFalse: [source asLocalString]
]
