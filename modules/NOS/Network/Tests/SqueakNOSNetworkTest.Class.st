'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #SqueakNOSNetworkTest category: 'SqueakNOS-Net-Tests'!
TestCase subclass: #SqueakNOSNetworkTest
	instanceVariableNames: 'eth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
addressOfTestServer
	^ InternetAddress fromString: '192.168.88.64'
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
localAddress
	^ InternetAddress fromString: '192.168.88.66'
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
setUp
	eth := EthernetInterface on: Computer current defaultNetworkDevice.
	eth internetAddress: self localAddress.
	eth up
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
tearDown
	eth down
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testPing
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
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testPingBig
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
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testProtocolUnreachable
	| received socket |
	socket := eth ip icmp | InternalRawSocket new.
	eth ip << ((IPPacket with: (IGMPPacket new: 100)) destination: self addressOfTestServer).
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received isProtocolUnreachable
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testTCPEcho
	| stream |
	stream := eth ip tcp connectTo: self addressOfTestServer port: 7.
	stream nextPutAll: 'hola'; flush.
	[stream waitForReadabilityTimeoutAfter: 1000] on: TimedOut do: [^ self error: 'timed out'].
	self assert: stream nextAvailable = 'hola'.
	stream close
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testTCPEcho2
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
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testUDPClosed
	| received socket |
	socket := eth ip icmp | InternalRawSocket new.
	eth ip << ((IPPacket with: ((UDPPacket new: 100) destination: 100)) destination: self addressOfTestServer).
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received isPortUnreachable
! !

!SqueakNOSNetworkTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testUDPEcho
	| socket packet |
	socket := eth ip udp socketTo: self addressOfTestServer port: 7.
	socket nextPut: (UDPPacket with: 'hola').
	[packet := socket nextTimeoutMSecs: 1000] on: TimedOut do: [^ self error: 'timed out'].
	self assert: packet rawData asString = 'hola'.
	socket close
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SqueakNOSNetworkTest class' category: 'SqueakNOS-Net-Tests'!
SqueakNOSNetworkTest class
	instanceVariableNames: ''!


