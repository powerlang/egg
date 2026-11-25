'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NetHighLevelTest category: 'SqueakNOS-Net-Tests'!
TestCase subclass: #NetHighLevelTest
	instanceVariableNames: 'loopback net1 net2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!NetHighLevelTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
newHostWithEthernet: anEthernetAddress ip: anInternetAddress
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
! !

!NetHighLevelTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
roundTripMilliseconds
	^ 100
! !

!NetHighLevelTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
setUp
	net1 := self newHostWithEthernet: (EthernetAddress fromString: '00:48:54:85:CC:51') ip: (InternetAddress fromString: '192.168.88.1').
	net2 := self newHostWithEthernet: (EthernetAddress fromString: '00:82:44:55:DD:67') ip: (InternetAddress fromString: '192.168.88.2').

	loopback := NetInterface loopback.

	loopback "| TranscripterConduit new" | net1.
	loopback "| TranscripterConduit new" | net2.

	loopback up
! !

!NetHighLevelTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
tearDown
	loopback down
! !

!NetHighLevelTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testNetDown
	loopback down.
	self value: [(net1 findA: IP) << ((IPPacket with: (UDPPacket new: 100)) destination: (net2 findA: IP) address)] shouldRaise: NetDown
! !

!NetHighLevelTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testPing
	| ping |
	ping := Ping new.
	(net1 findA: ICMP) | ping.
	self assert: (ping ping: (net2 findA: IP) address).
	self assert: (ping ping: (net1 findA: IP) address).
	self deny: (ping ping: (InternetAddress fromString: '192.168.88.123'))
! !

!NetHighLevelTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testTCPSynScanner
	| scanner ports |
	scanner := TCPSynScanner new.
	scanner destination: (net2 findA: IP) address.
	(net1 findA: IP) | scanner.
	ports := (1 to: 10) collect: [ :each | 65535 atRandom].
	scanner scanAll: ports.
	(Delay forMilliseconds: self roundTripMilliseconds) wait.
	ports do: [ :each | self assert: (scanner closed includes: each)].
	self assert: scanner open isEmpty
! !

!NetHighLevelTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testTraceRoute
	| traceroute route |
	traceroute := TraceRoute new.
	(net1 findA: IP) | traceroute.
	route := traceroute routeTo: (net2 findA: IP) address.
	self assert: route size = 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NetHighLevelTest class' category: 'SqueakNOS-Net-Tests'!
NetHighLevelTest class
	instanceVariableNames: ''!


