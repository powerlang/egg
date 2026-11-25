'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SCompilationResult category: #'Powerlang-Core-SCompiler'!
Object subclass: #SCompilationResult
	instanceVariableNames: 'compiler error ast method'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!SCompilationResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
ast
	^ast
! !

!SCompilationResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
ast: aParseNode
	ast := aParseNode
! !

!SCompilationResult methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
beSuccessful
	error := nil
! !

!SCompilationResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiler: aSmalltalkCompiler
	compiler := aSmalltalkCompiler
! !

!SCompilationResult methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
error
	^error
! !

!SCompilationResult methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
error: aCompilationError
	error := aCompilationError
! !

!SCompilationResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
method
	^method
! !

!SCompilationResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
method: aCompiledMethod
	method := aCompiledMethod
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCompilationResult class' category: #'Powerlang-Core-SCompiler'!
SCompilationResult class
	instanceVariableNames: ''!


