'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #EPMModule category: #EPM!
Module subclass: #EPMModule
	instanceVariableNames: 'args parser config'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'EPM'!
!EPMModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!EPMModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
addCommand: aString description: aDescription action: aSymbol
	| command |
	command := Command new
		name: aString;
		description: aDescription.
	command action: [:result | self perform: aSymbol with: result].
	parser addCommand: command.
	^command
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
commandDev: aResult
	| cwd name dev module |
	cwd := Kernel currentDirectory.
	name := cwd copyAfterLast: $/.
	dev := Kernel load: #Development.
	module := Kernel load: name asSymbol.
	dev main: args
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
commandInit: aResult
	| cwd name generator |
	cwd := Kernel currentDirectory.
	name := cwd copyAfterLast: $/.
	name isEmpty ifTrue: [name := 'myproject'].
	generator := ProjectGenerator new.
	generator name: name.
	generator dir: cwd.
	generator generateToml.
	Kernel log: 'Initialized epm.toml for: ', name
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
commandInstall: aResult
	| dependencies |
	config ifNil: [self loadConfig].
	dependencies := config dependencies.
	dependencies isEmpty ifTrue: [
		Kernel log: 'No dependencies to install'.
		^self].
	Kernel log: 'Installing dependencies...'.
	dependencies keysAndValuesDo: [:name :constraint |
		Kernel log: '  ', name, ' (', constraint asString, ')'].
	Kernel log: 'Done'
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
commandList: aResult
	| dependencies |
	config ifNil: [self loadConfig].
	dependencies := config dependencies.
	dependencies isEmpty ifTrue: [
		Kernel log: 'No dependencies'.
		^self].
	Kernel log: config name ifNil: ['(unnamed project)'].
	dependencies keysAndValuesDo: [:name :constraint |
		Kernel log: '  ', name, ' ', constraint asString]
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
commandNew: aResult
	| name generator |
	aResult positionals isEmpty ifTrue: [
		^self error: 'Usage: epm new <project-name>'].
	name := aResult positionalAt: 1.
	generator := ProjectGenerator new.
	generator name: name.
	generator generate.
	Kernel log: 'Created project: ', name
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
commandStart: aResult
	| cwd name module |
	cwd := Kernel currentDirectory.
	name := cwd copyAfterLast: $/.
	module := Kernel load: name asSymbol.
	module main: args
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
commandTest: aResult
	| name module positionals |
	positionals := aResult positionals.
	name := positionals isEmpty
		ifTrue: [self projectName]
		ifFalse: [positionals first].
	name ifNil: [
		^self error: 'Usage: epm test [module-name]'].
	module := Kernel load: (name, '.Tests') asSymbol.
	(aResult optionAt: 'debug') == true
		ifTrue: [self debugTestModule: module]
		ifFalse: [module main: args]
! !

!EPMModule methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:40'!
debugTestModule: aModule
	Kernel log: 'Running ', aModule name, ' tests in debug mode...'; log: String cr.
	(TestSuite forModule: aModule) runDebug.
	Kernel log: 'Done.'; log: String cr
! !

!EPMModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:40'!
imports
	^{
		#Kernel -> #(Error OrderedDictionary).
		#ArgParser -> #(ArgParser Command Option).
		#SUnit -> #(TestSuite).
		#TOML -> #(TOMLParser TOMLWriter).
	}
! !

!EPMModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadConfig
	| host |
	config := Config load.
	host := Kernel host.
	config modulePaths do: [:path |
		host prependSearchPath: path type: #tonel.
		host prependSearchPath: path type: #ems]
! !

!EPMModule methodsFor:  'main' stamp: 'KenD 28/Jun/2026 13:27:40'!
main: aCollection
	| params |
	args := aCollection.
	self loadConfig.
	self setupParser.
	params := OrderedCollection new.
	3 to: args size do: [:i |
		| arg |
		arg := args at: i.
		params add: arg].
	parser parse: params asArray
! !

!EPMModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
projectName
	^config ifNotNil: [config name]
! !

!EPMModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
setupParser
	| create |
	parser := ArgParser new name: 'epm'; description: 'Egg Package Manager'.
	create := self addCommand: 'new' description: 'Create a new project' action: #commandNew:.
	create addPositional: 'name'.
	self addCommand: 'init' description: 'Initialize epm.toml in current directory' action: #commandInit:.
	self addCommand: 'start' description: 'Run current project' action: #commandStart:.
	self addCommand: 'dev' description: 'Start development environment for current project' action: #commandDev:.
	self addCommand: 'install' description: 'Install dependencies from epm.toml' action: #commandInstall:.
	self addCommand: 'list' description: 'List project dependencies' action: #commandList:.
	((self addCommand: 'test' description: 'Run tests for a module' action: #commandTest:)
		addPositional: 'module';
		addOption: (Option new
			long: '--debug';
			description: 'Run tests without swallowing exceptions';
			beFlag;
			yourself))
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EPMModule class' category: #EPM!
EPMModule class
	instanceVariableNames: ''!


