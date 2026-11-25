'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #EthernetPacket category: 'SqueakNOS-Net-Packets'!
Packet subclass: #EthernetPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!EthernetPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
data
	| type |
	type := self type.
	Packet allSubclassesDo: [ :each | each etherType = type ifTrue: [^ each on: self]].
	^ nil
! !

!EthernetPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
destination
	^ EthernetAddress bytes: (self copyFrom: 1 to: 6)
! !

!EthernetPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
destination: anEthernetAddress
	self replaceFrom: 1 to: 6 with: anEthernetAddress asByteArray
! !

!EthernetPacket methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: 'Ether '; print: self source; nextPutAll: ' -> '; print: self destination
! !

!EthernetPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
source
	^ EthernetAddress bytes: (self copyFrom: 7 to: 12)
! !

!EthernetPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
source: anEthernetAddress
	self replaceFrom: 7 to: 12 with: anEthernetAddress asByteArray
! !

!EthernetPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ self shortAt: 13
! !

!EthernetPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type: anInteger
	self shortAt: 13 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EthernetPacket class' category: 'SqueakNOS-Net-Packets'!
EthernetPacket class
	instanceVariableNames: ''!

!EthernetPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fieldsNames
	^ #(destination source type)
! !

!EthernetPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
headerSize
	^ 14
! !

!EthernetPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ 97
! !

!EthernetPacket class methodsFor:  'instances creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
with: aPacket headerSize: anInteger
	^ (super with: aPacket headerSize: anInteger)
		type: aPacket class etherType
! !


