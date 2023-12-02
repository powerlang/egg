Class {
	#name : #IPOptionsTest,
	#superclass : #TestCase,
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #tests }
IPOptionsTest >> testClassification [
	| option |
	option := IPOption bytes: #(68 3 1). "timestamp"
	self assert: option classification = 2.
	self assert: option number = 4.
	self assert: option length = 3
]

{ #category : #tests }
IPOptionsTest >> testEOL [
	| option |
	option := IPOption bytes: #(0).
	self assert: option classification = 0.
	self assert: option number = 0.
	self assert: option isEOL
]

{ #category : #tests }
IPOptionsTest >> testNop [
	| option |
	option := IPOption bytes: #(1).
	self assert: option classification = 0.
	self assert: option number = 1.
	self assert: option isNOP
]
