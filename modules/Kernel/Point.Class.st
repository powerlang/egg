'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Point category: #Kernel!
Object subclass: #Point
	instanceVariableNames: 'x y'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Point commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- operand
	| point |
	point := operand asPoint.
	^x - point x @ (y - point y)
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* operand
	| point |
	point := operand asPoint.
	^x * point x @ (y * point y)
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ operand
	| point |
	point := operand asPoint.
	^x / point x @ (y / point y)
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
// operand
	| point |
	point := operand asPoint.
	^x // point x @ (y // point y)
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
\\ operand
	| point |
	point := operand asPoint.
	^x \\ point x @ (y \\ point y)
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ operand
	| point |
	point := operand asPoint.
	^x + point x @ (y + point y)
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aPoint
	^x < aPoint x and: [y < aPoint y]
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aPoint
	^x <= aPoint x and: [y <= aPoint y]
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aPoint
	^aPoint isPoint and: [x = aPoint x] and: [y = aPoint y]
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
> aPoint
	^x > aPoint x and: [self y > aPoint y]
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>= aPoint
	^x >= aPoint x and: [y >= aPoint y]
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
abs
	^x abs @ y abs
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
asPoint
	^self
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
between: aPoint and: anotherPoint
	^aPoint <= self and: [self <= anotherPoint]
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
corner: aPoint
	^Rectangle origin: self corner: aPoint
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
down: aNumber
	^x @ (y + aNumber)
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
extent: aPoint
	^Rectangle origin: self extent: aPoint
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^x hashWith: y
! !

!Point methodsFor:  'geometry - testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBefore: aPoint
	^y < aPoint y or: [aPoint y = y and: [x < aPoint x]]
! !

!Point methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isPoint
	^true
! !

!Point methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
left: aNumber
	^x - aNumber @ y
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftAndDown: delta
	| point |
	point := delta asPoint.
	^x - point x @ (y + point y)
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftAndUp: delta
	| point |
	point := delta asPoint.
	^x - point x @ (y - point y)
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
max: aPoint
	^(x max: aPoint x) @ (y max: aPoint y)
! !

!Point methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
min: aPoint
	| max |
	max := aPoint asPoint.
	^(x min: max x) @ (y min: max y)
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
moveBy: aPoint
	x := x + aPoint x.
	y := y + aPoint y
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
negated
	^x negated @ y negated
! !

!Point methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	x isFraction
		ifTrue: [
			aStream nextPut: $(.
			x printOn: aStream.
			aStream nextPut: $)]
		ifFalse: [x printOn: aStream].
	aStream nextPutAll: ' @ '.
	y isFraction
		ifTrue: [
			aStream nextPut: $(.
			y printOn: aStream.
			aStream nextPut: $)]
		ifFalse: [y printOn: aStream]
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
right: aNumber
	^x + aNumber @ y
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightAndUp: delta
	| point |
	point := delta asPoint.
	^x + point x @ (y - point y)
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightBottom: aPoint
	^self corner: aPoint
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightTop: aPoint
	^Rectangle leftBottom: self rightTop: aPoint
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
rounded
	^x rounded @ y rounded
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
translatedBy: delta
	^self + delta
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
transpose
	^y @ x
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncated
	^x truncated @ y truncated
! !

!Point methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncateTo: factor
	^(self x truncateTo: factor) @ (self y truncateTo: factor)
! !

!Point methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
up: aNumber
	^x @ (y - aNumber)
! !

!Point methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
x
	^x
! !

!Point methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
x: aNumber
	x := aNumber
! !

!Point methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
x: abscissa y: ordinate
	x := abscissa.
	y := ordinate
! !

!Point methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
y
	^y
! !

!Point methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
y: aNumber
	y := aNumber
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Point class' category: #Kernel!
Point class
	instanceVariableNames: ''!

!Point class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString
	^self readFrom: aString readStream
! !

!Point class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
readFrom: aStream
	"
	Point readFrom: '1 @ 2' readStream
	"
	| x y |
	aStream skipSeparators.
	x := Integer readFrom: aStream.
	aStream skipTo: $@; skipSeparators.
	y := Integer readFrom: aStream.
	^x @ y
! !

!Point class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
x: x y: y
	^self new x: x; y: y
! !


