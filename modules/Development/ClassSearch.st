"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassSearch, 
	#superclass : #CodeSearch, 
	#category : #Development
}

{#category : #services}
ClassSearch >> search [
	self reset.
	Kernel namespace keysAndValuesDo: [:name :global | 
		(global isClass and: [self includes: name])
			ifTrue: [results add: (CodeSearchResult class: global)]]
]

