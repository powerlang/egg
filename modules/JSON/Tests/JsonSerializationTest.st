"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonSerializationTest,
	#superclass : #TestCase,
	#category : #'JSON\Tests'
}

{ #category : #all }
JsonSerializationTest >> testBasicSerialization [
	| serialized inflated |
	serialized := JsonSerializer serialize: #(true 1 'a').
	self assert: serialized = '[
	true,
	1,
	"a"
]'.
	inflated := JsonSerializer inflate: serialized.
	self assert: inflated = #(true 1 'a')
]

{ #category : #all }
JsonSerializationTest >> testInflate [
	| mappings class mapping serializer dictionary json copy |
	mappings := JsonMappingRegistry new.
	class := EdmEntityType new.
	class
		name: 'class';
		addKeyNamed: 'name' type: EdmType string;
		addPropertyNamed: 'subclasses' type: (EdmArrayType of: class);
		addPropertyNamed: 'format' type: EdmType integer;
		addPropertyNamed: 'instanceVariables'
		type: (EdmArrayType of: EdmType string).
	mapping := JsonMapping fromType: class toClass: Class.
	mapping
		get: 'name' with: #symbol;
		set: 'name' with: #name: adaptor: SymbolAdaptor new;
		get: 'subclasses' with: #subclasses;
		get: 'instanceVariables' with: #instVarNames;
		set: 'instanceVariables' with: #instVarNames:;
		get: 'format' with: #format.
	mapping
		locator: [:dict | (Smalltalk at: (dict at: 'name') asSymbol) objectShallowCopy].
	mappings register: mapping.
	serializer := mapping serializer onlyKeysFromLevel: 2.
	dictionary := serializer jsonObjectFrom: HashedCollection.
	json := JsonWriter write: dictionary.
	copy := serializer inflate: json using: mapping.
	self
		assert: copy !== HashedCollection;
		assert: copy name = HashedCollection name;
		assert: copy format = HashedCollection format;
		assert: copy instVarNames = HashedCollection instVarNames.
	copy subclasses with: HashedCollection subclasses do: [:c :d | 
		self
			assert: c !== d;
			assert: c name = d name;
			assert: c format = d format;
			assert: c instVarNames = d instVarNames.
		c subclasses with: d subclasses do: [:e :f | self assert: e == f]]
]

{ #category : #all }
JsonSerializationTest >> testInflate2 [
	| mappings class mapping serializer dictionary json copy |
	mappings := JsonMappingRegistry new.
	class := EdmEntityType new.
	class
		name: 'class';
		addKeyNamed: 'name' type: EdmType string;
		addPropertyNamed: 'subclasses' type: (EdmArrayType of: class);
		addPropertyNamed: 'format' type: EdmType integer;
		addPropertyNamed: 'instanceVariables'
		type: (EdmArrayType of: EdmType string).
	mapping := JsonMapping fromType: class toClass: Class.
	mapping
		get: 'name' with: #symbol;
		set: 'name' with: #name: adaptor: SymbolAdaptor new;
		get: 'subclasses' with: #subclasses;
		get: 'instanceVariables' with: #instVarNames;
		set: 'instanceVariables' with: #instVarNames:;
		get: 'format' with: #format.
	mapping
		locator: [:dict | (Smalltalk at: (dict at: 'name') asSymbol) objectShallowCopy].
	mappings register: mapping.
	serializer := mapping serializer onlyKeysFromLevel: 3.
	dictionary := serializer jsonObjectFrom: HashedCollection.
	json := JsonWriter write: dictionary.
	copy := serializer inflate: json using: mapping.
	self
		assert: copy !== HashedCollection;
		assert: copy name = HashedCollection name;
		assert: copy format = HashedCollection format;
		assert: copy instVarNames = HashedCollection instVarNames.
	copy subclasses with: HashedCollection subclasses do: [:c :d | 
		self
			assert: c !== d;
			assert: c name = d name;
			assert: c format = d format;
			assert: c instVarNames = d instVarNames.
		c subclasses with: d subclasses do: [:e :f | self assert: e !== f]]
]

{ #category : #all }
JsonSerializationTest >> testKeysFromLevel [
	| mappings t1 mapping t2 t3 object serializer dictionary |
	mappings := JsonMappingRegistry new.
	t1 := EdmEntityType new.
	t1
		name: 't1';
		addKeyNamed: 'id' type: EdmType integer;
		addPropertyNamed: 'name' type: EdmType string.
	mapping := JsonMapping fromType: t1 toClass: Association.
	mapping
		get: 'id' with: #key;
		get: 'name' with: #value.
	mappings register: mapping.
	t2 := EdmComplexType new.
	t2
		name: 't2';
		addPropertyNamed: 't1' type: t1.
	mapping := JsonMapping fromType: t2 toClass: Object.
	mapping get: 't1' with: #t1.
	mappings register: mapping.
	t3 := EdmComplexType new.
	t3
		name: 't3';
		addPropertyNamed: 't1' type: t1;
		addPropertyNamed: 't2' type: t2.
	mapping := JsonMapping fromType: t3 toClass: Window.
	mapping
		get: 't1' with: #t1;
		get: 't2' with: #t2.
	mappings register: mapping.
	object := Window new.
	object
		answerTo: #t1 with: 1 -> 'William';
		answerTo: #t2 with: (Object new answerTo: #t1 with: 2 -> 'Juliette').
	serializer := JsonSerializer new.
	serializer mappings: mappings; onlyKeysFromLevel: 2.
	dictionary := serializer jsonObjectFrom: object.
	self
		assert: ((dictionary valueAt: 't1') keys equalsTo: #('id' 'name'));
		assert: (((dictionary valueAt: 't2') valueAt: 't1') keys equalsTo: #('id'))
]

{ #category : #all }
JsonSerializationTest >> testLevelCutting [
	| type mappings mapping object serializer dictionary |
	type := EdmComplexType new.
	type
		name: 'type';
		addPropertyNamed: 'name' type: EdmType string;
		addPropertyNamed: 'child' type: type.
	mappings := JsonMappingRegistry new.
	mapping := JsonMapping fromType: type toClass: Association.
	mapping
		get: 'name' with: #key;
		get: 'child' with: #value.
	mappings register: mapping.
	object := 'a' -> ('b' -> ('c' -> 'd')).
	serializer := mapping serializer upToLevel: 2.
	dictionary := serializer jsonObjectFrom: object.
	self
		assert: (dictionary valueAt: 'name') = 'a';
		assert: (dictionary valueAt: 'child') notNil;
		assert: ((dictionary valueAt: 'child') valueAt: 'name') = 'b';
		assert: ((dictionary valueAt: 'child') valueAt: 'child') isNil
]

{ #category : #all }
JsonSerializationTest >> testLevelCutting2 [
	| type mappings mapping object serializer dictionary |
	type := EdmEntityType new.
	type
		name: 'type';
		addKeyNamed: 'name' type: EdmType string;
		addPropertyNamed: 'index' type: EdmType integer;
		addPropertyNamed: 'child' type: type.
	mappings := JsonMappingRegistry new.
	mapping := JsonMapping fromType: type toClass: Association.
	mapping
		get: 'name' with: #key;
		get: 'index' with: [:assoc | assoc value key];
		get: 'child' with: [:assoc | assoc value value].
	mappings register: mapping.
	object := 'a' -> (1 -> ('b' -> (2 -> ('c' -> (3 -> 'd'))))).
	serializer := mapping serializer upToLevel: 2.
	dictionary := serializer jsonObjectFrom: object.
	self
		assert: (dictionary valueAt: 'name') = 'a';
		assert: (dictionary valueAt: 'index') = 1;
		assert: ((dictionary valueAt: 'child') valueAt: 'name') = 'b';
		assert: ((dictionary valueAt: 'child') valueAt: 'index') = 2;
		assert: (((dictionary valueAt: 'child') valueAt: 'child') valueAt: 'name') = 'c';
		assert: (((dictionary valueAt: 'child') valueAt: 'child') valueAt: 'index') isNil;
		assert: (((dictionary valueAt: 'child') valueAt: 'child') valueAt: 'child') isNil
]

{ #category : #all }
JsonSerializationTest >> testOnlyKeys [
	| mappings subtype mapping type object serializer dictionary |
	mappings := JsonMappingRegistry new.
	subtype := EdmEntityType new.
	subtype
		name: 'subtype';
		addKeyNamed: 'id' type: EdmType integer;
		addPropertyNamed: 'name' type: EdmType string.
	mapping := JsonMapping fromType: subtype toClass: Association.
	mapping
		get: 'id' with: #key;
		get: 'name' with: #value.
	mappings register: mapping.
	type := EdmComplexType new.
	type
		name: 'type';
		addPropertyNamed: 'one' type: subtype;
		addPropertyNamed: 'many' type: (EdmType arrayOf: subtype).
	mapping := JsonMapping fromType: type toClass: Object.
	mapping
		get: 'one' with: #one;
		get: 'many' with: #many.
	mappings register: mapping.
	object := Object new.
	object
		answerTo: #one with: 1 -> 'John';
		answerTo: #many
		with: (Array with: 2 -> 'William' with: 3 -> 'Juliette').
	serializer := mapping serializer onlyKeys.
	dictionary := serializer jsonObjectFrom: object.
	self
		assert: ((dictionary valueAt: 'one') keys equalsTo: #('id'));
		assert: ((dictionary valueAt: 'many')
			conform: [:d | d keys equalsTo: #('id')])
]

