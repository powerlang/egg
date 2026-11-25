'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #ScancodeDecoder category: 'SqueakNOS-Devices-Base'!
Object subclass: #ScancodeDecoder
	instanceVariableNames: 'previousScanCode actualScanCode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
altGrPressedIn: aModifiersRegister
	^(aModifiersRegister bitAnd: 16r40) > 0 and: [(aModifiersRegister bitAnd: 16r10 ) > 0 ].
! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
correspondingMapWith: aModifiersRegister

	"rule 1 - extended keys aren't affected by modifiers like control and alt gr.
	 rule 2 - caps lock isn't handled here, because <fill when you know the answer>"
	
	| modifiers |
	modifiers := OrderedCollection new.
	
	previousScanCode == 16rE0 ifTrue: [ modifiers add: #extended. ^modifiers asArray. ].
	
	(self shiftPressedIn: aModifiersRegister) ifTrue: [ modifiers add: #shift ].
	(self altGrPressedIn: aModifiersRegister) ifTrue: [ modifiers add: #alt ].

	modifiers ifEmpty: [modifiers add: #none].
	
	 ^modifiers asArray.
! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
isKeyUp
	^actualScanCode anyMask: 16r80.
! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
isModifier
	^self translateModifierScanCode > 0.
! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
keyUsing: aKeysMapping modifiers: modifiers
	| normalizedCode |
	normalizedCode := actualScanCode bitClear: 16r80.
	
	^(aKeysMapping at: (self correspondingMapWith: modifiers)) at: (normalizedCode ).
	
! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextKeyReady
	 ^(actualScanCode == 16rE0 | (actualScanCode == 16rE1)) not. "If extended scancode we have to wait next to complete"
	

! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextScanCode: aScanCode
	previousScanCode := actualScanCode.
	actualScanCode := aScanCode.
	
! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
shiftPressedIn: aModifiersRegister
	^(aModifiersRegister bitAnd: 8 ) > 0.

! !

!ScancodeDecoder methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
translateModifierScanCode

	| normalizedCode |
	
	previousScanCode = 16rE0 ifTrue: [^ 0]. "Is an extended scancode, can't be a modifier"
	
	normalizedCode := actualScanCode bitClear: 16r80.
	
	normalizedCode == 16r2A ifTrue: [^ 8].		" left shift "	
	normalizedCode == 16r36 ifTrue: [^ 8].		" right shift "
	normalizedCode == 16r38 ifTrue: [^ 16r40].	" left ALT (command key) "
	normalizedCode == 16r1D ifTrue: [^ 16r10].	" left CTRL "

	^ 0.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ScancodeDecoder class' category: 'SqueakNOS-Devices-Base'!
ScancodeDecoder class
	instanceVariableNames: ''!


