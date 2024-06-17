Class {
	#name : 'SStringNode',
	#superclass : 'SLiteralNode',
	#category : 'Powerlang-SCompiler-Parser',
	#package : 'Powerlang-SCompiler',
	#tag : 'Parser'
}

{ #category : 'visiting' }
SStringNode >> acceptVisitor: visitor [
	^visitor visitString: self
]
