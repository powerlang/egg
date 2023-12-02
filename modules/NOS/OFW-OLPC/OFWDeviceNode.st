"
chosen := OFWDeviceNode findDevice: '/chosen'
chosen nextProp: ''

"
Class {
	#name : #OFWDeviceNode,
	#superclass : #OpenFirmwareCalloutClient,
	#instVars : [
		'phandle'
	],
	#category : 'SqueakNOS-OFW-OLPC'
}

{ #category : #'as yet unclassified' }
OFWDeviceNode class >> findDevice: nodeName [
	| args |
	args := self newArgsFor: 'finddevice' inputs: 1 outputs: 1.
	args at: 4 put: nodeName.
	self callout: args.
	^ self new handle: args last

]

{ #category : #'as yet unclassified' }
OFWDeviceNode >> getProp: propertyName [ 
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

]

{ #category : #'as yet unclassified' }
OFWDeviceNode >> getPropLen: propertyName [ 
	| args |
	args := self newArgsFor: 'getproplen' inputs: 2 outputs: 1.
	args at: 4 put: phandle.
	args at: 5 put: propertyName, (Character value: 0) asString.
	self callout: args.
	^ args last

]

{ #category : #'as yet unclassified' }
OFWDeviceNode >> handle [
	^ phandle
]

{ #category : #'as yet unclassified' }
OFWDeviceNode >> handle: anInteger [
	phandle := anInteger
]

{ #category : #'as yet unclassified' }
OFWDeviceNode >> nextProp: previous [ 
	| args buf |
	buf := String new: 32.
	args := self newArgsFor: 'getprop' inputs: 3 outputs: 1.
	args at: 4 put: phandle.
	args at: 5 put: previous, (Character value: 0) asString.
	args at: 6 put: buf.

	self callout: args.
	^ buf

]
