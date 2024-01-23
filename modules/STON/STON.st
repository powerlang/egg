"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STON, 
	#superclass : #Object, 
	#category : #STON
}

{#category : #accessing}
STON class >> associationClass [
	^ Association]

{#category : #accessing}
STON class >> classNameKey [
	^ #className]

{#category : #convencience}
STON class >> fromStream: readStream [
	^ (self reader on: readStream) next]

{#category : #convencience}
STON class >> fromString: string [
	^ self fromStream: string readStream]

{#category : #accessing}
STON class >> jsonWriter [
	^STONWriter new jsonMode: true]

{#category : #accessing}
STON class >> listClass [
	^Array]

{#category : #accessing}
STON class >> mapClass [
	^Dictionary]

{#category : #convencience}
STON class >> put: object asJsonOnStream: stream [
	self jsonWriter on: stream; nextPut: object]

{#category : #convencience}
STON class >> put: object asJsonOnStreamPretty: stream [
	self jsonWriter on: stream; nextPut: object]

{#category : #convencience}
STON class >> put: object onStream: stream [
	(self writer on: stream) nextPut: object]

{#category : #convencience}
STON class >> put: object onStreamPretty: stream [
	self writer on: stream; nextPut: object]

{#category : #accessing}
STON class >> reader [
	^ STONReader new]

{#category : #convencience}
STON class >> toJsonString: object [
	^String streamContents: [:stream | self put: object asJsonOnStream: stream]]

{#category : #convencience}
STON class >> toJsonStringPretty: object [
	^ String streamContents: [ :stream |
		self put: object asJsonOnStreamPretty: stream ]]

{#category : #convencience}
STON class >> toString: object [
	^ String streamContents: [ :stream |
		self put: object onStream: stream ]]

{#category : #convencience}
STON class >> toStringPretty: object [
	^ String streamContents: [ :stream |
		self put: object onStreamPretty: stream ]]

{#category : #accessing}
STON class >> writer [
	^ STONWriter new]

