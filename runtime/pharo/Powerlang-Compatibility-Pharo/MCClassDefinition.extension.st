Extension { #name : 'MCClassDefinition' }

{ #category : '*Powerlang-Compatibility-Pharo' }
MCClassDefinition >> instancesAreArrayed [

	"
		compiledMethod type is a hack added to MCClassDefinition that
		overrides what the tonel definition states
	"

	^ type == #bytes
		  or: [ type == #variable ]
		  or: [ type == #compiledMethod ]
]

{ #category : '*Powerlang-Compatibility-Pharo' }
MCClassDefinition >> instancesHavePointers [

	^ type != #bytes
]
