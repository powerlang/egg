Class {
	#name : #SqueakNOSNetworkTest,
	#superclass : #TestCase,
	#instVars : [
		'eth'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> addressOfTestServer [
	^ InternetAddress fromString: '192.168.88.64'
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> localAddress [
	^ InternetAddress fromString: '192.168.88.66'
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> setUp [
	eth := EthernetInterface on: Computer current defaultNetworkDevice.
	eth internetAddress: self localAddress.
	eth up
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> tearDown [
	eth down
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> testPing [
	| icmp ip socket response |
	icmp := (ICMPPacket new: 100)
		typeName: #EchoRequest;
		id: 1;
		sequence: 1.
	ip := (IPPacket with: icmp)
		destination: self addressOfTestServer;
		ttl: 255;
		id: 34233.
	socket := eth ip icmp | InternalRawSocket new.
	socket nextPut: ip.
	response := [socket nextTimeoutMSecs: 1000] on: TimedOut do: [self error: 'timed out'].
	self assert: response isEchoReply & (response envelope source = self addressOfTestServer)
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> testPingBig [
	| icmp ip socket response |
	icmp := (ICMPPacket new: 10000)
		typeName: #EchoRequest;
		id: 1;
		sequence: 1.
	ip := (IPPacket with: icmp)
		destination: self addressOfTestServer;
		ttl: 255;
		id: 34233.
	socket := eth ip icmp | InternalRawSocket new.
	socket nextPut: ip.
	response := [socket nextTimeoutMSecs: 1000] on: TimedOut do: [self error: 'timed out'].
	self assert: response isEchoReply & (response envelope source = self addressOfTestServer)
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> testProtocolUnreachable [
	| received socket |
	socket := eth ip icmp | InternalRawSocket new.
	eth ip << ((IPPacket with: (IGMPPacket new: 100)) destination: self addressOfTestServer).
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received isProtocolUnreachable
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> testTCPEcho [
	| stream |
	stream := eth ip tcp connectTo: self addressOfTestServer port: 7.
	stream nextPutAll: 'hola'; flush.
	[stream waitForReadabilityTimeoutAfter: 1000] on: TimedOut do: [^ self error: 'timed out'].
	self assert: stream nextAvailable = 'hola'.
	stream close
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> testTCPEcho2 [
	| stream |
	stream := eth ip tcp connectTo: self addressOfTestServer port: 7.
	self assert: stream dataAvailable not.
	stream nextPutAll: 'hola'; flush.
	[stream waitForReadabilityTimeoutAfter: 1000] on: TimedOut do: [^ self error: 'timed out'].
	self assert: stream nextAvailable = 'hola'.
	self assert: stream dataAvailable not.
	stream nextPutAll: 'chau'; flush.
	[stream waitForReadabilityTimeoutAfter: 1000] on: TimedOut do: [^ self error: 'timed out'].
	self assert: stream nextAvailable = 'chau'.
	self assert: stream dataAvailable not.
	stream close
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> testUDPClosed [
	| received socket |
	socket := eth ip icmp | InternalRawSocket new.
	eth ip << ((IPPacket with: ((UDPPacket new: 100) destination: 100)) destination: self addressOfTestServer).
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received isPortUnreachable
]

{ #category : #'as yet unclassified' }
SqueakNOSNetworkTest >> testUDPEcho [
	| socket packet |
	socket := eth ip udp socketTo: self addressOfTestServer port: 7.
	socket nextPut: (UDPPacket with: 'hola').
	[packet := socket nextTimeoutMSecs: 1000] on: TimedOut do: [^ self error: 'timed out'].
	self assert: packet rawData asString = 'hola'.
	socket close
]
