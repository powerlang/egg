'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #FAT32BootRecord category: 'SqueakNOS-Filesystems-FAT32'!
Object subclass: #FAT32BootRecord
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems-FAT32'!
!FAT32BootRecord commentStamp: '<historical>' prior: 0!

A FAT32BootRecord contains the description of a fat32 partition.
!

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
bootRecordSignature
	^bytes unsignedShortAt: 16r1FF.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
bootRecordSignature: anInteger
	^ bytes unsignedShortAt: 16r1FF put: anInteger
! !

!FAT32BootRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes
	"Answer the value of bytes"

	^ bytes
! !

!FAT32BootRecord methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: anObject
	"Set the value of bytes"

	bytes := anObject
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesPerSector
	^bytes unsignedShortAt: 16r0C.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesPerSector: anInteger
	^ bytes unsignedShortAt: 16r0C put: anInteger 
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterNumberOfStartOfRootDir
	^bytes unsignedLongAt: 16r2D.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterNumberOfStartOfRootDir: anInteger
	^ bytes unsignedLongAt: 16r2D put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
executableCode: aString
	Transcript show: 'complete this method (executableCode:)'
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
extendedSignature
	^bytes unsignedByteAt: 16r43.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
extendedSignature: anInteger
	^ bytes unsignedByteAt: 16r43 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
fatName
	^(bytes copyFrom: 16r53 to: 16r5A) asString.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
fatName: aString
	bytes replaceFrom: 16r53 to: 16r5A with: aString
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
flags
	^bytes unsignedShortAt: 16r29.
! !

!FAT32BootRecord methodsFor:  'accessing structure variables' stamp: 'KenD 28/Jun/2026 13:32:25'!
flags: anInteger
	^ bytes unsignedShortAt: 16r29 put: anInteger
! !

!FAT32BootRecord methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initializeWithDefaultValues
	self
		bytesPerSector: 512;
		sectorsPerCluster: 1;
		reservedSectors: 16r20;
		numberOfCopiesOfFAT: 2;
		mediaDescriptor: 16rF8;
		sectorsPerTrack: 16r20;
		numberOfHeads: 64;
		numberOfHiddenSectors: 16r20;
		sectorsPerFAT: 16r020C;
		flags: 0;
		versionOfFAT32Drive: 0;
		clusterNumberOfStartOfRootDir: 2;
		sectorNumberOfFSInformationSector: 1;
		logicalDriveNumberOfPartition: 16r80;
		extendedSignature: 16r29;
		volumeNameOfPartition: 'NO NAME    ';
		fatName: 'FAT32   ';
		executableCode: '0';
		bootRecordSignature: 16rAA55
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
logicalDriveNumberOfPartition
	^bytes unsignedByteAt: 16r41.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
logicalDriveNumberOfPartition: anInteger
	^ bytes unsignedByteAt: 16r41 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
mediaDescriptor
	^bytes unsignedByteAt: 16r16.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
mediaDescriptor: anInteger
	^ bytes unsignedByteAt: 16r16 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfCopiesOfFAT
	^bytes unsignedByteAt: 16r11.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfCopiesOfFAT: anInteger
	^ bytes unsignedByteAt: 16r11 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfHeads
	^bytes unsignedShortAt: 16r1B.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfHeads: anInteger
	^ bytes unsignedShortAt: 16r1B put: anInteger 
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfHiddenSectors
	^bytes unsignedLongAt: 16r1D.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfHiddenSectors: anInteger
	^ bytes unsignedLongAt: 16r1D put: anInteger 
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfSectorsInPartition
	^bytes unsignedLongAt: 16r21.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfSectorsInPartition: anInteger
	^ bytes unsignedLongAt: 16r21 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: out

	out nextPutAll: 'Boot sector named '; << self volumeNameOfPartition; cr.
	out nextPutAll: 'Bytes per sector: '; << self bytesPerSector; cr.
	out nextPutAll: 'Sectors per cluster: '; << self sectorsPerCluster; cr.
	out nextPutAll: 'Cluster number of start of root dir: '; << self clusterNumberOfStartOfRootDir; cr.
	out nextPutAll: 'Sectors per FAT: '; << self sectorsPerFAT; cr.
	out nextPutAll: 'Sectors per track: '; << self sectorsPerTrack; cr.
	out nextPutAll: 'Number of sectors in partition: '; << self numberOfSectorsInPartition; cr.
	out nextPutAll: 'Number of copies of FAT: '; << self numberOfCopiesOfFAT; cr.
	out nextPutAll: 'Reserved sectors: '; << self reservedSectors.
	
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
reservedSectors
	^bytes unsignedShortAt: 16r0F.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
reservedSectors: anInteger
	^ bytes unsignedShortAt: 16r0F put: anInteger 
	
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorNumberOfFSInformationSector
	^bytes unsignedShortAt: 16r31.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorNumberOfFSInformationSector: anInteger
	^ bytes unsignedShortAt: 16r31 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerCluster
	^bytes unsignedByteAt: 16rE.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerCluster: anInteger
	^ bytes unsignedByteAt: 16rE put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerFAT
	^bytes unsignedLongAt: 16r25.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerFAT: anInteger
	^ bytes unsignedLongAt: 16r25 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerTrack
	^bytes unsignedShortAt: 16r19.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerTrack: anInteger
	^ bytes unsignedShortAt: 16r19 put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
serialNumberOfPartition
	^bytes unsignedLongAt: 16r44.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
verifySignature
	self bootRecordSignature = 16rAA55
		ifFalse: [ self error: 'This does not look as a FAT32 partition' ]
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
versionOfFAT32Drive
	^bytes unsignedShortAt: 16r2B.
! !

!FAT32BootRecord methodsFor:  'versions' stamp: 'KenD 28/Jun/2026 13:32:25'!
versionOfFAT32Drive: anInteger
	^ bytes unsignedShortAt: 16r2B put: anInteger
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
volumeNameOfPartition
	^(bytes copyFrom: 16r48 to: 16r52) asString.
! !

!FAT32BootRecord methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
volumeNameOfPartition: aString
	bytes replaceFrom: 16r48 to: 16r52 with: aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FAT32BootRecord class' category: 'SqueakNOS-Filesystems-FAT32'!
FAT32BootRecord class
	instanceVariableNames: ''!

!FAT32BootRecord class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	^self new bytes: aByteArray.
! !


