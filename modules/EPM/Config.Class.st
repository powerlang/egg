'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #Config category: #EPM!
Object subclass: #Config
	instanceVariableNames: 'project user merged'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'EPM'!
!Config commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
at: aString
			^merged at: aString ifAbsent: [nil]
! !

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
at: aString ifAbsent: aBlock
			^merged at: aString ifAbsent: aBlock
! !

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
dependencies
			^self at: 'dependencies' ifAbsent: [OrderedDictionary new]
! !

!Config methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
load
			self loadUser.
	self loadProject.
	self merge
! !

!Config methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadProject
	| cwd path contents |
	cwd := Kernel currentDirectory.
	path := cwd, '/epm.toml'.
	(Kernel pathExists: path)
		ifTrue: [
			contents := Kernel readFile: path.
			project := TOMLParser parse: contents]
		ifFalse: [project := OrderedDictionary new]
! !

!Config methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadUser
	| home path contents |
	home := Kernel getEnv: 'HOME'.
	home ifNil: [user := OrderedDictionary new. ^self].
	path := home, '/.egg/config.toml'.
	(Kernel pathExists: path)
		ifTrue: [
			contents := Kernel readFile: path.
			user := TOMLParser parse: contents]
		ifFalse: [user := OrderedDictionary new]
! !

!Config methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
merge
			merged := OrderedDictionary new.
	self mergeFrom: user into: merged.
	self mergeFrom: project into: merged
! !

!Config methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
mergeFrom: aSource into: aTarget
			aSource keysAndValuesDo: [:k :v |
		| existing |
		existing := aTarget at: k ifAbsent: [nil].
		(v isKindOf: OrderedDictionary)
			ifTrue: [
				(existing isKindOf: OrderedDictionary)
					ifTrue: [self mergeFrom: v into: existing]
					ifFalse: [
						| copy |
						copy := OrderedDictionary new.
						self mergeFrom: v into: copy.
						aTarget at: k put: copy]]
			ifFalse: [aTarget at: k put: v]]
! !

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
modulePaths
	| paths section |
	paths := self at: 'paths'.
	paths ifNil: [^#()].
	section := paths at: 'modules' ifAbsent: [nil].
	section ifNil: [^#()].
	^section
! !

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	| section |
	section := self at: 'project'.
	section ifNil: [^nil].
	^section at: 'name' ifAbsent: [nil]
! !

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
project
			^project
! !

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
user
			^user
! !

!Config methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
version
	| section |
	section := self at: 'project'.
	section ifNil: [^nil].
	^section at: 'version' ifAbsent: [nil]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Config class' category: #EPM!
Config class
	instanceVariableNames: ''!

!Config class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
load
			^self new load
! !


