Class {
	#name : #EthernetPacket,
	#superclass : #Packet,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
EthernetPacket class >> fieldsNames [
	^ #(destination source type)
]

{ #category : #accessing }
EthernetPacket class >> headerSize [
	^ 14
]

{ #category : #accessing }
EthernetPacket class >> protocol [
	^ 97
]

{ #category : #'instances creation' }
EthernetPacket class >> with: aPacket headerSize: anInteger [
	^ (super with: aPacket headerSize: anInteger)
		type: aPacket class etherType
]

{ #category : #accessing }
EthernetPacket >> data [
	| type |
	type := self type.
	Packet allSubclassesDo: [ :each | each etherType = type ifTrue: [^ each on: self]].
	^ nil
]

{ #category : #accessing }
EthernetPacket >> destination [
	^ EthernetAddress bytes: (self copyFrom: 1 to: 6)
]

{ #category : #accessing }
EthernetPacket >> destination: anEthernetAddress [
	self replaceFrom: 1 to: 6 with: anEthernetAddress asByteArray
]

{ #category : #printing }
EthernetPacket >> printOn: aStream [
	aStream nextPutAll: 'Ether '; print: self source; nextPutAll: ' -> '; print: self destination
]

{ #category : #accessing }
EthernetPacket >> source [
	^ EthernetAddress bytes: (self copyFrom: 7 to: 12)
]

{ #category : #accessing }
EthernetPacket >> source: anEthernetAddress [
	self replaceFrom: 7 to: 12 with: anEthernetAddress asByteArray
]

{ #category : #accessing }
EthernetPacket >> type [
	^ self shortAt: 13
]

{ #category : #accessing }
EthernetPacket >> type: anInteger [
	self shortAt: 13 put: anInteger
]
