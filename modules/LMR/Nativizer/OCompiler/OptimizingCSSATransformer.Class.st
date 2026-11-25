'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingCSSATransformer category: #OCompiler!
Object subclass: #OptimizingCSSATransformer
	instanceVariableNames: 'firstBlock liveness'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingCSSATransformer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingCSSATransformer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
applyTransformation
	self splitPhis; coalescePhis
! !

!OptimizingCSSATransformer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
coalescePhis
	"
	to do
	"
	
! !

!OptimizingCSSATransformer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: block
	firstBlock := block
! !

!OptimizingCSSATransformer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
liftPhisIn: block
	block phisDo: [:phi | 
		phi variablesWithBlocksDo: [:var :pred | | copy |
			copy := var insertCopyBefore: pred lastInstruction.
			phi atOperand: pred put: copy.
			var removeUse: phi at: pred; dissolveIfUnused.
			copy addUse: phi at: pred]]
! !

!OptimizingCSSATransformer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitPhis
	firstBlock withSuccessorsPostOrder do: [:block | self liftPhisIn: block]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingCSSATransformer class' category: #OCompiler!
OptimizingCSSATransformer class
	instanceVariableNames: ''!


