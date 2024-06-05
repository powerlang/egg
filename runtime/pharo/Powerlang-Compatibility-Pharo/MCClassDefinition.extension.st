Extension { #name : #MCClassDefinition }

{ #category : #'*Powerlang-Compatibility-Pharo' }
MCClassDefinition >> addCodeSpecTo: module [

	| class metaclass |
	class := ClassSpec new.
	metaclass := MetaclassSpec new
		             instanceClass: class;
		             module: module;
		             ivars: self classInstVarNames.
	class
		module: module;
		metaclass: metaclass;
		name: name;
		supername: superclassName;
		ivars: self instVarNames asOrderedCollection;
		cvars: self classVariables.
	self instancesAreArrayed ifTrue: [ class beArrayed ].
	self instancesHavePointers ifFalse: [ class beBytes ].
	^ module addClass: class
]

{ #category : #'*Powerlang-Compatibility-Pharo' }
MCClassDefinition >> instancesAreArrayed [

	"
		compiledMethod type is a hack added to MCClassDefinition that
		overrides what the tonel definition states
	"

	^ type == #bytes
		  or: [ type == #variable ]
		  or: [ type == #compiledMethod ]
]

{ #category : #'*Powerlang-Compatibility-Pharo' }
MCClassDefinition >> instancesHavePointers [

	^ type != #bytes
]
