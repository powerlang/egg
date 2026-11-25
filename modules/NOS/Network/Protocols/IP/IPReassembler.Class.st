'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IPReassembler category: 'SqueakNOS-Net-Protocols-IP'!
Conduit subclass: #IPReassembler
	instanceVariableNames: 'lists'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-IP'!
!IPReassembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	lists := Heap sortBlock: [ :a :b | a timeout < b timeout]
! !

!IPReassembler methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: anIPPacket
	| reassemblyList |
	anIPPacket isFragment ifFalse: [^ super input: anIPPacket].
	reassemblyList := lists detect: [ :one | one matches: anIPPacket] ifNone: [lists add: (IPReassemblyList new timeout: timer time + 20000)].
	reassemblyList add: anIPPacket.
	reassemblyList isComplete ifFalse: [^ self].
	lists remove: reassemblyList.
	super input: reassemblyList packet
! !

!IPReassembler methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
prune
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
! !

!IPReassembler methodsFor:  'timers' stamp: 'KenD 28/Jun/2026 13:32:25'!
schedule
	super schedule.
	timer every: 5000 "msecs" send: #prune to: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IPReassembler class' category: 'SqueakNOS-Net-Protocols-IP'!
IPReassembler class
	instanceVariableNames: ''!


IPReassembler initialize!

