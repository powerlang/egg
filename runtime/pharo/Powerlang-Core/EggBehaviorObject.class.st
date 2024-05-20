Class {
	#name : #EggBehaviorObject,
	#superclass : #EggSlotObject,
	#instVars : [
		'runtime'
	],
	#category : #'Powerlang-Core-Execution-Metacircular'
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
EggBehaviorObject >> printInstance: anLMRObject on: aStream [
	runtime print: anLMRObject on: aStream
]

{ #category : #accessing }
EggBehaviorObject >> printOn: aStream [
	runtime printBehavior: self on: aStream
]

{ #category : #accessing }
EggBehaviorObject >> runtime: aPowertalkLMR [
	runtime := aPowertalkLMR
]
