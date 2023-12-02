Class {
	#name : #PacketInspector,
	#superclass : #Object,
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #selecting }
PacketInspector >> contentsIsString [
	"Hacked so contents empty when deselected and = long printString when item 2"

	^ false
]

{ #category : #accessing }
PacketInspector >> fieldList [
	^ object class allFieldsNames
]

{ #category : #selecting }
PacketInspector >> replaceSelectionValue: anObject [ 
	"Add colon to fieldname to get setter selector, and send it to object with the argument.
	 Refer to the comment in Inspector|replaceSelectionValue:."

	selectionIndex = 1
		ifTrue: [^object]
		ifFalse: [^object perform: ((self fieldList at: selectionIndex), ':') asSymbol with: anObject]
]

{ #category : #selecting }
PacketInspector >> selection [ 
	"Refer to the comment in Inspector|selection."
	selectionIndex <= 1 ifTrue: [^object].
	^ object perform: (self fieldList at: selectionIndex)
]
