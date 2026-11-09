"
	Copyright (c) 2026, Javier Pimas.
	See (MIT) license in root directory.
"

Extension { #name : #KernelModule }

{ #category : #'*LMR' }
KernelModule >> os [
	^OSMemory current
]
