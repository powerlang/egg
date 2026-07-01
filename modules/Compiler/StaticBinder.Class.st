'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #StaticBinder category: #'Powerlang-Core-SCompiler'!
IdentifierBinder subclass: #StaticBinder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
at: aString
	^contents at: aString ifAbsent: nil
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
at: aString ifAbsentPut: aBlock
	^contents at: aString ifAbsentPut: aBlock
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
at: aString put: aBinding
	contents at: aString put: aBinding
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
define: aString as: aBinding
	contents at: aString put: aBinding
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
defines: identifier
	^contents includesKey: identifier
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
do: aBlock
	contents do: aBlock
! !

!StaticBinder methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	contents := OrderedDictionary new
! !

!StaticBinder methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPut: $<.
	contents keys
		do: [:name | name printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $>
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
select: aBlock
	^contents select: aBlock
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
values
	^contents values
! !

!StaticBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
withIndexDo: aBlock
	contents withIndexDo: aBlock
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StaticBinder class' category: #'Powerlang-Core-SCompiler'!
StaticBinder class
	instanceVariableNames: ''!


StaticBinder initialize!

