Class {
	#name : #X86Processor,
	#superclass : #MicroProcessor,
	#category : #'SqueakNOS-Devices-Processor'
}

{ #category : #registers }
X86Processor >> cr0 [
	<primitive: 'primitiveRead32bitRegisterCr0' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
]

{ #category : #registers }
X86Processor >> cr0: statusWord [
	<primitive: 'primitivePutIn32bitRegisterCr0' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
]

{ #category : #registers }
X86Processor >> cr3 [
	<primitive: 'primitiveRead32bitRegisterCr3' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
]

{ #category : #registers }
X86Processor >> cr3: memoryAddress [
	<primitive: 'primitivePutIn32bitRegisterCr3' module:'SqueakNOSPlugin'> "primitiveExternalCall" 
	^self primitiveFailed
]

{ #category : #paging }
X86Processor >> enablePaging [
	| pagingEnabled |
	pagingEnabled := self cr0 bitAt: 32 put: 1. "Enable paging"
	pagingEnabled := pagingEnabled bitAt: 17 put: 1. "Enable write protect"
	self cr0: pagingEnabled
]

{ #category : #paging }
X86Processor >> enablePagingWithDirectory: memoryAddress [
	self pageDirectory: memoryAddress.
	self enablePaging.
]

{ #category : #paging }
X86Processor >> pageDirectory: memoryAddress [
	self cr3: memoryAddress
]
