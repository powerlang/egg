"
It is a 16 bytes table contained inside the MBR, it's contents are:

Offset  Description                                                          				  Size
00h		Current State of Partition (00h=Inactive, 80h=Active)         				1 Byte
01h		Beginning of Partition - Head                                   				1 Byte
02h		Beginning of Partition - Cylinder/Sector (See Below)         				1 Word
04h		Type of Partition (See List Below)                            					1 Byte
05h		End of Partition - Head                                       					1 Byte
06h		End of Partition - Cylinder/Sector                                         		1 Word
08h		Number of Sectors Between the MBR and the First Sector in the Partition	1 Double Word
0Ch		Number of Sectors in the Partition                                           	1 Double Word



"
Class {
	#name : #PartitionRecord,
	#superclass : #Object,
	#instVars : [
		'bytes'
	],
	#category : #'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
PartitionRecord class >> partitionTypes [
	"source:
	http://home.teleport.com/~brainy/fat32.htm and
	http://www.win.tue.nl/~aeb/partitions/partition_types-1.html"
	
	| types |
	types := Dictionary new.
	types at: 16r00 put: #Unknown;
		at: 16r01 put: #FAT12;
		at: 16r04 put: #FAT16; "16-bit FAT (Partition Smaller than 32MB)"
		at: 16r05 put: #ExtendedMSDOS;
		at: 16r06 put: #FAT16Large; "16-bit FAT (Partition Larger than 32MB)"
		at: 16r0B put: #FAT32; "32-bit FAT (Partition Up to 2048GB)"
		at: 16r0C put: #FAT32LBA; "Same as 0BH, but uses LBA1 13h Extensions"
		at: 16r0E put: #FAT16LargeLBA; "Same as 06H, but uses LBA1 13h Extensions"
		at: 16r0F put: #ExtendedMSDOSLBA; "Same as 05H, but uses LBA1 13h Extensions"
		at: 16r83 put: #Linux. "Various filesystem types like xiafs, ext2, ext3, reiserfs, etc. all use ID 83".
		
	^types.
]

{ #category : #'as yet unclassified' }
PartitionRecord class >> with: anArray [
	anArray size ~= 16 ifTrue: [self error: 'Not a Partition Record'].
	^self new bytes: anArray.
]

{ #category : #'as yet unclassified' }
PartitionRecord >> active [
	"00h	Current State of Partition (00h=Inactive, 80h=Active) 		1 Byte"
	^(bytes byteAt: 1) = 16r80.
]

{ #category : #'as yet unclassified' }
PartitionRecord >> bytes: aByteArray [
	bytes := aByteArray.
]

{ #category : #'as yet unclassified' }
PartitionRecord >> decodedCylinderLow: encodedCylSecLow high: encodedCylSecHigh [
	"
	+ 15 14 13 12 11 10 9 8	|    7    6  	| 5 4 3 2 1 0	+
	|  Cylinder Bits 7 to 0	|  Cylinder	|   Sector 	|
	+ 						|   Bits 9+8	| Bits 5 to 0	+
	"
	^encodedCylSecHigh bitOr: ((encodedCylSecLow bitAnd: 16rC0) bitShift: 2).
]

{ #category : #'as yet unclassified' }
PartitionRecord >> decodedSector: encodedCylSec [
	"
	+ 15 14 13 12 11 10 9 8	|    7    6  	| 5 4 3 2 1 0	+
	|  Cylinder Bits 7 to 0	|  Cylinder	|   Sector 	|
	+ 						|   Bits 9+8	| Bits 5 to 0	+
	"
	^encodedCylSec bitAnd: 16r3F.
]

{ #category : #'as yet unclassified' }
PartitionRecord >> firstCylinder [
	"01h - Beginning of Partition - Cylinder/Sector - 2 Byte
	"
	^self decodedCylinderLow: (bytes byteAt: 3) high: (bytes byteAt: 4).
]

{ #category : #'as yet unclassified' }
PartitionRecord >> firstHead [
	"01h		Beginning of Partition - Head		1 Byte"
	^bytes byteAt: 2.
]

{ #category : #'as yet unclassified' }
PartitionRecord >> firstSector [
	"01h - Beginning of Partition - Cylinder/Sector - 2 Byte"
	^self decodedSector: (bytes byteAt: 3).
]

{ #category : #'as yet unclassified' }
PartitionRecord >> inactive [
	"00h	Current State of Partition (00h=Inactive, 80h=Active) 		1 Byte"
	^(bytes byteAt: 1) = 16r00.
]

{ #category : #'as yet unclassified' }
PartitionRecord >> numberOfSectors [
	"08h	Number of Sectors in the Partition.	1 Double Word"
	^bytes unsignedLongAt: 13.
]

{ #category : #'as yet unclassified' }
PartitionRecord >> offsetFromMBR [
	"08h	Number of Sectors Between the MBR and the First Sector in the Partition.	1 Double Word"
	^bytes unsignedLongAt: 9.
]

{ #category : #converting }
PartitionRecord >> partitionSegmentOn: aBlockDevice [

	^ aBlockDevice segmentFrom: self offsetFromMBR +1 size: self numberOfSectors
]

{ #category : #'as yet unclassified' }
PartitionRecord >> partitionType [
	"04h - Type of Partition - 1 Byte	"
		
	^self class partitionTypes at: (bytes byteAt: 5) ifAbsent: [ ^#unknown].
]
