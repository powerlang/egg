'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Rectangle category: #Kernel!
Object subclass: #Rectangle
	instanceVariableNames: 'origin corner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Rectangle commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Rectangle methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aRectangle
	^aRectangle isRectangle
		and: [origin = aRectangle leftTop]
		and: [corner = aRectangle rightBottom]
! !

!Rectangle methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
area
	^self height * self width
! !

!Rectangle methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
areasOutside: aRectangle
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
! !

!Rectangle methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asRectangle
	^self
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bottom
	^corner y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bottom: aNumber
	corner := corner x @ aNumber
! !

!Rectangle methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
bottomCenter
	^self center x @ self bottom
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bottomLeft
	^self left @ self bottom
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bottomLeft: aPoint
	self
		topLeft: aPoint x @ self topLeft y;
		bottomRight: self bottomRight x @ aPoint y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bottomRight
	^corner
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bottomRight: aPoint
	corner := aPoint
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
center
	^origin + corner // 2
! !

!Rectangle methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
containsPoint: aPoint
	^origin <= aPoint and: [aPoint < corner]
! !

!Rectangle methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
containsRect: aRectangle
	^origin <= aRectangle origin and: [aRectangle corner <= corner]
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
corner
	^corner
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
corner: aPoint
	corner := aPoint
! !

!Rectangle methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
corners
	^{origin. corner. origin x @ corner y. corner x @ origin y}
! !

!Rectangle methodsFor:  'movements' stamp: 'KenD 28/Jun/2026 13:27:38'!
down: delta
	origin := origin down: delta.
	corner := corner down: delta
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
expandBy: delta
	delta isRectangle
		ifTrue: [
			^(origin leftAndUp: delta leftTop)
				rightBottom: (corner translatedBy: delta rightBottom)]
		ifFalse: [^(origin leftAndUp: delta)
			rightBottom: (corner translatedBy: delta)]
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
extent
	^self width @ self height
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
extent: aPoint
	corner := origin + aPoint
! !

!Rectangle methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^origin hashWith: corner
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
height
	^(origin y - corner y) abs
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
height: aNumber
	corner y: origin y + aNumber
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
insetBy: delta
	| o c |
	delta isRectangle
		ifTrue: [
			o := origin translatedBy: delta leftTop.
			c := corner leftAndUp: delta rightBottom]
		ifFalse: [
			o := origin translatedBy: delta.
			c := corner leftAndUp: delta].
	^o rightBottom: c
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
intersect: aRectangle
	| o c |
	aRectangle isNil ifTrue: [^self].
	o := origin max: aRectangle origin.
	c := corner min: aRectangle corner.
	o x > c x ifTrue: [c x: o x].
	o y > c y ifTrue: [c y: o y].
	^o corner: c
! !

!Rectangle methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
intersects: aRectangle
	^origin < aRectangle rightBottom and: [aRectangle leftTop < corner]
! !

!Rectangle methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isRectangle
	^true
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
left
	^origin x
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
left: aNumber
	origin := aNumber @ origin y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftBottom
	^self left @ self bottom
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftBottom: aPoint
	origin := aPoint x @ self top.
	corner := self right @ aPoint y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftBottom: point extent: extent
	origin := point up: extent y.
	corner := point right: extent x
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftBottom: point1 rightTop: point2
	origin := point1 x @ point2 y.
	corner := point2 x @ point1 y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftCenter
	^self left @ self center y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftTop
	^origin
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftTop: aPoint
	origin := aPoint
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftTop: originPoint extent: extent
	corner := originPoint + extent.
	origin := originPoint
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftTop: oPoint rightBottom: cPoint
	origin := oPoint.
	corner := cPoint
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
merge: aRectangle
	| o c |
	aRectangle isNil ifTrue: [^self].
	o := origin min: aRectangle leftTop.
	c := corner max: aRectangle rightBottom.
	^o rightBottom: c
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
mergeWith: aRectangle
	origin := origin min: aRectangle origin.
	corner := corner max: aRectangle corner
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
moveBy: aPoint
	origin := origin + aPoint.
	corner := corner + aPoint
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
moveTo: aPoint
	self moveBy: aPoint - origin
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
origin
	^origin
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
origin: aPoint
	self topLeft: aPoint
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
origin: originPoint corner: cornerPoint
	self leftTop: originPoint rightBottom: cornerPoint
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
origin: oPoint extent: ePoint
	self origin: oPoint corner: oPoint + ePoint
! !

!Rectangle methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	origin printOn: aStream.
	aStream nextPutAll: ' rightBottom: '.
	corner printOn: aStream
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
relativeTo: aRectangle
	| extent |
	extent := aRectangle extent.
	(extent x = 0 or: [extent y = 0]) ifTrue: [^self].
	^origin - aRectangle leftTop / extent extent: self extent / extent
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
right
	^corner x
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
right: aNumber
	corner := aNumber @ corner y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightBottom
	^corner
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightBottom: aPoint
	corner := aPoint
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightBottom: point extent: extent
	origin := (point up: extent y) left: extent x.
	corner := point
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightCenter
	^self right @ self center y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightTop
	^self right @ self top
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightTop: aPoint
	origin := self left @ aPoint y.
	corner := aPoint x @ self bottom
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
round
	origin := origin rounded.
	corner := corner rounded
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
rounded
	origin := origin rounded.
	corner := corner rounded
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
scaleBy: delta
	^origin * delta rightBottom: corner * delta
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
scaleTo: aRectangle
	| scaled |
	scaled := aRectangle scaleBy: self extent.
	^scaled truncated moveBy: self origin
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
signedHeight
	^corner y - origin y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
signedWidth
	^corner x - origin x
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
top
	^origin y
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
top: aNumber
	origin := origin x @ aNumber
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
topCenter
	^self center x @ self top
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
topLeft
	^origin
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
topLeft: aPoint
	origin := aPoint
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
topRight
	^self right @ self top
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
topRight: aPoint
	self
		topLeft: self left @ aPoint y;
		bottomRight: aPoint x @ self bottom
! !

!Rectangle methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
translateBy: delta
	^origin + delta rightBottom: corner + delta
! !

!Rectangle methodsFor:  'movements' stamp: 'KenD 28/Jun/2026 13:27:38'!
translatedBy: delta
	^origin + delta rightBottom: corner + delta
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncate
	origin := origin truncated.
	corner := corner truncated
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncated
	^origin truncated corner: corner truncated
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
width
	^(corner x - origin x) abs
! !

!Rectangle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
width: anInteger
	corner x: origin x + anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Rectangle class' category: #Kernel!
Rectangle class
	instanceVariableNames: ''!

!Rectangle class methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:38'!
aspects
	^#(#width #height)
! !

!Rectangle class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftBottom: leftBottomPoint extent: extentPoint
	^self new leftBottom: leftBottomPoint extent: extentPoint
! !

!Rectangle class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftBottom: leftBottomPoint rightTop: rightTopPoint
	^self new leftBottom: leftBottomPoint rightTop: rightTopPoint
! !

!Rectangle class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftTop: leftTopPoint extent: extentPoint
	^self new leftTop: leftTopPoint extent: extentPoint
! !

!Rectangle class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftTop: leftTopPoint rightBottom: rightBottomPoint
	^self new leftTop: leftTopPoint rightBottom: rightBottomPoint
! !

!Rectangle class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
origin: originPoint corner: cornerPoint
	^self new origin: originPoint corner: cornerPoint
! !

!Rectangle class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
origin: originPoint extent: extentPoint
	^self new origin: originPoint extent: extentPoint
! !

!Rectangle class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
rightBottom: rightBottomPoint extent: extentPoint
	^self new rightBottom: rightBottomPoint extent: extentPoint
! !


