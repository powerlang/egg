Class {
	#name : #SExpressionsModule,
	#superclass : #Module,
	#instVars : [
		'globals',
		'memory'
	],
	#category : #'Powerlang-Core-LMR'
}


{ #category : #spec }
SExpressionsModule >> imports [
	^{
	}
] 

{ #category : #bootstrapping }
SExpressionsModule >> justLoaded [
	TreecodeDecoder initializePools; initializeBindingTypes; initializeNodeTypes
]
