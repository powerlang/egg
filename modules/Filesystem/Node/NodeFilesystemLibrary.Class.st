'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NodeFilesystemLibrary category: #Filesystem!
Object subclass: #NodeFilesystemLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Filesystem'!
!NodeFilesystemLibrary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!NodeFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
libname
	^'filesystem'
! !

!NodeFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
directoryFromPath: aPath
	<primitive: directory_new_from_path>
! !

!NodeFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
directoryPath: aDirectory
	<primitive: directory_path>
! !

!NodeFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
directoryRelease: aDirectory
	<primitive: directory_release>
! !

!NodeFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathCreateDirectory: aPath
	<primitive: path_create_directory>
! !

!NodeFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathExists: aPath
	<primitive: path_exists>
! !

!NodeFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathFilename: string
	<primitive: path_filename>
! !

!NodeFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathNew: string
	<primitive: path_new>
! !

!NodeFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathParent: aPath
	<primitive: path_parent>
! !

!NodeFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathOperatorSlash: aPath with: string
	<primitive: path_operator_slash>
! !

!NodeFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathRemove: aPath
	<primitive: path_remove>
! !

!NodeFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathRelease: aPath
	<primitive: path_remove>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NodeFilesystemLibrary class' category: #Filesystem!
NodeFilesystemLibrary class
	instanceVariableNames: ''!


