Extension { #name : 'ByteArray' }

{ #category : '*Powerlang-Compatibility-Pharo' }
ByteArray >> asLittleEndianNegativeInteger [
	| integer |
	integer := LargeNegativeInteger new: self size.
	self withIndexDo: [ :value :i | integer at: i put: 255 - value ].
	^ integer - 1
]

{ #category : '*Powerlang-Compatibility-Pharo' }
ByteArray >> asLittleEndianPositiveInteger [
	| integer |
	integer := LargePositiveInteger new: self size.
	self withIndexDo: [ :value :i | integer at: i put: value ].
	^ integer normalize
	

]
