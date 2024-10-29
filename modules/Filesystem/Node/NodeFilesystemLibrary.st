"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #NodeFilesystemLibrary,
	#superclass : #Object,
	#category : #'Filesystem'
}

{ #category : #spec }
NodeFilesystemLibrary >> libname [
	^'filesystem'
]

{ #category : #initializing }
NodeFilesystemLibrary >> directoryFromPath: aPath [
	<primitive: directory_new_from_path>
]


{ #category : #initializing }
NodeFilesystemLibrary >> directoryPath: aDirectory [
	<primitive: directory_path>
]

{ #category : #initializing }
NodeFilesystemLibrary >> directoryRelease: aDirectory [
	<primitive: directory_release>
]

{ #category : #initializing }
NodeFilesystemLibrary >> pathCreateDirectory: aPath [
	<primitive: path_create_directory>
]

{ #category : #spec }
NodeFilesystemLibrary >> pathExists: aPath [
	<primitive: path_exists>
]

{ #category : #spec }
NodeFilesystemLibrary >> pathFilename: string [
	<primitive: path_filename>
]

{ #category : #spec }
NodeFilesystemLibrary >> pathNew: string [
	<primitive: path_new>
]

{ #category : #initializing }
NodeFilesystemLibrary >> pathParent: aPath [
	<primitive: path_parent>
]

{ #category : #spec }
NodeFilesystemLibrary >> pathOperatorSlash: aPath with: string [
	<primitive: path_operator_slash>
]

{ #category : #initializing }
NodeFilesystemLibrary >> pathRemove: aPath [
	<primitive: path_remove>
]

{ #category : #initializing }
NodeFilesystemLibrary >> pathRelease: aPath [
	<primitive: path_remove>
]
