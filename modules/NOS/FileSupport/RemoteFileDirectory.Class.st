'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RemoteFileDirectory category: 'SqueakNOS-FileSupport'!
Object subclass: #RemoteFileDirectory
	instanceVariableNames: 'channel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-FileSupport'!
!RemoteFileDirectory methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
channel
	channel
		ifNil: [channel := RemoteObjectChannel for: self using: 'FileDirectory on: ' , pathName pathName storeString].
	^ channel
! !

!RemoteFileDirectory methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
channel: aStream
	channel := aStream
! !

!RemoteFileDirectory methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
primCreateDirectory: fullPath
	^ self channel remotePerform: #primCreateDirectory: with: fullPath
! !

!RemoteFileDirectory methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
primDeleteDirectory: fullPath
	^ self channel remotePerform: #primDeleteDirectory: with: fullPath
! !

!RemoteFileDirectory methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
primDeleteFileNamed: aFileName
	^ self channel remotePerform: #primDeleteFileNamed: with: aFileName
! !

!RemoteFileDirectory methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
primLookupEntryIn: fullPath index: index
	^ self channel remotePerform: #primLookupEntryIn:index: with: fullPath with: index
! !

!RemoteFileDirectory methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
primRename: oldFileFullName to: newFileFullName
	^ self channel remotePerform: #primRename:to: with: oldFileFullName with: newFileFullName.

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RemoteFileDirectory class' category: 'SqueakNOS-FileSupport'!
RemoteFileDirectory class
	instanceVariableNames: ''!

!RemoteFileDirectory class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
isActiveDirectoryClass
	^ Computer isSqueakNOS
! !

!RemoteFileDirectory class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
pathNameDelimiter
	^ $/
! !


