"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Rectangle,
	#superclass : #Object,
	#instVars : [
		'origin',
		'corner'
	],
	#category : #Kernel
}

{ #category : #inspecting }
Rectangle class >> aspects [
	^#(#width #height)
]

{ #category : #'instance creation' }
Rectangle class >> leftBottom: leftBottomPoint extent: extentPoint [
	^self new leftBottom: leftBottomPoint extent: extentPoint
]

{ #category : #'instance creation' }
Rectangle class >> leftBottom: leftBottomPoint rightTop: rightTopPoint [
	^self new leftBottom: leftBottomPoint rightTop: rightTopPoint
]

{ #category : #'instance creation' }
Rectangle class >> leftTop: leftTopPoint extent: extentPoint [
	^self new leftTop: leftTopPoint extent: extentPoint
]

{ #category : #'instance creation' }
Rectangle class >> leftTop: leftTopPoint rightBottom: rightBottomPoint [
	^self new leftTop: leftTopPoint rightBottom: rightBottomPoint
]

{ #category : #'instance creation' }
Rectangle class >> origin: originPoint corner: cornerPoint [
	^self new origin: originPoint corner: cornerPoint
]

{ #category : #'instance creation' }
Rectangle class >> origin: originPoint extent: extentPoint [
	^self new origin: originPoint extent: extentPoint
]

{ #category : #'instance creation' }
Rectangle class >> rightBottom: rightBottomPoint extent: extentPoint [
	^self new rightBottom: rightBottomPoint extent: extentPoint
]

{ #category : #comparing }
Rectangle >> = aRectangle [
	^aRectangle isRectangle
		and: [origin = aRectangle leftTop]
		and: [corner = aRectangle rightBottom]
]

{ #category : #inquiries }
Rectangle >> area [
	^self height * self width
]

{ #category : #inquiries }
Rectangle >> areasOutside: aRectangle [
	| areas y0 y1 area |
	(self intersects: aRectangle) ifFalse: [^{self}].
	areas := OrderedCollection new: 4.
	y0 := self top.
	aRectangle top > y0 ifTrue: [
		y0 := aRectangle top.
		areas addLast: (origin corner: corner x @ y0)].
	y1 := self bottom.
	aRectangle bottom < y1 ifTrue: [
		y1 := aRectangle bottom.
		area := self left @ y1 corner: corner.
		areas addLast: area].
	aRectangle left > self left ifTrue: [
		area := self left @ y0 corner: aRectangle left @ y1.
		areas addLast: area].
	aRectangle right < self right ifTrue: [
		area := aRectangle right @ y0 corner: self right @ y1.
		areas addLast: area].
	^areas
]

{ #category : #converting }
Rectangle >> asRectangle [
	^self
]

{ #category : #accessing }
Rectangle >> bottom [
	^corner y
]

{ #category : #accessing }
Rectangle >> bottom: aNumber [
	corner := corner x @ aNumber
]

{ #category : #inquiries }
Rectangle >> bottomCenter [
	^self center x @ self bottom
]

{ #category : #accessing }
Rectangle >> bottomLeft [
	^self left @ self bottom
]

{ #category : #accessing }
Rectangle >> bottomLeft: aPoint [
	self
		topLeft: aPoint x @ self topLeft y;
		bottomRight: self bottomRight x @ aPoint y
]

{ #category : #accessing }
Rectangle >> bottomRight [
	^corner
]

{ #category : #accessing }
Rectangle >> bottomRight: aPoint [
	corner := aPoint
]

{ #category : #accessing }
Rectangle >> center [
	^origin + corner // 2
]

{ #category : #inquiries }
Rectangle >> containsPoint: aPoint [
	^origin <= aPoint and: [aPoint < corner]
]

{ #category : #inquiries }
Rectangle >> containsRect: aRectangle [
	^origin <= aRectangle origin and: [aRectangle corner <= corner]
]

{ #category : #accessing }
Rectangle >> corner [
	^corner
]

{ #category : #accessing }
Rectangle >> corner: aPoint [
	corner := aPoint
]

{ #category : #services }
Rectangle >> corners [
	^{origin. corner. origin x @ corner y. corner x @ origin y}
]

{ #category : #movements }
Rectangle >> down: delta [
	origin := origin down: delta.
	corner := corner down: delta
]

{ #category : #operations }
Rectangle >> expandBy: delta [
	delta isRectangle
		ifTrue: [
			^(origin leftAndUp: delta leftTop)
				rightBottom: (corner translatedBy: delta rightBottom)]
		ifFalse: [^(origin leftAndUp: delta)
			rightBottom: (corner translatedBy: delta)]
]

{ #category : #accessing }
Rectangle >> extent [
	^self width @ self height
]

{ #category : #accessing }
Rectangle >> extent: aPoint [
	corner := origin + aPoint
]

{ #category : #comparing }
Rectangle >> hash [
	^origin hashWith: corner
]

{ #category : #accessing }
Rectangle >> height [
	^(origin y - corner y) abs
]

{ #category : #accessing }
Rectangle >> height: aNumber [
	corner y: origin y + aNumber
]

{ #category : #operations }
Rectangle >> insetBy: delta [
	| o c |
	delta isRectangle
		ifTrue: [
			o := origin translatedBy: delta leftTop.
			c := corner leftAndUp: delta rightBottom]
		ifFalse: [
			o := origin translatedBy: delta.
			c := corner leftAndUp: delta].
	^o rightBottom: c
]

{ #category : #operations }
Rectangle >> intersect: aRectangle [
	| o c |
	aRectangle isNil ifTrue: [^self].
	o := origin max: aRectangle origin.
	c := corner min: aRectangle corner.
	o x > c x ifTrue: [c x: o x].
	o y > c y ifTrue: [c y: o y].
	^o corner: c
]

{ #category : #testing }
Rectangle >> intersects: aRectangle [
	^origin < aRectangle rightBottom and: [aRectangle leftTop < corner]
]

{ #category : #testing }
Rectangle >> isRectangle [
	^true
]

{ #category : #accessing }
Rectangle >> left [
	^origin x
]

{ #category : #accessing }
Rectangle >> left: aNumber [
	origin := aNumber @ origin y
]

{ #category : #accessing }
Rectangle >> leftBottom [
	^self left @ self bottom
]

{ #category : #accessing }
Rectangle >> leftBottom: aPoint [
	origin := aPoint x @ self top.
	corner := self right @ aPoint y
]

{ #category : #accessing }
Rectangle >> leftBottom: point extent: extent [
	origin := point up: extent y.
	corner := point right: extent x
]

{ #category : #accessing }
Rectangle >> leftBottom: point1 rightTop: point2 [
	origin := point1 x @ point2 y.
	corner := point2 x @ point1 y
]

{ #category : #accessing }
Rectangle >> leftCenter [
	^self left @ self center y
]

{ #category : #accessing }
Rectangle >> leftTop [
	^origin
]

{ #category : #accessing }
Rectangle >> leftTop: aPoint [
	origin := aPoint
]

{ #category : #accessing }
Rectangle >> leftTop: originPoint extent: extent [
	corner := originPoint + extent.
	origin := originPoint
]

{ #category : #accessing }
Rectangle >> leftTop: oPoint rightBottom: cPoint [
	origin := oPoint.
	corner := cPoint
]

{ #category : #operations }
Rectangle >> merge: aRectangle [
	| o c |
	aRectangle isNil ifTrue: [^self].
	o := origin min: aRectangle leftTop.
	c := corner max: aRectangle rightBottom.
	^o rightBottom: c
]

{ #category : #operations }
Rectangle >> mergeWith: aRectangle [
	origin := origin min: aRectangle origin.
	corner := corner max: aRectangle corner
]

{ #category : #accessing }
Rectangle >> moveBy: aPoint [
	origin := origin + aPoint.
	corner := corner + aPoint
]

{ #category : #operations }
Rectangle >> moveTo: aPoint [
	self moveBy: aPoint - origin
]

{ #category : #accessing }
Rectangle >> origin [
	^origin
]

{ #category : #accessing }
Rectangle >> origin: aPoint [
	self topLeft: aPoint
]

{ #category : #accessing }
Rectangle >> origin: originPoint corner: cornerPoint [
	self leftTop: originPoint rightBottom: cornerPoint
]

{ #category : #accessing }
Rectangle >> origin: oPoint extent: ePoint [
	self origin: oPoint corner: oPoint + ePoint
]

{ #category : #printing }
Rectangle >> printOn: aStream [
	origin printOn: aStream.
	aStream nextPutAll: ' rightBottom: '.
	corner printOn: aStream
]

{ #category : #operations }
Rectangle >> relativeTo: aRectangle [
	| extent |
	extent := aRectangle extent.
	(extent x = 0 or: [extent y = 0]) ifTrue: [^self].
	^origin - aRectangle leftTop / extent extent: self extent / extent
]

{ #category : #accessing }
Rectangle >> right [
	^corner x
]

{ #category : #accessing }
Rectangle >> right: aNumber [
	corner := aNumber @ corner y
]

{ #category : #accessing }
Rectangle >> rightBottom [
	^corner
]

{ #category : #accessing }
Rectangle >> rightBottom: aPoint [
	corner := aPoint
]

{ #category : #accessing }
Rectangle >> rightBottom: point extent: extent [
	origin := (point up: extent y) left: extent x.
	corner := point
]

{ #category : #accessing }
Rectangle >> rightCenter [
	^self right @ self center y
]

{ #category : #accessing }
Rectangle >> rightTop [
	^self right @ self top
]

{ #category : #accessing }
Rectangle >> rightTop: aPoint [
	origin := self left @ aPoint y.
	corner := aPoint x @ self bottom
]

{ #category : #accessing }
Rectangle >> round [
	origin := origin rounded.
	corner := corner rounded
]

{ #category : #accessing }
Rectangle >> rounded [
	origin := origin rounded.
	corner := corner rounded
]

{ #category : #operations }
Rectangle >> scaleBy: delta [
	^origin * delta rightBottom: corner * delta
]

{ #category : #operations }
Rectangle >> scaleTo: aRectangle [
	| scaled |
	scaled := aRectangle scaleBy: self extent.
	^scaled truncated moveBy: self origin
]

{ #category : #accessing }
Rectangle >> signedHeight [
	^corner y - origin y
]

{ #category : #accessing }
Rectangle >> signedWidth [
	^corner x - origin x
]

{ #category : #accessing }
Rectangle >> top [
	^origin y
]

{ #category : #accessing }
Rectangle >> top: aNumber [
	origin := origin x @ aNumber
]

{ #category : #accessing }
Rectangle >> topCenter [
	^self center x @ self top
]

{ #category : #accessing }
Rectangle >> topLeft [
	^origin
]

{ #category : #accessing }
Rectangle >> topLeft: aPoint [
	origin := aPoint
]

{ #category : #accessing }
Rectangle >> topRight [
	^self right @ self top
]

{ #category : #accessing }
Rectangle >> topRight: aPoint [
	self
		topLeft: self left @ aPoint y;
		bottomRight: aPoint x @ self bottom
]

{ #category : #operations }
Rectangle >> translateBy: delta [
	^origin + delta rightBottom: corner + delta
]

{ #category : #movements }
Rectangle >> translatedBy: delta [
	^origin + delta rightBottom: corner + delta
]

{ #category : #accessing }
Rectangle >> truncate [
	origin := origin truncated.
	corner := corner truncated
]

{ #category : #accessing }
Rectangle >> truncated [
	^origin truncated corner: corner truncated
]

{ #category : #accessing }
Rectangle >> width [
	^(corner x - origin x) abs
]

{ #category : #accessing }
Rectangle >> width: anInteger [
	corner x: origin x + anInteger
]

