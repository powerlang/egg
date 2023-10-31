Class {
	#name : #Builder,
	#superclass : #Object,
	#instVars : [
		'module',
		'closure',
		'wordSize',
		'classes'
	],
	#category : #'Builder'
}

{ #category : #closure }
Builder >> build [
	module prepareForSnapshot: self.
	closure traverse: module.
]

{ #category : #accessing }
Builder >> closure [
	^closure
]

{ #category : #private }
Builder >> configureClass: aClass [
	self
		configureSuperclass: aClass;
		configureSubclasses: aClass;
		configureMethods: aClass;
		configureMethods: aClass class
]

{ #category : #private }
Builder >> configureMethods: aClass [
    | original saved |
    original := aClass methodDictionary.
	saved := (classes includes: aClass instanceClass)
		ifTrue: [original collect: [:method | module originalMethodFor: method]]
		ifFalse: [Dictionary new].
    saved := saved select: [:method | method notNil].
	saved do: [:method | self configureMethodExecutableCode: method].
    closure map: original to: saved
]

{ #category : #private }
Builder >> configureMethodExecutableCode: method [
	closure map: method executableCode to: nil.
	method hasBlocks ifFalse: [^self].
	method do: [:slot |
		slot class == CompiledBlock
			ifTrue: [closure map: slot blockExecutableCode to: nil]]
]

{ #category : #private }
Builder >> configureSubclasses: aClass [
    | original saved |
    original := aClass subclasses.
    saved := original select: [:s | module classes includes: s].
    closure map: original to: saved
]

{ #category : #private }
Builder >> configureSuperclass: aClass [
    | superclass |
    superclass := aClass superclass.
	superclass ifNil: [^self].
    (module classes includes: superclass) ifFalse: [self import: superclass]
]

{ #category : #initializing }
Builder >> initialize [
	closure := ObjectClosure new.
]

{ #category : #accessing }
Builder >> map: anObject to: anotherObject [
	closure map: anObject to: anotherObject
]

{ #category : #accessing }
Builder >> module: aModule [
	module := aModule.
	classes := Set new.
	classes 
		addAll: SmallInteger withAllSuperclasses;
		addAll: Array withAllSuperclasses;
		addAll: {ByteArray. CompiledMethod. Interval. OrderedCollection. Character. 
				CharacterArray. String. Symbol.
				HashedCollection. Dictionary. Set. HashTable. InlinedHashTable.
				Species. Class. Metaclass. Behavior. Association.
				True. False. Boolean. Closure. CompiledBlock.
				Namespace. Module. KernelModule}.
    module classes do: [:c | self configureClass: c]
]
