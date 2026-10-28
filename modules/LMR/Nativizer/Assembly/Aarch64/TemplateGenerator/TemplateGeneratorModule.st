"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	Generates ARM64TemplateAssembler.st. Run it from the repository root with:

		egg LMR.Nativizer.Assembly.Aarch64.TemplateGenerator [output]

	For each GenericAssembler method that always makes ARM64CodeGenerator
	emit the same instructions, with no labels, literals or fixups and
	leaving the assembler as it was, it writes a method that emits those
	instructions directly. Methods taking an immediate or an index get the
	ranges of arguments whose code only differs in one instruction, linearly
	with the argument, and fall back to GenericAssembler outside them.
"

Class {
	#name : #TemplateGeneratorModule,
	#superclass : #Module,
	#instVars : [
		'platform'
	],
	#category : #'LMR-Nativizer-Assembly-Aarch64-TemplateGenerator'
}

{ #category : #spec }
TemplateGeneratorModule >> imports [
	^{
		#Kernel -> #(Error OrderedCollection String).
		#'LMR.Nativizer' -> #(NativizationPlatform).
		#'LMR.Nativizer.Assembly' -> #(GenericAssembler)
	}
]

{ #category : #services }
TemplateGeneratorModule >> main: args [
	| filename source |
	platform := NativizationPlatform aarch64_darwin.
	filename := args size > 2
		ifTrue: [args at: 3]
		ifFalse: ['modules/LMR/Nativizer/Assembly/Aarch64/ARM64TemplateAssembler.st'].
	source := self templateSource.
	Kernel writeFile: filename contents: source.
	Kernel host logInfo: 'wrote ' , filename
]

{ #category : #generating }
TemplateGeneratorModule >> templateSource [
	| stream |
	stream := String new writeStream.
	stream nextPutAll: self header.
	self templateSelectors
		do: [:selector | self writeTemplateOf: selector on: stream].
	^stream contents
]

{ #category : #generating }
TemplateGeneratorModule >> writeTemplateOf: selector on: stream [
	| instructions ranges |
	selector arity = 0 ifTrue: [
		instructions := self instructionsOf: selector.
		instructions notNil
			ifTrue: [self write: selector instructions: instructions on: stream].
		^self].
	ranges := self rangesOf: selector.
	ranges isEmpty ifFalse: [self write: selector ranges: ranges on: stream]
]

{ #category : #generating }
TemplateGeneratorModule >> templateSelectors [
	| selectors |
	selectors := GenericAssembler selectors
		select: [:selector | self isTemplate: GenericAssembler >> selector].
	^selectors asSortedCollection asArray
]

{ #category : #generating }
TemplateGeneratorModule >> isTemplate: aCompiledMethod [
	| selector |
	aCompiledMethod category == #services ifTrue: [^false].
	selector := aCompiledMethod selector.
	aCompiledMethod argumentCount = 1 ifTrue: [
		^(selector endsWith: 'Immediate:') or: [selector endsWith: 'index:']].
	aCompiledMethod argumentCount > 0 ifTrue: [^false].
	^(selector beginsWith: 'reg') not and: [(selector beginsWith: 'labeled') not]
]

{ #category : #generating }
TemplateGeneratorModule >> instructionsOf: selector [
	| instructions elsewhere |
	instructions := self instructions: selector with: #() after: 0 logging: true.
	instructions isNil ifTrue: [^nil].
	elsewhere := self instructions: selector with: #() after: 1 logging: false.
	^elsewhere = instructions ifTrue: [instructions]
]

{ #category : #generating }
TemplateGeneratorModule >> instructionsOf: selector with: anInteger [
	| instructions elsewhere |
	instructions := self quickInstructionsOf: selector with: anInteger.
	instructions isNil ifTrue: [^nil].
	elsewhere := self
		instructions: selector
		with: {anInteger}
		after: 1
		logging: false.
	^elsewhere = instructions ifTrue: [instructions]
]

{ #category : #generating }
TemplateGeneratorModule >> quickInstructionsOf: selector with: anInteger [
	^self instructions: selector with: {anInteger} after: 0 logging: false
]

{ #category : #generating }
TemplateGeneratorModule >> instructions: selector with: arguments after: nopCount logging: aBoolean [
	| assembler codegen memory start state bytes |
	assembler := GenericAssembler new platform: platform.
	codegen := assembler codegen.
	memory := codegen memory.
	nopCount timesRepeat: [codegen nop].
	start := memory position.
	state := self stateOf: assembler.
	[assembler perform: selector withArguments: arguments] on: Error do: [:e |
		aBoolean ifTrue: [self warnNoTemplateFor: selector because: e].
		^nil].
	memory fixups isEmpty ifFalse: [^nil].
	(self stateOf: assembler) = state ifFalse: [^nil].
	bytes := memory bytes copyFrom: start + 1 to: memory position.
	bytes isEmpty ifTrue: [^nil].
	^(1 to: bytes size by: 4) asArray collect: [:i | self instructionAt: i in: bytes]
]

{ #category : #generating }
TemplateGeneratorModule >> instructionAt: index in: bytes [
	| instruction |
	instruction := 0.
	3 to: 0 by: -1 do: [:i | instruction := (instruction bitShift: 8) + (bytes at: index + i)].
	^instruction
]

{ #category : #generating }
TemplateGeneratorModule >> warnNoTemplateFor: selector because: anError [
	Kernel host logWarning: 'no template for ' , selector , ': ' , anError description
]

{ #category : #generating }
TemplateGeneratorModule >> stateOf: assembler [
	| state codegen |
	state := OrderedCollection new.
	codegen := assembler codegen.
	{assembler. codegen} do: [:object |
		1 to: object class instSize do: [:i | | value |
			value := object instVarAt: i.
			(value == codegen or: [value == codegen memory])
				ifFalse: [state add: (self snapshotOf: value)]]].
	^state asArray
]

{ #category : #generating }
TemplateGeneratorModule >> snapshotOf: anObject [
	^anObject isCollection ifTrue: [anObject copy] ifFalse: [anObject]
]

{ #category : #generating }
TemplateGeneratorModule >> rangesOf: selector [
	| first ranges |
	first := (selector endsWith: 'index:') ifTrue: [1] ifFalse: [0].
	ranges := {
		self rangeOf: selector from: first by: 1.
		self rangeOf: selector from: first - 1 by: -1}.
	^ranges reject: [:range | range isNil]
]

{ #category : #generating }
TemplateGeneratorModule >> rangeOf: selector from: start by: step [
	| instructions next index stride base fits good bad end last |
	instructions := self instructionsOf: selector with: start.
	next := self instructionsOf: selector with: start + step.
	(instructions isNil or: [next isNil]) ifTrue: [^nil].
	instructions size = next size ifFalse: [^nil].
	index := self indexOfOnlyDifferenceBetween: instructions and: next.
	index isNil ifTrue: [^nil].
	stride := ((next at: index) - (instructions at: index)) * step.
	base := (instructions at: index) - (start * stride).
	fits := [:count | self fits: start + (count * step) in: selector instructions: instructions at: index base: base stride: stride].
	good := 1.
	bad := 2.
	[bad < (1 bitShift: 27) and: [fits value: bad]] whileTrue: [good := bad. bad := bad * 2].
	[bad - good > 1] whileTrue: [| middle |
		middle := good + bad // 2.
		(fits value: middle) ifTrue: [good := middle] ifFalse: [bad := middle]].
	((fits value: good // 2) and: [fits value: good - 1]) ifFalse: [^nil].
	end := start + (good * step).
	last := self instructionsOf: selector with: end.
	last isNil ifTrue: [^nil].
	^{start min: end. start max: end. instructions. index. base. stride}
]

{ #category : #generating }
TemplateGeneratorModule >> fits: value in: selector instructions: instructions at: index base: base stride: stride [
	| probe |
	probe := self quickInstructionsOf: selector with: value.
	(probe notNil and: [probe size = instructions size]) ifFalse: [^false].
	^(1 to: instructions size) conform: [:i | | expected |
		expected := i = index ifTrue: [base + (value * stride)] ifFalse: [instructions at: i].
		(probe at: i) = expected]
]

{ #category : #generating }
TemplateGeneratorModule >> indexOfOnlyDifferenceBetween: instructions and: others [
	| index |
	index := nil.
	1 to: instructions size do: [:i |
		(instructions at: i) = (others at: i) ifFalse: [
			index notNil ifTrue: [^nil].
			index := i]].
	^index
]

{ #category : #generating }
TemplateGeneratorModule >> header [
	^'"
	Generated by LMR.Nativizer.Assembly.Aarch64.TemplateGenerator, do not edit.
	Each method is the code ARM64CodeGenerator emits for the GenericAssembler
	method of the same name; the rest are inherited from GenericAssembler.
"

Class {
	#name : #ARM64TemplateAssembler,
	#superclass : #GenericAssembler,
	#category : #Aarch64
}
'
]

{ #category : #generating }
TemplateGeneratorModule >> write: selector instructions: instructions on: stream [
	stream
		nextPutAll: '
{ #category : #templates }
ARM64TemplateAssembler >> ';
		nextPutAll: selector;
		nextPutAll: ' [
	codegen'.
	self writeInstructions: instructions on: stream.
	stream nextPutAll: '
]
'
]

{ #category : #generating }
TemplateGeneratorModule >> write: selector ranges: ranges on: stream [
	stream
		nextPutAll: '
{ #category : #templates }
ARM64TemplateAssembler >> ';
		nextPutAll: selector;
		nextPutAll: ' anInteger ['.
	ranges
		do: [:range | self writeRange: range on: stream]
		separatedBy: [stream nextPut: $.].
	stream
		nextPutAll: '.
	^super ';
		nextPutAll: selector;
		nextPutAll: ' anInteger
]
'
]

{ #category : #generating }
TemplateGeneratorModule >> writeRange: range on: stream [
	| instructions low high |
	instructions := (range at: 3) copy.
	instructions at: (range at: 4) put: range.
	low := range at: 1.
	high := range at: 2.
	stream
		nextPutAll: '
	(anInteger between: ';
		print: low;
		nextPutAll: ' and: ';
		print: high;
		nextPutAll: ') ifTrue: [^codegen'.
	self writeInstructions: instructions on: stream.
	stream nextPut: $]
]

{ #category : #generating }
TemplateGeneratorModule >> writeInstructions: instructions on: stream [
	instructions size = 1 ifTrue: [
		stream space.
		^self writeInstruction: instructions first on: stream].
	instructions
		do: [:instruction |
			stream nextPutAll: '
		'.
			self writeInstruction: instruction on: stream]
		separatedBy: [stream nextPut: $;]
]

{ #category : #generating }
TemplateGeneratorModule >> writeInstruction: instruction on: stream [
	| base stride |
	stream nextPutAll: 'emit: '.
	instruction isInteger ifTrue: [^self writeHex: instruction on: stream].
	base := instruction at: 5.
	stride := instruction at: 6.
	self writeHex: base on: stream.
	stream nextPutAll: ' + (anInteger * '; print: stride; nextPut: $)
]

{ #category : #generating }
TemplateGeneratorModule >> writeHex: anInteger on: stream [
	| digits |
	anInteger < 0 ifTrue: [stream nextPut: $-].
	digits := anInteger abs printPaddedWith: $0 to: 8 base: 16.
	stream nextPutAll: '16r'; nextPutAll: digits
]
