Class {
	#name : #NetworkingDevice,
	#superclass : #PCIDevice,
	#category : #'SqueakNOS-Devices-Network'
}

{ #category : #'as yet unclassified' }
NetworkingDevice class >> onPCIEntry: aPCIBusEntry computer: aComputer [
	| answer |
	answer := super onPCIEntry: aPCIBusEntry computer: aComputer.
	aComputer defaultNetworkInterface: answer.
	^answer
]

{ #category : #'as yet unclassified' }
NetworkingDevice >> down [
]

{ #category : #'as yet unclassified' }
NetworkingDevice >> input: pkt [
	"a packet coming from media"
	self triggerEvent: #input: with: pkt.

]

{ #category : #'as yet unclassified' }
NetworkingDevice >> mtu [
	" 1536 - 4 (for Ethernet CRC)"
	^ 1532
]

{ #category : #'as yet unclassified' }
NetworkingDevice >> output: aPacket [
	^ self sendNow: aPacket
]

{ #category : #'as yet unclassified' }
NetworkingDevice >> up [
]
