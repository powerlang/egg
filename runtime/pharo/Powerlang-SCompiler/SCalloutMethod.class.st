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

{ #category : 'constants' }
SCalloutMethod >> pragma: anSPragmaNode [
	descriptor := anSPragmaNode info.
	symbol := anSPragmaNode name
]
