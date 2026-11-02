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

{ #category : #accessing }
Thread class >> registeredInstances [
	"shortcut: no Thread objects yet, so the GC scans no thread-local storage;
	register threads once the launcher runs more than one, or keeps objects in TLS"
	^#()
]

