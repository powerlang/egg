"
    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #BootstrapModule,
	#superclass : #Module,
	#instVars : [
		'environment'
	],
	#category : #'Powerlang-Core-LMR'
}

{ #category : #bootstrapping }
BootstrapModule >> imports [
	^{#Core.Modules -> #Builder. #Core.Modules.JSON -> #Writer  }
]

{ #category : #bootstrapping }
BootstrapModule >> start [
	Kernel addModuleLoader: ModuleLoader new.
]

{ #category : #bootstrapping }
BootstrapModule >> fixOverrides [
	<primitive: BootstrapFixOverrides>
]

{ #category : #bootstrapping }
BootstrapModule >> writeJSONKernel [
	| builder writer |
	self fixOverrides.
	Kernel addModuleLoader: ModuleLoader new.
	self
		import: #Builder from: #ImageSegmentBuilder;
		import: #Writer from: #ImageSegmentBuilder.JSON.
	builder := Builder new.
	builder module: Kernel; build.
	writer := Writer new.
	^writer closure: builder closure; exports: Kernel exports; write; image
]

