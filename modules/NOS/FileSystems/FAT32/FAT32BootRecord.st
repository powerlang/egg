"
A FAT32BootRecord contains the description of a fat32 partition.
"
Class {
	#name : #FAT32BootRecord,
	#superclass : #Object,
	#instVars : [
		'bytes'
	],
	#category : #'SqueakNOS-Filesystems-FAT32'
}

{ #category : #'as yet unclassified' }
FAT32BootRecord class >> bytes: aByteArray [
	^self new bytes: aByteArray.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> bootRecordSignature [
	^bytes unsignedShortAt: 16r1FF.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> bootRecordSignature: anInteger [
	^ bytes unsignedShortAt: 16r1FF put: anInteger
]

{ #category : #accessing }
FAT32BootRecord >> bytes [
	"Answer the value of bytes"

	^ bytes
]

{ #category : #accessing }
FAT32BootRecord >> bytes: anObject [
	"Set the value of bytes"

	bytes := anObject
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> bytesPerSector [
	^bytes unsignedShortAt: 16r0C.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> bytesPerSector: anInteger [
	^ bytes unsignedShortAt: 16r0C put: anInteger 
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> clusterNumberOfStartOfRootDir [
	^bytes unsignedLongAt: 16r2D.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> clusterNumberOfStartOfRootDir: anInteger [
	^ bytes unsignedLongAt: 16r2D put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> executableCode: aString [
	Transcript show: 'complete this method (executableCode:)'
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> extendedSignature [
	^bytes unsignedByteAt: 16r43.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> extendedSignature: anInteger [
	^ bytes unsignedByteAt: 16r43 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> fatName [
	^(bytes copyFrom: 16r53 to: 16r5A) asString.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> fatName: aString [
	bytes replaceFrom: 16r53 to: 16r5A with: aString
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> flags [
	^bytes unsignedShortAt: 16r29.
]

{ #category : #'accessing structure variables' }
FAT32BootRecord >> flags: anInteger [
	^ bytes unsignedShortAt: 16r29 put: anInteger
]

{ #category : #initialization }
FAT32BootRecord >> initializeWithDefaultValues [
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
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> logicalDriveNumberOfPartition [
	^bytes unsignedByteAt: 16r41.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> logicalDriveNumberOfPartition: anInteger [
	^ bytes unsignedByteAt: 16r41 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> mediaDescriptor [
	^bytes unsignedByteAt: 16r16.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> mediaDescriptor: anInteger [
	^ bytes unsignedByteAt: 16r16 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfCopiesOfFAT [
	^bytes unsignedByteAt: 16r11.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfCopiesOfFAT: anInteger [
	^ bytes unsignedByteAt: 16r11 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfHeads [
	^bytes unsignedShortAt: 16r1B.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfHeads: anInteger [
	^ bytes unsignedShortAt: 16r1B put: anInteger 
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfHiddenSectors [
	^bytes unsignedLongAt: 16r1D.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfHiddenSectors: anInteger [
	^ bytes unsignedLongAt: 16r1D put: anInteger 
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfSectorsInPartition [
	^bytes unsignedLongAt: 16r21.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> numberOfSectorsInPartition: anInteger [
	^ bytes unsignedLongAt: 16r21 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> printOn: out [

	out nextPutAll: 'Boot sector named '; << self volumeNameOfPartition; cr.
	out nextPutAll: 'Bytes per sector: '; << self bytesPerSector; cr.
	out nextPutAll: 'Sectors per cluster: '; << self sectorsPerCluster; cr.
	out nextPutAll: 'Cluster number of start of root dir: '; << self clusterNumberOfStartOfRootDir; cr.
	out nextPutAll: 'Sectors per FAT: '; << self sectorsPerFAT; cr.
	out nextPutAll: 'Sectors per track: '; << self sectorsPerTrack; cr.
	out nextPutAll: 'Number of sectors in partition: '; << self numberOfSectorsInPartition; cr.
	out nextPutAll: 'Number of copies of FAT: '; << self numberOfCopiesOfFAT; cr.
	out nextPutAll: 'Reserved sectors: '; << self reservedSectors.
	
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> reservedSectors [
	^bytes unsignedShortAt: 16r0F.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> reservedSectors: anInteger [
	^ bytes unsignedShortAt: 16r0F put: anInteger 
	
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorNumberOfFSInformationSector [
	^bytes unsignedShortAt: 16r31.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorNumberOfFSInformationSector: anInteger [
	^ bytes unsignedShortAt: 16r31 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorsPerCluster [
	^bytes unsignedByteAt: 16rE.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorsPerCluster: anInteger [
	^ bytes unsignedByteAt: 16rE put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorsPerFAT [
	^bytes unsignedLongAt: 16r25.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorsPerFAT: anInteger [
	^ bytes unsignedLongAt: 16r25 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorsPerTrack [
	^bytes unsignedShortAt: 16r19.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> sectorsPerTrack: anInteger [
	^ bytes unsignedShortAt: 16r19 put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> serialNumberOfPartition [
	^bytes unsignedLongAt: 16r44.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> verifySignature [
	self bootRecordSignature = 16rAA55
		ifFalse: [ self error: 'This does not look as a FAT32 partition' ]
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> versionOfFAT32Drive [
	^bytes unsignedShortAt: 16r2B.
]

{ #category : #versions }
FAT32BootRecord >> versionOfFAT32Drive: anInteger [
	^ bytes unsignedShortAt: 16r2B put: anInteger
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> volumeNameOfPartition [
	^(bytes copyFrom: 16r48 to: 16r52) asString.
]

{ #category : #'as yet unclassified' }
FAT32BootRecord >> volumeNameOfPartition: aString [
	bytes replaceFrom: 16r48 to: 16r52 with: aString
]
