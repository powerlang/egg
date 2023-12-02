Class {
	#name : #ScancodeDecoder,
	#superclass : #Object,
	#instVars : [
		'previousScanCode',
		'actualScanCode'
	],
	#category : 'SqueakNOS-Devices-Base'
}

{ #category : #'as yet unclassified' }
ScancodeDecoder >> altGrPressedIn: aModifiersRegister [
	^(aModifiersRegister bitAnd: 16r40) > 0 and: [(aModifiersRegister bitAnd: 16r10 ) > 0 ].
]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> correspondingMapWith: aModifiersRegister [

	"rule 1 - extended keys aren't affected by modifiers like control and alt gr.
	 rule 2 - caps lock isn't handled here, because <fill when you know the answer>"
	
	| modifiers |
	modifiers := OrderedCollection new.
	
	previousScanCode == 16rE0 ifTrue: [ modifiers add: #extended. ^modifiers asArray. ].
	
	(self shiftPressedIn: aModifiersRegister) ifTrue: [ modifiers add: #shift ].
	(self altGrPressedIn: aModifiersRegister) ifTrue: [ modifiers add: #alt ].

	modifiers ifEmpty: [modifiers add: #none].
	
	 ^modifiers asArray.
]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> isKeyUp [
	^actualScanCode anyMask: 16r80.
]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> isModifier [
	^self translateModifierScanCode > 0.
]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> keyUsing: aKeysMapping modifiers: modifiers [
	| normalizedCode |
	normalizedCode := actualScanCode bitClear: 16r80.
	
	^(aKeysMapping at: (self correspondingMapWith: modifiers)) at: (normalizedCode ).
	
]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> nextKeyReady [
	 ^(actualScanCode == 16rE0 | (actualScanCode == 16rE1)) not. "If extended scancode we have to wait next to complete"
	

]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> nextScanCode: aScanCode [
	previousScanCode := actualScanCode.
	actualScanCode := aScanCode.
	
]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> shiftPressedIn: aModifiersRegister [
	^(aModifiersRegister bitAnd: 8 ) > 0.

]

{ #category : #'as yet unclassified' }
ScancodeDecoder >> translateModifierScanCode [

	| normalizedCode |
	
	previousScanCode = 16rE0 ifTrue: [^ 0]. "Is an extended scancode, can't be a modifier"
	
	normalizedCode := actualScanCode bitClear: 16r80.
	
	normalizedCode == 16r2A ifTrue: [^ 8].		" left shift "	
	normalizedCode == 16r36 ifTrue: [^ 8].		" right shift "
	normalizedCode == 16r38 ifTrue: [^ 16r40].	" left ALT (command key) "
	normalizedCode == 16r1D ifTrue: [^ 16r10].	" left CTRL "

	^ 0.
]
