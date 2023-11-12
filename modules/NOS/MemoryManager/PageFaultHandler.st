Class {
	#name : #PageFaultHandler,
	#superclass : #Object,
	#instVars : [
		'manager',
		'handlingBlock'
	],
	#category : #'SqueakNOS-Memory-Manager'
}

{ #category : #services }
PageFaultHandler >> defaultHandlingBlock [
	^[ :anAddress :handler | | directoryEntry pageEntry |
		self halt.
		directoryEntry := manager pageDirectoryEntryFor: anAddress.
		directoryEntry isPresentAndAllowed ifFalse: [directoryEntry setPresentAndWritable].
		pageEntry := manager pageTableEntryFor: anAddress.
		pageEntry isPresentAndAllowed 
			ifFalse: [pageEntry setPresentAndWritable]
			ifTrue: [self error: 'Why did this page faulted?']
	]
	
]

{ #category : #services }
PageFaultHandler >> doDefaultHandlingFor: anAddress [ 
	self defaultHandlingBlock value: anAddress value: self

	
]

{ #category : #accessing }
PageFaultHandler >> handlingBlock [
	^ handlingBlock
]

{ #category : #accessing }
PageFaultHandler >> handlingBlock: aHandlingBlock [
	handlingBlock := aHandlingBlock

]

{ #category : #accessing }
PageFaultHandler >> initialize [
	handlingBlock := self defaultHandlingBlock.
]

{ #category : #accessing }
PageFaultHandler >> manager: aMemoryManagerStrategy [
	manager := aMemoryManagerStrategy
]

{ #category : #services }
PageFaultHandler >> resolvePageFaultOn: anAddress [
	handlingBlock value: anAddress value: self.
	
]
