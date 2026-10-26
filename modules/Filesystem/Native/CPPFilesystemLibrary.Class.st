'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #CPPFilesystemLibrary category: #Filesystem!
ExternalLibrary subclass: #CPPFilesystemLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Filesystem'!
!CPPFilesystemLibrary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!CPPFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
libname
	^'filesystem'
! !

!CPPFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
directoryFromPath: aPath
	<cdecl: directory_new_from_path>
! !

!CPPFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
directoryPath: aDirectory
	<cdecl: directory_path>
! !

!CPPFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
directoryRelease: aDirectory
	<cdecl: directory_release>
! !

!CPPFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathCreateDirectory: aPath
	<cdecl: path_create_directory>
! !

!CPPFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathExists: aPath
	<cdecl: path_exists>
! !

!CPPFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathFilename: string
	<cdecl: path_filename>
! !

!CPPFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathNew: string
	<cdecl: path_new>
! !

!CPPFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathParent: aPath
	<cdecl: path_parent>
! !

!CPPFilesystemLibrary methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathOperatorSlash: aPath with: string
	<cdecl: path_operator_slash>
! !

!CPPFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathRemove: aPath
	<cdecl: path_remove>
! !

!CPPFilesystemLibrary methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pathRelease: aPath
	<cdecl: path_remove>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CPPFilesystemLibrary class' category: #Filesystem!
CPPFilesystemLibrary class
	instanceVariableNames: ''!


