'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ByteArrayOnBlockDevice category: 'SqueakNOS-Storage'!
ArrayedCollection subclass: #ByteArrayOnBlockDevice
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!ByteArrayOnBlockDevice commentStamp: '<historical>' prior: 0!

I look like a byte array, but map operations to an underlying block device.

People talk to me as if I were a byte array, but under the hood I transform operations to block device operations (remember that block devices have a 512 byte granularity).
!

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	^self byteAt: anInteger
! !

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger put: byte
	^self byteAt: anInteger put: byte
! !

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index
	^contents byteAt: index
! !

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index put: value
	^contents byteAt: index put: value
! !

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: aBlockStorage
	contents := aBlockStorage
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
copyToMemory
	| sectors |
	sectors := 256 * 1024. "should use 'device size' after checking ATADevices answer correctly to 'size'"
	
	^ contents from: 1 to: sectors
! !

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
segmentFrom: start to: end
	^ByteArraySegment on: self from: start to: end
! !

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ contents sizeInBytes 
! !

!ByteArrayOnBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
species
	^ByteArray
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedByteAt: byteIndex put: value
	contents unsignedByteAt: byteIndex + offset put: value
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAt: byteIndex
	^ contents unsignedLongAt: byteIndex
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAt: byteIndex put: value
	contents unsignedLongAt: byteIndex put: value
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAtOffset: byteOffset
	^ self unsignedLongAt: byteOffset + 1
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAtOffset: byteOffset put: value
	^ self unsignedLongAt: byteOffset + 1 put: value
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: byteIndex
	^ contents unsignedShortAt: byteIndex
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: byteIndex put: value
	contents unsignedShortAt: byteIndex put: value
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAtOffset: byteOffset
	^self unsignedShortAt: byteOffset + 1
! !

!ByteArrayOnBlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAtOffset: byteOffset put: value
	^ self unsignedShortAt: byteOffset + 1 put: value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ByteArrayOnBlockDevice class' category: 'SqueakNOS-Storage'!
ByteArrayOnBlockDevice class
	instanceVariableNames: ''!

!ByteArrayOnBlockDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aBlockStorage

	^self new contents: aBlockStorage
! !


