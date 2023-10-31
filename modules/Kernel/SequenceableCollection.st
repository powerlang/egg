"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #SequenceableCollection,
	#superclass : #Collection,
	#category : #Kernel
}

{ #category : #'instance creation' }
SequenceableCollection class >> new: size withAll: value [
	| collection |
	collection := self new: size.
	value notNil ifTrue: [1 to: size do: [:i | collection at: i put: value]].
	^collection
]

{ #category : #'instance creation' }
SequenceableCollection class >> streamContents: aBlock [
	| stream |
	stream := (self new: 100) writeStream.
	aBlock value: stream.
	^stream contents
]

{ #category : #'instance creation' }
SequenceableCollection class >> withAll: aCollection [
	| new idx |
	new := self new: aCollection size.
	idx := 1.
	aCollection do: [:element | 
		new at: idx put: element.
		idx := idx + 1].
	^new
]

{ #category : #operations }
SequenceableCollection >> , aSequenceableCollection [
	| size n |
	aSequenceableCollection isSequenceableCollection ifFalse: [
		self
			error: 'Instances of ' , aSequenceableCollection class name
				, ' are not indexable'].
	size := self size.
	n := size + aSequenceableCollection size.
	^(self species new: n)
		replaceFrom: 1 to: size with: self startingAt: 1;
		replaceFrom: size + 1 to: n with: aSequenceableCollection startingAt: 1
]

{ #category : #comparing }
SequenceableCollection >> = aCollection [
	| size |
	self == aCollection ifTrue: [^true].
	self class == aCollection class ifFalse: [^false].
	size := self size.
	size != aCollection size ifTrue: [^false].
	1 to: size do: [:i | (self at: i) = (aCollection at: i) ifFalse: [^false]].
	^true
]

{ #category : #queries }
SequenceableCollection >> after: anObject [
	^self after: anObject ifAbsent: [self errorNotFound]
]

{ #category : #queries }
SequenceableCollection >> after: anObject ifAbsent: absentBlock [
	| i |
	i := self indexOf: anObject ifAbsent: [^absentBlock value].
	^self at: i + 1 ifAbsent: absentBlock
]

{ #category : #copying }
SequenceableCollection >> allButFirst [
	^self allButFirst: 1
]

{ #category : #copying }
SequenceableCollection >> allButFirst: n [
	^self copyFrom: n + 1
]

{ #category : #copying }
SequenceableCollection >> allButIndex: anInteger [
	| m copy |
	m := self size - 1.
	copy := self class new: m.
	^copy
		replaceFrom: 1
		to: anInteger - 1
		with: self
		startingAt: 1;
		replaceFrom: anInteger
		to: m
		with: self
		startingAt: anInteger + 1
]

{ #category : #copying }
SequenceableCollection >> allButLast [
	^self allButLast: 1
]

{ #category : #copying }
SequenceableCollection >> allButLast: n [
	^self copyFrom: 1 to: self size - n
]

{ #category : #converting }
SequenceableCollection >> asStream [
	^ReadWriteStream on: self
]

{ #category : #accessing }
SequenceableCollection >> at: anInteger ifAbsent: aBlock [
	^(anInteger between: 1 and: self size)
		ifTrue: [self at: anInteger]
		ifFalse: [aBlock value]
]

{ #category : #accessing }
SequenceableCollection >> atAll: aCollection put: anObject [
	aCollection do: [:i | self at: i put: anObject]
]

{ #category : #accessing }
SequenceableCollection >> atAllPut: anObject [
	self size > 0
		ifTrue: [self replaceFrom: 1 to: self size withObject: anObject]
]

{ #category : #queries }
SequenceableCollection >> before: anObject [
	^self before: anObject ifAbsent: [self errorNotFound]
]

{ #category : #queries }
SequenceableCollection >> before: anObject ifAbsent: absentBlock [
	| index |
	index := self indexOf: anObject ifAbsent: [^absentBlock value].
	index = 1 ifTrue: [^absentBlock value].
	^self at: index - 1
]

{ #category : #inquiries }
SequenceableCollection >> beginsWith: aCollection [
	self size < aCollection size ifTrue: [^false].
	1
		to: aCollection size
		do: [:i | (self at: i) = (aCollection at: i) ifFalse: [^false]].
	^true
]

{ #category : #validation }
SequenceableCollection >> checkIndex: anInteger [
	anInteger isInteger ifFalse: [^self error: 'Non integer index'].
	(anInteger between: 1 and: self size)
		ifFalse: [^self outOfBoundsIndex: anInteger]
]

{ #category : #copying }
SequenceableCollection >> copyFrom: start [
	^self copyFrom: start to: self size
]

{ #category : #copying }
SequenceableCollection >> copyFrom: start to: stop [
	| size copy |
	size := stop - start + 1 max: 0.
	copy := self species new: size.
	^copy
		replaceFrom: 1
		to: size
		with: self
		startingAt: start
]

{ #category : #copying }
SequenceableCollection >> copyReplaceFrom: start to: stop with: aCollection [
	| n m |
	n := aCollection size.
	m := self size + n - (stop - start + 1).
	^(self species new: m)
		replaceFrom: 1 to: start - 1 with: self startingAt: 1;
		replaceFrom: start to: start + n - 1 with: aCollection startingAt: 1;
		replaceFrom: start + n to: m with: self startingAt: stop + 1
]

{ #category : #copying }
SequenceableCollection >> copyTo: end [
	^self copyFrom: 1 to: end
]

{ #category : #copying }
SequenceableCollection >> copyWith: anObject [
	| size |
	size := self size.
	^(self species new: size + 1)
		at: size + 1 put: anObject;
		replaceFrom: 1 to: size with: self startingAt: 1
]

{ #category : #copying }
SequenceableCollection >> copyWithout: anObject [
	| n i1 copy j |
	n := self size.
	copy := self copy.
	n = 0 ifTrue: [^self].
	j := 1.
	i1 := 0.
	[i1 + 1 <= n] whileTrue: [| i0 k |
		i0 := i1 + 1.
		i1 := self indexOf: anObject startingAt: i0 ifAbsent: [n + 1].
		k := i1 - i0.
		copy replaceFrom: j to: j + k - 1 with: self startingAt: i0.
		j := j + k].
	^j - 1 = n ifTrue: [copy] ifFalse: [copy copyTo: j - 1]
]

{ #category : #enumerating }
SequenceableCollection >> do: aBlock [
	1 to: self size do: [:i | | element |
		element := self atValid: i.
		aBlock evaluateWith: element]
]

{ #category : #inquiries }
SequenceableCollection >> endsWith: aCollection [
	| m n |
	n := self size.
	m := aCollection size.
	n < m ifTrue: [^false].
	1
		to: m
		do: [:i | (self at: n - i + 1) = (aCollection at: m - i + 1) ifFalse: [^false]].
	^true
]

{ #category : #queries }
SequenceableCollection >> findFirst: aBlock [
	^self findFirst: aBlock ifAbsent: [self errorNotFound]
]

{ #category : #queries }
SequenceableCollection >> findFirst: aBlock ifAbsent: absentBlock [
	^self findFirst: aBlock startingAt: 1 ifAbsent: absentBlock
]

{ #category : #queries }
SequenceableCollection >> findFirst: aBlock startingAt: index ifAbsent: absentBlock [
	| size i |
	size := self size.
	i := index.
	[i <= size] whileTrue: [
		(aBlock evaluateWith: (self at: i)) ifTrue: [^i].
		i := i + 1].
	^absentBlock value
]

{ #category : #queries }
SequenceableCollection >> findLast: aBlock [
	^self findLast: aBlock ifAbsent: [self errorNotFound]
]

{ #category : #queries }
SequenceableCollection >> findLast: aBlock ifAbsent: absentBlock [
	self size
		to: 1
		by: -1
		do: [:i | (aBlock evaluateWith: (self at: i)) ifTrue: [^i]].
	^absentBlock value
]

{ #category : #accessing }
SequenceableCollection >> first [
	^self at: 1
]

{ #category : #enumerating }
SequenceableCollection >> fold: aBlock [
	"
	#('Hello' 'there' 'from' 'Bee Smalltalk!') fold: [:a :b | a , ' ', b]
	"
	| fold |
	fold := self at: 1.
	2
		to: self size
		do: [:i | fold := aBlock evaluateWith: fold with: (self at: i)].
	^fold
]

{ #category : #accessing }
SequenceableCollection >> fourth [
	^self at: 4
]

{ #category : #enumerating }
SequenceableCollection >> from: start
to: stop
findFirst: aBlock
ifAbsent: errorBlock [
	start to: stop do: [:i | | found item |
		item := self at: i.
		found := aBlock evaluateWith: item.
		found ifTrue: [^i]].
	^errorBlock value
]

{ #category : #private }
SequenceableCollection >> growSize [
	| min |
	min := self size max: 10.
	^min min: 1000000
]

{ #category : #comparing }
SequenceableCollection >> hash [
	^self size
]

{ #category : #testing }
SequenceableCollection >> hasIndexedSlots [
	^true
]

{ #category : #sorting }
SequenceableCollection >> hybridSort [
	self hybridSort: self
]

{ #category : #sorting }
SequenceableCollection >> hybridSort: aBlock [
	self
		hybridSortFrom: 1
		to: self size
		with: aBlock
		scratch: (Array new: 10)
]

{ #category : #sorting }
SequenceableCollection >> hybridSortFrom: start
to: stop
with: aBlock
scratch: anArray [
	"
	Sort elements i through j of self to be non-descending according to sortBlock.
	Use quicksort for large ranges and insertion sort for ranges within scratch size.
	The prefix d means the data at that index.
	#(1 3 2 6 7 5) hybridSortFrom: 1 to: 6 with: [:a :b | a <= b] scratch: (Array new: 3)
	"
	| di dij dj tt ij k l n |
	n := stop + 1 - start.
	n <= 1 ifTrue: [^self].
	n <= anArray size ifTrue: [
		^self
			insertSortFrom: start
			to: stop
			with: aBlock
			scratch: anArray].
	"Assume more than three elements."
	"Sort di,dj and dij."
	di := self basicAt: start.
	dj := self basicAt: stop.
	(aBlock value: di value: dj) ifFalse: [
		self swap: start with: stop.
		tt := di.
		di := dj.
		dj := tt].
	"i.e., should di precede dj?"
	ij := start + stop // 2.
	"ij is the midpoint of i and j."
	dij := self basicAt: ij.
	("Sort di, dij, dj.  Make dij be their median."
	aBlock value: di value: dij "i.e. should di precede dij?")
		ifTrue: [
			(aBlock value: dij value: dj) ifFalse: [
				"i.e., should dij precede dj?"
				self swap: stop with: ij.
				dij := dj]]
		ifFalse: [
			"i.e. di should come after dij"
			self swap: start with: ij.
			dij := di].
	"Find k>i and l<j such that dk,dij,dl are in reverse order.
	 Swap k and l.  Repeat this procedure until k and l pass each other."
	k := start.
	l := stop.
	[
		[
			l := l - 1.
			k <= l and: [aBlock value: dij value: (self basicAt: l)]] whileTrue.
		[
			"i.e. while dl succeeds dij"
			k := k + 1.
			k <= l and: [aBlock value: (self basicAt: k) value: dij]] whileTrue.
		"i.e. while dij succeeds dk"
	k <= l]
		whileTrue: [self swap: k with: l].
	["Skip already sorted ranges."
	k < stop and: [aBlock value: (self basicAt: k) value: dij]]
		whileTrue: [k := k + 1].
	"Now l<k (either 1 or 2 less), and di through dl are all less than or equal to dk
	 through dj.  Sort those two segments."
	self
		hybridSortFrom: start
		to: l
		with: aBlock
		scratch: anArray;
		hybridSortFrom: k
		to: stop
		with: aBlock
		scratch: anArray
]

{ #category : #inquiries }
SequenceableCollection >> includes: anObject [
	| i |
	i := self size + 1.
	[(i := i - 1) > 0] whileTrue: [anObject = (self at: i) ifTrue: [^true]].
	^false
]

{ #category : #inquiries }
SequenceableCollection >> increasingIncludes: anObject [
	| stop start |
	stop := self size.
	stop = 0 ifTrue: [^false].
	start := 1.
	anObject < (self at: 1) ifTrue: [^false].
	(self at: stop) < anObject ifTrue: [^false].
	[start <= stop] whileTrue: [| mid token |
		mid := start + stop // 2.
		token := self at: mid.
		anObject = token ifTrue: [^true].
		anObject < token ifTrue: [stop := mid - 1] ifFalse: [start := mid + 1]].
	^false
]

{ #category : #inquiries }
SequenceableCollection >> indexOf: anObject [
	^self indexOf: anObject ifAbsent: 0
]

{ #category : #inquiries }
SequenceableCollection >> indexOf: anObject
between: start
and: end
ifAbsent: aBlock [
	start to: end do: [:i | (self at: i) = anObject ifTrue: [^i]].
	^aBlock value
]

{ #category : #inquiries }
SequenceableCollection >> indexOf: anObject ifAbsent: aBlock [
	^self indexOf: anObject startingAt: 1 ifAbsent: aBlock
]

{ #category : #inquiries }
SequenceableCollection >> indexOf: anObject startingAt: start ifAbsent: aBlock [
	^self
		indexOf: anObject
		between: start
		and: self size
		ifAbsent: aBlock
]

{ #category : #inquiries }
SequenceableCollection >> indexOfIdentical: anObject [
	^self indexOfIdentical: anObject ifAbsent: 0
]

{ #category : #inquiries }
SequenceableCollection >> indexOfIdentical: anObject ifAbsent: aBlock [
	1 to: self size do: [:i | (self at: i) == anObject ifTrue: [^i]].
	^aBlock value
]

{ #category : #inquiries }
SequenceableCollection >> indexOfSubcollection: aCollection [
	^self indexOfSubcollection: aCollection startingAt: 1
]

{ #category : #inquiries }
SequenceableCollection >> indexOfSubcollection: aCollection
from: start
to: stop
td1: aDictionary [
	| m k |
	m := aCollection size.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i object delta |
		i := 1.
		[i <= m and: [(aCollection at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		object := self at: k + m.
		delta := aDictionary at: object ifAbsent: [m + 1].
		delta isNil ifTrue: [delta := m + 1].
		k := k + delta].
	^0
]

{ #category : #inquiries }
SequenceableCollection >> indexOfSubcollection: aCollection startingAt: anInteger [
	| m n i first |
	m := aCollection size.
	m = 0 ifTrue: [^0].
	n := self size - m + 1.
	i := anInteger.
	first := aCollection at: 1.
	[i <= n] whileTrue: [| j |
		(self at: i) = first ifTrue: [
			j := 2.
			[j <= m and: [(self at: i + j - 1) = (aCollection at: j)]]
				whileTrue: [j := j + 1].
			j > m ifTrue: [^i]].
		i := i + 1].
	^0
]

{ #category : #sorting }
SequenceableCollection >> insertSortFrom: start
to: stop
with: aBlock
scratch: anArray [
	"
	#(1 3 2 6 7 5) insertSortFrom: 1 to: 6 with: [:a :b | a <= b] scratch: (Array new: 6)
	"
	| n |
	n := stop + 1 - start.
	n <= 1 ifTrue: [^self].
	anArray at: 1 put: (self at: start).
	2 to: n do: [:i | | ai j s |
		ai := self at: start + i - 1.
		j := 1.
		[j < i and: [aBlock value: (anArray at: j) value: ai]]
			whileTrue: [j := j + 1].
		j < i ifTrue: [
			s := i.
			[j < s] whileTrue: [
				anArray at: s put: (anArray at: s - 1).
				s := s - 1]].
		anArray at: j put: ai].
	1 to: n do: [:i | self at: start + i - 1 put: (anArray at: i)]
]

{ #category : #testing }
SequenceableCollection >> isSequenceableCollection [
	^true
]

{ #category : #accessing }
SequenceableCollection >> last [
	^self at: self size
]

{ #category : #inquiries }
SequenceableCollection >> occurrencesOf: anObject [
	| count |
	count := 0.
	1
		to: self size
		do: [:i | (self at: i) = anObject ifTrue: [count := count + 1]].
	^count
]

{ #category : #errors }
SequenceableCollection >> outOfBoundsIndex: anInteger [
	^self
		error: 'index: ' , anInteger printString
			, ' is outside of collection bounds'
]

{ #category : #printing }
SequenceableCollection >> printElementText: element on: rtf position: i [
	rtf nextPutAll: i asString; tab; tab.
	element printOn: rtf
]

{ #category : #converting }
SequenceableCollection >> readStream [
	^InternalReadStream on: self
]

{ #category : #replacing }
SequenceableCollection >> replaceBackwardFrom: stop
to: start
with: aCollection
startingAt: position [
	| i j |
	i := stop.
	j := position.
	[start <= i] whileTrue: [
		self at: i put: (aCollection at: j).
		i := i - 1.
		j := j - 1]
]

{ #category : #replacing }
SequenceableCollection >> replaceForwardFrom: start
to: stop
with: aCollection
startingAt: position [
	| i j |
	i := start.
	j := position.
	[i <= stop] whileTrue: [
		self at: i put: (aCollection at: j).
		i := i + 1.
		j := j + 1]
]

{ #category : #replacing }
SequenceableCollection >> replaceFrom: start to: stop with: aCollection [
	stop - start + 1 <= aCollection size
		ifFalse: [^self error: 'size of replacement does not match'].
	self replaceFrom: start to: stop with: aCollection startingAt: 1
]

{ #category : #replacing }
SequenceableCollection >> replaceFrom: start
to: stop
with: aCollection
startingAt: position [
	| end |
	start > stop ifTrue: [^self].
	(self == aCollection and: [
		end := position + stop - start.
		start between: position and: end])
		ifTrue: [self
			replaceBackwardFrom: stop
			to: start
			with: aCollection
			startingAt: end]
		ifFalse: [
			self
				replaceForwardFrom: start
				to: stop
				with: aCollection
				startingAt: position]
]

{ #category : #replacing }
SequenceableCollection >> replaceFrom: start to: stop withObject: anObject [
	start to: stop do: [:i | self at: i put: anObject].
	^anObject
]

{ #category : #accessing }
SequenceableCollection >> reverse [
	^self reversed
]

{ #category : #accessing }
SequenceableCollection >> reversed [
	| copy n |
	n := self size.
	copy := self class new: n withAll: nil.
	1 to: n do: [:i | | xi |
		xi := self at: i.
		copy at: n - i + 1 put: xi].
	^copy
]

{ #category : #enumerating }
SequenceableCollection >> reverseDetect: aBlock [
	^self reverseDetect: aBlock ifNone: [self errorNotFound]
]

{ #category : #enumerating }
SequenceableCollection >> reverseDetect: aBlock ifNone: exceptionBlock [
	self reverseDo: [:e | (aBlock evaluateWith: e) ifTrue: [^e]].
	^exceptionBlock value
]

{ #category : #enumerating }
SequenceableCollection >> reverseDo: aBlock [
	self size to: 1 by: -1 do: [:i | aBlock evaluateWith: (self atValid: i)]
]

{ #category : #accessing }
SequenceableCollection >> second [
	^self at: 2
]

{ #category : #accessing }
SequenceableCollection >> size [
	^self subclassResponsibility
]

{ #category : #sorting }
SequenceableCollection >> sort [
	self sortBy: self
]

{ #category : #sorting }
SequenceableCollection >> sort: start to: stop with: block [
	| i0 i1 |
	i0 := start.
	i1 := stop.
	[| x1 x0 mid pivot last i |
		i1 - i0 <= 1 ifTrue: [
			(i0 < i1 and: [
				x1 := self at: i1.
				x0 := self at: i0.
				(block value: x1 value: x0) value])
				ifTrue: [
					self
						at: i0 put: x1;
						at: i1 put: x0].
			^self].
		mid := i0 + i1 // 2.
		pivot := self at: mid.
		self at: mid put: (self at: i0).
		i := last := i0.
		[
			i := i + 1.
			x0 := self at: i.
			((block value: x0 value: pivot) value andNot: [
				last := last + 1.
				last = i])
				ifTrue: [
					self
						at: i put: (self at: last);
						at: last put: x0].
			i < i1] whileTrue.
		self
			at: i0 put: (self at: last);
			at: last put: pivot.
		mid < last
			ifTrue: [
				self sort: last + 1 to: i1 with: block.
				i1 := last - 1]
			ifFalse: [
				self sort: i0 to: last - 1 with: block.
				i0 := last + 1]] repeat
]

{ #category : #sorting }
SequenceableCollection >> sortBy: aBlock [
	self sort: 1 to: self size with: aBlock
]

{ #category : #accessing }
SequenceableCollection >> swap: index1 with: index2 [
	| temp |
	temp := self at: index1.
	self at: index1 put: (self at: index2).
	self at: index2 put: temp.
]

{ #category : #private }
SequenceableCollection >> td1 [
	| m td1 |
	m := self size.
	td1 := Dictionary new: m.
	m to: 1 by: -1 do: [:i | | object |
		object := self at: i.
		td1 at: object ifAbsentPut: [m - i + 1]].
	^td1
]

{ #category : #accessing }
SequenceableCollection >> third [
	^self at: 3
]

{ #category : #evaluating }
SequenceableCollection >> value: object1 value: object2 [
	^[object1 <= object2] on: Error do: [object2 >= object1]
]

{ #category : #enumerating }
SequenceableCollection >> with: aCollection collect: aBlock in: rCollection [
	| n |
	n := self size.
	1 to: n do: [:i | | ai bi value |
		ai := self atValid: i.
		bi := aCollection at: i.
		value := aBlock evaluateWith: ai with: bi.
		rCollection add: value].
	^rCollection
]

{ #category : #enumerating }
SequenceableCollection >> with: aCollection do: aBlock [
	self size = aCollection size
		ifFalse: [^self error: 'The collections have different sizes'].
	1
		to: self size
		do: [:i | aBlock value: (self atValid: i) value: (aCollection atValid: i)]
]

{ #category : #enumerating }
SequenceableCollection >> with: aCollection withIndexDo: aBlock [
	aCollection size = self size
		ifFalse: [self error: 'both collections must have the same size'].
	1
		to: self size
		do: [:i | aBlock
			value: (self atValid: i)
			value: (aCollection atValid: i)
			value: i]
]

{ #category : #enumerating }
SequenceableCollection >> withIndexCollect: aBlock [
	^self withIndexCollect: aBlock in: (self class new: self size)
]

{ #category : #enumerating }
SequenceableCollection >> withIndexCollect: aBlock in: aCollection [
	| size |
	size := self size.
	1
		to: size
		do: [:i | aCollection add: (aBlock value: (self atValid: i) value: i)].
	^aCollection
]

{ #category : #enumerating }
SequenceableCollection >> withIndexDo: aBlock [
	1 to: self size do: [:i | aBlock value: (self atValid: i) value: i]
]

{ #category : #enumerating }
SequenceableCollection >> withIndexSelect: aBlock [
	| i |
	i := 0.
	^self select: [:element | 
		i := i + 1.
		aBlock evaluateWith: element with: i]
]

{ #category : #converting }
SequenceableCollection >> writeStream [
	^InternalWriteStream on: self
]

