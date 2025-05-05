"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #CompiledMethod }

{ #category : #'*webside' }
CompiledMethod >> asWebsideJson [
	| json status |
	json := super asWebsideJson.
	json
		at: 'selector' put: selector;
		at: 'methodClass' put: class name;
		at: 'category' put: self category;
		at: 'source' put: self sourceObject;
		at: 'author' put: self author;
		at: 'timestamp' put: self timestamp;
		at: 'package' put: self module name;
		at: 'needsRecompilation' put: self needsRecompilation.
	"self isTest ifTrue: [
		status := self propertyAt: #status ifAbsent: ['unknown'].
		json at: 'status' put: status asString]."
	^json
]

{ #category : #'*webside' }
CompiledMethod >> needsRecompilation [
	"FIXME: to be implemented"
	^false
]
