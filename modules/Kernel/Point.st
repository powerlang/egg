"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Point,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Point class >> fromString: aString [
	^self readFrom: aString readStream
]

{ #category : #'instance creation' }
Point class >> readFrom: aStream [
	"
	Point readFrom: '1 @ 2' readStream
	"
	| x y |
	aStream skipSeparators.
	x := Integer readFrom: aStream.
	aStream skipTo: $@; skipSeparators.
	y := Integer readFrom: aStream.
	^x @ y
]

{ #category : #'instance creation' }
Point class >> x: x y: y [
	^self new x: x; y: y
]

{ #category : #arithmetic }
Point >> - operand [
	| point |
	point := operand asPoint.
	^x - point x @ (y - point y)
]

{ #category : #arithmetic }
Point >> * operand [
	| point |
	point := operand asPoint.
	^x * point x @ (y * point y)
]

{ #category : #arithmetic }
Point >> / operand [
	| point |
	point := operand asPoint.
	^x / point x @ (y / point y)
]

{ #category : #arithmetic }
Point >> // operand [
	| point |
	point := operand asPoint.
	^x // point x @ (y // point y)
]

{ #category : #arithmetic }
Point >> \\ operand [
	| point |
	point := operand asPoint.
	^x \\ point x @ (y \\ point y)
]

{ #category : #arithmetic }
Point >> + operand [
	| point |
	point := operand asPoint.
	^x + point x @ (y + point y)
]

{ #category : #comparing }
Point >> < aPoint [
	^x < aPoint x and: [y < aPoint y]
]

{ #category : #comparing }
Point >> <= aPoint [
	^x <= aPoint x and: [y <= aPoint y]
]

{ #category : #comparing }
Point >> = aPoint [
	^aPoint isPoint and: [x = aPoint x] and: [y = aPoint y]
]

{ #category : #comparing }
Point >> > aPoint [
	^x > aPoint x and: [self y > aPoint y]
]

{ #category : #comparing }
Point >> >= aPoint [
	^x >= aPoint x and: [y >= aPoint y]
]

{ #category : #arithmetic }
Point >> abs [
	^x abs @ y abs
]

{ #category : #comparing }
Point >> asPoint [
	^self
]

{ #category : #comparing }
Point >> between: aPoint and: anotherPoint [
	^aPoint <= self and: [self <= anotherPoint]
]

{ #category : #geometry }
Point >> corner: aPoint [
	^Rectangle origin: self corner: aPoint
]

{ #category : #geometry }
Point >> down: aNumber [
	^x @ (y + aNumber)
]

{ #category : #geometry }
Point >> extent: aPoint [
	^Rectangle origin: self extent: aPoint
]

{ #category : #comparing }
Point >> hash [
	^x hashWith: y
]

{ #category : #'geometry - testing' }
Point >> isBefore: aPoint [
	^y < aPoint y or: [aPoint y = y and: [x < aPoint x]]
]

{ #category : #testing }
Point >> isPoint [
	^true
]

{ #category : #accessing }
Point >> left: aNumber [
	^x - aNumber @ y
]

{ #category : #geometry }
Point >> leftAndDown: delta [
	| point |
	point := delta asPoint.
	^x - point x @ (y + point y)
]

{ #category : #geometry }
Point >> leftAndUp: delta [
	| point |
	point := delta asPoint.
	^x - point x @ (y - point y)
]

{ #category : #comparing }
Point >> max: aPoint [
	^(x max: aPoint x) @ (y max: aPoint y)
]

{ #category : #comparing }
Point >> min: aPoint [
	| max |
	max := aPoint asPoint.
	^(x min: max x) @ (y min: max y)
]

{ #category : #arithmetic }
Point >> moveBy: aPoint [
	x := x + aPoint x.
	y := y + aPoint y
]

{ #category : #arithmetic }
Point >> negated [
	^x negated @ y negated
]

{ #category : #printing }
Point >> printOn: aStream [
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
]

{ #category : #geometry }
Point >> right: aNumber [
	^x + aNumber @ y
]

{ #category : #geometry }
Point >> rightAndUp: delta [
	| point |
	point := delta asPoint.
	^x + point x @ (y - point y)
]

{ #category : #geometry }
Point >> rightBottom: aPoint [
	^self corner: aPoint
]

{ #category : #geometry }
Point >> rightTop: aPoint [
	^Rectangle leftBottom: self rightTop: aPoint
]

{ #category : #arithmetic }
Point >> rounded [
	^x rounded @ y rounded
]

{ #category : #geometry }
Point >> translatedBy: delta [
	^self + delta
]

{ #category : #geometry }
Point >> transpose [
	^y @ x
]

{ #category : #arithmetic }
Point >> truncated [
	^x truncated @ y truncated
]

{ #category : #arithmetic }
Point >> truncateTo: factor [
	^(self x truncateTo: factor) @ (self y truncateTo: factor)
]

{ #category : #geometry }
Point >> up: aNumber [
	^x @ (y - aNumber)
]

{ #category : #accessing }
Point >> x [
	^x
]

{ #category : #accessing }
Point >> x: aNumber [
	x := aNumber
]

{ #category : #accessing }
Point >> x: abscissa y: ordinate [
	x := abscissa.
	y := ordinate
]

{ #category : #accessing }
Point >> y [
	^y
]

{ #category : #accessing }
Point >> y: aNumber [
	y := aNumber
]

