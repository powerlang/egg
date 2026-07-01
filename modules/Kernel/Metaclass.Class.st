'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Metaclass category: #Kernel!
Species subclass: #Metaclass
	instanceVariableNames: 'class'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Metaclass commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Metaclass class' category: #Kernel!
Metaclass class
	instanceVariableNames: ''!

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name
	^class name , ' class'
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
beSubclassOf: aClass
	| md |	
	format := aClass format.
	superclass := aClass.
	md := MethodDictionary new: 2.
	instanceBehavior := Behavior with: md withAll: aClass instanceBehavior.
	instanceBehavior classBinding: self.
	class := self new
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVariables
	^class classVariables
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVarNames
	^class classVarNames
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
comment
	^class comment
! !

!Metaclass methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
duplicateHierarchyFrom: aClass with: aClassCopy
	^(class duplicateHierarchyFrom: aClass with: aClassCopy) class
! !

!Metaclass methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^class hash
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instanceClass
	^class
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instanceClass: aClass
	class := aClass
! !

!Metaclass methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMetaclass
	^true
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name
	^class name , ' class'
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
namespace
	^class namespace
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
module
	^class module
! !

!Metaclass methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
shouldBeHidden: aSymbol
	^class shouldBeHidden: aSymbol
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subclasses
	^class subclasses collect: [:cls | cls class]
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subclasses: aCollection
	"
	do nothing
	"
	
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subclassesDo: aBlock
	class isNil ifTrue: [^self].
	class subclasses
		select: [:cls | cls notNil]
		thenDo: [:cls | aBlock value: cls class]
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subspecies
	^self subclasses
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subspeciesDo: aBlock
	self subclassesDo: aBlock
! !

!Metaclass methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
symbol
	^self name asSymbol
! !


