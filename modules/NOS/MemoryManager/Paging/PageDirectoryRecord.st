Class {
	#name : #PageDirectoryRecord,
	#superclass : #Alien,
	#type : #bytes,
	#category : 'SqueakNOS-MemoryManager-Paging'
}

{ #category : #'initialize-release' }
PageDirectoryRecord >> initializeSameAddresses [
	| i |
	i := 1.
	self records do: [:record | record address: i]
]
