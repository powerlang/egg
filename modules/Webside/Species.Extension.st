'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!


!Species methodsFor:  '*webside' stamp: 'KenD 28/Jun/2026 13:32:24'!
asWebsideJson
	^super asWebsideJson
		at: 'name' put: self name;
		at: 'definition' put: self definitionString;
		at: 'superclass'
		put: (self superclass ifNotNil: [:c | c name]);
		at: 'comment' put: self comment;
		at: 'variable' put: self isVariable;
		at: 'package' put: self module name;
		yourself
! !

!Species methodsFor:  '*webside' stamp: 'KenD 28/Jun/2026 13:32:24'!
definitionString
	^String streamContents: [:strm | self fileOutOn: strm]
! !


