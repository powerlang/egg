'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!


!Species methodsFor:  '*Compiling' stamp: 'KenD 28/Jun/2026 13:27:40'!
compile: aString
	| method |
	method := SCompiler compile: aString in: self.
	method ifNotNil: [method install]
! !


