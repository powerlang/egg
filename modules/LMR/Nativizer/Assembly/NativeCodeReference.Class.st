'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #NativeCodeReference category: #'Powerlang-Core-Assembly'!
Object subclass: #NativeCodeReference
	instanceVariableNames: 'source sourceOffset target absolute'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beAbsolute
	absolute := true
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
classBinding
	^source classBinding
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
for: anObject
	self target: anObject
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	absolute := false
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isAbsolute
	^absolute
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	aStream nextPutAll: 'Ref to '; print: target
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
source: sourceObject
	source := sourceObject
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sourceOffset
	^sourceOffset
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sourceOffset: aNumber
	sourceOffset := aNumber
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
target
	^target
! !

!NativeCodeReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
target: anObject
	target := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativeCodeReference class' category: #'Powerlang-Core-Assembly'!
NativeCodeReference class
	instanceVariableNames: ''!

!NativeCodeReference class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
absoluteFor: anObject
	^(self new for: anObject) beAbsolute
! !

!NativeCodeReference class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !


NativeCodeReference initialize!

