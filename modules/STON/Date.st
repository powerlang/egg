"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Date class'}

{#category : '*STON'}
Date class >> fromSton: stonReader [
	^self yyyymmdd: stonReader parseListSingleton
]

{#category : '*STON'}
Date >> stonOn: stonWriter [
	stonWriter writeObject: self listSingleton: self yyyymmdd
]

