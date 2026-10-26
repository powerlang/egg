'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ModuleImporterModule category: #ModuleImporter!
Module subclass: #ModuleImporterModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ModuleImporter'!
!ModuleImporterModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Quorum Software.
    See (MIT) license in root directory.
!

!ModuleImporterModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(#InternalReadStream #Character #CharacterArray #IdentitySet #Module).
		#Tonel -> #(#TonelReader).
		#CodeSpecs -> #(#ModuleSpec #ClassSpec #MetaclassSpec #MethodSpec).
		#STON -> #(#STONReader).
		#Compiler -> #(#SCompiler).
	}
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ModuleImporterModule class' category: #ModuleImporter!
ModuleImporterModule class
	instanceVariableNames: ''!


