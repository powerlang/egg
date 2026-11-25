'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #OpenFirmwareCalloutClient category: 'SqueakNOS-OFW-OLPC'!
Object subclass: #OpenFirmwareCalloutClient
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-OFW-OLPC'!
!OpenFirmwareCalloutClient commentStamp: '<historical>' prior: 0!

args := OpenFirmwareCalloutClient newArgsFor: 'interpreter' inputs: 1 outputs: 0.
args at: 4 put: '." hola manola"'.
OpenFirmwareCalloutClient callout: args.
(ExternalAddress new fromInteger: args fourth / 2) stringAt: 0 size: 100

!

!OpenFirmwareCalloutClient methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
callout: anArray
	self class callout: anArray
! !

!OpenFirmwareCalloutClient methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
newArgsFor: serviceName inputs: aInteger outputs: bInteger
	^ self class newArgsFor: serviceName inputs: aInteger outputs: bInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OpenFirmwareCalloutClient class' category: 'SqueakNOS-OFW-OLPC'!
OpenFirmwareCalloutClient class
	instanceVariableNames: ''!

!OpenFirmwareCalloutClient class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
callout: anArray
	| answer |
	answer := self primOFWCallout: anArray.
	answer = 0 ifFalse: [^ self error: 'OpenFirmware calout returned error: ', answer printString]
! !

!OpenFirmwareCalloutClient class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
newArgsFor: serviceName inputs: aInteger outputs: bInteger
	| answer |
	answer := Array new: 3 + aInteger + bInteger.
	answer
		at: 1 put: serviceName, (Character value: 0) asString;
		at: 2 put: aInteger;
		at: 3 put: bInteger.
	^ answer

! !

!OpenFirmwareCalloutClient class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
primOFWCallout: anArray
	<primitive: 'primitiveOFWCallout' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !


