Class {
	#name : #BlockCacheTest,
	#superclass : #TestCase,
	#category : 'SqueakNOS-Storage-Tests'
}

{ #category : #'as yet unclassified' }
BlockCacheTest >> testBigWrite [
	| device cache array original |
	device := Computer blankBlockDeviceForTest.
	cache := BlockCache on: device.
	
	device at: 1 writeArray: (ByteArray new: 300000).
	array := ByteArray new: 200000.
	1 to: 200000 do: [ :i | array at: i put: i \\ 256 ].
	original :=  (device from: 2 to: 300000) asByteArray.

	original replaceFrom:         15                                              to: 200009 with: array startingAt: 5.
	cache   replaceFromByte: (15 + cache blockSize) bytesCount: 199995 with: array startingAtByte: 5.
	
	self assert: original = (cache from: 2 to: 300000).
	
]

{ #category : #'as yet unclassified' }
BlockCacheTest >> testRead [
	| device cache |
	device := ATAController primary master.
	cache := BlockCache on: device.
	
	
	self assert: (device from: 10 to: 11) asByteArray = (cache from: 10 to: 11).	
	self assert: (device from: 1 to: 1) asByteArray = (cache from: 1 to: 1).
	self assert: (device from: 100 to: 110) asByteArray = (cache from: 100 to: 110).
]

{ #category : #'as yet unclassified' }
BlockCacheTest >> testWrite [
	| device cache array original |
	device := ATAController primary master.
	cache := BlockCache on: device.
	
	array := ByteArray withAll: (0 to: 255).
	
	original :=  (device at: 1) asByteArray.
	original replaceFrom: 15 to: 32 with: array startingAt: 5.
	cache replaceFromByte: 15 bytesCount: 18 with: array startingAtByte: 5.
	
	self assert: original = (cache from: 1 to: 1).
]
