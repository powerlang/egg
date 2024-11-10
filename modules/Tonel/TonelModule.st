Class {
	#name : #TonelModule,
	#superclass : #Module,
	#category : #Tonel
}

{ #category : #spec }
TonelModule >> imports [
	^{
		#STON -> #(#STONReader #STONWriter).
		#Compiler -> #(#SSmalltalkParser).
		#Kernel -> #(#OrderedDictionary)
	}
]