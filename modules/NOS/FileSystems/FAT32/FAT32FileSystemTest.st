Class {
	#name : #FAT32FileSystemTest,
	#superclass : #TestCase,
	#instVars : [
		'device'
	],
	#category : 'SqueakNOS-Filesystems-FAT32'
}

{ #category : #helpers }
FAT32FileSystemTest >> memoryFilesystem [
	| memory |
	memory := ByteArray new: 40 * 1024 * 1024.
	^(FAT32FileSystem on: memory) format
]

{ #category : #helpers }
FAT32FileSystemTest >> standardChangesStream [
	^'testData/SqueakNos.changes' asFileReference	readStream
]

{ #category : #tests }
FAT32FileSystemTest >> test005Creation [
	self shouldnt: [self memoryFilesystem] raise: Error.

]

{ #category : #tests }
FAT32FileSystemTest >> test010BootRecord [
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
		
]

{ #category : #tests }
FAT32FileSystemTest >> test020EmptyRoot [
	| root |
	root := self memoryFilesystem root.
	self
		assert: root directories size equals: 0;
		assert: root files size equals: 0
]
