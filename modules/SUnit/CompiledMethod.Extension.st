'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!CompiledMethod methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
isTest
	^(class inheritsFrom: TestCase) and: [class isTestSelector: selector]
! !


