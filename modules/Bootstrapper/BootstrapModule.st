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
BootstrapModule >> justLoaded [
	super justLoaded.
	Kernel addModuleLoader: ModuleLoader new.
]

{ #category : #bootstrapping }
BootstrapModule >> fixOverrides [
	<primitive: BootstrapFixOverrides>
]

{ #category : #bootstrapping }
BootstrapModule >> writeJSONKernel [
	^self writeJSONModule: Kernel
]

{ #category : #bootstrapping }
BootstrapModule >> writeJSONModule: aModule [
	| builder writer |
	self fixOverrides.
	Kernel addModuleLoader: ModuleLoader new.
	self
		import: #Builder from: #Core.Modules;
		import: #Writer from: #Core.Modules.JSON.
	builder := Builder new.
	builder module: aModule; build.
	writer := Writer new.
	^writer
		objects: builder objects;
		mapping: builder mapping;
		imports: builder imports;
		exports: aModule exports;
		write;
		image
]
