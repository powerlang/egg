Class {
	#name : #ATAControllerTest,
	#superclass : #TestCase,
	#instVars : [
		'controller'
	],
	#category : #'SqueakNOS-Devices-Storage'
}

{ #category : #tests }
ATAControllerTest >> selectFirstSector [
	controller unsignedByteAt: 6 put: 16rE0.	"(slavebit << 4) | ((addr >> 24) & 0x0F));"
	controller unsignedByteAt: 1 put: 16r00.
	controller unsignedByteAt: 2 put: 16r01.
	controller unsignedByteAt: 3 put: 0.	"; addr"
	controller unsignedByteAt: 4 put: 0.	"; addr >> 8"
	controller unsignedByteAt: 5 put: 0	"; addr >> 16"
]

{ #category : #tests }
ATAControllerTest >> setUp [
	controller := ATAController primary.

]

{ #category : #tests }
ATAControllerTest >> test010SameStatus [
	|  alternate regular |

	alternate := controller atAlternateStatusReg.
	regular := controller atStatusReg.
	self assert: alternate equals: regular
]

{ #category : #tests }
ATAControllerTest >> test020ReadSectorRaw [
	"read boot sector, which ends in the magic number 0xAA55"

	| status buffer short |
	self selectFirstSector.
	controller unsignedByteAt: 7 put: 16r20.	" ; read command"

	"wait until not busy"
	[ status := controller control uByteAtOffset: 0.
	(status bitAnd: 2r10000000) = 0 ] whileFalse.

	"do read"
	buffer := ByteArray new: 512.
	1 to: 256 do: [ :i | 
		short := controller unsignedShortAt: 0.
		buffer unsignedShortAt: i * 2 - 1 put: short ].
	self assert: short equals: 16rAA55
]

{ #category : #tests }
ATAControllerTest >> test030Read1Sector [
	| sector magic |
	sector := controller
		issueReadFrom: 0
		count: 1
		device: 0
		timeout: 1000.
	magic := sector unsignedShortAt: 511.
	self assert: magic equals: 16rAA55
]

{ #category : #tests }
ATAControllerTest >> test040ReadSectorsInBlock [
	| all first second third fourth |
	all := controller at: 1 count: 4 of: 0.
	first := controller at: 1 count: 1 of: 0.
	second := controller at: 2 count: 1 of: 0.
	third := controller at: 3 count: 1 of: 0.
	fourth := controller at: 4 count: 1 of: 0.
	self assert: all equals: first , second , third , fourth
]
