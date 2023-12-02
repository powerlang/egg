"
(self onFileNamed: '../ssh-amadeus.tcpdump')
"
Class {
	#name : #PacketCapturerFile,
	#superclass : #InternalNetworkDevice,
	#instVars : [
		'stream',
		'packetClass'
	],
	#category : 'SqueakNOS-Net-Devices'
}

{ #category : #'instance creation' }
PacketCapturerFile class >> fileNamed: filename [
	^ self new stream: (FileStream readOnlyFileNamed: filename)
]

{ #category : #testing }
PacketCapturerFile >> atEnd [
	^ stream atEnd
]

{ #category : #accessing }
PacketCapturerFile >> close [
	stream close
]

{ #category : #initialization }
PacketCapturerFile >> initialize [
	super initialize.
	packetClass := EthernetPacket
]

{ #category : #accessing }
PacketCapturerFile >> nextPacket [
	| hdr packetLength capLen |
	hdr := stream next: 16.
	capLen := hdr unsignedLongAt: 9 bigEndian: false.
	packetLength := hdr unsignedLongAt: 13 bigEndian: false.
	^ packetClass bytes: (stream next: capLen)
]

{ #category : #accessing }
PacketCapturerFile >> output: ignore [
	^ self
]

{ #category : #accessing }
PacketCapturerFile >> packetClass: aClass [
	packetClass := aClass
]

{ #category : #accessing }
PacketCapturerFile >> run [
	[self input: self nextPacket] repeat
]

{ #category : #accessing }
PacketCapturerFile >> stream: aStream [
	stream := aStream binary.
	stream skip: 24
]
