'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Writer category: #Writer!
Object subclass: #Writer
	instanceVariableNames: 'stream objects mapping imports exports closure'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Writer'!
!Writer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022-2023, Javier Pimás.
    See (MIT) license in root directory.
!

!Writer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
closure: anObjectClosure
	closure := anObjectClosure
! !

!Writer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objects: aCollection
	objects := aCollection
! !

!Writer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapping: aDictionary
	mapping := aDictionary
! !

!Writer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports: anIdentityDictionary
	imports := anIdentityDictionary
! !

!Writer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
exports: aDictionary
	exports := aDictionary
! !

!Writer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
image
	^stream contents
! !

!Writer methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	stream := '' writeStream.
! !

!Writer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
stream: aWriteStream
	stream := aWriteStream
! !

!Writer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
write
	self subclassResponsibility
! !

!Writer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeTo: aStream
	self stream: aStream; write.
! !

!Writer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeToFile: filename
	filename binaryWriteStreamDo: [ :s | self writeTo: byteStream ]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Writer class' category: #Writer!
Writer class
	instanceVariableNames: ''!


Writer initialize!

