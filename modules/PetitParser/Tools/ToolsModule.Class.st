'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ToolsModule category: #PetitParser!
Module subclass: #ToolsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PetitParser'!
!ToolsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#PetitParser.Parsers -> #(#PPDelegateParser #PPParser)
	}
! !

!ToolsModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	self name: #'PetitParser.Tools'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ToolsModule class' category: #PetitParser!
ToolsModule class
	instanceVariableNames: ''!


ToolsModule initialize!

