"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #StackWrapper,
	#superclass : #Object,
	#instVars : [
		'process',
		'thread',
		'native',
		'base',
		'limit',
		'chunk'
	],
	#classVars : [
		'Instances'
	],
	#category : #Kernel
}
