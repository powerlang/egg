Class {
	#name : #IPTest,
	#superclass : #TestCase,
	#instVars : [
		'loopback',
		'ip1',
		'ip2'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #running }
IPTest >> newHostWithAddress: anInternetAddress [
	| ip |
	ip := IP new.
	ip address: anInternetAddress.
	ip | ICMP new.
	ip | TCP new.
	ip | UDP new.
	^ ip
]

{ #category : #running }
IPTest >> roundTripMilliseconds [
	^ 1000
]

{ #category : #running }
IPTest >> setUp [
	ip1 := self newHostWithAddress: (InternetAddress fromString: '192.168.88.1').
	ip2 := self newHostWithAddress: (InternetAddress fromString: '192.168.88.2').

	loopback := NetInterface loopback.

	loopback | PluggableConduit transcripter | ip1.
	loopback | PluggableConduit transcripter | ip2.

	loopback up
]

{ #category : #running }
IPTest >> tearDown [
	loopback down
]

{ #category : #testing }
IPTest >> testBigIPPacket [
	| received bigPacket socket |
	socket := ip2 raw | InternalRawSocket new.
	bigPacket := (IPPacket with: (UDPPacket new: 5000)) destination: ip2 address.
	ip1 << bigPacket.
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received length = bigPacket length
]

{ #category : #testing }
IPTest >> testIPPacket [
	| semaphore received |
	semaphore := Semaphore new.
	ip2 | (PluggableConduit new incomingAction: [ :packet | received _ packet. semaphore signal]).
	ip1 << ((IPPacket with: (UDPPacket new: 100)) destination: ip2 address).
	semaphore waitTimeoutMSecs: self roundTripMilliseconds.
	self assert: received notNil
]

{ #category : #testing }
IPTest >> testPing [
	| icmp ip socket response |
	icmp := (ICMPPacket new: 100)
		typeName: #EchoRequest;
		id: 1;
		sequence: 1.
	ip := (IPPacket with: icmp)
		destination: ip2 address;
		ttl: 255;
		id: 34233.
	socket := ip1 icmp | InternalRawSocket new.
	socket nextPut: ip.
	response := [socket nextTimeoutMSecs: 1000] on: TimedOut do: [self error: 'timed out'].
	self assert: response isEchoReply & (response envelope source = ip2 address)
]

{ #category : #testing }
IPTest >> testProtocolUnreachable [
	| received socket |
	socket := ip1 icmp | InternalRawSocket new.
	ip1 << ((IPPacket with: (IGMPPacket new: 100)) destination: ip2 address).
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received isProtocolUnreachable
]

{ #category : #testing }
IPTest >> testRawIP [
	| received socket |
	socket := ip2 raw | InternalRawSocket new.
	ip1 << ((IPPacket with: (UDPPacket new: 100)) destination: ip2 address).
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received destination = ip2 address.
	self assert: received source = ip1 address.
	self assert: (received data isKindOf: UDPPacket)
]

{ #category : #testing }
IPTest >> testUDP [
	| socket1 socket2 hola |
	socket1 := ip1 udp socketTo: ip2 address port: 5678 localPort: 1234.
	socket2 := ip2 udp socketTo: ip1 address port: 1234 localPort: 5678.
	self assert: socket2 dataAvailable not.
	socket1 nextPut: (UDPPacket with: 'hola').
	hola := socket2 nextTimeoutMSecs: self roundTripMilliseconds.
	self assert: hola rawData asString = 'hola'.
	self assert: socket2 dataAvailable not
]

{ #category : #testing }
IPTest >> testUDPClosed [
	| received socket |
	socket := ip1 icmp | InternalRawSocket new.
	ip1 << ((IPPacket with: ((UDPPacket new: 100) destination: 100)) destination: ip2 address).
	received := [socket nextTimeoutMSecs: self roundTripMilliseconds] on: TimedOut do: [].
	self assert: received notNil.
	self assert: received isPortUnreachable
]
