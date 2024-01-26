"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STONMapWriter, 
	#superclass : #STONStreamWriter, 
	#category : #STON
}

{#category : #accessing}
STONMapWriter >> comma [
	writer comma; cr
]

