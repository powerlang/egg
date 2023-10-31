"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #BootstrapDictionary,
	#superclass : #Object,
	#category : #Kernel
}


{ #category : #accessing }
BootstrapDictionary >> at: key [
	<primitive: BootstrapDictAt>
]

{ #category : #accessing }
BootstrapDictionary >> at: key put: value [
	<primitive: BootstrapDictAtPut>
]

{ #category : #accessing }
BootstrapDictionary >> beConstantPool [
	<primitive: BootstrapDictBeConstant>
]

{ #category : #accessing }
BootstrapDictionary >> keys [
	<primitive: BootstrapDictKeys>
]

