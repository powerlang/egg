Class {
	#name : 'CompiledBlockMirror',
	#superclass : 'ObjectMirror',
	#classVars : [
		'Flags'
	],
	#pools : [
		'CompiledBlockFormatMasks'
	],
	#category : 'Powerlang-Core-Mirrors',
	#package : 'Powerlang-Core',
	#tag : 'Mirrors'
}

{ #category : 'private' }
CompiledBlockMirror >> structureType [
	^ #CompiledBlock
]
