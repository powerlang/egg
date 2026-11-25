'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SPragmaNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SPragmaNode
	instanceVariableNames: 'type name info'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: aVisitor
	self isFFI ifTrue: [^aVisitor visitFFIPragma: self].
	self isPrimitive ifTrue: [^aVisitor visitPrimitivePragma: self].
	self isSymbolic ifTrue: [^aVisitor visitSymbolicPragma: self]
! !

!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
ffi: cc name: aString with: anFFIDescriptor
	type := cc.
	name := aString.
	info := anFFIDescriptor
! !

!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
ffi: aString with: anFFIDescriptor
	type := #ffi.
	name := aString.
	info := anFFIDescriptor
! !

!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
info
	^info
! !

!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
isUsed
	^type notNil
! !

!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^name
! !

!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
primitive: anInteger name: aString
	type := #primitive.
	name := aString.
	info := anInteger
! !

!SPragmaNode methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
type
	^type
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SPragmaNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SPragmaNode class
	instanceVariableNames: ''!


