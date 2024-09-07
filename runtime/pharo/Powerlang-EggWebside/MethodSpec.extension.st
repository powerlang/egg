Extension { #name : 'MethodSpec' }

{ #category : '*Powerlang-EggWebside-Base' }
MethodSpec >> asWebsideJson [

	^ NeoJSONObject new
		  at: 'selector' put: self selector;
		  at: 'class' put: self classBinding name;
		  at: 'category' put: self category;
		  at: 'source' put: self sourceCode;
		  at: 'author' put: self author;
		  at: 'timestamp' put: self time asString;
		  at: 'overriding' put: false;
		  at: 'overriden' put: false;
		  yourself
]

{ #category : '*Powerlang-EggWebside-Base' }
MethodSpec >> author [
	^'no author'
]

{ #category : '*Powerlang-EggWebside-Base' }
MethodSpec >> time [
	^Time now
]
