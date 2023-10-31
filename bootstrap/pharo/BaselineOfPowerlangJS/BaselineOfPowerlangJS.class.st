Class {
	#name : #BaselineOfPowerlangJS,
	#superclass : #BaselineOf,
	#category : #BaselineOfPowerlangJS
}

{ #category : #baselines }
BaselineOfPowerlangJS >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec baseline: 'OCompiler' with: [ 
			spec loads: 'default'.
			spec repository: 'github://powerlang/ocompiler:main' ].

		spec
			package: 'PowerlangJS-Core'
			with: [ spec requires: 'OCompiler' ].
		spec package: 'PowerlangJS-Tests'.
		spec package: 'PowerlangJS-TestsFailing'.

		"base group: just core boostrapping code and tests"
		spec
			group: 'base'
			with:
			#( 'PowerlangJS-Core' 'PowerlangJS-Tests' 'PowerlangJS-TestsFailing' ).

		"default group: loaded when group is not specified"
		spec group: 'default' with: #( 'base' ) ]
]
