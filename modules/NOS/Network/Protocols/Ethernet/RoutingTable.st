Class {
	#name : #RoutingTable,
	#superclass : #Object,
	#instVars : [
		'routes',
		'default'
	],
	#category : 'SqueakNOS-Net-Protocols-Ethernet'
}

{ #category : #'as yet unclassified' }
RoutingTable class >> new [
	^ super new initialize
]

{ #category : #accessing }
RoutingTable >> add: aRoute [
	^ routes add: aRoute
]

{ #category : #accessing }
RoutingTable >> default [
	^ default
]

{ #category : #accessing }
RoutingTable >> default: aRouteOrNil [
	default := aRouteOrNil
]

{ #category : #accessing }
RoutingTable >> gatewayTo: aNetAddress ifNone: exceptionBlock [
	^ routes detect: [ :one | (one destination includes: aNetAddress) and: [one gateway notNil and: [one gateway ~= aNetAddress]]] ifNone: exceptionBlock
]

{ #category : #initialization }
RoutingTable >> initialize [
	routes := OrderedCollection new
]

{ #category : #accessing }
RoutingTable >> remove: aRoute [
	^ routes remove: aRoute
]

{ #category : #accessing }
RoutingTable >> routeTo: aNetAddress [
	^ self routeTo: aNetAddress ifNone: [default]
]

{ #category : #accessing }
RoutingTable >> routeTo: aNetAddress ifNone: exceptionBlock [
	^ routes detect: [ :one | one destination includes: aNetAddress] ifNone: exceptionBlock
]

{ #category : #accessing }
RoutingTable >> routes [
	^ routes
]
