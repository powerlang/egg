"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRHashTable,
	#superclass : #HashTable,
	#type : #variable,
	#category : #Kernel
}

{ #category : #inquiries }
LMRHashTable class >> primeFor: size [
	| n primes |
	n := size bitOr: 1.
	n <= 251 ifTrue: [^Sizes at: n // 2 + 1].
	primes := self goodPrimes.
	1 to: primes size do: [:i | | p |
		p := primes at: i.
		p > n ifTrue: [^p]].
	^n
]
