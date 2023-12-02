"
The Master Boot Record is the same for pretty much all Operating Systems.  It is located on the first Sector of the Hard Drive, at Cylinder 0, Head 0, Sector 1.  It is the first piece of code that your computer runs after it has checked all of your hardware (POST) and turned control of loading software over the hard drive.

  It also contains the partition table, which defines the different sections of your hard drive.  Basically if anything happens to this little 512 byte section, your hard drive is brain dead. 

Offset				Description								   Size		
000h				Executable Code (Boots Computer)			446 Bytes
1BEh				1st Partition Entry (See Next Table)		16  Bytes
1CEh				2nd Partition Entry						16  Bytes
1DEh				3rd Partition Entry						16  Bytes
1EEh				4th Partition Entry						16  Bytes
1FEh				Boot Record Signature (55h AAh)			2   Bytes


"
Class {
	#name : #MasterBootRecord,
	#superclass : #Object,
	#instVars : [
		'bytes'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'instance creation' }
MasterBootRecord class >> on: bytes [
	bytes size ~= 512
		ifTrue: [ self error: 'Not a Master Boot Record' ].
	^ self new bytes: bytes
]

{ #category : #'as yet unclassified' }
MasterBootRecord >> bytes: aBytesArray [
	bytes := aBytesArray.
]

{ #category : #'as yet unclassified' }
MasterBootRecord >> offsetToPartition: aNumber sectorSize: aSectorSize [
	"Gets the partition record number aNumber. There are 4 of them, each occupies 16 bytes and
	 are placed in a table. aNumber can be 1, 2, 3 or 4.
	Result is 0-indexed"

	^ (self partitionRecord: aNumber) offsetFromMBR * (aSectorSize ifNil: [ 512 ])
]

{ #category : #'as yet unclassified' }
MasterBootRecord >> partitionRecord: index [
	"Gets the partition record number index. There are 4 of them, each occupies 16 bytes and
	 are placed in a table. index can be 1, 2, 3 or 4"

	| start |
	start := 447 + (16 * (index - 1)).
	^ PartitionRecord with: (bytes segmentFrom: start to: start + 15)
]
