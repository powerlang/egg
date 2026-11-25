'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #FAT32FileSystemTest category: 'SqueakNOS-Filesystems-FAT32'!
TestCase subclass: #FAT32FileSystemTest
	instanceVariableNames: 'device'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems-FAT32'!
!FAT32FileSystemTest methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
memoryFilesystem
	| memory |
	memory := ByteArray new: 40 * 1024 * 1024.
	^(FAT32FileSystem on: memory) format
! !

!FAT32FileSystemTest methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
standardChangesStream
	^'testData/SqueakNos.changes' asFileReference	readStream
! !

!FAT32FileSystemTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
test005Creation
	self shouldnt: [self memoryFilesystem] raise: Error.

! !

!FAT32FileSystemTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
test010BootRecord
	| br |
	br := self memoryFilesystem bootRecord.
	self assert: br bytesPerSector = 512;
		assert: br sectorsPerCluster = 1;
		assert: br reservedSectors = 16r20;
		assert: br numberOfCopiesOfFAT = 2;
		assert: br mediaDescriptor = 16rF8;
		assert: br sectorsPerTrack = 16r20;
		assert: br numberOfHeads = 64;
"		assert: br numberOfHiddenSectors = 16r20;"
"		assert: br numberOfSectorsInPartition = 16r0107E0;"
"		assert: br sectorsPerFAT = 16r020C;"
		assert: br flags = 0;
		assert: br versionOfFAT32Drive = 0;
		assert: br clusterNumberOfStartOfRootDir = 2;
		assert: br sectorNumberOfFSInformationSector = 1;
		assert: br logicalDriveNumberOfPartition = 16r80;
		assert: br extendedSignature = 16r29;
		assert: br volumeNameOfPartition = 'NO NAME    ';
		assert: br fatName = 'FAT32   ';
		"assert: br executableCode = ;"
		assert: br bootRecordSignature = 16rAA55.
		
! !

!FAT32FileSystemTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
test020EmptyRoot
	| root |
	root := self memoryFilesystem root.
	self
		assert: root directories size equals: 0;
		assert: root files size equals: 0
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FAT32FileSystemTest class' category: 'SqueakNOS-Filesystems-FAT32'!
FAT32FileSystemTest class
	instanceVariableNames: ''!


