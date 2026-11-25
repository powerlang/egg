'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #OFWDeviceNode category: 'SqueakNOS-OFW-OLPC'!
OpenFirmwareCalloutClient subclass: #OFWDeviceNode
	instanceVariableNames: 'phandle'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-OFW-OLPC'!
!OFWDeviceNode commentStamp: '<historical>' prior: 0!

chosen := OFWDeviceNode findDevice: '/chosen'
chosen nextProp: ''

!

!OFWDeviceNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
getProp: propertyName
	| args len buf |
	len := self getPropLen: propertyName.
	buf := String new: len.
	args := self newArgsFor: 'getprop' inputs: 4 outputs: 1.
	args at: 4 put: phandle.
	args at: 5 put: propertyName, (Character value: 0) asString.
	args at: 6 put: buf.
	args at: 7 put: len.
	self callout: args.
	^ buf

! !

!OFWDeviceNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
getPropLen: propertyName
	| args |
	args := self newArgsFor: 'getproplen' inputs: 2 outputs: 1.
	args at: 4 put: phandle.
	args at: 5 put: propertyName, (Character value: 0) asString.
	self callout: args.
	^ args last

! !

!OFWDeviceNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
handle
	^ phandle
! !

!OFWDeviceNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
handle: anInteger
	phandle := anInteger
! !

!OFWDeviceNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextProp: previous
	| args buf |
	buf := String new: 32.
	args := self newArgsFor: 'getprop' inputs: 3 outputs: 1.
	args at: 4 put: phandle.
	args at: 5 put: previous, (Character value: 0) asString.
	args at: 6 put: buf.

	self callout: args.
	^ buf

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OFWDeviceNode class' category: 'SqueakNOS-OFW-OLPC'!
OFWDeviceNode class
	instanceVariableNames: ''!

!OFWDeviceNode class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
findDevice: nodeName
	| args |
	args := self newArgsFor: 'finddevice' inputs: 1 outputs: 1.
	args at: 4 put: nodeName.
	self callout: args.
	^ self new handle: args last

! !


