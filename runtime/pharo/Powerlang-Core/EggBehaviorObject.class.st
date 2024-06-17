Class {
	#name : #EggBehaviorObject,
	#superclass : #EggSlotObject,
	#instVars : [
		'runtime'
	],
	#category : 'Powerlang-Core-Execution-Metacircular',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Metacircular'
}

{ #category : #accessing }
EggBehaviorObject >> classInstSize [
	| class |
	class := runtime behaviorClass: self.
	^runtime speciesInstanceSize: class
]

{ #category : #accessing }
EggBehaviorObject >> localClassName [
	| class |
	class := runtime behaviorClass: self.
	^ runtime speciesLocalName: class
]

{ #category : #accessing }
EggBehaviorObject >> printInstance: anEggObject on: aStream [
	runtime print: anEggObject on: aStream
]

{ #category : #accessing }
EggBehaviorObject >> printOn: aStream [
	runtime printBehavior: self on: aStream
]

{ #category : #accessing }
EggBehaviorObject >> runtime: anEggRuntime [
	runtime := anEggRuntime
]
