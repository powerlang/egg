Class {
	#name : #IPv6Packet,
	#superclass : #IPPacket,
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #accessing }
IPv6Packet class >> etherType [
	^ 16r86DD
]
