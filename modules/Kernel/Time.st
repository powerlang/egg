"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Time,
	#superclass : #Magnitude,
	#category : #Kernel
}

{ #category : #'instance creation' }
Time class >> millisecondsToRun: aClosure [
	| start stop |
	start := Kernel host currentMilliseconds.
	aClosure value.
	stop := Kernel host currentMilliseconds.
	^stop - start
]
