Class {
	#name : #BaselineOfPowerlang,
	#superclass : #BaselineOf,
	#category : #BaselineOfPowerlang
}

{ #category : #accessing }
BaselineOfPowerlang >> baseline: spec [
	<baseline>
	spec for: #common do: [

		spec package: 'Powerlang-Compatibility-Pharo'.
		spec package: 'Powerlang-SCompiler'.
		spec package: 'Powerlang-Core' with: [
			spec requires: 'Powerlang-Compatibility-Pharo'.
			spec requires: 'Powerlang-SCompiler'.
		].
		spec package: 'Powerlang-SCompiler-Tests'.
		spec package: 'Powerlang-Tests'.
		spec package: 'Powerlang-TestsFailing'.

		"compiler group: just compiler and compiler tests"
		spec group: 'base-compiler' with: #(
											'Powerlang-Compatibility-Pharo'
											'Powerlang-SCompiler'
											'Powerlang-SCompiler-Tests').
		"base group: just core boostrapping code and tests"
		spec group: 'base' with: #(
											'Powerlang-Compatibility-Pharo'
											'Powerlang-SCompiler'
											'Powerlang-Core'
											'Powerlang-SCompiler-Tests'
											'Powerlang-Tests'
											'Powerlang-TestsFailing').

		"default group: loaded when group is not specified"
		spec group: 'default' with: #('base').
		self ocompiler: spec; powerlangjs: spec.
		
		spec package: 'Powerlang-UI' with: [
			spec requires: 'OCompiler-Core'
		].

		"devel group: base, tests and custom dev tools"
		spec group: 'devel' with: #('base' 'Powerlang-UI').

	].

]

{ #category : #accessing }
BaselineOfPowerlang >> ocompiler: spec [
		spec package: 'OCompiler-Pharo'.
		spec package: 'OCompiler-Core' with: [
			spec requires: 'OCompiler-Pharo'
		].
	
		spec package: 'OCompiler-Tests'.

		spec group: 'ocompiler' with: #('OCompiler-Pharo'
		                           'OCompiler-Core'
		                           'OCompiler-Tests').


]

{ #category : #accessing }
BaselineOfPowerlang >> powerlangjs: spec [
	spec package: 'PowerlangJS-Core' with: [
		spec requires: 'OCompiler-Core'.
		spec requires: 'Powerlang-Core'
	].

	spec package: 'PowerlangJS-Tests'.
	spec package: 'PowerlangJS-TestsFailing'.

	"powerlangjs group: transpiling and tests"
	spec
		group: 'powerlangjs'
		with:
		#('OCompiler-Pharo' 'OCompiler-Core' 'PowerlangJS-Core' 'PowerlangJS-Tests' 'PowerlangJS-TestsFailing').

]

{ #category : #accessing }
BaselineOfPowerlang >> repository [
	^ self packageRepositoryURL
]
