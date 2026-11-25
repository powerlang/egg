'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #PacketInspector category: 'SqueakNOS-Net-Tests'!
Object subclass: #PacketInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!PacketInspector methodsFor:  'selecting' stamp: 'KenD 28/Jun/2026 13:32:25'!
contentsIsString
	"Hacked so contents empty when deselected and = long printString when item 2"

	^ false
! !

!PacketInspector methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fieldList
	^ object class allFieldsNames
! !

!PacketInspector methodsFor:  'selecting' stamp: 'KenD 28/Jun/2026 13:32:25'!
replaceSelectionValue: anObject
	"Add colon to fieldname to get setter selector, and send it to object with the argument.
	 Refer to the comment in Inspector|replaceSelectionValue:."

	selectionIndex = 1
		ifTrue: [^object]
		ifFalse: [^object perform: ((self fieldList at: selectionIndex), ':') asSymbol with: anObject]
! !

!PacketInspector methodsFor:  'selecting' stamp: 'KenD 28/Jun/2026 13:32:25'!
selection
	"Refer to the comment in Inspector|selection."
	selectionIndex <= 1 ifTrue: [^object].
	^ object perform: (self fieldList at: selectionIndex)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PacketInspector class' category: 'SqueakNOS-Net-Tests'!
PacketInspector class
	instanceVariableNames: ''!


