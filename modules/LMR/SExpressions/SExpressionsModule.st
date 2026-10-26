Class {
	#name : #SExpressionsModule,
	#superclass : #Module,
	#category : #SExpressions
}


{ #category : #spec }
SExpressionsModule >> imports [
	^{
	}
] 

{ #category : #bootstrapping }
SExpressionsModule >> justLoaded [
	super justLoaded.
	TreecodeDecoder initializePools; initializeBindingTypes; initializeNodeTypes
]
