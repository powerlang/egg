Extension { #name : #RGBehavior }

{ #category : #'*Powerlang-EggWebside' }
RGBehavior >> allSubclasses [
	| allSubclasses index |
	index := 1.
	allSubclasses := OrderedCollection withAll: self subclasses.
	[ index <= allSubclasses size ]
		whileTrue: [ allSubclasses addAll: (allSubclasses at: index) subclasses.
			index := index + 1 ].
	^ allSubclasses
]

{ #category : #'*Powerlang-EggWebside' }
RGBehavior >> asWebsideJson [
	^ super asWebsideJson
		at: 'name' put: self name;
		at: 'definition' put: self definition;
		at: 'superclass' put: (self superclass ifNotNil: [ :c | c name ]);
		at: 'comment' put: self comment asString;
		at: 'variable' put: self isVariable;
		at: 'project' put: self package name;
		yourself
]

{ #category : #'*Powerlang-EggWebside' }
RGBehavior >> withAllSubclasses [
	^ self allSubclasses
		add: self;
		yourself
]
