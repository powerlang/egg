"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #HashTable,
	#superclass : #Array,
	#type : #variable,
	#instVars : [
		'policy'
	],
	#classVars : [
		'NilToken',
		'Sizes'
	],
	#category : #Kernel
}

{ #category : #initialization }
HashTable class >> initializeConstants [
	NilToken := Object new
]

{ #category : #initialization }
HashTable class >> initializeSizes [
	| primes p |
	Sizes := ByteArray new: 126.
	primes := #(
			2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79
			83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163
			167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251
		) readStream.
	p := primes next.
	1 to: Sizes size do: [:i | | n |
		n := i * 2 - 1.
		p < n ifTrue: [p := primes next].
		Sizes at: i put: p]
]

{ #category : #inquiries }
HashTable class >> goodPrimes [
	"
	from squeak
	"
	^#(269 359 479 641 857 1151 1549 2069
		2237 2423 2617 2797 2999 3167 3359 3539 3727 3911
		4441 4787 5119 5471 5801 6143 6521 6827 7177 7517 7853
		8783 9601 10243 10867 11549 12239 12919 13679 14293 15013 15731
		17569 19051 20443 21767 23159 24611 25847 27397 28571 30047 31397
		35771 38201 40841 43973 46633 48989 51631 54371 57349 60139 62969
		70589 76091 80347 85843 90697 95791 101051 106261 111143 115777 120691 126311
		140863 150523 160969 170557 181243 190717 201653 211891 221251 232591 242873 251443
		282089 300869 321949 341227 362353 383681 401411 422927 443231 464951 482033 504011
		562621 605779 647659 681607 723623 763307 808261 844709 886163 926623 967229 1014617
		1121987 1201469 1268789 1345651 1429531 1492177 1577839 1651547 1722601 1800377 1878623 1942141 2028401
		2242727 2399581 2559173 2686813 2836357 3005579 3144971 3283993 3460133 3582923 3757093 3903769 4061261
		4455361 4783837 5068529 5418079 5680243 6000023 6292981 6611497 6884641 7211599 7514189 7798313 8077189
		9031853 9612721 10226107 10745291 11338417 11939203 12567671 13212697 13816333 14337529 14938571 15595673 16147291
		17851577 18993941 20180239 21228533 22375079 23450491 24635579 25683871 26850101 27921689 29090911 30153841 31292507 32467307
		35817611 37983761 40234253 42457253 44750177 46957969 49175831 51442639 53726417 55954637 58126987 60365939 62666977 64826669
		71582779 76039231 80534381 84995153 89500331 93956777 98470819 102879613 107400389 111856841 116365721 120819287 125246581 129732203
		143163379 152076289 161031319 169981667 179000669 187913573 196826447 205826729 214748357 223713691 232679021 241591901 250504801 259470131
		285162679 301939921 318717121 335494331 352271573 369148753 385926017 402603193 419480419 436157621 453034849 469712051 486589307 503366497 520043707 
		570475349 603929813 637584271 671138659 704693081 738247541 771801929 805356457 838910803 872365267 905919671 939574117 973128521 1006682977 1040137411 
		1073741833)
]

{ #category : #'instance creation' }
HashTable class >> new [
	^self new: 7
]

{ #category : #'instance creation' }
HashTable class >> new: anInteger [
	| size |
	size := self primeFor: anInteger.
	^super new: size
]

{ #category : #accessing }
HashTable class >> nilToken [
	^NilToken
]

{ #category : #inquiries }
HashTable class >> primeFor: size [
	| n primes |
	n := size bitOr: 1.
	n <= 251 ifTrue: [^Sizes at: n // 2 + 1].
	primes := self goodPrimes.
	1 to: primes size do: [:i | | p |
		p := primes at: i.
		p > n ifTrue: [p]].
	^n
]

{ #category : #private }
HashTable >> associationClass [
	^policy notNil ifTrue: [policy associationClass] ifFalse: [Association]
]

{ #category : #private }
HashTable >> at: index put: anObject [
	| element |
	element := anObject ifNil: [NilToken].
	^self basicAt: index put: element
]

{ #category : #private }
HashTable >> atKey: key hash: hash put: element [
	| index |
	index := self indexOfKey: key hash: hash.
	^self at: index key: key put: element
]

{ #category : #accessing }
HashTable >> atKey: key put: element [
	| hash |
	hash := self hashFor: key.
	^self atKey: key hash: hash put: element
]

{ #category : #accessing }
HashTable >> atKey: key sum: magnitude [
	| hash |
	hash := self hashFor: key.
	^self atKey: key hash: hash sum: magnitude
]

{ #category : #private }
HashTable >> beWeak [
	| empty |
	empty := self emptySlot.
	self withIndexDo: [:v :i | v isNil ifTrue: [self basicAt: i put: empty]].
	super beWeak
]

{ #category : #private }
HashTable >> bucketClass [
	^OpenHashTable
]

{ #category : #removing }
HashTable >> clearSlot: anInteger [
	self clearSlot: anInteger with: self emptySlot
]

{ #category : #removing }
HashTable >> clearSlot: anInteger with: emptySlot [
	self basicAt: anInteger put: emptySlot
]

{ #category : #private }
HashTable >> clearSlots: indexes ifAbsent: absentBlock [
	| empty |
	empty := self emptySlot.
	indexes do: [:i | | v |
		v := self at: i.
		(v == nil or: [v == empty])
			ifTrue: [absentBlock value]
			ifFalse: [self clearSlot: i with: empty]]
]

{ #category : #enumerating }
HashTable >> elementsDo: aBlock [
	self elementsDo: aBlock count: self size
]

{ #category : #private }
HashTable >> emptySlot [
	^policy notNil ifTrue: [policy emptySlot]
]

{ #category : #private }
HashTable >> equates: anObject1 with: anObject2 [
	^policy notNil
		ifTrue: [policy equates: anObject1 with: anObject2]
		ifFalse: [anObject1 = anObject2]
]

{ #category : #accessing }
HashTable >> findFirst: aBlock startingAt: index [
	| n i first slots |
	n := self size.
	first := i := index.
	slots := self slotsPerElement.
	[aBlock evaluateWith: (self at: i)] whileFalse: [
		i := i + slots.
		i > n ifTrue: [i := 1].
		i = first ifTrue: [self error: 'element not found']].
	^i
]

{ #category : #private }
HashTable >> hashFor: anObject [
	^policy notNil ifTrue: [policy hashFor: anObject] ifFalse: [anObject hash]
]

{ #category : #private }
HashTable >> indexOf: key [
	| hash |
	hash := self hashFor: key.
	^self indexOfHash: hash
]

{ #category : #private }
HashTable >> indexOfHash: integer [
	^integer \\ (self size // 2) + 1
]

{ #category : #private }
HashTable >> indexOfKey: key [
	| hash |
	hash := self hashFor: key.
	^self indexOfKey: key hash: hash
]

{ #category : #private }
HashTable >> indexOfKey: key hash: hash [
	| first empty |
	first := self indexOfHash: hash.
	empty := self emptySlot.
	^self
		findFirst: [:obj | 
			obj == nil or: [obj == empty] or: [| k |
				k := obj == NilToken ifFalse: [obj].
				self equates: key with: k]]
		startingAt: first
]

{ #category : #private }
HashTable >> keyFor: anObject [
	^policy notNil ifTrue: [policy keyFor: anObject] ifFalse: [anObject]
]

{ #category : #private }
HashTable >> keyNotFound: anObject [
	KeyNotFound signalFor: anObject
]

{ #category : #accessing }
HashTable >> lookupKey: key [
	^self lookupKey: key ifAbsent: nil
]

{ #category : #accessing }
HashTable >> lookupKey: key ifAbsent: aBlock [
	| index hash first empty |
	hash := self hashFor: key.
	first := self indexOfHash: hash.
	empty := self emptySlot.
	index := self
		findFirst: [:obj | 
			obj == empty or: [| k |
				k := obj == NilToken ifFalse: [obj].
				self equates: key with: k]]
		startingAt: first.
	^self valueAt: index ifAbsent: aBlock
]

{ #category : #accessing }
HashTable >> lookupValue: key ifAbsent: aBlock [
	^self lookupKey: key ifAbsent: aBlock
]

{ #category : #accessing }
HashTable >> lookUpValue: key ifAbsent: aBlock ifPresent: pBlock [
	| v |
	v := self lookupValue: key ifAbsent: [^aBlock value].
	^pBlock arity = 1 ifTrue: [pBlock evaluateWith: v] ifFalse: [pBlock value]
]

{ #category : #accessing }
HashTable >> lookupValue: key ifPresent: aBlock [
	^self lookUpValue: key ifAbsent: nil ifPresent: aBlock
]

{ #category : #accessing }
HashTable >> owner [
	^policy
]

{ #category : #accessing }
HashTable >> owner: aHashedCollection [
	policy := aHashedCollection
]

{ #category : #accessing }
HashTable >> policy [
	^policy
]

{ #category : #accessing }
HashTable >> policy: aHashTablePolicy [
	policy := aHashTablePolicy
]

{ #category : #private }
HashTable >> rehash: indexes [
	| n index empty |
	n := self size.
	index := 1.
	empty := self emptySlot.
	indexes sort do: [:j | | v |
		index := j max: index.
		[
			index := index = n ifTrue: [1] ifFalse: [index + 1].
			v := self at: index.
			v == nil or: [v == empty]]
			whileFalse: [| k i |
				k := self keyFor: v.
				i := self indexOfKey: k.
				v := self basicAt: i.
				(v == nil or: [v == empty]) ifTrue: [self moveSlot: index to: i]]]
]

{ #category : #private }
HashTable >> rehashFrom: index1 to: index2 [
	| max empty n |
	max := index2.
	empty := self emptySlot.
	n := self size.
	self
		withIndexDo: [:obj :i | | j v k |
			i = n ifTrue: [max := 0].
			(obj == empty and: [i > max]) ifTrue: [^self].
			k := self keyFor: obj.
			j := self indexOfKey: k.
			v := self basicAt: j.
			(v == nil or: [v == empty]) ifTrue: [self moveSlot: i to: j]]
		startingAt: index1
]

{ #category : #private }
HashTable >> removeAll [
	1 to: self size do: [:i | self basicAt: i put: nil]
]

{ #category : #removing }
HashTable >> removeKey: key ifAbsent: aBlock [
	| index empty object |
	index := self indexOfKey: key.
	empty := self emptySlot.
	object := self basicAt: index.
	object == nil ifTrue: [^aBlock value].
	object == empty ifTrue: [^aBlock value].
	self clearSlot: index.
	index := index + self slotsPerElement.
	index > self size ifTrue: [index := 1].
	self
		withIndexDo: [:obj :i | | j v k |
			obj == empty ifTrue: [^self].
			k := self keyFor: obj.
			j := self indexOfKey: k.
			v := self basicAt: j.
			(v == nil or: [v == empty]) ifTrue: [self moveSlot: i to: j]]
		startingAt: index
]

{ #category : #private }
HashTable >> removeKeys: keys ifAbsent: absentBlock [
	| indexes min max |
	keys isEmpty ifTrue: [^self].
	min := self size + 1.
	max := 0.
	indexes := keys
		collect: [:k | | index |
			index := self indexOfKey: k.
			index < min ifTrue: [min := index].
			max < index ifTrue: [max := index].
			index]
		in: OrderedCollection new.
	self clearSlots: indexes ifAbsent: absentBlock.
	indexes size <= 1000
		ifTrue: [self rehash: indexes]
		ifFalse: [self rehashFrom: min to: max]
]

{ #category : #replacing }
HashTable >> replaceBackwardFrom: stop
to: start
with: aCollection
startingAt: position [
	| i j |
	i := stop.
	j := position.
	[start <= i] whileTrue: [
		self basicAt: i put: (aCollection at: j).
		i := i - 1.
		j := j - 1]
]

{ #category : #replacing }
HashTable >> replaceForwardFrom: start
to: stop
with: aCollection
startingAt: position [
	| i j |
	i := start.
	j := position.
	[i <= stop] whileTrue: [
		self basicAt: i put: (aCollection at: j).
		i := i + 1.
		j := j + 1]
]

{ #category : #removing }
HashTable >> slotsPerElement [
	^1
]

{ #category : #accessing }
HashTable >> valueAt: index ifAbsent: aBlock [
	| value |
	value := self at: index.
	value == nil ifTrue: [^aBlock value].
	value == self emptySlot ifTrue: [^aBlock value].
	^value == NilToken ifFalse: [value]
]

{ #category : #removing }
HashTable >> withIndexDo: aBlock startingAt: anInteger [
	| n i first slots |
	n := self size.
	first := i := anInteger.
	slots := self slotsPerElement.
	[
		aBlock evaluateWith: (self at: i) with: i.
		i := i + slots.
		i > n ifTrue: [i := 1].
		i = first] whileFalse
]

