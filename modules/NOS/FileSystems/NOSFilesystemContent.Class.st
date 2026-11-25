'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NOSFilesystemContent category: 'SqueakNOS-Filesystems'!
Object subclass: #NOSFilesystemContent
	instanceVariableNames: 'name identifier filesystem directory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems'!
!NOSFilesystemContent commentStamp: '<historical>' prior: 0!

Me and my subclasses have been copied from the Pharo versions.
FIXME: this is highly work-in-progress.
 Check what is really needed from this hierarchy
!

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
directory
	^directory
! !

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
directory: aDirectory
	directory := aDirectory
! !

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
filesystem
	^filesystem
! !

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
filesystem: aFilesystem
	filesystem := aFilesystem
! !

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
identifier
	^identifier
! !

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
identifier: aClusterNumber
	identifier := aClusterNumber
! !

!NOSFilesystemContent methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDirectory
	^false
! !

!NOSFilesystemContent methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isFile
	^false
! !

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name
	^name
! !

!NOSFilesystemContent methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name: aString
	name := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NOSFilesystemContent class' category: 'SqueakNOS-Filesystems'!
NOSFilesystemContent class
	instanceVariableNames: ''!

!NOSFilesystemContent class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
identifier: anId filesystem:aFilesystem
	^self named: ''
	      identifier: anId 
		filesystem: aFilesystem.
! !

!NOSFilesystemContent class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
named: aString identifier: anId filesystem: aFilesystem
	^self new name: aString;
			   identifier: anId; 
			   filesystem: aFilesystem.
! !

!NOSFilesystemContent class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
named: aString identifier: anId filesystem: aFilesystem directory: aDirectory
	^self new name: aString;
		identifier: anId; 
		filesystem: aFilesystem;
		directory: aDirectory.
! !


