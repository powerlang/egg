"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'Timestamp class'}

{#category : '*STON'}
Timestamp class >> fromSton: stonReader [
	^self readFromIso8601: stonReader parseListSingleton readStream]

{#category : '*STON'}
Timestamp class >> year: yyyy
month: m
day: dd
hour: hh
minute: mm
second: ss
offset: h [
	^self
		newDay: dd
		month: m
		year: yyyy
		hours: hh
		minutes: mm
		seconds: ss
		milliseconds: 0
		offset: h * 60]

{#category : '*STON'}
Timestamp >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self listSingleton: self iso8601]

