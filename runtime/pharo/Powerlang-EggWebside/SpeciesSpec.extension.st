Extension { #name : 'SpeciesSpec' }

{ #category : '*Powerlang-EggWebside-Base' }
SpeciesSpec >> asWebsideJson [

	^ super asWebsideJson
		  at: 'name' put: self name;
		  at: 'definition' put: self definition;
		  at: 'superclass' put: (self superclass ifNotNil: [ :c | c name ]);
		  at: 'comment' put: '';
		  at: 'variable' put: self isVariable;
		  at: 'project' put: module name;
		  yourself
]

{ #category : '*Powerlang-EggWebside-Base' }
SpeciesSpec >> definition [
	^self subclassResponsibility
]
