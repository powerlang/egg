'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #FAT32ClusterRecord category: 'SqueakNOS-Filesystems-FAT32'!
Object subclass: #FAT32ClusterRecord
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems-FAT32'!
!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
attrib
	^ contents byteAtOffset: 16r0B
! !

!FAT32ClusterRecord methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
beEndOfDirectory
	contents byteAt: 1 put: 0
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents
	^ contents
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: bytes
	contents := bytes
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstCluster
	| hi lo |
	hi := contents unsignedShortAtOffset: 16r14.
	lo := contents unsignedShortAtOffset: 16r1A.
	^ lo + (hi bitShift: 16)
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstCluster: aNumber
	| hi lo |
	lo := aNumber bitAnd: 16rFFFF.
	hi := (aNumber bitShift: -16) bitAnd: 16rFFFF.
	contents
		unsignedShortAtOffset: 16r14 put: hi;
		unsignedShortAtOffset: 16r1A put: lo
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
free
	^ contents at: 1 put: self unusedByte
! !

!FAT32ClusterRecord methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDirectory
	^(self attrib bitAnd: 16) = 16
	
! !

!FAT32ClusterRecord methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isEndOfDirectory
	^(contents byteAt: 1) isZero
	
! !

!FAT32ClusterRecord methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isFile
	^(self attrib bitAnd: 16) = 0
! !

!FAT32ClusterRecord methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isInternal
	^self isDirectory and: [self name = '.' or: [self name = '..']]
	
! !

!FAT32ClusterRecord methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isUnused
	^(contents byteAt: 1) = 16rE5
	
! !

!FAT32ClusterRecord methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isVFat
	^(self attrib bitAnd: 15) = 15
	
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name
	| bytes name extension |
	bytes := contents asByteArray.
	name := (String new: 8)
		replaceFrom: 1
			to: 8
			with: bytes
			startingAt: 1;
		trimmed.
	extension := (String new: 3)
		replaceFrom: 1
			to: 3
			with: bytes
			startingAt: 9;
		trimmed.
	extension notEmpty
		ifTrue: [ extension := '.' , extension ].
	^ name , extension 
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name: aString
	aString size = 11 ifFalse: [self error: 'The string is not in a suitable format'].
	contents replaceFrom: 1 to: 11 with: aString asByteArray startingAt: 1
	

! !

!FAT32ClusterRecord methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	^aStream nextPutAll: self name
! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^contents unsignedLongAtOffset: 16r1C

! !

!FAT32ClusterRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: value
	^ contents unsignedLongAtOffset: 16r1C put: value
! !

!FAT32ClusterRecord methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:32:25'!
unusedByte
	^16rE5
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FAT32ClusterRecord class' category: 'SqueakNOS-Filesystems-FAT32'!
FAT32ClusterRecord class
	instanceVariableNames: ''!

!FAT32ClusterRecord class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: bytes
	^ self new contents: bytes
! !

!FAT32ClusterRecord class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
endOfDirectory
	^self contents: (self streamForEndOfDirectory)
	
! !

!FAT32ClusterRecord class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
named: aString firstCluster: aNumber
	^(self raw) name: aString; firstCluster: aNumber.
	
! !

!FAT32ClusterRecord class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
raw
	^self contents: (self streamForNewRecord)
	
! !

!FAT32ClusterRecord class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^32
! !

!FAT32ClusterRecord class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
streamForEndOfDirectory
	| contents |
	contents := ByteArray new: self size withAll: 0.
	^ReadWriteStream with: contents
! !

!FAT32ClusterRecord class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
streamForNewRecord
	| contents |
	contents := ByteArray new: self size withAll: 0.
	^ReadWriteStream with: contents.
	
! !


