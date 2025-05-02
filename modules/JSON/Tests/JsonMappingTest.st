"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonMappingTest,
	#superclass : #TestCase,
	#category : #'JSON\Tests'
}

{ #category : #all }
JsonMappingTest >> testTypeMapping [
	| type mapping json object |
	type := EdmComplexType new.
	type
		name: 'point';
		addPropertyNamed: 'x' type: EdmType int;
		addPropertyNamed: 'y' type: EdmType int.
	mapping := JsonMapping fromType: type toClass: Point.
	json := mapping jsonObjectFrom: 1 @ 2.
	self
		assert: json isJsonObject;
		assert: (json at: 'x' ifAbsent: [self assert: false]) = 1;
		assert: (json at: 'y' ifAbsent: [self assert: false]) = 2.
	object := mapping objectFrom: json.
	self assert: object = (1 @ 2)
]

{ #category : #all }
JsonMappingTest >> testTypesMapping [
	| registry point mapping rectangle example dictionary object serializer |
	registry := JsonMappingRegistry new.
	point := EdmComplexType new.
	point
		name: 'point';
		addPropertyNamed: 'x' type: EdmType int;
		addPropertyNamed: 'y' type: EdmType int.
	mapping := JsonMapping fromType: point toClass: Point.
	registry register: mapping.
	rectangle := EdmComplexType new.
	rectangle
		name: 'rectangle';
		addPropertyNamed: 'leftTop' type: point;
		addPropertyNamed: 'rightBottom' type: point.
	mapping := JsonMapping fromType: rectangle toClass: Rectangle.
	registry register: mapping.
	example := Rectangle origin: -10 @ 5 corner: 20 @ 10.
	serializer := mapping serializer condition: true.
	dictionary := serializer jsonObjectFrom: example.
	self assert: dictionary isDictionary.
	object := mapping objectFrom: dictionary.
	self assert: object = example
]

