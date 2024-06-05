Extension { #name : 'MCMethodDefinition' }

{ #category : '*Powerlang-Compatibility-Pharo' }
MCMethodDefinition >> addCodeSpecTo: module class: aClassSpec [
	| method species |
	species := classIsMeta ifTrue: [aClassSpec metaclass] ifFalse: [aClassSpec].
	method := MethodSpec new
		module: module;
		selector: self selector;
		classBinding: species;
		source: self source;
		category: self protocol.
	species addMethod: method

]
