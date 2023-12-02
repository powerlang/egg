Class {
	#name : #IPReassembler,
	#superclass : #Conduit,
	#instVars : [
		'lists'
	],
	#category : 'SqueakNOS-Net-Protocols-IP'
}

{ #category : #initialization }
IPReassembler >> initialize [
	super initialize.
	lists := Heap sortBlock: [ :a :b | a timeout < b timeout]
]

{ #category : #flow }
IPReassembler >> input: anIPPacket [
	| reassemblyList |
	anIPPacket isFragment ifFalse: [^ super input: anIPPacket].
	reassemblyList := lists detect: [ :one | one matches: anIPPacket] ifNone: [lists add: (IPReassemblyList new timeout: timer time + 20000)].
	reassemblyList add: anIPPacket.
	reassemblyList isComplete ifFalse: [^ self].
	lists remove: reassemblyList.
	super input: reassemblyList packet
]

{ #category : #timers }
IPReassembler >> prune [
	| reassemblyList icmp ip |
	[lists notEmpty and: [lists first timeout < timer time]]
		whileTrue: [reassemblyList := lists removeFirst.
					(icmp := ICMPPacket quote: reassemblyList fragments first)
						typeName: #TimeExceeded;
						codeName: #FragmentationReassemblyTimeExceeded.
					(ip := IPPacket with: icmp)
						destination: reassemblyList source;
						id: reassemblyList id.
					self << ip]
]

{ #category : #timers }
IPReassembler >> schedule [
	super schedule.
	timer every: 5000 "msecs" send: #prune to: self
]
