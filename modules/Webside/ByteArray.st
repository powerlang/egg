"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #ByteArray }

{ #category : #'*webside' }
ByteArray >> asBase64 [
	| alphabet result size triple |
	alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.
	result := '' writeStream.
	size := self size.
	1 to: size by: 3 do: [:i |
		triple := (self at: i) << 16.
		triple := triple bitOr: (self at: i+1 ifAbsent: [ 0 ]) << 8.
		triple := triple bitOr: (self at: i+2 ifAbsent: [ 0 ]).
		result
			nextPut: (alphabet at: (triple >> 18 bitAnd: 63) + 1);
			nextPut: (alphabet at: (triple >> 12 bitAnd: 63) + 1);
			nextPut: (i+1 <= size ifTrue: [ alphabet at: ((triple >> 6 bitAnd: 63) + 1) ] ifFalse: [ $= ]);
			nextPut: (i+2 <= size ifTrue: [ alphabet at: ((triple bitAnd: 63) + 1) ] ifFalse: [ $= ])
	].
	^result contents
]
