"
    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #STONModule,
	#superclass : #Module,
	#instVars : [],
	#category : #'STON'
}

{ #category : #spec }
STONModule >> imports [
	^{
		#Kernel -> {#Error. #Association. #Boolean. #ByteArray. #Closure. #Collection. #Date. #Dictionary. 
		#HashedCollection. #Integer. #Interval. #Module. #Number. #OrderedDictionary. #Point. #SequenceableCollection.
		#String. #Symbol. #Time. #Timestamp. #UndefinedObject. #IdentityDictionary. #MessageNotUnderstood}.
	}
] 
