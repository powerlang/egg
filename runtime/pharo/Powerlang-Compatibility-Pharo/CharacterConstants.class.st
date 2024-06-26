Class {
	#name : 'CharacterConstants',
	#superclass : 'PSharedPool',
	#classVars : [
		'Cr',
		'Lf',
		'Space',
		'Tab'
	],
	#category : 'Powerlang-Compatibility-Pharo',
	#package : 'Powerlang-Compatibility-Pharo'
}

{ #category : 'class initialization' }
CharacterConstants class >> initialize [
	Cr := Character cr.
	Lf := Character lf.
	Tab := Character tab.
	Space := Character space.
]
