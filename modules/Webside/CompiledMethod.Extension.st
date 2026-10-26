'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!


!CompiledMethod methodsFor:  '*webside' stamp: 'KenD 28/Jun/2026 13:32:24'!
asWebsideJson
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
! !

!CompiledMethod methodsFor:  '*webside' stamp: 'KenD 28/Jun/2026 13:32:24'!
needsRecompilation
	"FIXME: to be implemented"
	^false
! !


