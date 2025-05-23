Class {
	#name : #LookupLinker,
	#superclass : #MessageLinker,
	#instVars : [
		'lookup',
		'lookupSuper'
	],
	#category : #Nativization
}

{ #category : #nativizing }
LookupLinker >> emitSend: aSymbol using: anAssembler [
	| send |
	send := SendSite new lookup: aSymbol using: lookup.
	anAssembler
		loadAwithLiteral: send;
		callIndirectA;
		discardArguments: aSymbol arity.
	^send
]

{ #category : #nativizing }
LookupLinker >> emitSendSuper: aSymbol from: aClass using: anAssembler [
	| send behavior |
	send := SendSite new lookup: aSymbol using: lookupSuper; beSuperSend.
	behavior := aClass superclass map instanceBehavior.
	anAssembler
		loadAwithLiteral: send;
		loadTwithLiteral: behavior;
		callIndirectA;
		discardArguments: aSymbol arity.
	^send
]

{ #category : #accessing }
LookupLinker >> initializeFrom: anLMRModule [
	lookup := anLMRModule lookupStub.
	lookupSuper := anLMRModule lookupSuperStub.

]

{ #category : #accessing }
LookupLinker >> lookup: aByteArray [
	lookup := aByteArray
]

{ #category : #accessing }
LookupLinker >> lookupSuper: aByteArray [
	lookupSuper := aByteArray
]
