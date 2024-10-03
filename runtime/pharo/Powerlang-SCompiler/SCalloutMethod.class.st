Class {
	#name : 'SCalloutMethod',
	#superclass : 'SCompiledMethod',
	#type : 'variable',
	#instVars : [
		'descriptor',
		'symbol',
		'address'
	],
	#category : 'Powerlang-SCompiler-Backend',
	#package : 'Powerlang-SCompiler',
	#tag : 'Backend'
}

{ #category : 'accessing' }
SCalloutMethod >> descriptor [
	^descriptor
]

{ #category : 'constants' }
SCalloutMethod >> isCalloutMethod [
	^ true
]

{ #category : 'constants' }
SCalloutMethod >> pragma: anSPragmaNode [
	descriptor := anSPragmaNode info.
	symbol := anSPragmaNode name
]

{ #category : 'accessing' }
SCalloutMethod >> symbol [
	^symbol
]
