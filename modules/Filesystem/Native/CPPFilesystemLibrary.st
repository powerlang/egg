"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #CPPFilesystemLibrary,
	#superclass : #ExternalLibrary,
	#category : #'Filesystem'
}

{ #category : #spec }
CPPFilesystemLibrary >> libname [
	^'filesystem'
]

{ #category : #initializing }
CPPFilesystemLibrary >> directoryFromPath: aPath [
	<cdecl: directory_new_from_path>
]


{ #category : #initializing }
CPPFilesystemLibrary >> directoryPath: aDirectory [
	<cdecl: directory_path>
]

{ #category : #initializing }
CPPFilesystemLibrary >> directoryRelease: aDirectory [
	<cdecl: directory_release>
]

{ #category : #initializing }
CPPFilesystemLibrary >> pathCreateDirectory: aPath [
	<cdecl: path_create_directory>
]

{ #category : #spec }
CPPFilesystemLibrary >> pathExists: aPath [
	<cdecl: path_exists>
]

{ #category : #spec }
CPPFilesystemLibrary >> pathFilename: string [
	<cdecl: path_filename>
]

{ #category : #spec }
CPPFilesystemLibrary >> pathNew: string [
	<cdecl: path_new>
]

{ #category : #initializing }
CPPFilesystemLibrary >> pathParent: aPath [
	<cdecl: path_parent>
]

{ #category : #spec }
CPPFilesystemLibrary >> pathOperatorSlash: aPath with: string [
	<cdecl: path_operator_slash>
]

{ #category : #initializing }
CPPFilesystemLibrary >> pathRemove: aPath [
	<cdecl: path_remove>
]

{ #category : #initializing }
CPPFilesystemLibrary >> pathRelease: aPath [
	<cdecl: path_remove>
]
