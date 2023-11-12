Class {
	#name : #RemoteFileDirectory,
	#superclass : #Object,
	#instVars : [
		'channel'
	],
	#category : #'SqueakNOS-FileSupport'
}

{ #category : #'as yet unclassified' }
RemoteFileDirectory class >> isActiveDirectoryClass [
	^ Computer isSqueakNOS
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory class >> pathNameDelimiter [
	^ $/
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory >> channel [
	channel
		ifNil: [channel := RemoteObjectChannel for: self using: 'FileDirectory on: ' , pathName pathName storeString].
	^ channel
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory >> channel: aStream [
	channel := aStream
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory >> primCreateDirectory: fullPath [
	^ self channel remotePerform: #primCreateDirectory: with: fullPath
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory >> primDeleteDirectory: fullPath [
	^ self channel remotePerform: #primDeleteDirectory: with: fullPath
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory >> primDeleteFileNamed: aFileName [
	^ self channel remotePerform: #primDeleteFileNamed: with: aFileName
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory >> primLookupEntryIn: fullPath index: index [
	^ self channel remotePerform: #primLookupEntryIn:index: with: fullPath with: index
]

{ #category : #'as yet unclassified' }
RemoteFileDirectory >> primRename: oldFileFullName to: newFileFullName [ 
	^ self channel remotePerform: #primRename:to: with: oldFileFullName with: newFileFullName.

]
