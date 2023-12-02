Class {
	#name : #PluggableConduit,
	#superclass : #Conduit,
	#instVars : [
		'incomingAction',
		'outgoingAction'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #examples }
PluggableConduit class >> transcripter [
	^ self new
		outgoingAction: [ :aPacket | Transcript cr; show: '<< '; show: aPacket fullPrintString];
		incomingAction: [ :aPacket | Transcript cr; show: '>> '; show: aPacket fullPrintString];
		yourself
]

{ #category : #accessing }
PluggableConduit >> incomingAction: aBlock [
	incomingAction := aBlock
]

{ #category : #flow }
PluggableConduit >> input: aPacket [
	incomingAction ifNotNil: [incomingAction value: aPacket].
	super input: aPacket
]

{ #category : #accessing }
PluggableConduit >> outgoingAction: aBlock [
	outgoingAction := aBlock
]

{ #category : #flow }
PluggableConduit >> output: aPacket [
	outgoingAction ifNotNil: [outgoingAction value: aPacket].
	super output: aPacket
]
