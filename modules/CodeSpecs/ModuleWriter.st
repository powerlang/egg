"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleWriter, 
	#superclass : #Object, 
	#instVars : [
		'module', 
		'path', 
		'compatible'
	], 
	#category : #ModuleWriter
}

{#category : #'instance creation'}
ModuleWriter class >> new [
	^super new initialize
]

{#category : #accessing}
ModuleWriter >> compatible: aBoolean [
	compatible := aBoolean
]

{#category : #accessing}
ModuleWriter >> copyright [
	^'Copyright (c) ' , Date today year asString , ' Quorum Software.'
]

{#category : #private}
ModuleWriter >> createFolder [
	self moduleFolder createPath
]

{#category : #private}
ModuleWriter >> definition [
	| names |
	names := (module classes collect: #name) sort.
	^OrderedDictionary new
		at: #name put: self moduleName asSymbol;
		at: #requires
		put: module dependencies keys asArray sort;
		at: #classes put: names asArray;
		yourself
]

{#category : #export}
ModuleWriter >> export [
	self
		createFolder;
		exportMetadata;
		exportClasses;
		exportExtendedClasses
]

{#category : #export}
ModuleWriter >> exportClass: aClassSpec [
	| filename |
	filename := self filenameForClass: aClassSpec.
	self withFileNamed: filename do: [:stream | | writer |
		stream truncate.
		writer := TonelWriter on: stream.
		writer
			category: self moduleName;
			class: aClassSpec;
			methods: (aClassSpec metaMethods sortBy: #selector)
				& (aClassSpec methods sortBy: #selector);
			write]
]

{#category : #export}
ModuleWriter >> exportClasses [
	module classes do: [:class | self exportClass: class]
]

{#category : #private}
ModuleWriter >> exportedName [
	^module name copy replace: Character space with: $\
]

{#category : #export}
ModuleWriter >> exportEmptyClass: aClassSpec [
	| filename |
	filename := self filenameForClass: aClassSpec.
	self withFileNamed: filename do: [:stream | | writer |
		writer := TonelWriter on: stream.
		writer
			category: self moduleName;
			class: aClassSpec;
			methods: #();
			write]
]

{#category : #export}
ModuleWriter >> exportEmptyClasses [
	module classes do: [:class | self exportEmptyClass: class]
]

{#category : #export}
ModuleWriter >> exportExtendedClass: aClassSpec [
	| filename |
	filename := self filenameForExtension: aClassSpec.
	self withFileNamed: filename do: [:stream | 
		stream truncate.
		(TonelWriter on: stream)
			writeMethods: (aClassSpec metaMethods sortBy: #selector)
				& (aClassSpec methods sortBy: #selector)]
]

{#category : #export}
ModuleWriter >> exportExtendedClasses [
	module extendedClasses do: [:class | self exportExtendedClass: class]
]

{#category : #export}
ModuleWriter >> exportMetadata [
	| package |
	package := self moduleFolder \ 'package.st'.
	self withFileNamed: package do: [:stream | 
		stream nextPutAll: 'Package '.
		(STONWriter on: stream) writeMap: self definition]
]

{#category : #services}
ModuleWriter >> exportPseudoTonel [
	compatible := false.
	self export
]

{#category : #private}
ModuleWriter >> filenameForClass: aClassSpec [
	| name |
	name := aClassSpec name asFilename.
	compatible ifTrue: [name := name appendExtension: 'class'].
	^self moduleFolder \ name appendExtension: 'st'
]

{#category : #private}
ModuleWriter >> filenameForExtension: aClassSpec [
	| name |
	name := aClassSpec name asFilename.
	compatible ifTrue: [name := name appendExtension: 'extension'].
	^self moduleFolder \ name appendExtension: 'st'
]

{#category : #initialization}
ModuleWriter >> initialize [
	super initialize.
	path := Directory current asFilename.
	compatible := true
]

{#category : #accessing}
ModuleWriter >> license [
	^'See (MIT) license in root directory.'
]

{#category : #accessing}
ModuleWriter >> module: aModuleSpec [
	module := aModuleSpec
]

{#category : #private}
ModuleWriter >> moduleFolder [
	^path \ self exportedName
]

{#category : #private}
ModuleWriter >> moduleName [
	^self exportedName asFilename entityName
]

{#category : #accessing}
ModuleWriter >> path: aFilename [
	path := aFilename asFilename
]

{#category : #private}
ModuleWriter >> withFileNamed: aFilename do: aBlock [
	| stream |
	stream := aFilename asFile writeStream.
	stream
		truncate;
		eol: String lf;
		nextPut: $";
		crtab;
		nextPutAll: self copyright;
		crtab;
		nextPutAll: self license;
		cr;
		nextPut: $";
		cr;
		cr.
	[aBlock evaluateWith: stream] ensure: [stream close]
]

