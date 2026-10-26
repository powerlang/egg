'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Object methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: aSTONReader
	self class isVariable
		ifTrue: [
			aSTONReader
				error: 'custom #fromSton: implementation needed for variable/indexable class']
		ifFalse: [aSTONReader parseNamedInstVarsFor: self]
! !

!Object methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStonReference
	^false
! !

!Object methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	self class isVariable
		ifTrue: [
			aSTONWriter
				error: 'custom #stonOn: implementation needed for variable/indexable class']
		ifFalse: [aSTONWriter writeObject: self]
! !

!Object methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonPostReferenceResolution
	
! !

!Object class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	^self new fromSton: stonReader; yourself
! !

!Object class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonAllInstVarNames
	"Override to encode my instances using a custom set of instance variables or to define their order."
	
	^ self allInstVarNames 
! !

!Object class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonName
	"Override to encode my instances using a different class name."
	
	^ self name
! !


