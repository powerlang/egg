Class {
	#name : #TonelModule,
	#superclass : #Module,
	#category : #Tonel
}

{ #category : #spec }
TonelModule >> imports [
	^{
		#STON -> #(#STONReader #STONWriter #STON).
		#Compiler -> #(#SSmalltalkParser).
		#Kernel -> #(#OrderedDictionary #ReadStream)
	}
]