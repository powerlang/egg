"
args := OpenFirmwareCalloutClient newArgsFor: 'interpreter' inputs: 1 outputs: 0.
args at: 4 put: '."" hola manola""'.
OpenFirmwareCalloutClient callout: args.
(ExternalAddress new fromInteger: args fourth / 2) stringAt: 0 size: 100

"
Class {
	#name : #OpenFirmwareCalloutClient,
	#superclass : #Object,
	#category : #'SqueakNOS-OFW-OLPC'
}

{ #category : #'as yet unclassified' }
OpenFirmwareCalloutClient class >> callout: anArray [
	| answer |
	answer := self primOFWCallout: anArray.
	answer = 0 ifFalse: [^ self error: 'OpenFirmware calout returned error: ', answer printString]
]

{ #category : #'as yet unclassified' }
OpenFirmwareCalloutClient class >> newArgsFor: serviceName inputs: aInteger outputs: bInteger [
	| answer |
	answer := Array new: 3 + aInteger + bInteger.
	answer
		at: 1 put: serviceName, (Character value: 0) asString;
		at: 2 put: aInteger;
		at: 3 put: bInteger.
	^ answer

]

{ #category : #'as yet unclassified' }
OpenFirmwareCalloutClient class >> primOFWCallout: anArray [ 
	<primitive: 'primitiveOFWCallout' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #'as yet unclassified' }
OpenFirmwareCalloutClient >> callout: anArray [
	self class callout: anArray
]

{ #category : #'as yet unclassified' }
OpenFirmwareCalloutClient >> newArgsFor: serviceName inputs: aInteger outputs: bInteger [
	^ self class newArgsFor: serviceName inputs: aInteger outputs: bInteger
]
