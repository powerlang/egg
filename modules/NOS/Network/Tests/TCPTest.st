Class {
	#name : #TCPTest,
	#superclass : #TestCase,
	#instVars : [
		'loopback',
		'ip1',
		'ip2',
		'socket1',
		'socket2',
		'stream1',
		'stream2'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #running }
TCPTest >> newHostWithAddress: anInternetAddress [
	| ip |
	ip := IP new.
	ip address: anInternetAddress.
	ip | ICMP new.
	ip | UDP new.
	ip | TCP new.
	^ ip
]

{ #category : #running }
TCPTest >> roundTripMilliseconds [
	^ 1000
]

{ #category : #running }
TCPTest >> setUp [
	ip1 := self newHostWithAddress: (InternetAddress fromString: '192.168.88.1').
	ip2 := self newHostWithAddress: (InternetAddress fromString: '192.168.88.2').

	ip1 tcp timerUp.
	ip2 tcp timerUp.

	loopback := NetInterface on: RealisticLoopback new.

	loopback | (PluggableConduit new outgoingAction: [ :each | Transcript cr; nextPutAll: '(1) ', each fullPrintString]) | ip1.
	loopback | (PluggableConduit new outgoingAction: [ :each | Transcript cr; nextPutAll: '(2) ', each fullPrintString]) | ip2.

	stream1 := NetStream on: (socket1 := InternalTCPSocket new localPort: 1234; remoteAddress: ip2 address; remotePort: 5678).
	stream2 := NetStream on: (socket2 := InternalTCPSocket new localPort: 5678; remoteAddress: ip1 address; remotePort: 1234).
	(ip1 findA: TCP) | socket1.
	(ip2 findA: TCP) | socket2.

	loopback up
]

{ #category : #running }
TCPTest >> tearDown [
	ip1 tcp timerDown.
	ip2 tcp timerDown.

	loopback down
]

{ #category : #testing }
TCPTest >> testConnectionEstablishment [
	socket1 listen.
	self assert: (socket1 state isKindOf: TCPListen).
	socket2 connect.
	self assert: (socket2 state isKindOf: TCPSynSent).
	(Delay forMilliseconds: 2000) wait.
	self assert: (socket1 state isKindOf: TCPEstablished).
	self assert: (socket2 state isKindOf: TCPEstablished)
]

{ #category : #testing }
TCPTest >> testConnectionRefused [
"	socket1 listen." "skip listening and still try to connect"
	socket2 connect.
	self assert: (socket2 state isKindOf: TCPSynSent).
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPClosed)
]

{ #category : #testing }
TCPTest >> testConnectionTermination [
	socket1 listen.
	self assert: (socket1 state isKindOf: TCPListen).
	socket2 connect.
	self assert: (socket2 state isKindOf: TCPSynSent).
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPEstablished).
	self assert: (socket2 state isKindOf: TCPEstablished).
	socket1 close.
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPFinWait2).
	self assert: (socket2 state isKindOf: TCPCloseWait).
	socket2 close.
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPTimeWait).
	self assert: (socket2 state isKindOf: TCPClosed)
]

{ #category : #testing }
TCPTest >> testDataFlow [
	| data |
	socket1 listen.
	socket2 connect.
	(Delay forMilliseconds: 1000) wait.
	self assert: stream2 dataAvailable not.
	stream1 nextPutAll: 'hola'; flush.
	self shouldnt: [data := stream2 next: 4 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self assert: data = 'hola'.
	self assert: stream2 dataAvailable not
]

{ #category : #testing }
TCPTest >> testHalfClose [
	| data |
	socket1 listen.
	socket2 connect.
	(Delay forMilliseconds: 1000) wait.
	stream2 close.
	(Delay forMilliseconds: 1000) wait.
	self assert: stream2 dataAvailable not.
	stream1 nextPutAll: 'some data'; flush.
	self shouldnt: [data := stream2 next: 9 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self assert: data = 'some data'.
	self assert: stream2 dataAvailable not
]

{ #category : #testing }
TCPTest >> testKamikaze [
	"Test sending and receibing a nastigram, i.e. a segment
	with SYN, EOL, URG, and FIN on and carrying one octet of data."
	self assert: false
]

{ #category : #testing }
TCPTest >> testListenWildcards [
	socket1 remoteAddress: nil; remotePort: nil.
	socket1 listen.
	self assert: (socket1 state isKindOf: TCPListen).
	socket2 connect.
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPEstablished).
	self assert: (socket2 state isKindOf: TCPEstablished).
	self assert: socket1 remoteAddress = ip2 address.
	self assert: socket1 remotePort = socket2 localPort
]

{ #category : #testing }
TCPTest >> testRetransmission [
	| data |
	socket1 listen.
	socket2 connect.
	(Delay forMilliseconds: 1000) wait.
	self assert: stream2 dataAvailable not.
	loopback device dropRate: 1.
	stream1 nextPutAll: 'hola'; flush.
	self should: [stream2 next: 4 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self assert: stream2 dataAvailable not.
	loopback device dropRate: 0.
	self shouldnt: [data := stream2 next: 4 timeoutAfter: self roundTripMilliseconds * 2] raise: TimedOut.
	self assert: data = 'hola'.
	self assert: stream2 dataAvailable not
]

{ #category : #testing }
TCPTest >> testSelfConnect [
	socket1 remoteAddress: ip1 address; remotePort: socket1 localPort.
	socket1 connect.
	self assert: (socket1 state isKindOf: TCPSynSent).
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPEstablished)
]

{ #category : #testing }
TCPTest >> testSelfConnectDataFlow [
	| data |
	socket1 remoteAddress: ip1 address; remotePort: socket1 localPort.
	socket1 connect.
	self assert: stream1 dataAvailable not.
	stream1 nextPutAll: 'hola'; flush.
	(Delay forMilliseconds: 1000) wait.
	self assert: stream1 dataAvailable.
	self shouldnt: [data := stream2 next: 4 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self assert: data = 'hola'.
	self assert: stream1 dataAvailable not
]

{ #category : #testing }
TCPTest >> testSequenceNumberWraparound [
	"Test proper functioning when sequence
	numbers (a) pass 2**31 (i.e., go from plus to 'minus') and
	(b) pass 2**32 (i.e., go from 2**32-1 to 0)."

	| data |
	socket1 sequence: (TCPSequenceNumber value: 16rFFFFFFF4).
	socket1 listen.
	socket2 connect.
	(Delay forMilliseconds: 1000) wait.
	self assert: stream2 dataAvailable not.
	stream1 nextPutAll: '1234567890abcdef'; flush.
	self shouldnt: [data := stream2 next: 16 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self assert: data = '1234567890abcdef'.
	self assert: stream2 dataAvailable not
]

{ #category : #testing }
TCPTest >> testSequenceNumberWraparound2 [
	| data |
	socket1 sequence: (TCPSequenceNumber value: 16rFFFFFFF4).
	socket1 listen.
	socket2 connect.
	(Delay forMilliseconds: 1000) wait.
	self assert: stream2 dataAvailable not.
	'1234567890abcdef' do: [ :each | stream1 nextPut: each].
	stream1 flush.
	self shouldnt: [data := stream2 next: 16 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self assert: data = '1234567890abcdef'.
	self assert: stream2 dataAvailable not
]

{ #category : #testing }
TCPTest >> testSimultaneousClose [
	socket1 listen.
	self assert: (socket1 state isKindOf: TCPListen).
	socket2 connect.
	self assert: (socket2 state isKindOf: TCPSynSent).
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPEstablished).
	self assert: (socket2 state isKindOf: TCPEstablished).
	socket1 close.
	socket2 close.
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket1 state isKindOf: TCPTimeWait).
	self assert: (socket2 state isKindOf: TCPTimeWait)
]

{ #category : #testing }
TCPTest >> testSimultaneousOpen [
	socket1 connect.
	self assert: (socket1 state isKindOf: TCPSynSent).
	socket2 connect.
	self assert: (socket2 state isKindOf: TCPSynSent).
	(Delay forMilliseconds: 1000) wait.
	self assert: (socket2 state isKindOf: TCPEstablished).
	self assert: (socket1 state isKindOf: TCPEstablished)
]

{ #category : #testing }
TCPTest >> testSlowStart [
	self assert: false
]

{ #category : #testing }
TCPTest >> testTwoConnectionsDataFlow [
	| data stream3 socket3 stream4 socket4 data2 |
	socket1 listen.
	socket2 connect.
	stream3 := NetStream on: (socket3 := InternalTCPSocket new localPort: 11234; remoteAddress: ip2 address; remotePort: 15678).
	stream4 := NetStream on: (socket4 := InternalTCPSocket new localPort: 15678; remoteAddress: ip1 address; remotePort: 11234).
	(ip1 findA: TCP) | socket3.
	(ip2 findA: TCP) | socket4.
	socket3 listen.
	socket4 connect.

	(Delay forMilliseconds: 1000) wait.
	self assert: stream2 dataAvailable not.
	stream1 nextPutAll: 'hola'; flush.
	stream3 nextPutAll: 'hello'; flush.
	self shouldnt: [data2 := stream4 next: 5 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self shouldnt: [data := stream2 next: 4 timeoutAfter: self roundTripMilliseconds] raise: TimedOut.
	self assert: data = 'hola'.
	self assert: data2 = 'hello'.
	self assert: stream2 dataAvailable not.
	self assert: stream4 dataAvailable not
]

{ #category : #testing }
TCPTest >> testUrgentData [
	self assert: false
]

{ #category : #testing }
TCPTest >> testZeroWindowACK [
	self assert: false
]
