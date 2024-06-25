"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #Thread,
	#superclass : #Object,
	#classVars : [
		'tlsGlobalDispatchCacheIndex'
	],
	#category : #Kernel
}

{ #category : #accessing }
Thread class >> currentGlobalLookup [
	^tlsGlobalDispatchCacheIndex _getThreadValue
]

