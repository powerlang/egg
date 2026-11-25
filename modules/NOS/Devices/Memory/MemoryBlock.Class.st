'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #MemoryBlock category: 'SqueakNOS-Devices-Memory'!
Object subclass: #MemoryBlock
	instanceVariableNames: 'interval description'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Memory'!
!MemoryBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
description
	^description
! !

!MemoryBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
description: aString
	description := aString
! !

!MemoryBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
end
	^interval last
! !

!MemoryBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interval
	^interval
! !

!MemoryBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interval: anInterval
	interval := anInterval
! !

!MemoryBlock methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	^aStream nextPutAll: self interval first printString; nextPut: $-; nextPutAll: self interval last printString; nextPut: $(;nextPutAll: self description; nextPut: $)
! !

!MemoryBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
start
	^interval first
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MemoryBlock class' category: 'SqueakNOS-Devices-Memory'!
MemoryBlock class
	instanceVariableNames: ''!

!MemoryBlock class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
from: start to: end description: aString
	^self new interval: (Interval from: start to: end); description: aString
! !


