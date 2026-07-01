'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPEndOfInputParser category: #Parsers!
PPDelegateParser subclass: #PPEndOfInputParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPEndOfInputParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPEndOfInputParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
end
	^ self
! !

!PPEndOfInputParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| position result |
	position := aStream position.
	result := parser parseOn: aStream.
	(result isPetitFailure or: [aStream atEnd]) ifTrue: [^result].
	result := PPFailure message: 'end of input expected' from: aStream.
	aStream position: position.
	^aStream failure
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPEndOfInputParser class' category: #Parsers!
PPEndOfInputParser class
	instanceVariableNames: ''!


