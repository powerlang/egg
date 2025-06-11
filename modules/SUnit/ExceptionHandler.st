"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #ExceptionHandler }

{ #category : '*SUnit' }
ExceptionHandler >> isSUnitHandler [
	^handlerBlock method selector beginsWith: 'sunit'
]

