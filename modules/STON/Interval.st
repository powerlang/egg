"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Interval class'}

{#category : '*STON'}
Interval class >> fromSton: stonReader [
	^self new fromSton: stonReader; yourself]

{#category : '*STON'}
Interval >> fromSton: aSTONReader [
	aSTONReader parseNamedInstVarsFor: self]

{#category : '*STON'}
Interval >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self]

