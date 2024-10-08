Class {
	#name : 'MirageGate',
	#superclass : 'Gate',
	#instVars : [
		'class'
	],
	#category : 'Powerlang-Core-Metaphysics',
	#package : 'Powerlang-Core',
	#tag : 'Metaphysics'
}

{ #category : 'accessing' }
MirageGate >> classBinding [
	^class
]

{ #category : 'notifications' }
MirageGate >> dispatch: aMessage [
	^self dispatch: aMessage from: nil
]

{ #category : 'notifications' }
MirageGate >> dispatch: aMessage from: parentInterpreter [
	| receiver |
	receiver := aMessage receiver.
	^receiver _gate isLocal
		ifTrue: [ self dispatchLocal: aMessage from: parentInterpreter ]
		ifFalse: [ self dispatchRemote: aMessage from: parentInterpreter ]
]

{ #category : 'notifications' }
MirageGate >> dispatchLocal: aMessage from: parentInterpreter [
	| args receiver result hresult |
	"args := aMessage arguments
		collect: [ :arg | 
			arg class == Subject
				ifTrue: [ arg _gate handle oid ]
				ifFalse: [ arg ] ]."
	args := aMessage arguments.
	receiver := aMessage receiver _gate handle.
	result := receiver oid perform: aMessage selector withArguments: args.
	result class == Subject
		ifTrue: [ ^ result ].
	hresult := LocalHandle on: result within: receiver runtime.
	^ hresult mirage
]

{ #category : 'notifications' }
MirageGate >> dispatchRemote: aMessage from: parentInterpreter [
	| method interpreter |
	method := self lookup: aMessage selector.
	method ifNil: [ self error: 'cannot interpet ' , aMessage selector ].
	interpreter := SmalltalkInterpreter
		on: aMessage receiver
		with: aMessage arguments
		for: method.
	^ interpreter
		parent: parentInterpreter;
		evaluate: method
]

{ #category : 'private' }
MirageGate >> getInstVarNamed: name [
	| index |
	index := class indexOfSlot: name.
	index = 0 ifTrue: [self error: 'instance variable not found'].
	^self slotAt: index
]

{ #category : 'accessing' }
MirageGate >> handle: anObjectHandle [
	super handle: anObjectHandle.
	class := handle isLocal
		ifTrue: [ handle oid class ]
		ifFalse: [ handle mirror reflectedClass localEquivalent ]
]

{ #category : 'nativizing' }
MirageGate >> lookup: selector [
	^class methodNamed: selector
]

{ #category : 'private' }
MirageGate >> printOn: aStream [
	aStream nextPutAll: 'mirage gate on: ' , handle printString
]

{ #category : 'services' }
MirageGate >> slotAt: index [
	| slot |
	slot := handle slotAt: index.
	^self mirageOn: slot
]
