"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #CompiledMethod }

{ #category : '*SUnit' }
CompiledMethod >> isTest [
	^(class inheritsFrom: TestCase) and: [class isTestSelector: selector]
]

