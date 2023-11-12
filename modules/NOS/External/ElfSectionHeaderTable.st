Class {
	#name : #ElfSectionHeaderTable,
	#superclass : #ExternalStructure,
	#category : #'SqueakNOS-External-Structures'
}

{ #category : #accessing }
ElfSectionHeaderTable class >> fields [
	^#(
		(number 'ulong')
		(size 'ulong')
		(address 'ulong')
		(shndx 'ulong')
	   )
]

{ #category : #accessing }
ElfSectionHeaderTable >> address [
	"This method was automatically generated"
	^handle unsignedLongAt: 9
]

{ #category : #accessing }
ElfSectionHeaderTable >> address: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
]

{ #category : #accessing }
ElfSectionHeaderTable >> number [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
ElfSectionHeaderTable >> number: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]

{ #category : #accessing }
ElfSectionHeaderTable >> shndx [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #accessing }
ElfSectionHeaderTable >> shndx: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #accessing }
ElfSectionHeaderTable >> size [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #accessing }
ElfSectionHeaderTable >> size: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]
