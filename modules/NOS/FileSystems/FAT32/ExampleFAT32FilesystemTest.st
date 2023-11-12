Class {
	#name : #ExampleFAT32FileSystemTest,
	#superclass : #TestCase,
	#category : #'SqueakNOS-Filesystems-FAT32'
}

{ #category : #helpers }
ExampleFAT32FileSystemTest >> createTempFile: tempFileName from: existingFileName do: aTriArgsBlock [
	| filesystem root original clone |
	filesystem := self openRawBig.
	root := filesystem root.
	original := root files detect: [ :file | file name asLowercase = existingFileName ].
	(root files noneSatisfy: [ :file | file name asLowercase = tempFileName ])
		ifFalse: [ self error: 'Temporary file already exists.' ].
	[ clone := root newFileNamed: tempFileName.
	clone readWriteStream nextPutAll: original readStream contents.
	aTriArgsBlock value: original value: clone value: filesystem ]
		ensure: [ root removeFileNamed: tempFileName.
			(root files noneSatisfy: [ :file | file name asLowercase = tempFileName ])
				ifFalse: [ self error: 'Couldn''t delete temporary file' ] ]
]

{ #category : #helpers }
ExampleFAT32FileSystemTest >> openDiskFilesystem [
	| stream device |
	stream := StandardFileStream fileNamed: './testdata/ExampleFAT32.raw'.
	device := BlockDeviceOnStream on: stream blockSize: 512.
	^ device primaryFilesystem
]

{ #category : #helpers }
ExampleFAT32FileSystemTest >> openDiskFilesystem: fileName [
	| stream device |
	stream := StandardFileStream fileNamed: fileName.
	device := BlockDeviceOnStream on: stream blockSize: 512.
	^ device primaryFilesystem
]

{ #category : #helpers }
ExampleFAT32FileSystemTest >> openRawBig [
	^ self openRawFilesystem: './testdata/FAT32Partition.raw'
]

{ #category : #helpers }
ExampleFAT32FileSystemTest >> openRawFilesystem: fileName [
	| stream  |
	"We create a copy so that in the worse case we don't break the test filesystem"
	stream := StandardFileStream fileNamed: fileName.
	^ (FAT32FileSystem on: stream binary contents) open
]

{ #category : #helpers }
ExampleFAT32FileSystemTest >> openRawSmall [
^self openRawFilesystem: './testdata/FAT32PartitionSmall.raw'
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test010EmptyFile [
	"
	self new test010EmptyFile
	"

	| empty |
	empty := self openRawSmall root files
		detect: [ :file | file name asLowercase = 'empty.txt' ]
		ifNone: [ self assert: false ].
	self assert: empty readStream contents isEmpty
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test015CreateAndRemoveFile [
	|  root test name |
	root := self openRawSmall root.
	name := 'test.st'.
	self assert: (root files noneSatisfy: [ :file | file name asLowercase = name ]).
	root newFileNamed: name.
	test := root files detect: [ :file | file name asLowercase = name ] ifNone: [ self assert: false ].
	self assert: test readStream contents isEmpty.
	root removeFileNamed: name.
	self assert: (root files noneSatisfy: [ :file | file name asLowercase = name ])
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test020AsciiFile [
	"
	self new test020AsciiFile
	"

	| ascii |
	ascii := self openRawSmall root files detect: [ :file | file name asLowercase = 'ascii' ].
	self assert: ascii readStream contents = ('zaraza' , String lf)
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test021AsciiFile [
	| ascii |
	ascii := self openRawSmall root fileNamed: 'ascii'.
	self assert: ascii readStream contents = ('zaraza' , String lf)
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test025SmallFileWrite [
	| root name small stream |
	root := self openRawSmall root.
	name := 'small.st'.
	self assert: (root files noneSatisfy: [ :file | file name asLowercase = name ]).
	small := root newFileNamed: name.
	stream := small readWriteStream.
	stream nextPutAll: 'zaraza test small'.
	self assert: (root fileNamed: name) readStream contents = 'zaraza test small'

]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test030LargeFileRead [
	"I open a file bigger than one cluster and check it's content to match what is written by the testing filesystem generator script"

	| fs bytesPerCluster name large contents |
	fs := self openRawBig.
	bytesPerCluster := fs bytesPerCluster.
	name := fs pureFAT32FilenameFor: 'moreth~2'.
	large := fs root fileNamed: name.
	contents := large readStream contents asString trimmed.
	self
		assert: contents size > bytesPerCluster;
		assert: (contents first: 13) = '1234567890abc';
		assert: (contents last: 13) = '1234567890abc'
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test040DeepDirectory [
	| directory |
	directory := self openRawBig directoryNamed: '/dira'.
	self
		assert: directory directories size = 0;
		assert: (directory fileExists: 'file.txt')
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test050LargeFileCopy [
	self
		createTempFile: 'morecopy.st'
		from: 'moreth~2'
		do:
			[ :original :clone :filesystem | self assert: original readStream contents equals: clone readStream contents ]
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test060LargeFileAppend [
	self
		createTempFile: 'morecopy.st'
		from: 'moreth~2'
		do: [ :original :clone :filesystem | 
			| stream |
			stream := clone readWriteStream.
			stream setToEnd.
			stream nextPutAll: 'Goodbye cruel world!'.
			self
				assert:
					clone readStream contents
						equals: (original readStream contents , 'Goodbye cruel world!') ]
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test070LargeFileWrite [
		| fs root large original name new written |
	fs := self openRawBig.
	root := fs root.
	large := root files detect: [:file | file name asLowercase = 'moreth~2'] ifNone: [self assert: false].
	original := large readStream contents trimmed.
	name := 'new.st'.
	self assert: ( root files noneSatisfy: [:file | file name asLowercase = name] ).
	new := root newFileNamed: name.

	new readWriteStream nextPutAll: original.
	written := (root fileNamed: name) readStream contents.
	self assert: written size > fs bytesPerCluster;
	assert: (written first: 13) equals: '1234567890abc';
	assert: (written last: 13) equals: '1234567890abc';
	assert: written equals: original.

	
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test080CompareToStandardFileStream [
	| fs fatChanges fat32TestStream standardTestStream |
	fs := self openRawBig.
	fatChanges := fs root readOnlyFileNamed: (fs pureFAT32FilenameFor: 'SqueakNOS.changes').
	fat32TestStream := fatChanges readStream.
	standardTestStream := 'testdata/SqueakNOS.changes' asFileReference readStream.
	self assert: fat32TestStream size = standardTestStream size.
	self assert: (fat32TestStream next: 1000) = (standardTestStream next: 1000).
	fat32TestStream position: 10000.
	standardTestStream position: 10000.
	self assert: (fat32TestStream basicUpTo: $!) = (standardTestStream basicUpTo: $!).
	fat32TestStream position: fat32TestStream size - 500.
	standardTestStream position: standardTestStream size - 500.
	self assert: fat32TestStream upToEnd = standardTestStream upToEnd
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test090WriteAtEndOfChanges [
	| fs stream changes readOnlyStream contents |
	fs := self openRawBig.
	changes := fs root readOnlyFileNamed: (fs pureFAT32FilenameFor: 'SqueakNOS.changes').
	stream := changes readWriteStream.
	stream position: stream size.
	stream nextPutAll: 'Test content'.
	readOnlyStream := changes readStream.
	readOnlyStream position: readOnlyStream size - 12.
	contents := readOnlyStream next: 12.
	self assert: contents = 'Test content'
]

{ #category : #tests }
ExampleFAT32FileSystemTest >> test100MethodSources [
"	| image sources |
	image := SmalltalkImage current.
	[image openSourceFilesForSqueakNos.
	sources := SmalltalkImage methodDictionary at: #argumentAt:.
	self
		assert: (sources getSource string includesSubString: 'argumentAt: i')]
		ensure: [image openSourceFiles]"
]
