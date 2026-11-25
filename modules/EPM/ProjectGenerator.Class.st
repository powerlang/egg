'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ProjectGenerator category: #EPM!
Object subclass: #ProjectGenerator
	instanceVariableNames: 'name dir'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'EPM'!
!ProjectGenerator commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ProjectGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
dir: aString
	dir := aString
! !

!ProjectGenerator methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
ensureDir
	dir ifNil: [
		dir := Kernel currentDirectory, '/', name].
	Kernel createDirectory: dir
! !

!ProjectGenerator methodsFor:  'generating' stamp: 'KenD 28/Jun/2026 13:27:40'!
generate
	| modules module |
	self ensureDir.
	modules := dir, '/modules'.
	module := modules, '/', self moduleName.
	Kernel createDirectory: modules.
	Kernel createDirectory: module.
	self generateToml.
	self generateModule: module
! !

!ProjectGenerator methodsFor:  'generating' stamp: 'KenD 28/Jun/2026 13:27:40'!
generateModule: aString
	| filename contents module |
	module := self moduleName.
	filename := aString, '/', module, 'Module.st'.
	contents := '"
    See (MIT) license in root directory.
"

Class {
	#name : #', module, 'Module,
	#superclass : #Module,
	#instVars : [],
	#category : #', module, '
}

{ #category : #main }
', module, 'Module >> main: args [
	Kernel log: ''Hello from ', name, '''
]
'.
	Kernel writeFile: filename contents: contents
! !

!ProjectGenerator methodsFor:  'generating' stamp: 'KenD 28/Jun/2026 13:27:40'!
generateToml
	| filename contents |
	self ensureDir.
	filename := dir, '/epm.toml'.
	contents := '[project]
name = "', name, '"
version = "0.1.0"
description = ""

[dependencies]
'.
	Kernel writeFile: filename contents: contents
! !

!ProjectGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
moduleName
	| first |
	first := name first asUppercase.
	^(String with: first), (name copyFrom: 2)
! !

!ProjectGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name: aString
	name := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ProjectGenerator class' category: #EPM!
ProjectGenerator class
	instanceVariableNames: ''!


