Class {
	#name : #ProtoeggClass,
	#superclass : #ProtoeggSpecies,
	#category : #'Powerlang-Core-Execution-Bootstrap-Ring'
}

{ #category : #accessing }
ProtoeggClass >> allInstVarNames [
	^ (spec environment at: #Class)allInstVarNames, spec allInstVarNames
]

{ #category : #accessing }
ProtoeggClass >> computeAllSlotNames [
	| c |
	c := spec environment at: #Class.
	^slotNames := c allInstVarNames , spec allInstVarNames
]

{ #category : #accessing }
ProtoeggClass >> instanceSide [
	^ self
]

{ #category : #accessing }
ProtoeggClass >> name [
	^instanceSpec name
]

{ #category : #accessing }
ProtoeggClass >> namespaces [
	^ self slotNamed: #namespaces
]

{ #category : #accessing }
ProtoeggClass >> namespaces: array [
	^ self slotNamed: #namespaces put: array
]

{ #category : #accessing }
ProtoeggClass >> printOn: aStream [
	aStream
		nextPutAll: '<<';
		nextPutAll: self name asString;
		nextPutAll: '>>'
]

{ #category : #accessing }
ProtoeggClass >> withAllSuperclasses [
	^self superclass isNil ifTrue: [ OrderedCollection with: self ]
		ifFalse: [self superclass withAllSuperclasses
				addFirst: self;
				yourself ]
]
