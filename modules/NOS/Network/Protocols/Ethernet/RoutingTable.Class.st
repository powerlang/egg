'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RoutingTable category: 'SqueakNOS-Net-Protocols-Ethernet'!
Object subclass: #RoutingTable
	instanceVariableNames: 'routes default'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-Ethernet'!
!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: aRoute
	^ routes add: aRoute
! !

!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
default
	^ default
! !

!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
default: aRouteOrNil
	default := aRouteOrNil
! !

!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
gatewayTo: aNetAddress ifNone: exceptionBlock
	^ routes detect: [ :one | (one destination includes: aNetAddress) and: [one gateway notNil and: [one gateway ~= aNetAddress]]] ifNone: exceptionBlock
! !

!RoutingTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	routes := OrderedCollection new
! !

!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remove: aRoute
	^ routes remove: aRoute
! !

!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
routeTo: aNetAddress
	^ self routeTo: aNetAddress ifNone: [default]
! !

!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
routeTo: aNetAddress ifNone: exceptionBlock
	^ routes detect: [ :one | one destination includes: aNetAddress] ifNone: exceptionBlock
! !

!RoutingTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
routes
	^ routes
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RoutingTable class' category: 'SqueakNOS-Net-Protocols-Ethernet'!
RoutingTable class
	instanceVariableNames: ''!

!RoutingTable class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ super new initialize
! !


RoutingTable initialize!

