'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RecordRoute category: 'SqueakNOS-Net-Options-IP'!
IPOption subclass: #RecordRoute
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Options-IP'!
!RecordRoute methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: anInternetAddress
	self length - 4 > self pointer ifFalse: [^ self].
	1 to: 4 do: [ :each | self at: self pointer + each - 1 put: (anInternetAddress at: each)].
	self pointer: self pointer + 4.
	^ anInternetAddress
! !

!RecordRoute methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
addresses
	^ (4 to: self pointer by: 4) collect: [ :each | InternetAddress bytes: (self copyFrom: each to: each + 4)]
! !

!RecordRoute methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name
	^ 'RecordRoute'
! !

!RecordRoute methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pointer
	^ self at: 3
! !

!RecordRoute methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pointer: anInteger
	self at: 3 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RecordRoute class' category: 'SqueakNOS-Net-Options-IP'!
RecordRoute class
	instanceVariableNames: ''!

!RecordRoute class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 7
! !


