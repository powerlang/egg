"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STONJSON, 
	#superclass : #Object, 
	#category : #STON
}

{#category : #convenience}
STONJSON class >> fromStream: stream [
	^ STON fromStream: stream
]

{#category : #convenience}
STONJSON class >> fromString: string [
	^ STON fromString: string
]

{#category : #convenience}
STONJSON class >> put: object onStream: stream [
	STON put: object asJsonOnStream: stream
]

{#category : #convenience}
STONJSON class >> put: object onStreamPretty: stream [
	STON put: object asJsonOnStreamPretty: stream
]

{#category : #convenience}
STONJSON class >> toString: object [
	^ STON toJsonString: object
]

{#category : #convenience}
STONJSON class >> toStringPretty: object [
	^ STON toJsonStringPretty: object
]

