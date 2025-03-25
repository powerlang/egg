"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #TinyBenchmarksModule,
	#superclass : #Module,
	#instVars : [],
	#category : #TinyBenchmarks

}

{ #category : #initializing }
TinyBenchmarksModule >> imports [
	^{ 
		#Kernel -> {#Integer. #Time}
	}
]
{ #category : #benchmarking }
TinyBenchmarksModule >> tinyBenchmarks [
	"
	Report the results of running the two tiny Squeak benchmarks.
	ar 9/10/1999: Adjusted to run at least 1 sec to get more stable results
	0 tinyBenchmarks
	On a 292 MHz G3 Mac: 22727272 bytecodes/sec; 984169 sends/sec
	On a 400 MHz PII/Win98:  18028169 bytecodes/sec; 1081272 sends/sec
	"
	| t1 t2 r n1 n2 |
	n1 := 256.
	[
		t1 := Time millisecondsToRun: [self bytecodeIntensiveBenchmark: n1].
		t1 < 1000]
		whileTrue: [n1 := n1 * 2].
	"Note: #benchmark's runtime is about O(n)"

	n2 := 26.
	[
		t2 := Time millisecondsToRun: [r := self fibonacchi: n2].
		t2 < 1000]
		whileTrue: [n2 := n2 + 1].
	
	"Note: #fibonacchi's runtime is about O(n^2)."

	^(n1 * 500000 * 1000 // t1) printString , ' bytecodes/sec; '
		, (r * 1000 // t2) printString
		, ' sends/sec'
]

{ #category : 'benchmarking' }
TinyBenchmarksModule >> bytecodeIntensiveBenchmark: anInteger [
	"
	(500000 // time to run) = approx bytecodes per second
	5000000 // (Time millisecondsToRun: [10 benchmark]) * 1000
	3059000 on a Mac 8100/100
	"
	| size flags prime k count |
	size := 8190.
	1 to: anInteger do: [:iter | 
		count := 0.
		flags := (Array new: size) atAllPut: true.
		1 to: size do: [:i | 
			(flags at: i) ifTrue: [
				prime := i + 1.
				k := i + prime.
				[k <= size] whileTrue: [
					flags at: k put: false.
					k := k + prime].
				count := count + 1]]].
	^count
]

{ #category : 'benchmarking' }
TinyBenchmarksModule >> fibonacchi: anInteger [
	"
	Handy send-heavy benchmark
	(result // seconds to run) = approx calls per second
	| r t |
	t := Time millisecondsToRun: [r := 26 benchFib].
	(r * 1000) // t
	138000 on a Mac 8100/100
	"
	^anInteger < 2
		ifTrue: [1]
		ifFalse: [(self fibonacchi: anInteger - 1) + (self fibonacchi: anInteger - 2) + 1]
]

{ #category : 'cli' }
TinyBenchmarksModule >> main: args [

	Kernel log: self tinyBenchmarks, String cr
]