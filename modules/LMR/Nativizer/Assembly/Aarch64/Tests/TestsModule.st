"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #TestsModule,
	#superclass : #Module,
	#category : #'LMR.Nativizer.Assembly.Aarch64.Tests'
}

{ #category : #spec }
TestsModule >> imports [
	^{
		#Kernel -> #(Error).
		#'LMR.Nativizer.Assembly.Aarch64' -> #(ARM64InstructionSpec ARM64Register).
		#SUnit -> #(TestCase TestResult)
	}
]

{ #category : #main }
TestsModule >> main: anArray [
	{ARM64InstructionSpecTest} do: [:test | | result |
		result := test buildTestSuite run.
		Kernel log: test name , ': ' , result printString , String cr]
]
