"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Character class'}

{#category : '*STON'}
Character class >> fromSton: stonReader [
	^ stonReader parseListSingleton first]

{#category : '*STON'}
Character >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self listSingleton: self asString]

