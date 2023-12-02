Class {
	#name : #FAT32ClusterRecord,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#category : 'SqueakNOS-Filesystems-FAT32'
}

{ #category : #'instance creation' }
FAT32ClusterRecord class >> contents: bytes [
	^ self new contents: bytes
]

{ #category : #'instance creation' }
FAT32ClusterRecord class >> endOfDirectory [
	^self contents: (self streamForEndOfDirectory)
	
]

{ #category : #'instance creation' }
FAT32ClusterRecord class >> named: aString firstCluster: aNumber [
	^(self raw) name: aString; firstCluster: aNumber.
	
]

{ #category : #'instance creation' }
FAT32ClusterRecord class >> raw [
	^self contents: (self streamForNewRecord)
	
]

{ #category : #'instance creation' }
FAT32ClusterRecord class >> size [
	^32
]

{ #category : #'instance creation' }
FAT32ClusterRecord class >> streamForEndOfDirectory [
	| contents |
	contents := ByteArray new: self size withAll: 0.
	^ReadWriteStream with: contents
]

{ #category : #'instance creation' }
FAT32ClusterRecord class >> streamForNewRecord [
	| contents |
	contents := ByteArray new: self size withAll: 0.
	^ReadWriteStream with: contents.
	
]

{ #category : #accessing }
FAT32ClusterRecord >> attrib [
	^ contents byteAtOffset: 16r0B
]

{ #category : #testing }
FAT32ClusterRecord >> beEndOfDirectory [
	contents byteAt: 1 put: 0
]

{ #category : #accessing }
FAT32ClusterRecord >> contents [
	^ contents
]

{ #category : #accessing }
FAT32ClusterRecord >> contents: bytes [
	contents := bytes
]

{ #category : #accessing }
FAT32ClusterRecord >> firstCluster [
	| hi lo |
	hi := contents unsignedShortAtOffset: 16r14.
	lo := contents unsignedShortAtOffset: 16r1A.
	^ lo + (hi bitShift: 16)
]

{ #category : #accessing }
FAT32ClusterRecord >> firstCluster: aNumber [
	| hi lo |
	lo := aNumber bitAnd: 16rFFFF.
	hi := (aNumber bitShift: -16) bitAnd: 16rFFFF.
	contents
		unsignedShortAtOffset: 16r14 put: hi;
		unsignedShortAtOffset: 16r1A put: lo
]

{ #category : #accessing }
FAT32ClusterRecord >> free [
	^ contents at: 1 put: self unusedByte
]

{ #category : #testing }
FAT32ClusterRecord >> isDirectory [
	^(self attrib bitAnd: 16) = 16
	
]

{ #category : #testing }
FAT32ClusterRecord >> isEndOfDirectory [
	^(contents byteAt: 1) isZero
	
]

{ #category : #testing }
FAT32ClusterRecord >> isFile [
	^(self attrib bitAnd: 16) = 0
]

{ #category : #testing }
FAT32ClusterRecord >> isInternal [
	^self isDirectory and: [self name = '.' or: [self name = '..']]
	
]

{ #category : #testing }
FAT32ClusterRecord >> isUnused [
	^(contents byteAt: 1) = 16rE5
	
]

{ #category : #testing }
FAT32ClusterRecord >> isVFat [
	^(self attrib bitAnd: 15) = 15
	
]

{ #category : #accessing }
FAT32ClusterRecord >> name [
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
]

{ #category : #accessing }
FAT32ClusterRecord >> name: aString [
	aString size = 11 ifFalse: [self error: 'The string is not in a suitable format'].
	contents replaceFrom: 1 to: 11 with: aString asByteArray startingAt: 1
	

]

{ #category : #printing }
FAT32ClusterRecord >> printOn: aStream [
	^aStream nextPutAll: self name
]

{ #category : #accessing }
FAT32ClusterRecord >> size [
	^contents unsignedLongAtOffset: 16r1C

]

{ #category : #accessing }
FAT32ClusterRecord >> size: value [
	^ contents unsignedLongAtOffset: 16r1C put: value
]

{ #category : #constants }
FAT32ClusterRecord >> unusedByte [
	^16rE5
]
