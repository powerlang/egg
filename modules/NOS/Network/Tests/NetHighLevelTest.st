Class {
	#name : #NetHighLevelTest,
	#superclass : #TestCase,
	#instVars : [
		'loopback',
		'net1',
		'net2'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #'instance creation' }
NetHighLevelTest >> newHostWithEthernet: anEthernetAddress ip: anInternetAddress [
	| ip ethernet |
	ip := IP new.
	ip address: anInternetAddress.
	ip | ICMP new.
	ip | TCP new.
	ip | UDP new.
	ethernet := Ethernet new.
	ethernet address: anEthernetAddress.
	ethernet | ip.
	ethernet arp protocolAddress: ip address.
	^ ethernet
]

{ #category : #'as yet unclassified' }
NetHighLevelTest >> roundTripMilliseconds [
	^ 100
]

{ #category : #'as yet unclassified' }
NetHighLevelTest >> setUp [
	net1 := self newHostWithEthernet: (EthernetAddress fromString: '00:48:54:85:CC:51') ip: (InternetAddress fromString: '192.168.88.1').
	net2 := self newHostWithEthernet: (EthernetAddress fromString: '00:82:44:55:DD:67') ip: (InternetAddress fromString: '192.168.88.2').

	loopback := NetInterface loopback.

	loopback "| TranscripterConduit new" | net1.
	loopback "| TranscripterConduit new" | net2.

	loopback up
]

{ #category : #'as yet unclassified' }
NetHighLevelTest >> tearDown [
	loopback down
]

{ #category : #'as yet unclassified' }
NetHighLevelTest >> testNetDown [
	loopback down.
	self value: [(net1 findA: IP) << ((IPPacket with: (UDPPacket new: 100)) destination: (net2 findA: IP) address)] shouldRaise: NetDown
]

{ #category : #tests }
NetHighLevelTest >> testPing [
	| ping |
	ping := Ping new.
	(net1 findA: ICMP) | ping.
	self assert: (ping ping: (net2 findA: IP) address).
	self assert: (ping ping: (net1 findA: IP) address).
	self deny: (ping ping: (InternetAddress fromString: '192.168.88.123'))
]

{ #category : #tests }
NetHighLevelTest >> testTCPSynScanner [
	| scanner ports |
	scanner := TCPSynScanner new.
	scanner destination: (net2 findA: IP) address.
	(net1 findA: IP) | scanner.
	ports := (1 to: 10) collect: [ :each | 65535 atRandom].
	scanner scanAll: ports.
	(Delay forMilliseconds: self roundTripMilliseconds) wait.
	ports do: [ :each | self assert: (scanner closed includes: each)].
	self assert: scanner open isEmpty
]

{ #category : #tests }
NetHighLevelTest >> testTraceRoute [
	| traceroute route |
	traceroute := TraceRoute new.
	(net1 findA: IP) | traceroute.
	route := traceroute routeTo: (net2 findA: IP) address.
	self assert: route size = 1
]
