"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Object class'}

{#category : '*STON'}
Object class >> fromSton: stonReader [
	^self new fromSton: stonReader; yourself]

{#category : '*STON'}
Object class >> stonAllInstVarNames [
	"Override to encode my instances using a custom set of instance variables or to define their order."
	
	^ self allInstVarNames ]

{#category : '*STON'}
Object class >> stonName [
	"Override to encode my instances using a different class name."
	
	^ self name]

{#category : '*STON'}
Object >> fromSton: aSTONReader [
	self class isVariable
		ifTrue: [
			aSTONReader
				error: 'custom #fromSton: implementation needed for variable/indexable class']
		ifFalse: [aSTONReader parseNamedInstVarsFor: self]]

{#category : '*STON'}
Object >> isStonReference [
	^false]

{#category : '*STON'}
Object >> stonOn: aSTONWriter [
	self class isVariable
		ifTrue: [
			aSTONWriter
				error: 'custom #stonOn: implementation needed for variable/indexable class']
		ifFalse: [aSTONWriter writeObject: self]]

{#category : '*STON'}
Object >> stonPostReferenceResolution [
	]

