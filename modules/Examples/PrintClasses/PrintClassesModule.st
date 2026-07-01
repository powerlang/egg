Class {
	#name : #PrintClassesModule,
	#superclass : #Module,
	#category : #'Examples-PrintClasses'
}

{ #category : #spec }
PrintClassesModule >> imports [
	^{}
]

{ #category: #private }
PrintClassesModule >> printAClass: aClass indent: indentCount [
	| aString |
	indentCount timesRepeat: [
		Kernel log: '    '.
	].
	Kernel log: aClass printString, String cr.
	aClass subclassesDo: [ :sub | self printAClass: sub indent: indentCount + 1 ].
]

{ #category : #services }
PrintClassesModule >> main: arguments [
	Kernel log: 'Current Local Classes', String cr.
	self printAClass: Object class indent: 0.
	^0
]
