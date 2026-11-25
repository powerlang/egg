'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Point methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: aSTONReader
	aSTONReader parseListDo: [:v :i | 
		i = 1 ifTrue: [x := v].
		i = 2 ifTrue: [y := v]]
! !

!Point methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: stonWriter
	stonWriter
		writeObject: self
		streamShortList: [:writer | writer add: x; add: y]
! !


