'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #DeviceStream category: 'SqueakNOS-FileSupport'!
ReadWriteStream subclass: #DeviceStream
	instanceVariableNames: 'device'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-FileSupport'!
!DeviceStream commentStamp: '<historical>' prior: 0!

a DeviceStream is a ReadWriteStream on top of a Device

a Device must understand
#next, #nextPut: , #reopen, #isOpen, #flush, #close, #dataAvailable
!

!DeviceStream methodsFor:  'fileIn/Out' stamp: 'KenD 28/Jun/2026 13:32:25'!
atEnd
	^ device isOpen not
! !

!DeviceStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	device close
! !

!DeviceStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
dataAvailable
	^ device dataAvailable
! !

!DeviceStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
device: aDevice
	device := aDevice
! !

!DeviceStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
flush
	device flush
! !

!DeviceStream methodsFor:  'fileIn/Out' stamp: 'KenD 28/Jun/2026 13:32:25'!
next
	^ device next
! !

!DeviceStream methodsFor:  'fileIn/Out' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger
	^ device next: anInteger
! !

!DeviceStream methodsFor:  'fileIn/Out' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: anObject
	^ device nextPut: anObject
! !

!DeviceStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reopen
	^ device reopen
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DeviceStream class' category: 'SqueakNOS-FileSupport'!
DeviceStream class
	instanceVariableNames: ''!

!DeviceStream class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aDevice
	^ self basicNew device: aDevice
! !


