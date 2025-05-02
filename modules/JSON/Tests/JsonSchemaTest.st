"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonSchemaTest,
	#superclass : #TestCase,
	#category : #'JSON\Tests'
}

{ #category : #validation }
JsonSchemaTest >> testAnyOfValidation [
	| string number schema |
	string := JsonSchema string maxLength: 5.
	number := JsonSchema number minimum: 0.
	schema := JsonSchema anyOf: {string. number}.
	self
		assert: (schema validate: 'short') hasPassed;
		assert: (schema validate: 'too long') hasValidationFailures;
		assert: (schema validate: 12) hasPassed;
		assert: (schema validate: -5) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testArrayItemsValidation [
	| schema |
	schema := JsonSchema arrayOf: JsonSchema number.
	self
		assert: (schema validate: #(1 2 3 4 5)) hasPassed;
		assert: (schema validate: #(1 2 '3' 4 5)) hasValidationFailures;
		assert: (schema validate: #()) hasPassed;
		assert: (schema validate: 'abc') hasValidationFailures;
		assert: (schema validate: nil) hasValidationFailures;
		assert: (schema validate: true) hasValidationFailures;
		assert: (schema validate: 123) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testArrayLengthValidation [
	| schema |
	schema := JsonSchema arrayOf: JsonSchema number.
	schema minItems: 2; maxItems: 3.
	self
		assert: (schema validate: #()) hasValidationFailures;
		assert: (schema validate: #(1)) hasValidationFailures;
		assert: (schema validate: #(1 2)) hasPassed;
		assert: (schema validate: #(1 2 3)) hasPassed;
		assert: (schema validate: #(1 2 3 4)) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testArrayUniquenessValidation [
	| schema |
	schema := JsonSchema array.
	schema uniqueItems: true.
	self
		assert: (schema validate: #(1 2 3 4 5)) hasPassed;
		assert: (schema validate: #(1 2 3 3 4)) hasValidationFailures;
		assert: (schema validate: #()) hasPassed
]

{ #category : #validation }
JsonSchemaTest >> testBooleanValidation [
	| schema |
	schema := JsonSchema boolean.
	self
		assert: (schema validate: true) hasPassed;
		assert: (schema validate: false) hasPassed;
		assert: (schema validate: 'true') hasValidationFailures;
		assert: (schema validate: 0) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testEnumValidation [
	| schema |
	schema := JsonSchema string.
	schema enum: #('red' 'amber' 'green').
	self
		assert: (schema validate: 'red') hasPassed;
		assert: (schema validate: 'blue') hasValidationFailures.
	schema := JsonSchema new.
	schema enum: {'red'. 'amber'. 'green'. nil. 42}.
	self
		assert: (schema validate: 'red') hasPassed;
		assert: (schema validate: nil) hasPassed;
		assert: (schema validate: 42) hasPassed;
		assert: (schema validate: 0) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testIntegerValidation [
	| schema |
	schema := JsonSchema integer.
	self
		assert: (schema validate: 42) hasPassed;
		assert: (schema validate: -1) hasPassed;
		assert: (schema validate: 3.1415926) hasValidationFailures;
		assert: (schema validate: '42') hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testMultiple [
	| schema |
	schema := JsonSchema number multipleOf: 10.
	self
		assert: (schema validate: 0) hasPassed;
		assert: (schema validate: 10) hasPassed;
		assert: (schema validate: 20) hasPassed;
		assert: (schema validate: 23) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testNotValidation [
	| schema object |
	schema := JsonSchema string not.
	object := JsonObject with: 'key' -> 'value'.
	self
		assert: (schema validate: 42) hasPassed;
		assert: (schema validate: object) hasPassed;
		assert: (schema validate: 'I am a string') hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testNullValidation [
	| schema |
	schema := JsonSchema null.
	self
		assert: (schema validate: nil) hasPassed;
		assert: (schema validate: false) hasValidationFailures;
		assert: (schema validate: 0) hasValidationFailures;
		assert: (schema validate: '') hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testNumberRangeValidation [
	| schema |
	schema := JsonSchema number minimum: 0; exclusiveMaximum: 100.
	self
		assert: (schema validate: -1) hasValidationFailures;
		assert: (schema validate: 0) hasPassed;
		assert: (schema validate: 10) hasPassed;
		assert: (schema validate: 99) hasPassed;
		assert: (schema validate: 100) hasValidationFailures;
		assert: (schema validate: 101) hasValidationFailures.
	schema := JsonSchema number
		minimum: 0;
		maximum: 100;
		exclusiveMaximum: true.
	self
		assert: (schema validate: -1) hasValidationFailures;
		assert: (schema validate: 0) hasPassed;
		assert: (schema validate: 10) hasPassed;
		assert: (schema validate: 99) hasPassed;
		assert: (schema validate: 100) hasValidationFailures;
		assert: (schema validate: 101) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testNumberValidation [
	| schema |
	schema := JsonSchema number.
	self
		assert: (schema validate: 42) hasPassed;
		assert: (schema validate: -1) hasPassed;
		assert: (schema validate: 5.0) hasPassed;
		assert: (schema validate: 2.99792458e8) hasPassed;
		assert: (schema validate: '42') hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testObjectEnumValidation [
	| foo bar schema |
	foo := JsonObject with: 'id' -> 1 with: 'name' -> 'foo'.
	bar := JsonObject with: 'id' -> 2 with: 'name' -> 'bar'.
	schema := JsonSchema object enum: {foo. bar}.
	self
		assert: (schema validate: foo) hasPassed;
		assert: (schema validate: bar) hasPassed;
		assert: (schema validate: JsonObject new) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testObjectValidation [
	| schema person car |
	schema := JsonSchema object
		addProperty: 'name' schema: JsonSchema string;
		addProperty: 'age' schema: JsonSchema integer.
	person := JsonObject new.
	person
		at: 'name' put: 'william';
		at: 'age' put: 42.
	car := JsonObject new.
	car at: 'brand' put: 'chevrolet'.
	self
		assert: (schema validate: person) hasPassed;
		assert: (schema validate: JsonObject new) hasPassed;
		assert: (schema validate: car) hasPassed;
		assert: (schema validate: nil) hasValidationFailures;
		assert: (schema validate: true) hasValidationFailures;
		assert: (schema validate: 'abc') hasValidationFailures;
		assert: (schema validate: 123) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testOneOfValidation [
	| multiplesOf5 multiplesOf3 schema |
	multiplesOf5 := JsonSchema number multipleOf: 5.
	multiplesOf3 := JsonSchema number multipleOf: 3.
	schema := JsonSchema oneOf: {multiplesOf5. multiplesOf3}.
	self
		assert: (schema validate: 10) hasPassed;
		assert: (schema validate: 9) hasPassed;
		assert: (schema validate: 2) hasValidationFailures;
		assert: (schema validate: 15) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testReferenceResolution [
	| address person reference |
	address := JsonSchema object
		addProperty: 'street_address' schema: JsonSchema string;
		addProperty: 'city' schema: JsonSchema string;
		addProperty: 'state' schema: JsonSchema string.
	person := JsonSchema object
		addProperty: 'name' schema: JsonSchema string;
		addProperty: 'address' schema: address.
	reference := JsonSchemaReference path: '#/address'.
	self
		assert: reference isLocal;
		assert: (reference resolveIn: person) = address.
	reference := JsonSchemaReference path: '#/address/city'.
	self
		assert: reference isLocal;
		assert: (reference resolveIn: person) isStringSchema
]

{ #category : #validation }
JsonSchemaTest >> testReferenceValidation [
	| schema valid invalid |
	schema := JsonSchema object
		addProperty: 'name' schema: JsonSchema string;
		addProperty: 'nickname' schema: (JsonSchema ref: '#/name').
	valid := JsonParser
		parse: <json>
			{
				"name": "william",
				"nickname": "will"
			}
		</json>.
	invalid := JsonParser
		parse: <json>
			{
				"name": "william",
				"nickname": 33
			}
		</json>.
	self
		assert: (schema validate: valid) hasPassed;
		assert: (schema validate: invalid) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testReferenceValidation2 [
	| reference person schema valid invalid |
	reference := JsonSchema ref: '#/definitions/person'.
	person := JsonSchema object
		addProperty: 'name' schema: JsonSchema string;
		addProperty: 'children'
		schema: (JsonSchema arrayOf: reference).
	schema := JsonSchema object
		addDefinition: person named: 'person';
		addProperty: 'person' schema: reference.
	valid := JsonParser
		parse: <json>
			{"person": {
				"name": "homer",
				"children": [
					{"name": "bart"},
					{"name": "lisa"}
				]
			}}
		</json>.
	self assert: (schema validate: valid) hasPassed.
	invalid := JsonParser
		parse: <json>
			{"person": {
				"name": "homer",
				"children": [
					true,
					0,
					"abc"
				]
			}}
		</json>.
	self assert: (schema validate: invalid) hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testStringLengthValidation [
	| schema |
	schema := JsonSchema string.
	schema minLength: 2; maxLength: 3.
	self
		assert: (schema validate: 'A') hasValidationFailures;
		assert: (schema validate: 'AB') hasPassed;
		assert: (schema validate: 'ABC') hasPassed;
		assert: (schema validate: 'ABCD') hasValidationFailures
]

{ #category : #validation }
JsonSchemaTest >> testStringValidation [
	| schema |
	schema := JsonSchema string.
	self
		assert: (schema validate: 'This is a string') hasPassed;
		assert: (schema validate: 'Déjà vu') hasPassed;
		assert: (schema validate: '42') hasPassed;
		assert: (schema validate: 42) hasValidationFailures;
		assert: (schema validate: nil) hasValidationFailures;
		assert: (schema validate: true) hasValidationFailures;
		assert: (schema validate: false) hasValidationFailures;
		assert: (schema validate: 123) hasValidationFailures
]

