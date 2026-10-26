'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #PluggableConduit category: 'SqueakNOS-Net-Tests'!
Conduit subclass: #PluggableConduit
	instanceVariableNames: 'incomingAction outgoingAction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!PluggableConduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
incomingAction: aBlock
	incomingAction := aBlock
! !

!PluggableConduit methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	incomingAction ifNotNil: [incomingAction value: aPacket].
	super input: aPacket
! !

!PluggableConduit methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
outgoingAction: aBlock
	outgoingAction := aBlock
! !

!PluggableConduit methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
output: aPacket
	outgoingAction ifNotNil: [outgoingAction value: aPacket].
	super output: aPacket
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PluggableConduit class' category: 'SqueakNOS-Net-Tests'!
PluggableConduit class
	instanceVariableNames: ''!

!PluggableConduit class methodsFor:  'examples' stamp: 'KenD 28/Jun/2026 13:32:25'!
transcripter
	^ self new
		outgoingAction: [ :aPacket | Transcript cr; show: '<< '; show: aPacket fullPrintString];
		incomingAction: [ :aPacket | Transcript cr; show: '>> '; show: aPacket fullPrintString];
		yourself
! !


