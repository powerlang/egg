Class {
	#name : #BaselineOfOCompiler,
	#superclass : #BaselineOf,
	#category : #BaselineOfOCompiler
}

{ #category : #baselines }
BaselineOfOCompiler >> baseline: spec [
	<baseline>
	spec for: #common do: [
	
		spec package: 'OCompiler-Core'.

		spec package: 'OCompiler-Pharo'.
		spec package: 'OCompiler-Tests'.

		spec group: 'base' with: #('OCompiler-Pharo'
		                           'OCompiler-Core'
		                           'OCompiler-Tests').

		"default group: loaded when group is not specified"
		spec group: 'default' with: #('base').
	]
]
