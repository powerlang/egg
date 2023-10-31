"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Symbol }

{ #category : #private }
Symbol >> flushCacheFor: species [
	GlobalDispatchCache current flush: self forSpecies: species.
	SendSite flush: self
]

