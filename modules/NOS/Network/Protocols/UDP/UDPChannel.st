Class {
	#name : #UDPChannel,
	#superclass : #Conduit,
	#instVars : [
		'localPort',
		'remotePort'
	],
	#category : 'SqueakNOS-Net-Protocols-UDP'
}

{ #category : #flow }
UDPChannel >> accepts: aPacket [
	^ ((aPacket isKindOf: UDPPacket)
		and: [localPort isNil or: [aPacket destination = localPort]])
			and: [remotePort isNil or: [aPacket source = remotePort]]
]

{ #category : #accessing }
UDPChannel >> mtu [
	^ super mtu - UDPPacket headerSize
]
