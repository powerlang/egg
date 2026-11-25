'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HostSystem category: #Kernel!
Object subclass: #HostSystem
	instanceVariableNames: 'searchPaths'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!HostSystem commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimas.
    See (MIT) license in root directory.
!

!HostSystem methodsFor:  'search paths' stamp: 'KenD 28/Jun/2026 13:27:38'!
addSearchPath: aString type: aSymbol
	"Append a search path. aSymbol is #ems or #tonel."
	self searchPaths add: aString -> aSymbol
! !

!HostSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
createDirectory: aString
	<primitive: HostCreateDirectory>
! !

!HostSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
currentDirectory
	<primitive: HostCurrentDirectory>
! !

!HostSystem methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
currentMilliseconds
	<primitive: HostCurrentMilliseconds>
! !

!HostSystem methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
exit: anInteger
	<primitive: HostExit>
! !

!HostSystem methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:38'!
fixOverrides
	<primitive: HostFixOverrides>
! !

!HostSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
getEnv: aString
	<primitive: HostGetEnv>
! !

!HostSystem methodsFor:  'search paths' stamp: 'KenD 28/Jun/2026 13:27:38'!
homeDirectory
	^self isWindows
		ifTrue: [self getEnv: 'USERPROFILE']
		ifFalse: [self getEnv: 'HOME']
! !

!HostSystem methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeFFI: anExternalLibrary symbolFinder: anFFIMethod
	<primitive: HostInitializeFFI>
! !

!HostSystem methodsFor:  'search paths' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWindows
	^(self platformName indexOfSubcollection: 'win32') > 0
! !

!HostSystem methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:38'!
load: aSymbol
	"Search configured paths for a module named aSymbol. Each search path is
	an association `path -> type` where type is #ems (binary segment file) or
	#tonel (sources directory)."
	| relative |
	relative := self pathFor: aSymbol.
	searchPaths ifNil: [^nil].
	searchPaths do: [:assoc | | base type candidate |
		base := assoc key.
		type := assoc value.
		candidate := type = #ems
			ifTrue: [base , '/' , relative , '.ems']
			ifFalse: [base , '/' , relative].
		(self pathExists: candidate) ifTrue: [
			^self loadModuleFromPath: candidate]].
	^nil
! !

!HostSystem methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:38'!
loadModuleFromPath: aString
	| module |
	module := self primitiveLoadModuleFromPath: aString.
	^module justLoaded
! !

!HostSystem methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
log: aString level: anInteger
	<primitive: HostLog>
! !

!HostSystem methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
logDebug: aString
	self log: aString level: 1
! !

!HostSystem methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
logError: aString
	self log: aString level: 4
! !

!HostSystem methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
logFatal: aString
	self log: aString level: 5
! !

!HostSystem methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
logInfo: aString
	self log: aString level: 2
! !

!HostSystem methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
logTrace: aString
	self log: aString level: 0
! !

!HostSystem methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
logWarning: aString
	self log: aString level: 3
! !

!HostSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
pathExists: aString
	<primitive: HostPathExists>
! !

!HostSystem methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:38'!
pathFor: aSymbol
	^aSymbol asString replaceAll: '.' with: '/'
! !

!HostSystem methodsFor:  'search paths' stamp: 'KenD 28/Jun/2026 13:27:38'!
pathSeparator
	"Separator used by the host OS in PATH-like environment variables."
	^self isWindows ifTrue: [$;] ifFalse: [$:]
! !

!HostSystem methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:38'!
platformName
	<primitive: HostPlatformName>
! !

!HostSystem methodsFor:  'search paths' stamp: 'KenD 28/Jun/2026 13:27:38'!
prependSearchPath: aString type: aSymbol
	self searchPaths addFirst: aString -> aSymbol
! !

!HostSystem methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveLoad: aSymbol
	| error |
	<primitive: HostLoadModule>
	^Error signal: error
! !

!HostSystem methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveLoadModuleFromPath: aString
	| error |
	<primitive: HostLoadModuleFromPath>
	^Error signal: error
! !

!HostSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
readFile: filename
	<primitive: HostReadFile>
! !

!HostSystem methodsFor:  'search paths' stamp: 'KenD 28/Jun/2026 13:27:38'!
searchPaths
	"Ordered collection of associations `path -> type` (#ems or #tonel)."
	^searchPaths ifNil: [searchPaths := OrderedCollection new]
! !

!HostSystem methodsFor:  'search paths' stamp: 'KenD 28/Jun/2026 13:27:38'!
setupDefaultSearchPaths
	"Configure default search paths. EGG_MODULES_PATH (paths separated by the
	platform-native PATH separator) supplies extra source directories. We also
	walk a few levels up from the current directory so the runtime works both
	from the project root and from a build subdirectory."
	| env home prefixes |
	env := self getEnv: 'EGG_MODULES_PATH'.
	env ifNotNil: [
		(env substringsSplitBy: self pathSeparator) do: [:p |
			self addSearchPath: p type: #tonel.
			self addSearchPath: p type: #ems]].
	prefixes := #('' '../' '../../' '../../../' '../../../../').
	prefixes do: [:p | | base |
		base := p , 'modules'.
		(self pathExists: base) ifTrue: [
			self addSearchPath: base type: #tonel.
			self addSearchPath: base type: #ems]].
	home := self homeDirectory.
	home ifNotNil: [
		self addSearchPath: home , '/.egg/cache/modules' type: #ems].
	self isWindows ifFalse: [
		self addSearchPath: '/usr/local/share/egg/modules' type: #tonel.
		self addSearchPath: '/usr/local/share/egg/modules' type: #ems]
! !

!HostSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
suspended: aProcess because: anException
	self
		logError: 'Error: ' , anException description;
		exit: 1
! !

!HostSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
writeFile: aFilename contents: aString
	<primitive: HostWriteFile>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HostSystem class' category: #Kernel!
HostSystem class
	instanceVariableNames: ''!


