Extension { #name : #TonelRepository }

{ #category : #'*Powerlang-Compatibility-Pharo' }
TonelRepository >> asCodeSpecsModuleWith: packageName [

	| module version snap defs classDefs methodDefs class |
	module := ModuleSpec new name: packageName.
	version := self versionWithInfo: (self versionInfoFromVersionNamed: packageName).
	snap := version snapshot.
	defs := snap definitions.
	classDefs := defs select: #isClassDefinition.
	methodDefs := defs select: #isMethodDefinition.
	classDefs do: [ :cdef | cdef addCodeSpecTo: module ].
	methodDefs do: [ :mdef | 
		class := self ensureClassSpec: mdef className in: module.
		mdef addCodeSpecTo: module class: class ].
	^ module
]

{ #category : #'*Powerlang-Compatibility-Pharo' }
TonelRepository >> ensureClassSpec: classname in: aModuleSpec [
	| class |
	class := aModuleSpec resolveClass: classname.
	^class ifNil: [aModuleSpec addClassExtensionNamed: classname]
]
