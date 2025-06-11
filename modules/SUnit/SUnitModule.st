Class {
	#name : #SUnitModule,
	#superclass : #Module,
	#instVars : [
		'random'
	],
	#category : #SUnit
}

{ #category : #spec }
SUnitModule >> imports [
	^{
		#Kernel -> #(Bag CharacterArray Class Closure CompiledExpression CompiledMethod Error Exception ExceptionHandler IdentitySet Notification Species Symbol).
		#Random -> #(Random)
	}
]

{ #category : #spec }
SUnitModule >> initialize [
	super initialize.
]

{ #category : #accessing }
SUnitModule >> random [
	^random ifNil: [ random := Random new]
]
