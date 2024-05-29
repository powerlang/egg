Extension { #name : #RGMethod }

{ #category : #'*Powerlang-EggWebside' }
RGMethod >> asWebsideJson [
	^ NeoJSONObject new
		at: 'selector' put: self selector;
		at: 'class' put: self methodClass name;
		at: 'category' put: self category;
		at: 'source' put: self sourceCode;
		at: 'author' put: self author;
		at: 'timestamp' put: self time asString;
		at: 'overriding' put: false;
		at: 'overriden' put: false;
		yourself
]
