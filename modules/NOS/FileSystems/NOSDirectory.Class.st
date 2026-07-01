'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NOSDirectory category: 'SqueakNOS-Filesystems'!
NOSFilesystemContent subclass: #NOSDirectory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems'!
!NOSDirectory methodsFor:  'quering' stamp: 'KenD 28/Jun/2026 13:32:25'!
directories
	^self filesystem directoriesFor: self
! !

!NOSDirectory methodsFor:  'quering' stamp: 'KenD 28/Jun/2026 13:32:25'!
fileExists: aString
	^self files anySatisfy: [:file | file name asLowercase = 
		(String streamContents: [:stream | (filesystem nameFormat: aString) asFileReference gtDisplayOn: stream]) asLowercase]
! !

!NOSDirectory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
fileNamed: aString
	^self files detect: [:file | file name asLowercase = 
		(String streamContents: [:stream | (filesystem nameFormat: aString) asFileReference gtDisplayOn: stream]) asLowercase] 
! !

!NOSDirectory methodsFor:  'quering' stamp: 'KenD 28/Jun/2026 13:32:25'!
files
	^self filesystem filesFor: self
! !

!NOSDirectory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDirectory
	^true
! !

!NOSDirectory methodsFor:  'quering' stamp: 'KenD 28/Jun/2026 13:32:25'!
newFileNamed: aString
	^self filesystem createFileNamed: aString on: self.
! !

!NOSDirectory methodsFor:  'quering' stamp: 'KenD 28/Jun/2026 13:32:25'!
printString
	^self filesystem printStringOf: self.
! !

!NOSDirectory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
readOnlyFileNamed: aString
	^self fileNamed: aString
! !

!NOSDirectory methodsFor:  'quering' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeFileNamed: aString
	^self filesystem removeFileNamed: aString on: self.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NOSDirectory class' category: 'SqueakNOS-Filesystems'!
NOSDirectory class
	instanceVariableNames: ''!


