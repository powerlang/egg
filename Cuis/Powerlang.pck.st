'From Cuis7.9 [latest update: #8037] on 1 July 2026 at 3:21:12 pm'!
'Description Selected https://github.com/powerlang/egg/module classes transliterated via  Cuis-Smalltalk-Tonel-Browser.'!
!provides: 'Powerlang' 1 14!
!requires: 'BeeCompatibility' 1 65 nil!
!requires: 'ExchangeFormat-Tonel-Lite' 1 73 nil!
SystemOrganization addCategory: #'Powerlang-ModuleSpecReader'!
SystemOrganization addCategory: #'Powerlang-CodeSpecs'!
SystemOrganization addCategory: #'Powerlang-ArgParser'!
SystemOrganization addCategory: #'Powerlang-EPM'!
SystemOrganization addCategory: #'Powerlang-Core-LMR'!
SystemOrganization addCategory: #'Powerlang-Core-SCompiler'!
SystemOrganization addCategory: #'Powerlang-Core-SCompiler-Bindings'!
SystemOrganization addCategory: #'Powerlang-Core-SCompiler-Smalltalk'!
SystemOrganization addCategory: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SystemOrganization addCategory: #'Powerlang-Core-SExpressions'!
SystemOrganization addCategory: #'Powerlang-Kernel'!
SystemOrganization addCategory: #'Powerlang-ModuleImporter'!
SystemOrganization addCategory: #'Powerlang-Compiler.Tests'!
SystemOrganization addCategory: #'Powerlang-Writer'!
SystemOrganization addCategory: #'Powerlang-ImageSegmentBuilder'!
SystemOrganization addCategory: #'Powerlang-Nativization'!
SystemOrganization addCategory: #'Powerlang-Core-Building'!
SystemOrganization addCategory: #'Powerlang-Core-Assembly'!
SystemOrganization addCategory: #'Powerlang-Nativization-Assembly'!
SystemOrganization addCategory: #'Powerlang-Nativization-Tests'!


!classDefinition: #HashTable category: #'Powerlang-Kernel'!
Array variableSubclass: #HashTable
	instanceVariableNames: 'policy'
	classVariableNames: 'NilToken Sizes'
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'HashTable class' category: #'Powerlang-Kernel'!
HashTable class
	instanceVariableNames: 'NilToken Sizes'!

!classDefinition: #InlinedHashTable category: #'Powerlang-Kernel'!
HashTable variableSubclass: #InlinedHashTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'InlinedHashTable class' category: #'Powerlang-Kernel'!
InlinedHashTable class
	instanceVariableNames: ''!

!classDefinition: #OpenHashTable category: #'Powerlang-Kernel'!
HashTable variableSubclass: #OpenHashTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'OpenHashTable class' category: #'Powerlang-Kernel'!
OpenHashTable class
	instanceVariableNames: ''!

!classDefinition: #OrderedHashTable category: #'Powerlang-Kernel'!
OpenHashTable variableSubclass: #OrderedHashTable
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'OrderedHashTable class' category: #'Powerlang-Kernel'!
OrderedHashTable class
	instanceVariableNames: ''!

!classDefinition: #SFFIDescriptor category: #'Powerlang-Core-SCompiler'!
ByteArray variableByteSubclass: #SFFIDescriptor
	instanceVariableNames: ''
	classVariableNames: 'FFICallingConventions FFITypes'
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SFFIDescriptor class' category: #'Powerlang-Core-SCompiler'!
SFFIDescriptor class
	instanceVariableNames: 'FFICallingConventions FFITypes'!

!classDefinition: #LMRArrayedCollection category: #'Powerlang-Kernel'!
ArrayedCollection subclass: #LMRArrayedCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRArrayedCollection class' category: #'Powerlang-Kernel'!
LMRArrayedCollection class
	instanceVariableNames: ''!

!classDefinition: #LMRSymbol category: #'Powerlang-Kernel'!
Symbol variableByteSubclass: #LMRSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRSymbol class' category: #'Powerlang-Kernel'!
LMRSymbol class
	instanceVariableNames: ''!

!classDefinition: #WideSymbol category: #'Powerlang-Kernel'!
Symbol variableByteSubclass: #WideSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'WideSymbol class' category: #'Powerlang-Kernel'!
WideSymbol class
	instanceVariableNames: ''!

!classDefinition: #WideString category: #'Powerlang-Kernel'!
String variableByteSubclass: #WideString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'WideString class' category: #'Powerlang-Kernel'!
WideString class
	instanceVariableNames: ''!

!classDefinition: #CharacterArray category: #'Powerlang-ModuleImporter'!
CharacterSequence subclass: #CharacterArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ModuleImporter'!
!classDefinition: 'CharacterArray class' category: #'Powerlang-ModuleImporter'!
CharacterArray class
	instanceVariableNames: ''!

!classDefinition: #LMRCharacterArray category: #'Powerlang-Kernel'!
CharacterArray subclass: #LMRCharacterArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRCharacterArray class' category: #'Powerlang-Kernel'!
LMRCharacterArray class
	instanceVariableNames: ''!

!classDefinition: #InlinedDictionary category: #'Powerlang-Kernel'!
Dictionary subclass: #InlinedDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'InlinedDictionary class' category: #'Powerlang-Kernel'!
InlinedDictionary class
	instanceVariableNames: ''!

!classDefinition: #Namespace category: #'Powerlang-Kernel'!
Dictionary subclass: #Namespace
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'Namespace class' category: #'Powerlang-Kernel'!
Namespace class
	instanceVariableNames: ''!

!classDefinition: #WeakIdentityDictionary category: #'Powerlang-Kernel'!
Dictionary subclass: #WeakIdentityDictionary
	instanceVariableNames: 'critical'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'WeakIdentityDictionary class' category: #'Powerlang-Kernel'!
WeakIdentityDictionary class
	instanceVariableNames: ''!

!classDefinition: #HashedCollection category: #'Powerlang-Kernel'!
Collection subclass: #HashedCollection
	instanceVariableNames: 'tally table'
	classVariableNames: 'Policies'
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'HashedCollection class' category: #'Powerlang-Kernel'!
HashedCollection class
	instanceVariableNames: 'Policies'!

!classDefinition: #SCompilationError category: #'Powerlang-Core-SCompiler'!
Error subclass: #SCompilationError
	instanceVariableNames: 'compiler resumable retryable stretch'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SCompilationError class' category: #'Powerlang-Core-SCompiler'!
SCompilationError class
	instanceVariableNames: ''!

!classDefinition: #SInvalidPragmaError category: #'Powerlang-Core-SCompiler'!
SCompilationError subclass: #SInvalidPragmaError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SInvalidPragmaError class' category: #'Powerlang-Core-SCompiler'!
SInvalidPragmaError class
	instanceVariableNames: ''!

!classDefinition: #SUndeclaredIdentifierError category: #'Powerlang-Core-SCompiler'!
SCompilationError subclass: #SUndeclaredIdentifierError
	instanceVariableNames: 'identifier assigned'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SUndeclaredIdentifierError class' category: #'Powerlang-Core-SCompiler'!
SUndeclaredIdentifierError class
	instanceVariableNames: ''!

!classDefinition: #StackOverflow category: #'Powerlang-Kernel'!
Error subclass: #StackOverflow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'StackOverflow class' category: #'Powerlang-Kernel'!
StackOverflow class
	instanceVariableNames: ''!

!classDefinition: #LMRFloat category: #'Powerlang-Kernel'!
Float subclass: #LMRFloat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRFloat class' category: #'Powerlang-Kernel'!
LMRFloat class
	instanceVariableNames: ''!

!classDefinition: #ScaledDecimal category: #'Powerlang-Kernel'!
Fraction subclass: #ScaledDecimal
	instanceVariableNames: 'scale'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'ScaledDecimal class' category: #'Powerlang-Kernel'!
ScaledDecimal class
	instanceVariableNames: ''!

!classDefinition: #ArgParser category: #'Powerlang-ArgParser'!
Object subclass: #ArgParser
	instanceVariableNames: 'name description commands globalOptions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ArgParser'!
!classDefinition: 'ArgParser class' category: #'Powerlang-ArgParser'!
ArgParser class
	instanceVariableNames: ''!

!classDefinition: #Command category: #'Powerlang-ArgParser'!
Object subclass: #Command
	instanceVariableNames: 'name description options positionalNames action subcommands'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ArgParser'!
!classDefinition: 'Command class' category: #'Powerlang-ArgParser'!
Command class
	instanceVariableNames: ''!

!classDefinition: #Option category: #'Powerlang-ArgParser'!
Object subclass: #Option
	instanceVariableNames: 'short long description required hasValue defaultValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ArgParser'!
!classDefinition: 'Option class' category: #'Powerlang-ArgParser'!
Option class
	instanceVariableNames: ''!

!classDefinition: #ParseResult category: #'Powerlang-ArgParser'!
Object subclass: #ParseResult
	instanceVariableNames: 'command positionals options'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ArgParser'!
!classDefinition: 'ParseResult class' category: #'Powerlang-ArgParser'!
ParseResult class
	instanceVariableNames: ''!

!classDefinition: #MethodSpec category: #'Powerlang-CodeSpecs'!
Object subclass: #MethodSpec
	instanceVariableNames: 'selector class source category module ast'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-CodeSpecs'!
!classDefinition: 'MethodSpec class' category: #'Powerlang-CodeSpecs'!
MethodSpec class
	instanceVariableNames: ''!

!classDefinition: #ModuleSpec category: #'Powerlang-CodeSpecs'!
Object subclass: #ModuleSpec
	instanceVariableNames: 'name description classes extendedClasses subclassifiedClasses imports dependencies'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-CodeSpecs'!
!classDefinition: 'ModuleSpec class' category: #'Powerlang-CodeSpecs'!
ModuleSpec class
	instanceVariableNames: ''!

!classDefinition: #SpeciesSpec category: #'Powerlang-CodeSpecs'!
Object subclass: #SpeciesSpec
	instanceVariableNames: 'instanceVariables methods module format'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-CodeSpecs'!
!classDefinition: 'SpeciesSpec class' category: #'Powerlang-CodeSpecs'!
SpeciesSpec class
	instanceVariableNames: ''!

!classDefinition: #ClassSpec category: #'Powerlang-CodeSpecs'!
SpeciesSpec subclass: #ClassSpec
	instanceVariableNames: 'name supername classVariables sharedPools metaclass variable pointers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-CodeSpecs'!
!classDefinition: 'ClassSpec class' category: #'Powerlang-CodeSpecs'!
ClassSpec class
	instanceVariableNames: ''!

!classDefinition: #MetaclassSpec category: #'Powerlang-CodeSpecs'!
SpeciesSpec subclass: #MetaclassSpec
	instanceVariableNames: 'class'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-CodeSpecs'!
!classDefinition: 'MetaclassSpec class' category: #'Powerlang-CodeSpecs'!
MetaclassSpec class
	instanceVariableNames: ''!

!classDefinition: #Assembler category: #'Powerlang-Core-Assembly'!
Object subclass: #Assembler
	instanceVariableNames: 'labels literals'
	classVariableNames: 'IndexedLabels'
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!classDefinition: 'Assembler class' category: #'Powerlang-Core-Assembly'!
Assembler class
	instanceVariableNames: 'IndexedLabels'!

!classDefinition: #GenericAssembler category: #'Powerlang-Core-Assembly'!
Assembler subclass: #GenericAssembler
	instanceVariableNames: 'codegen'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!classDefinition: 'GenericAssembler class' category: #'Powerlang-Core-Assembly'!
GenericAssembler class
	instanceVariableNames: ''!

!classDefinition: #CodeGenerator category: #'Powerlang-Core-Assembly'!
Object subclass: #CodeGenerator
	instanceVariableNames: 'abi wordSize memory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!classDefinition: 'CodeGenerator class' category: #'Powerlang-Core-Assembly'!
CodeGenerator class
	instanceVariableNames: ''!

!classDefinition: #RISCCodeGenerator category: #'Powerlang-Core-Assembly'!
CodeGenerator subclass: #RISCCodeGenerator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!classDefinition: 'RISCCodeGenerator class' category: #'Powerlang-Core-Assembly'!
RISCCodeGenerator class
	instanceVariableNames: ''!

!classDefinition: #NativeCodeReference category: #'Powerlang-Core-Assembly'!
Object subclass: #NativeCodeReference
	instanceVariableNames: 'source sourceOffset target absolute'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!classDefinition: 'NativeCodeReference class' category: #'Powerlang-Core-Assembly'!
NativeCodeReference class
	instanceVariableNames: ''!

!classDefinition: #RelocatableBuffer category: #'Powerlang-Core-Assembly'!
Object subclass: #RelocatableBuffer
	instanceVariableNames: 'stream address fixups'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!classDefinition: 'RelocatableBuffer class' category: #'Powerlang-Core-Assembly'!
RelocatableBuffer class
	instanceVariableNames: ''!

!classDefinition: #RelocationFixup category: #'Powerlang-Core-Assembly'!
Object subclass: #RelocationFixup
	instanceVariableNames: 'source target relative size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!classDefinition: 'RelocationFixup class' category: #'Powerlang-Core-Assembly'!
RelocationFixup class
	instanceVariableNames: ''!

!classDefinition: #LookupNativizer category: #'Powerlang-Core-Building'!
Object subclass: #LookupNativizer
	instanceVariableNames: 'nativizer methods'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Building'!
!classDefinition: 'LookupNativizer class' category: #'Powerlang-Core-Building'!
LookupNativizer class
	instanceVariableNames: ''!

!classDefinition: #IdentifierBinder category: #'Powerlang-Core-SCompiler'!
Object subclass: #IdentifierBinder
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'IdentifierBinder class' category: #'Powerlang-Core-SCompiler'!
IdentifierBinder class
	instanceVariableNames: ''!

!classDefinition: #StaticBinder category: #'Powerlang-Core-SCompiler'!
IdentifierBinder subclass: #StaticBinder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'StaticBinder class' category: #'Powerlang-Core-SCompiler'!
StaticBinder class
	instanceVariableNames: ''!

!classDefinition: #LocalEnvironment category: #'Powerlang-Core-SCompiler'!
Object subclass: #LocalEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ClosureElementTypes'
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'LocalEnvironment class' category: #'Powerlang-Core-SCompiler'!
LocalEnvironment class
	instanceVariableNames: ''!

!classDefinition: #ArrayEnvironment category: #'Powerlang-Core-SCompiler'!
LocalEnvironment subclass: #ArrayEnvironment
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'ArrayEnvironment class' category: #'Powerlang-Core-SCompiler'!
ArrayEnvironment class
	instanceVariableNames: ''!

!classDefinition: #StackEnvironment category: #'Powerlang-Core-SCompiler'!
LocalEnvironment subclass: #StackEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'StackEnvironment class' category: #'Powerlang-Core-SCompiler'!
StackEnvironment class
	instanceVariableNames: ''!

!classDefinition: #ArgumentEnvironment category: #'Powerlang-Core-SCompiler'!
StackEnvironment subclass: #ArgumentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'ArgumentEnvironment class' category: #'Powerlang-Core-SCompiler'!
ArgumentEnvironment class
	instanceVariableNames: ''!

!classDefinition: #InlinedArgEnvironment category: #'Powerlang-Core-SCompiler'!
StackEnvironment subclass: #InlinedArgEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'InlinedArgEnvironment class' category: #'Powerlang-Core-SCompiler'!
InlinedArgEnvironment class
	instanceVariableNames: ''!

!classDefinition: #MessageInliner category: #'Powerlang-Core-SCompiler'!
Object subclass: #MessageInliner
	instanceVariableNames: 'message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'MessageInliner class' category: #'Powerlang-Core-SCompiler'!
MessageInliner class
	instanceVariableNames: ''!

!classDefinition: #SCompilationResult category: #'Powerlang-Core-SCompiler'!
Object subclass: #SCompilationResult
	instanceVariableNames: 'compiler error ast method'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SCompilationResult class' category: #'Powerlang-Core-SCompiler'!
SCompilationResult class
	instanceVariableNames: ''!

!classDefinition: #SCompiler category: #'Powerlang-Core-SCompiler'!
Object subclass: #SCompiler
	instanceVariableNames: 'errorHandler result class'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SCompiler class' category: #'Powerlang-Core-SCompiler'!
SCompiler class
	instanceVariableNames: ''!

!classDefinition: #SParseTreeVisitor category: #'Powerlang-Core-SCompiler'!
Object subclass: #SParseTreeVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SParseTreeVisitor class' category: #'Powerlang-Core-SCompiler'!
SParseTreeVisitor class
	instanceVariableNames: ''!

!classDefinition: #SSemanticVisitor category: #'Powerlang-Core-SCompiler'!
SParseTreeVisitor subclass: #SSemanticVisitor
	instanceVariableNames: 'inliner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'SSemanticVisitor class' category: #'Powerlang-Core-SCompiler'!
SSemanticVisitor class
	instanceVariableNames: ''!

!classDefinition: #TreecodeEncoder category: #'Powerlang-Core-SExpressions'!
SParseTreeVisitor subclass: #TreecodeEncoder
	instanceVariableNames: 'method stream script'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'TreecodeEncoder class' category: #'Powerlang-Core-SExpressions'!
TreecodeEncoder class
	instanceVariableNames: ''!

!classDefinition: #ScriptScope category: #'Powerlang-Core-SCompiler'!
Object subclass: #ScriptScope
	instanceVariableNames: 'script arguments temporaries stackSize envSize captureSelf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'ScriptScope class' category: #'Powerlang-Core-SCompiler'!
ScriptScope class
	instanceVariableNames: ''!

!classDefinition: #BlockScope category: #'Powerlang-Core-SCompiler'!
ScriptScope subclass: #BlockScope
	instanceVariableNames: 'environments captured'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'BlockScope class' category: #'Powerlang-Core-SCompiler'!
BlockScope class
	instanceVariableNames: ''!

!classDefinition: #MethodScope category: #'Powerlang-Core-SCompiler'!
ScriptScope subclass: #MethodScope
	instanceVariableNames: 'pseudo'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!classDefinition: 'MethodScope class' category: #'Powerlang-Core-SCompiler'!
MethodScope class
	instanceVariableNames: ''!

!classDefinition: #Binding category: #'Powerlang-Core-SCompiler-Bindings'!
Object subclass: #Binding
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'Binding class' category: #'Powerlang-Core-SCompiler-Bindings'!
Binding class
	instanceVariableNames: ''!

!classDefinition: #DynamicBinding category: #'Powerlang-Core-SCompiler-Bindings'!
Binding subclass: #DynamicBinding
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'DynamicBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
DynamicBinding class
	instanceVariableNames: 'Default'!

!classDefinition: #NestedDynamicBinding category: #'Powerlang-Core-SCompiler-Bindings'!
DynamicBinding subclass: #NestedDynamicBinding
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'NestedDynamicBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
NestedDynamicBinding class
	instanceVariableNames: ''!

!classDefinition: #LiteralBinding category: #'Powerlang-Core-SCompiler-Bindings'!
Binding subclass: #LiteralBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'LiteralBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
LiteralBinding class
	instanceVariableNames: ''!

!classDefinition: #FalseBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LiteralBinding subclass: #FalseBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'FalseBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
FalseBinding class
	instanceVariableNames: ''!

!classDefinition: #NilBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LiteralBinding subclass: #NilBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'NilBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
NilBinding class
	instanceVariableNames: ''!

!classDefinition: #TrueBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LiteralBinding subclass: #TrueBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'TrueBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
TrueBinding class
	instanceVariableNames: ''!

!classDefinition: #LocalBinding category: #'Powerlang-Core-SCompiler-Bindings'!
Binding subclass: #LocalBinding
	instanceVariableNames: 'index environment declaration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'LocalBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
LocalBinding class
	instanceVariableNames: ''!

!classDefinition: #ArgumentBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LocalBinding subclass: #ArgumentBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'ArgumentBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
ArgumentBinding class
	instanceVariableNames: ''!

!classDefinition: #TemporaryBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LocalBinding subclass: #TemporaryBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'TemporaryBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
TemporaryBinding class
	instanceVariableNames: ''!

!classDefinition: #SelfBinding category: #'Powerlang-Core-SCompiler-Bindings'!
Binding subclass: #SelfBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'SelfBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
SelfBinding class
	instanceVariableNames: ''!

!classDefinition: #SuperBinding category: #'Powerlang-Core-SCompiler-Bindings'!
SelfBinding subclass: #SuperBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!classDefinition: 'SuperBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
SuperBinding class
	instanceVariableNames: ''!

!classDefinition: #SSmalltalkCompiler category: #'Powerlang-Core-SCompiler-Smalltalk'!
Object subclass: #SSmalltalkCompiler
	instanceVariableNames: 'frontend source ast result headless blocks leaf activeScript'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk'!
!classDefinition: 'SSmalltalkCompiler class' category: #'Powerlang-Core-SCompiler-Smalltalk'!
SSmalltalkCompiler class
	instanceVariableNames: ''!

!classDefinition: #SSmalltalkParser category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
Object subclass: #SSmalltalkParser
	instanceVariableNames: 'compiler scanner token next'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SSmalltalkParser class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSmalltalkParser class
	instanceVariableNames: ''!

!classDefinition: #SSmalltalkScanner category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
Object subclass: #SSmalltalkScanner
	instanceVariableNames: 'compiler stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SSmalltalkScanner class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSmalltalkScanner class
	instanceVariableNames: ''!

!classDefinition: #SToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
Object subclass: #SToken
	instanceVariableNames: 'compiler stretch comments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken class
	instanceVariableNames: ''!

!classDefinition: #SEndToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SEndToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SEndToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SEndToken class
	instanceVariableNames: ''!

!classDefinition: #SParseNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SParseNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SParseNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode class
	instanceVariableNames: ''!

!classDefinition: #SAssignmentNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SAssignmentNode
	instanceVariableNames: 'assignees expression operators'
	classVariableNames: 'Token'
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SAssignmentNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SAssignmentNode class
	instanceVariableNames: 'Token'!

!classDefinition: #SBraceNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SBraceNode
	instanceVariableNames: 'elements message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SBraceNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SBraceNode class
	instanceVariableNames: ''!

!classDefinition: #SCascadeNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SCascadeNode
	instanceVariableNames: 'receiver messages optimized'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SCascadeNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SCascadeNode class
	instanceVariableNames: ''!

!classDefinition: #SCommentNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SCommentNode
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SCommentNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SCommentNode class
	instanceVariableNames: ''!

!classDefinition: #SIdentifierNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SIdentifierNode
	instanceVariableNames: 'name binding'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SIdentifierNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SIdentifierNode class
	instanceVariableNames: ''!

!classDefinition: #SLiteralNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SLiteralNode
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SLiteralNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SLiteralNode class
	instanceVariableNames: ''!

!classDefinition: #SNumberNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SLiteralNode subclass: #SNumberNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SNumberNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SNumberNode class
	instanceVariableNames: ''!

!classDefinition: #SMessageNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SMessageNode
	instanceVariableNames: 'selector receiver arguments inlined'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SMessageNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SMessageNode class
	instanceVariableNames: ''!

!classDefinition: #SCascadeMessageNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SMessageNode subclass: #SCascadeMessageNode
	instanceVariableNames: 'cascade'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SCascadeMessageNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SCascadeMessageNode class
	instanceVariableNames: ''!

!classDefinition: #SReturnNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SReturnNode
	instanceVariableNames: 'expression return'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SReturnNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SReturnNode class
	instanceVariableNames: ''!

!classDefinition: #SScriptNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SScriptNode
	instanceVariableNames: 'statements arguments temporaries children scope'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SScriptNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SScriptNode class
	instanceVariableNames: ''!

!classDefinition: #SBlockNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SScriptNode subclass: #SBlockNode
	instanceVariableNames: 'inlined index parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SBlockNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SBlockNode class
	instanceVariableNames: ''!

!classDefinition: #SMethodNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SScriptNode subclass: #SMethodNode
	instanceVariableNames: 'selector pragma'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SMethodNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SMethodNode class
	instanceVariableNames: ''!

!classDefinition: #SSelectorNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SSelectorNode
	instanceVariableNames: 'symbol keywords'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SSelectorNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSelectorNode class
	instanceVariableNames: ''!

!classDefinition: #SPragmaNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SPragmaNode
	instanceVariableNames: 'type name info'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SPragmaNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SPragmaNode class
	instanceVariableNames: ''!

!classDefinition: #SSymbolicToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SSymbolicToken
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SSymbolicToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSymbolicToken class
	instanceVariableNames: ''!

!classDefinition: #SDelimiterToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSymbolicToken subclass: #SDelimiterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SDelimiterToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SDelimiterToken class
	instanceVariableNames: ''!

!classDefinition: #SStringToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSymbolicToken subclass: #SStringToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!classDefinition: 'SStringToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SStringToken class
	instanceVariableNames: ''!

!classDefinition: #SBinding category: #'Powerlang-Core-SExpressions'!
Object subclass: #SBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SBinding class' category: #'Powerlang-Core-SExpressions'!
SBinding class
	instanceVariableNames: ''!

!classDefinition: #SAssociationBinding category: #'Powerlang-Core-SExpressions'!
SBinding subclass: #SAssociationBinding
	instanceVariableNames: 'index association'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SAssociationBinding class' category: #'Powerlang-Core-SExpressions'!
SAssociationBinding class
	instanceVariableNames: ''!

!classDefinition: #SDynamicBinding category: #'Powerlang-Core-SExpressions'!
SBinding subclass: #SDynamicBinding
	instanceVariableNames: 'name cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SDynamicBinding class' category: #'Powerlang-Core-SExpressions'!
SDynamicBinding class
	instanceVariableNames: ''!

!classDefinition: #SNestedDynamicBinding category: #'Powerlang-Core-SExpressions'!
SDynamicBinding subclass: #SNestedDynamicBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SNestedDynamicBinding class' category: #'Powerlang-Core-SExpressions'!
SNestedDynamicBinding class
	instanceVariableNames: ''!

!classDefinition: #SInstVarBinding category: #'Powerlang-Core-SExpressions'!
SBinding subclass: #SInstVarBinding
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SInstVarBinding class' category: #'Powerlang-Core-SExpressions'!
SInstVarBinding class
	instanceVariableNames: ''!

!classDefinition: #SLiteralBinding category: #'Powerlang-Core-SExpressions'!
SBinding subclass: #SLiteralBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SLiteralBinding class' category: #'Powerlang-Core-SExpressions'!
SLiteralBinding class
	instanceVariableNames: ''!

!classDefinition: #SFalseBinding category: #'Powerlang-Core-SExpressions'!
SLiteralBinding subclass: #SFalseBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SFalseBinding class' category: #'Powerlang-Core-SExpressions'!
SFalseBinding class
	instanceVariableNames: ''!

!classDefinition: #SNilBinding category: #'Powerlang-Core-SExpressions'!
SLiteralBinding subclass: #SNilBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SNilBinding class' category: #'Powerlang-Core-SExpressions'!
SNilBinding class
	instanceVariableNames: ''!

!classDefinition: #SLocalBinding category: #'Powerlang-Core-SExpressions'!
SBinding subclass: #SLocalBinding
	instanceVariableNames: 'position environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SLocalBinding class' category: #'Powerlang-Core-SExpressions'!
SLocalBinding class
	instanceVariableNames: ''!

!classDefinition: #SArgumentBinding category: #'Powerlang-Core-SExpressions'!
SLocalBinding subclass: #SArgumentBinding
	instanceVariableNames: 'inlined'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SArgumentBinding class' category: #'Powerlang-Core-SExpressions'!
SArgumentBinding class
	instanceVariableNames: ''!

!classDefinition: #STemporaryBinding category: #'Powerlang-Core-SExpressions'!
SLocalBinding subclass: #STemporaryBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'STemporaryBinding class' category: #'Powerlang-Core-SExpressions'!
STemporaryBinding class
	instanceVariableNames: ''!

!classDefinition: #SSelfBinding category: #'Powerlang-Core-SExpressions'!
SBinding subclass: #SSelfBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SSelfBinding class' category: #'Powerlang-Core-SExpressions'!
SSelfBinding class
	instanceVariableNames: ''!

!classDefinition: #SSuperBinding category: #'Powerlang-Core-SExpressions'!
SSelfBinding subclass: #SSuperBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SSuperBinding class' category: #'Powerlang-Core-SExpressions'!
SSuperBinding class
	instanceVariableNames: ''!

!classDefinition: #SExpression category: #'Powerlang-Core-SExpressions'!
Object subclass: #SExpression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SExpression class' category: #'Powerlang-Core-SExpressions'!
SExpression class
	instanceVariableNames: ''!

!classDefinition: #SAssignment category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SAssignment
	instanceVariableNames: 'assignees expression'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SAssignment class' category: #'Powerlang-Core-SExpressions'!
SAssignment class
	instanceVariableNames: ''!

!classDefinition: #SCascade category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SCascade
	instanceVariableNames: 'receiver messages'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SCascade class' category: #'Powerlang-Core-SExpressions'!
SCascade class
	instanceVariableNames: ''!

!classDefinition: #SCascadeMessage category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SCascadeMessage
	instanceVariableNames: 'selector arguments cascade cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SCascadeMessage class' category: #'Powerlang-Core-SExpressions'!
SCascadeMessage class
	instanceVariableNames: ''!

!classDefinition: #SIdentifier category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SIdentifier
	instanceVariableNames: 'binding'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SIdentifier class' category: #'Powerlang-Core-SExpressions'!
SIdentifier class
	instanceVariableNames: ''!

!classDefinition: #SLiteralVar category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SLiteralVar
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SLiteralVar class' category: #'Powerlang-Core-SExpressions'!
SLiteralVar class
	instanceVariableNames: ''!

!classDefinition: #SLiteral category: #'Powerlang-Core-SExpressions'!
SLiteralVar subclass: #SLiteral
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SLiteral class' category: #'Powerlang-Core-SExpressions'!
SLiteral class
	instanceVariableNames: ''!

!classDefinition: #SMessage category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SMessage
	instanceVariableNames: 'selector receiver arguments cache inlined'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SMessage class' category: #'Powerlang-Core-SExpressions'!
SMessage class
	instanceVariableNames: ''!

!classDefinition: #SOperation category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SOperation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOperation class' category: #'Powerlang-Core-SExpressions'!
SOperation class
	instanceVariableNames: ''!

!classDefinition: #SInlinerOperation category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SInlinerOperation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SInlinerOperation class' category: #'Powerlang-Core-SExpressions'!
SInlinerOperation class
	instanceVariableNames: ''!

!classDefinition: #SOpJump category: #'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpJump
	instanceVariableNames: 'target'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpJump class' category: #'Powerlang-Core-SExpressions'!
SOpJump class
	instanceVariableNames: ''!

!classDefinition: #SOpJumpFalse category: #'Powerlang-Core-SExpressions'!
SOpJump subclass: #SOpJumpFalse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpJumpFalse class' category: #'Powerlang-Core-SExpressions'!
SOpJumpFalse class
	instanceVariableNames: ''!

!classDefinition: #SOpJumpTrue category: #'Powerlang-Core-SExpressions'!
SOpJump subclass: #SOpJumpTrue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpJumpTrue class' category: #'Powerlang-Core-SExpressions'!
SOpJumpTrue class
	instanceVariableNames: ''!

!classDefinition: #SOpLoadRfromFrame category: #'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpLoadRfromFrame
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpLoadRfromFrame class' category: #'Powerlang-Core-SExpressions'!
SOpLoadRfromFrame class
	instanceVariableNames: ''!

!classDefinition: #SOpPopR category: #'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpPopR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpPopR class' category: #'Powerlang-Core-SExpressions'!
SOpPopR class
	instanceVariableNames: ''!

!classDefinition: #SOpStoreRintoFrame category: #'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpStoreRintoFrame
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpStoreRintoFrame class' category: #'Powerlang-Core-SExpressions'!
SOpStoreRintoFrame class
	instanceVariableNames: ''!

!classDefinition: #SOpAssign category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpAssign
	instanceVariableNames: 'assignees'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpAssign class' category: #'Powerlang-Core-SExpressions'!
SOpAssign class
	instanceVariableNames: ''!

!classDefinition: #SOpDispatchMessage category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpDispatchMessage
	instanceVariableNames: 'message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpDispatchMessage class' category: #'Powerlang-Core-SExpressions'!
SOpDispatchMessage class
	instanceVariableNames: ''!

!classDefinition: #SOpDropToS category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpDropToS
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpDropToS class' category: #'Powerlang-Core-SExpressions'!
SOpDropToS class
	instanceVariableNames: ''!

!classDefinition: #SOpLoadRfromStack category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpLoadRfromStack
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpLoadRfromStack class' category: #'Powerlang-Core-SExpressions'!
SOpLoadRfromStack class
	instanceVariableNames: ''!

!classDefinition: #SOpLoadRwithNil category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpLoadRwithNil
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpLoadRwithNil class' category: #'Powerlang-Core-SExpressions'!
SOpLoadRwithNil class
	instanceVariableNames: ''!

!classDefinition: #SOpLoadRwithSelf category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpLoadRwithSelf
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpLoadRwithSelf class' category: #'Powerlang-Core-SExpressions'!
SOpLoadRwithSelf class
	instanceVariableNames: ''!

!classDefinition: #SOpPrimitive category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpPrimitive
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpPrimitive class' category: #'Powerlang-Core-SExpressions'!
SOpPrimitive class
	instanceVariableNames: ''!

!classDefinition: #SOpPushR category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpPushR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpPushR class' category: #'Powerlang-Core-SExpressions'!
SOpPushR class
	instanceVariableNames: ''!

!classDefinition: #SOpRestart category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpRestart
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpRestart class' category: #'Powerlang-Core-SExpressions'!
SOpRestart class
	instanceVariableNames: ''!

!classDefinition: #SOpReturn category: #'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpReturn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpReturn class' category: #'Powerlang-Core-SExpressions'!
SOpReturn class
	instanceVariableNames: ''!

!classDefinition: #SPragma category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SPragma
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SPragma class' category: #'Powerlang-Core-SExpressions'!
SPragma class
	instanceVariableNames: ''!

!classDefinition: #SReturn category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SReturn
	instanceVariableNames: 'local expression'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SReturn class' category: #'Powerlang-Core-SExpressions'!
SReturn class
	instanceVariableNames: ''!

!classDefinition: #SScript category: #'Powerlang-Core-SExpressions'!
SExpression subclass: #SScript
	instanceVariableNames: 'statements compiledCode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SScript class' category: #'Powerlang-Core-SExpressions'!
SScript class
	instanceVariableNames: ''!

!classDefinition: #SBlock category: #'Powerlang-Core-SExpressions'!
SScript subclass: #SBlock
	instanceVariableNames: 'index capturedVariables inlinedArgs'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SBlock class' category: #'Powerlang-Core-SExpressions'!
SBlock class
	instanceVariableNames: ''!

!classDefinition: #SMethod category: #'Powerlang-Core-SExpressions'!
SScript subclass: #SMethod
	instanceVariableNames: 'pragma'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SMethod class' category: #'Powerlang-Core-SExpressions'!
SMethod class
	instanceVariableNames: ''!

!classDefinition: #TreecodeDecoder category: #'Powerlang-Core-SExpressions'!
Object subclass: #TreecodeDecoder
	instanceVariableNames: 'method stream builder'
	classVariableNames: 'BindingTypes NodeTypes'
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'TreecodeDecoder class' category: #'Powerlang-Core-SExpressions'!
TreecodeDecoder class
	instanceVariableNames: 'BindingTypes NodeTypes'!

!classDefinition: #Config category: #'Powerlang-EPM'!
Object subclass: #Config
	instanceVariableNames: 'project user merged'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-EPM'!
!classDefinition: 'Config class' category: #'Powerlang-EPM'!
Config class
	instanceVariableNames: ''!

!classDefinition: #ProjectGenerator category: #'Powerlang-EPM'!
Object subclass: #ProjectGenerator
	instanceVariableNames: 'name dir'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-EPM'!
!classDefinition: 'ProjectGenerator class' category: #'Powerlang-EPM'!
ProjectGenerator class
	instanceVariableNames: ''!

!classDefinition: #Builder category: #'Powerlang-ImageSegmentBuilder'!
Object subclass: #Builder
	instanceVariableNames: 'module closure classes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ImageSegmentBuilder'!
!classDefinition: 'Builder class' category: #'Powerlang-ImageSegmentBuilder'!
Builder class
	instanceVariableNames: ''!

!classDefinition: #ObjectClosure category: #'Powerlang-ImageSegmentBuilder'!
Object subclass: #ObjectClosure
	instanceVariableNames: 'queue added objects mapping boundary scope builder nilToken reversePaths debug'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ImageSegmentBuilder'!
!classDefinition: 'ObjectClosure class' category: #'Powerlang-ImageSegmentBuilder'!
ObjectClosure class
	instanceVariableNames: ''!

!classDefinition: #HashTablePolicy category: #'Powerlang-Kernel'!
Object subclass: #HashTablePolicy
	instanceVariableNames: 'associationClass bucketClass maxSlots weak hasher comparison storesAssociations'
	classVariableNames: 'EmptySlot'
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'HashTablePolicy class' category: #'Powerlang-Kernel'!
HashTablePolicy class
	instanceVariableNames: 'EmptySlot'!

!classDefinition: #ImageSegment category: #'Powerlang-Kernel'!
Object subclass: #ImageSegment
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'ImageSegment class' category: #'Powerlang-Kernel'!
ImageSegment class
	instanceVariableNames: ''!

!classDefinition: #LMRObject category: #'Powerlang-Kernel'!
Object subclass: #LMRObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRObject class' category: #'Powerlang-Kernel'!
LMRObject class
	instanceVariableNames: ''!

!classDefinition: #MatchAlgorithm category: #'Powerlang-Kernel'!
Object subclass: #MatchAlgorithm
	instanceVariableNames: 'string pattern start stop tokens failure ranges'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'MatchAlgorithm class' category: #'Powerlang-Kernel'!
MatchAlgorithm class
	instanceVariableNames: ''!

!classDefinition: #MatchToken category: #'Powerlang-Kernel'!
Object subclass: #MatchToken
	instanceVariableNames: 'string start stop'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'MatchToken class' category: #'Powerlang-Kernel'!
MatchToken class
	instanceVariableNames: ''!

!classDefinition: #Module category: #'Powerlang-Kernel'!
Object subclass: #Module
	instanceVariableNames: 'name version exports namespace hash cachedLookups classes extensions overriden requires'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'Module class' category: #'Powerlang-Kernel'!
Module class
	instanceVariableNames: ''!

!classDefinition: #ArgParserModule category: #'Powerlang-ArgParser'!
Module subclass: #ArgParserModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ArgParser'!
!classDefinition: 'ArgParserModule class' category: #'Powerlang-ArgParser'!
ArgParserModule class
	instanceVariableNames: ''!

!classDefinition: #CodeSpecsModule category: #'Powerlang-CodeSpecs'!
Module subclass: #CodeSpecsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-CodeSpecs'!
!classDefinition: 'CodeSpecsModule class' category: #'Powerlang-CodeSpecs'!
CodeSpecsModule class
	instanceVariableNames: ''!

!classDefinition: #TestsModule category: #'Powerlang-Compiler.Tests'!
Module subclass: #TestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Compiler.Tests'!
!classDefinition: 'TestsModule class' category: #'Powerlang-Compiler.Tests'!
TestsModule class
	instanceVariableNames: ''!

!classDefinition: #CompilerModule category: #'Powerlang-Core-LMR'!
Module subclass: #CompilerModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-LMR'!
!classDefinition: 'CompilerModule class' category: #'Powerlang-Core-LMR'!
CompilerModule class
	instanceVariableNames: ''!

!classDefinition: #LMRModule category: #'Powerlang-Core-LMR'!
Module subclass: #LMRModule
	instanceVariableNames: 'globals memory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-LMR'!
!classDefinition: 'LMRModule class' category: #'Powerlang-Core-LMR'!
LMRModule class
	instanceVariableNames: ''!

!classDefinition: #SExpressionsModule category: #'Powerlang-Core-LMR'!
Module subclass: #SExpressionsModule
	instanceVariableNames: 'globals memory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-LMR'!
!classDefinition: 'SExpressionsModule class' category: #'Powerlang-Core-LMR'!
SExpressionsModule class
	instanceVariableNames: ''!

!classDefinition: #EPMModule category: #'Powerlang-EPM'!
Module subclass: #EPMModule
	instanceVariableNames: 'args parser config'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-EPM'!
!classDefinition: 'EPMModule class' category: #'Powerlang-EPM'!
EPMModule class
	instanceVariableNames: ''!

!classDefinition: #ImageSegmentBuilderModule category: #'Powerlang-ImageSegmentBuilder'!
Module subclass: #ImageSegmentBuilderModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ImageSegmentBuilder'!
!classDefinition: 'ImageSegmentBuilderModule class' category: #'Powerlang-ImageSegmentBuilder'!
ImageSegmentBuilderModule class
	instanceVariableNames: ''!

!classDefinition: #KernelModule category: #'Powerlang-Kernel'!
Module subclass: #KernelModule
	instanceVariableNames: 'memory entrypoint loadedModules moduleLoaders host CRITICAL unhandledErrorHandler session properties utf8 utf16 utf32'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'KernelModule class' category: #'Powerlang-Kernel'!
KernelModule class
	instanceVariableNames: ''!

!classDefinition: #ModuleImporterModule category: #'Powerlang-ModuleImporter'!
Module subclass: #ModuleImporterModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ModuleImporter'!
!classDefinition: 'ModuleImporterModule class' category: #'Powerlang-ModuleImporter'!
ModuleImporterModule class
	instanceVariableNames: ''!

!classDefinition: #NativizerModule category: #'Powerlang-Nativization'!
Module subclass: #NativizerModule
	instanceVariableNames: 'environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'NativizerModule class' category: #'Powerlang-Nativization'!
NativizerModule class
	instanceVariableNames: ''!

!classDefinition: #NumberParser category: #'Powerlang-Kernel'!
Object subclass: #NumberParser
	instanceVariableNames: 'stream error return'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'NumberParser class' category: #'Powerlang-Kernel'!
NumberParser class
	instanceVariableNames: ''!

!classDefinition: #ObjectReference category: #'Powerlang-Kernel'!
Object subclass: #ObjectReference
	instanceVariableNames: 'source sourceOffset target absolute'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'ObjectReference class' category: #'Powerlang-Kernel'!
ObjectReference class
	instanceVariableNames: ''!

!classDefinition: #SmalltalkSession category: #'Powerlang-Kernel'!
Object subclass: #SmalltalkSession
	instanceVariableNames: 'name username args resources finalizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'SmalltalkSession class' category: #'Powerlang-Kernel'!
SmalltalkSession class
	instanceVariableNames: ''!

!classDefinition: #SmalltalkSystem category: #'Powerlang-Kernel'!
Object subclass: #SmalltalkSystem
	instanceVariableNames: 'globals eventHandlers registeredEvents eventDispatcher'
	classVariableNames: 'Implementors Senders'
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'SmalltalkSystem class' category: #'Powerlang-Kernel'!
SmalltalkSystem class
	instanceVariableNames: 'Implementors Senders'!

!classDefinition: #Species category: #'Powerlang-Kernel'!
Object subclass: #Species
	instanceVariableNames: 'superclass instanceBehavior format organization instanceVariables'
	classVariableNames: 'Flags'
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'Species class' category: #'Powerlang-Kernel'!
Species class
	instanceVariableNames: 'Flags'!

!classDefinition: #StarToken category: #'Powerlang-Kernel'!
Object subclass: #StarToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'StarToken class' category: #'Powerlang-Kernel'!
StarToken class
	instanceVariableNames: ''!

!classDefinition: #StringPattern category: #'Powerlang-Kernel'!
Object subclass: #StringPattern
	instanceVariableNames: 'stream tokens'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'StringPattern class' category: #'Powerlang-Kernel'!
StringPattern class
	instanceVariableNames: ''!

!classDefinition: #Unicode category: #'Powerlang-Kernel'!
Object subclass: #Unicode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'Unicode class' category: #'Powerlang-Kernel'!
Unicode class
	instanceVariableNames: ''!

!classDefinition: #UTF16 category: #'Powerlang-Kernel'!
Unicode subclass: #UTF16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'UTF16 class' category: #'Powerlang-Kernel'!
UTF16 class
	instanceVariableNames: ''!

!classDefinition: #UTF32 category: #'Powerlang-Kernel'!
Unicode subclass: #UTF32
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'UTF32 class' category: #'Powerlang-Kernel'!
UTF32 class
	instanceVariableNames: ''!

!classDefinition: #UTF8 category: #'Powerlang-Kernel'!
Unicode subclass: #UTF8
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'UTF8 class' category: #'Powerlang-Kernel'!
UTF8 class
	instanceVariableNames: ''!

!classDefinition: #ModuleLoader category: #'Powerlang-ModuleImporter'!
Object subclass: #ModuleLoader
	instanceVariableNames: 'module spec'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ModuleImporter'!
!classDefinition: 'ModuleLoader class' category: #'Powerlang-ModuleImporter'!
ModuleLoader class
	instanceVariableNames: ''!

!classDefinition: #NameOfSubclass category: #'Powerlang-ModuleImporter'!
Object subclass: #NameOfSubclass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ModuleImporter'!
!classDefinition: 'NameOfSubclass class' category: #'Powerlang-ModuleImporter'!
NameOfSubclass class
	instanceVariableNames: ''!

!classDefinition: #ModuleSpecReader category: #'Powerlang-ModuleSpecReader'!
Object subclass: #ModuleSpecReader
	instanceVariableNames: 'module path metadata'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-ModuleSpecReader'!
!classDefinition: 'ModuleSpecReader class' category: #'Powerlang-ModuleSpecReader'!
ModuleSpecReader class
	instanceVariableNames: ''!

!classDefinition: #InlinedMessageNativizer category: #'Powerlang-Nativization'!
Object subclass: #InlinedMessageNativizer
	instanceVariableNames: 'message assembler nativizer start end'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'InlinedMessageNativizer class' category: #'Powerlang-Nativization'!
InlinedMessageNativizer class
	instanceVariableNames: ''!

!classDefinition: #MessageLinker category: #'Powerlang-Nativization'!
Object subclass: #MessageLinker
	instanceVariableNames: 'filter'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'MessageLinker class' category: #'Powerlang-Nativization'!
MessageLinker class
	instanceVariableNames: ''!

!classDefinition: #InlineMessageLinker category: #'Powerlang-Nativization'!
MessageLinker subclass: #InlineMessageLinker
	instanceVariableNames: 'assembler map'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'InlineMessageLinker class' category: #'Powerlang-Nativization'!
InlineMessageLinker class
	instanceVariableNames: ''!

!classDefinition: #InvokeLinker category: #'Powerlang-Nativization'!
MessageLinker subclass: #InvokeLinker
	instanceVariableNames: 'invoker sends'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'InvokeLinker class' category: #'Powerlang-Nativization'!
InvokeLinker class
	instanceVariableNames: ''!

!classDefinition: #LookupLinker category: #'Powerlang-Nativization'!
MessageLinker subclass: #LookupLinker
	instanceVariableNames: 'lookup lookupSuper'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'LookupLinker class' category: #'Powerlang-Nativization'!
LookupLinker class
	instanceVariableNames: ''!

!classDefinition: #LazyLinker category: #'Powerlang-Nativization'!
LookupLinker subclass: #LazyLinker
	instanceVariableNames: 'sends'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'LazyLinker class' category: #'Powerlang-Nativization'!
LazyLinker class
	instanceVariableNames: ''!

!classDefinition: #NativizationEnvironment category: #'Powerlang-Nativization'!
Object subclass: #NativizationEnvironment
	instanceVariableNames: 'platform optimizedMethods invokedMethods inlinedMethods messageLinker writeBarrier safepointCheck cachedNativizer busy'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'NativizationEnvironment class' category: #'Powerlang-Nativization'!
NativizationEnvironment class
	instanceVariableNames: ''!

!classDefinition: #NativizationPlatform category: #'Powerlang-Nativization'!
Object subclass: #NativizationPlatform
	instanceVariableNames: 'name wordSize abi codeGeneratorClass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization'!
!classDefinition: 'NativizationPlatform class' category: #'Powerlang-Nativization'!
NativizationPlatform class
	instanceVariableNames: ''!

!classDefinition: #ABI category: #'Powerlang-Nativization-Assembly'!
Object subclass: #ABI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization-Assembly'!
!classDefinition: 'ABI class' category: #'Powerlang-Nativization-Assembly'!
ABI class
	instanceVariableNames: ''!

!classDefinition: #Writer category: #'Powerlang-Writer'!
Object subclass: #Writer
	instanceVariableNames: 'stream objects mapping imports exports closure'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Writer'!
!classDefinition: 'Writer class' category: #'Powerlang-Writer'!
Writer class
	instanceVariableNames: ''!

!classDefinition: #MessageInlinerTest category: #'Powerlang-Compiler.Tests'!
TestCase subclass: #MessageInlinerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Compiler.Tests'!
!classDefinition: 'MessageInlinerTest class' category: #'Powerlang-Compiler.Tests'!
MessageInlinerTest class
	instanceVariableNames: ''!

!classDefinition: #SmalltalkScannerTest category: #'Powerlang-Compiler.Tests'!
TestCase subclass: #SmalltalkScannerTest
	instanceVariableNames: 'scanner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Compiler.Tests'!
!classDefinition: 'SmalltalkScannerTest class' category: #'Powerlang-Compiler.Tests'!
SmalltalkScannerTest class
	instanceVariableNames: ''!

!classDefinition: #TemplateJITTest category: #'Powerlang-Nativization-Tests'!
TestCase subclass: #TemplateJITTest
	instanceVariableNames: 'environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Nativization-Tests'!
!classDefinition: 'TemplateJITTest class' category: #'Powerlang-Nativization-Tests'!
TemplateJITTest class
	instanceVariableNames: ''!

!classDefinition: #SOpNonLocalReturn category: #'Powerlang-Core-SExpressions'!
ProtoObject subclass: #SOpNonLocalReturn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!classDefinition: 'SOpNonLocalReturn class' category: #'Powerlang-Core-SExpressions'!
SOpNonLocalReturn class
	instanceVariableNames: ''!

!classDefinition: #LMRClosure category: #'Powerlang-Kernel'!
ProtoObject subclass: #LMRClosure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRClosure class' category: #'Powerlang-Kernel'!
LMRClosure class
	instanceVariableNames: ''!

!classDefinition: #LMRProtoObject category: #'Powerlang-Kernel'!
ProtoObject subclass: #LMRProtoObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRProtoObject class' category: #'Powerlang-Kernel'!
LMRProtoObject class
	instanceVariableNames: ''!

!classDefinition: #LMRSpecies category: #'Powerlang-Kernel'!
ProtoObject subclass: #LMRSpecies
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Kernel'!
!classDefinition: 'LMRSpecies class' category: #'Powerlang-Kernel'!
LMRSpecies class
	instanceVariableNames: ''!


!HashTable commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!InlinedHashTable commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!OpenHashTable commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!OrderedHashTable commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!LMRArrayedCollection commentStamp: '<historical>' prior: 0!
Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRSymbol commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!WideSymbol commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!WideString commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!LMRCharacterArray commentStamp: '<historical>' prior: 0!
Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
!

!InlinedDictionary commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Namespace commentStamp: '<historical>' prior: 0!
Copyright (c) 2022 Javier Pimás. 
    See (MIT) license in root directory.
!

!WeakIdentityDictionary commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!HashedCollection commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!StackOverflow commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!LMRFloat commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!ScaledDecimal commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ArgParser commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!Command commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!Option commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ParseResult commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!MethodSpec commentStamp: '<historical>' prior: 0!
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!ModuleSpec commentStamp: '<historical>' prior: 0!
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!SpeciesSpec commentStamp: '<historical>' prior: 0!
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!ClassSpec commentStamp: '<historical>' prior: 0!
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!MetaclassSpec commentStamp: '<historical>' prior: 0!
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!Assembler commentStamp: '<historical>' prior: 0!
I am the JIT assembler frontend. I provide a high-level assembler interface (if that really exists)
and delegate writing of the actual bytes to my backends.
!

!GenericAssembler commentStamp: '<historical>' prior: 0!
I am a JIT GenericAssembler frontend that can generate code for different architectures
using different code generators.
!

!RelocatableBuffer commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!RelocationFixup commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!MessageInliner commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!SExpression commentStamp: '<historical>' prior: 0!
I am a Smalltalk expression, the minimal unit of Smalltalk semantics, expressed as a tree
!

!Config commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ProjectGenerator commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ObjectClosure commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
!

!HashTablePolicy commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ImageSegment commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!LMRObject commentStamp: '<historical>' prior: 0!
Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
!

!MatchAlgorithm commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!MatchToken commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Module commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ArgParserModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!CodeSpecsModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Quorum Software. 
    See (MIT) license in root directory.
!

!TestsModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!CompilerModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
!

!LMRModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
!

!EPMModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ImageSegmentBuilderModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!KernelModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Quorum Software.
    Copyright (c) 2020, LabWare.
    See (MIT) license in root directory.
!

!ModuleImporterModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Quorum Software.
    See (MIT) license in root directory.
!

!NativizerModule commentStamp: '<historical>' prior: 0!
Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
!

!NumberParser commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ObjectReference commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!SmalltalkSystem commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!Species commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!StarToken commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!StringPattern commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Unicode commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!UTF16 commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!UTF32 commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!UTF8 commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ModuleLoader commentStamp: '<historical>' prior: 0!
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!ModuleSpecReader commentStamp: '<historical>' prior: 0!
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!ABI commentStamp: '<historical>' prior: 0!
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.

`ABI` seems to serve two different purposes:

 i) provide support for calling (native) function with system
	calling convention for given architecture and OS combination

ii) provide fixed mapping from 'IR' registers (such as A, R, M and so on)
	to real machine registers

!

!Writer commentStamp: '<historical>' prior: 0!
Copyright (c) 2022-2023, Javier Pimás.
    See (MIT) license in root directory.
!

!MessageInlinerTest commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!SmalltalkScannerTest commentStamp: '<historical>' prior: 0!
Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!LMRClosure commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRProtoObject commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRSpecies commentStamp: '<historical>' prior: 0!
Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationClass
	^policy notNil ifTrue: [policy associationClass] ifFalse: [Association]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index put: anObject
	| element |
	element := anObject ifNil: [NilToken].
	^self basicAt: index put: element
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atKey: key hash: hash put: element
	| index |
	index := self indexOfKey: key hash: hash.
	^self at: index key: key put: element
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
beWeak
	| empty |
	empty := self emptySlot.
	self withIndexDo: [:v :i | v isNil ifTrue: [self basicAt: i put: empty]].
	super beWeak
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bucketClass
	^OpenHashTable
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
clearSlots: indexes ifAbsent: absentBlock
	| empty |
	empty := self emptySlot.
	indexes do: [:i | | v |
		v := self at: i.
		(v == nil or: [v == empty])
			ifTrue: [absentBlock value]
			ifFalse: [self clearSlot: i with: empty]]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
emptySlot
	^policy notNil ifTrue: [policy emptySlot]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
equates: anObject1 with: anObject2
	^policy notNil
		ifTrue: [policy equates: anObject1 with: anObject2]
		ifFalse: [anObject1 = anObject2]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hashFor: anObject
	^policy notNil ifTrue: [policy hashFor: anObject] ifFalse: [anObject hash]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOf: key
	| hash |
	hash := self hashFor: key.
	^self indexOfHash: hash
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOfHash: integer
	^integer \\ (self size // 2) + 1
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOfKey: key
	| hash |
	hash := self hashFor: key.
	^self indexOfKey: key hash: hash
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOfKey: key hash: hash
	| first empty |
	first := self indexOfHash: hash.
	empty := self emptySlot.
	^self
		findFirst: [:obj | 
			obj == nil or: [obj == empty] or: [| k |
				k := obj == NilToken ifFalse: [obj].
				self equates: key with: k]]
		startingAt: first
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyFor: anObject
	^policy notNil ifTrue: [policy keyFor: anObject] ifFalse: [anObject]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyNotFound: anObject
	KeyNotFound signalFor: anObject
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
rehash: indexes
	| n index empty |
	n := self size.
	index := 1.
	empty := self emptySlot.
	indexes sort do: [:j | | v |
		index := j max: index.
		[
			index := index = n ifTrue: [1] ifFalse: [index + 1].
			v := self at: index.
			v == nil or: [v == empty]]
			whileFalse: [| k i |
				k := self keyFor: v.
				i := self indexOfKey: k.
				v := self basicAt: i.
				(v == nil or: [v == empty]) ifTrue: [self moveSlot: index to: i]]]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
rehashFrom: index1 to: index2
	| max empty n |
	max := index2.
	empty := self emptySlot.
	n := self size.
	self
		withIndexDo: [:obj :i | | j v k |
			i = n ifTrue: [max := 0].
			(obj == empty and: [i > max]) ifTrue: [^self].
			k := self keyFor: obj.
			j := self indexOfKey: k.
			v := self basicAt: j.
			(v == nil or: [v == empty]) ifTrue: [self moveSlot: i to: j]]
		startingAt: index1
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeAll
	1 to: self size do: [:i | self basicAt: i put: nil]
! !

!HashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeKeys: keys ifAbsent: absentBlock
	| indexes min max |
	keys isEmpty ifTrue: [^self].
	min := self size + 1.
	max := 0.
	indexes := keys
		collect: [:k | | index |
			index := self indexOfKey: k.
			index < min ifTrue: [min := index].
			max < index ifTrue: [max := index].
			index]
		in: OrderedCollection new.
	self clearSlots: indexes ifAbsent: absentBlock.
	indexes size <= 1000
		ifTrue: [self rehash: indexes]
		ifFalse: [self rehashFrom: min to: max]
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atKey: key put: element
	| hash |
	hash := self hashFor: key.
	^self atKey: key hash: hash put: element
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atKey: key sum: magnitude
	| hash |
	hash := self hashFor: key.
	^self atKey: key hash: hash sum: magnitude
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
findFirst: aBlock startingAt: index
	| n i first slots |
	n := self size.
	first := i := index.
	slots := self slotsPerElement.
	[aBlock evaluateWith: (self at: i)] whileFalse: [
		i := i + slots.
		i > n ifTrue: [i := 1].
		i = first ifTrue: [self error: 'element not found']].
	^i
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookUpValue: key ifAbsent: aBlock ifPresent: pBlock
	| v |
	v := self lookupValue: key ifAbsent: [^aBlock value].
	^pBlock arity = 1 ifTrue: [pBlock evaluateWith: v] ifFalse: [pBlock value]
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupKey: key
	^self lookupKey: key ifAbsent: nil
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupKey: key ifAbsent: aBlock
	| index hash first empty |
	hash := self hashFor: key.
	first := self indexOfHash: hash.
	empty := self emptySlot.
	index := self
		findFirst: [:obj | 
			obj == empty or: [| k |
				k := obj == NilToken ifFalse: [obj].
				self equates: key with: k]]
		startingAt: first.
	^self valueAt: index ifAbsent: aBlock
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupValue: key ifAbsent: aBlock
	^self lookupKey: key ifAbsent: aBlock
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupValue: key ifPresent: aBlock
	^self lookUpValue: key ifAbsent: nil ifPresent: aBlock
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
owner
	^policy
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
owner: aHashedCollection
	policy := aHashedCollection
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
policy
	^policy
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
policy: aHashTablePolicy
	policy := aHashTablePolicy
! !

!HashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
valueAt: index ifAbsent: aBlock
	| value |
	value := self at: index.
	value == nil ifTrue: [^aBlock value].
	value == self emptySlot ifTrue: [^aBlock value].
	^value == NilToken ifFalse: [value]
! !

!HashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
clearSlot: anInteger
	self clearSlot: anInteger with: self emptySlot
! !

!HashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
clearSlot: anInteger with: emptySlot
	self basicAt: anInteger put: emptySlot
! !

!HashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeKey: key ifAbsent: aBlock
	| index empty object |
	index := self indexOfKey: key.
	empty := self emptySlot.
	object := self basicAt: index.
	object == nil ifTrue: [^aBlock value].
	object == empty ifTrue: [^aBlock value].
	self clearSlot: index.
	index := index + self slotsPerElement.
	index > self size ifTrue: [index := 1].
	self
		withIndexDo: [:obj :i | | j v k |
			obj == empty ifTrue: [^self].
			k := self keyFor: obj.
			j := self indexOfKey: k.
			v := self basicAt: j.
			(v == nil or: [v == empty]) ifTrue: [self moveSlot: i to: j]]
		startingAt: index
! !

!HashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
slotsPerElement
	^1
! !

!HashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
withIndexDo: aBlock startingAt: anInteger
	| n i first slots |
	n := self size.
	first := i := anInteger.
	slots := self slotsPerElement.
	[
		aBlock evaluateWith: (self at: i) with: i.
		i := i + slots.
		i > n ifTrue: [i := 1].
		i = first] whileFalse
! !

!HashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
elementsDo: aBlock
	self elementsDo: aBlock count: self size
! !

!HashTable methodsFor: 'replacing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
replaceBackwardFrom: stop to: start with: aCollection startingAt: position
	| i j |
	i := stop.
	j := position.
	[start <= i] whileTrue: [
		self basicAt: i put: (aCollection at: j).
		i := i - 1.
		j := j - 1]
! !

!HashTable methodsFor: 'replacing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
replaceForwardFrom: start to: stop with: aCollection startingAt: position
	| i j |
	i := start.
	j := position.
	[i <= stop] whileTrue: [
		self basicAt: i put: (aCollection at: j).
		i := i + 1.
		j := j + 1]
! !

!HashTable class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeConstants
	NilToken := Object new
! !

!HashTable class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeSizes
	| primes p |
	Sizes := ByteArray new: 126.
	primes := #(
			2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79
			83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163
			167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251
		) readStream.
	p := primes next.
	1 to: Sizes size do: [:i | | n |
		n := i * 2 - 1.
		p < n ifTrue: [p := primes next].
		Sizes at: i put: p]
! !

!HashTable class methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
goodPrimes
	"
	from squeak
	"
	^#(269 359 479 641 857 1151 1549 2069
		2237 2423 2617 2797 2999 3167 3359 3539 3727 3911
		4441 4787 5119 5471 5801 6143 6521 6827 7177 7517 7853
		8783 9601 10243 10867 11549 12239 12919 13679 14293 15013 15731
		17569 19051 20443 21767 23159 24611 25847 27397 28571 30047 31397
		35771 38201 40841 43973 46633 48989 51631 54371 57349 60139 62969
		70589 76091 80347 85843 90697 95791 101051 106261 111143 115777 120691 126311
		140863 150523 160969 170557 181243 190717 201653 211891 221251 232591 242873 251443
		282089 300869 321949 341227 362353 383681 401411 422927 443231 464951 482033 504011
		562621 605779 647659 681607 723623 763307 808261 844709 886163 926623 967229 1014617
		1121987 1201469 1268789 1345651 1429531 1492177 1577839 1651547 1722601 1800377 1878623 1942141 2028401
		2242727 2399581 2559173 2686813 2836357 3005579 3144971 3283993 3460133 3582923 3757093 3903769 4061261
		4455361 4783837 5068529 5418079 5680243 6000023 6292981 6611497 6884641 7211599 7514189 7798313 8077189
		9031853 9612721 10226107 10745291 11338417 11939203 12567671 13212697 13816333 14337529 14938571 15595673 16147291
		17851577 18993941 20180239 21228533 22375079 23450491 24635579 25683871 26850101 27921689 29090911 30153841 31292507 32467307
		35817611 37983761 40234253 42457253 44750177 46957969 49175831 51442639 53726417 55954637 58126987 60365939 62666977 64826669
		71582779 76039231 80534381 84995153 89500331 93956777 98470819 102879613 107400389 111856841 116365721 120819287 125246581 129732203
		143163379 152076289 161031319 169981667 179000669 187913573 196826447 205826729 214748357 223713691 232679021 241591901 250504801 259470131
		285162679 301939921 318717121 335494331 352271573 369148753 385926017 402603193 419480419 436157621 453034849 469712051 486589307 503366497 520043707 
		570475349 603929813 637584271 671138659 704693081 738247541 771801929 805356457 838910803 872365267 905919671 939574117 973128521 1006682977 1040137411 
		1073741833)
! !

!HashTable class methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primeFor: size
	| n primes |
	n := size bitOr: 1.
	n <= 251 ifTrue: [^Sizes at: n // 2 + 1].
	primes := self goodPrimes.
	1 to: primes size do: [:i | | p |
		p := primes at: i.
		p > n ifTrue: [^p]].
	^n
! !

!HashTable class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new
	^self new: 7
! !

!HashTable class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger
	| size |
	size := self primeFor: anInteger.
	^super new: size
! !

!HashTable class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nilToken
	^NilToken
! !

!InlinedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index key: key put: element
	(self at: index) ifNil: [
		self
			at: index put: key;
			at: index + 1 put: element.
		^nil].
	self at: index + 1 put: element.
	^key
! !

!InlinedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atKey: key hash: hash sum: magnitude
	| index v k |
	index := self indexOfKey: key hash: hash.
	k := self at: index.
	(k == nil or: [k == self emptySlot]) ifFalse: [
		v := (self at: index + 1) + magnitude.
		self at: index + 1 put: v.
		^v].
	self
		at: index put: key;
		at: index + 1 put: magnitude.
	^nil
! !

!InlinedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
count
	| n empty |
	n := 0.
	empty := self emptySlot.
	1 to: self size by: 2 do: [:i | | k |
		k := self at: i.
		(k == nil or: [k == empty]) ifFalse: [n := n + 1]].
	^n
! !

!InlinedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAtKey: key put: element
	| index |
	index := self indexOfKey: key.
	self
		at: index put: key;
		at: index + 1 put: element
! !

!InlinedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
copyFromBucket: bucket
	| count |
	count := 0.
	bucket keysAndValuesDo: [:key :value | 
		count := count + 1.
		self basicAtKey: key put: value].
	^count
! !

!InlinedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOfHash: integer
	^integer \\ (self size // 2) * 2 + 1
! !

!InlinedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupValue: key
	^self lookupValue: key ifAbsent: [self keyNotFound: key]
! !

!InlinedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
valueAt: index ifAbsent: aBlock
	| k value |
	k := self at: index.
	(k == nil or: [k == self emptySlot]) ifTrue: [^aBlock value].
	value := self at: index + 1.
	^value == NilToken ifFalse: [value]
! !

!InlinedHashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
clearSlot: anInteger with: emptySlot
	self
		basicAt: anInteger put: emptySlot;
		basicAt: anInteger + 1 put: emptySlot
! !

!InlinedHashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
moveSlot: anInteger to: targetInteger
	| k v empty |
	empty := self emptySlot.
	k := self basicAt: anInteger.
	v := self basicAt: anInteger + 1.
	self
		basicAt: anInteger put: empty;
		basicAt: anInteger + 1 put: empty;
		basicAt: targetInteger put: k;
		basicAt: targetInteger + 1 put: v
! !

!InlinedHashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
slotsPerElement
	^2
! !

!InlinedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
elementsDo: aBlock count: n
	| count |
	count := 0.
	self keysAndValuesDo: [:k :v | | assoc |
		assoc := Association key: k value: v.
		aBlock evaluateWith: assoc.
		count := count + 1.
		count = n ifTrue: [^self]]
! !

!InlinedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keysAndValuesDo: aBlock
	1 to: self size by: 2 do: [:index | | key value |
		key := self at: index.
		key notNil ifTrue: [
			key := key == NilToken ifFalse: [key].
			value := self at: index + 1.
			value := value == NilToken ifFalse: [value].
			aBlock value: key value: value]]
! !

!InlinedHashTable methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isCapacityGreaterThan: count
	^self size * 3 > (count * 8)
! !

!InlinedHashTable class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger
	| n |
	n := self primeFor: anInteger.
	^self basicNew: n * 2
! !

!OpenHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index key: key put: element
	| object |
	object := self at: index.
	object == self emptySlot ifTrue: [object := nil].
	object == nil ifTrue: [self at: index put: element].
	^object
! !

!OpenHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atKey: key hash: hash sum: magnitude
	| index object assoc sum |
	index := self indexOfKey: key hash: hash.
	object := self at: index.
	(object == nil or: [object == self emptySlot]) ifTrue: [
		assoc := self associationClass key: key value: magnitude.
		self at: index put: assoc.
		^nil].
	sum := object value + magnitude.
	object value: sum.
	^object
! !

!OpenHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
count
	^self count: [:n | n notNil]
! !

!OpenHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAtKey: key put: element
	| index |
	index := self indexOfKey: key.
	self at: index put: element
! !

!OpenHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
copyAssociations
	self
		withIndexDo: [:a :index | a isAssociation
			ifTrue: [self at: index put: a key -> a value]]
! !

!OpenHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
copyFromBucket: bucket
	| count |
	count := 0.
	bucket elementsDo: [:element | | key |
		count := count + 1.
		key := self keyFor: element.
		self basicAtKey: key put: element].
	^count
! !

!OpenHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOfHash: integer
	^integer \\ self size + 1
! !

!OpenHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupValue: key
	^self lookupValue: key ifAbsent: [self keyNotFound: key]
! !

!OpenHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupValue: key ifAbsent: aBlock
	| assoc |
	assoc := super lookupValue: key ifAbsent: [^aBlock value].
	^assoc value
! !

!OpenHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
elementsDo: aBlock count: n
	| i empty |
	n = 0 ifTrue: [^self].
	i := 0.
	empty := self emptySlot.
	1 to: self size do: [:index | | value |
		value := self at: index.
		value == nil | (value == empty) ifFalse: [
			value := value == NilToken ifFalse: [value].
			aBlock evaluateWith: value.
			i := i + 1.
			i = n ifTrue: [^self]]]
! !

!OpenHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keysAndValuesDo: aBlock
	self
		elementsDo: [:assoc | aBlock evaluateWith: assoc key with: assoc value]
! !

!OpenHashTable methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isCapacityGreaterThan: count
	^self size * 75 > (count * 100)
! !

!OpenHashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
moveSlot: anInteger to: targetInteger
	| a |
	a := self basicAt: anInteger.
	self
		basicAt: anInteger put: self emptySlot;
		basicAt: targetInteger put: a
! !

!OrderedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index
	| i |
	i := super at: index.
	i ifNil: [^nil].
	^values at: i
! !

!OrderedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index put: anObject
	| i element |
	i := self basicAt: index.
	element := anObject ifNil: [NilToken].
	(i == nil or: [i == self emptySlot])
		ifTrue: [
			values add: element.
			super at: index put: values size]
		ifFalse: [values at: i put: element].
	^anObject
! !

!OrderedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
first
	values do: [:v | v notNil ifTrue: [^v]].
	^nil
! !

!OrderedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOfElement: anObject
	| i |
	i := 1.
	self elementsDo: [:assoc | 
		assoc value == anObject ifTrue: [^i].
		i := i + 1].
	^0
! !

!OrderedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
last
	values reverseDo: [:v | v notNil ifTrue: [^v]].
	^nil
! !

!OrderedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
totalSize
	^values size
! !

!OrderedHashTable methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
valueAt: index ifAbsent: aBlock
	| i value |
	i := self basicAt: index.
	i == nil ifTrue: [^aBlock value].
	i == self emptySlot ifTrue: [^aBlock value].
	value := values at: i ifAbsent: [^aBlock value].
	^value == NilToken ifFalse: [value]
! !

!OrderedHashTable methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index tally: tally
	| n i count vi |
	n := values size.
	index * 2 <= n
		ifTrue: [
			i := 1.
			count := 0.
			[
				vi := values at: i.
				vi == nil ifFalse: [count := count + 1].
				count = index ifTrue: [^vi == NilToken ifFalse: [vi]].
				i := i + 1.
				i <= n] whileTrue]
		ifFalse: [
			i := n.
			count := tally + 1.
			[
				vi := values at: i.
				vi == nil ifFalse: [count := count - 1].
				count = index ifTrue: [^vi == NilToken ifFalse: [vi]].
				i := i - 1.
				0 < i] whileTrue]
! !

!OrderedHashTable methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
compressTo: tally
	| relocations compressed |
	values size = tally ifTrue: [^self].
	relocations := Array new: values size.
	compressed := OrderedCollection new: tally.
	values withIndexDo: [:value :index | 
		value notNil ifTrue: [
			compressed add: value.
			relocations at: index put: compressed size]].
	1 to: self size do: [:index | | old new |
		old := super at: index.
		old notNil ifTrue: [
			new := relocations at: old.
			super at: index put: new]].
	values := compressed
! !

!OrderedHashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
clearSlot: anInteger with: emptySlot
	| i |
	i := self basicAt: anInteger.
	self basicAt: anInteger put: emptySlot.
	values at: i put: emptySlot
! !

!OrderedHashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeAll
	super removeAll.
	values removeAll
! !

!OrderedHashTable methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeObject: anObject ifAbsent: aBlock
	| association |
	association := values
		detect: [:assoc | assoc value == anObject]
		ifNone: [^aBlock value].
	^self removeKey: association key ifAbsent: aBlock
! !

!OrderedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
elementAt: index
	^values at: index
! !

!OrderedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
elementsDo: aBlock
	values
		select: [:value | value !!== nil]
		thenDo: [:value | aBlock evaluateWith: (value == NilToken ifFalse: [value])]
! !

!OrderedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
elementsDo: aBlock count: n
	| i |
	n = 0 ifTrue: [^self].
	i := 0.
	self elementsDo: [:value | 
		aBlock evaluateWith: value.
		i := i + 1.
		i = n ifTrue: [^self]]
! !

!OrderedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keysAndValuesDo: aBlock
	self elementsDo: [:assoc | aBlock value: assoc key value: assoc value]
! !

!OrderedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
privateDo: aBlock
	values do: [:value | aBlock evaluateWith: value]
! !

!OrderedHashTable methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
valuesReverseDo: aBlock
	values reverseDo: [:assoc | 
		assoc == nil
			ifFalse: [aBlock evaluateWith: (assoc == NilToken ifFalse: [assoc]) value]]
! !

!OrderedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexAtKey: key
	| index |
	index := self indexOfKey: key.
	^self basicAt: index
! !

!OrderedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
move: anAssociation to: anInteger
	| a min max |
	a := values indexOf: anAssociation.
	min := a min: anInteger.
	max := a max: anInteger.
	1 to: self size do: [:i | | index |
		index := self basicAt: i.
		index notNil ifTrue: [
			(index between: min and: max) ifTrue: [
				index <= a
					ifTrue: [self basicAt: i put: index + 1]
					ifFalse: [self basicAt: i put: index - 1]].
			index = a ifTrue: [self basicAt: i put: anInteger]]].
	values move: values last to: anInteger
! !

!OrderedHashTable methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
moveLastTo: anInteger
	| last |
	last := values size.
	1 to: self size do: [:i | | index |
		index := self basicAt: i.
		index notNil ifTrue: [
			index >= anInteger ifTrue: [self basicAt: i put: index + 1].
			index = last ifTrue: [self basicAt: i put: anInteger]]].
	values move: values last to: anInteger
! !

!OrderedHashTable methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	super initialize.
	values := OrderedCollection new
! !

!OrderedHashTable methodsFor: 'copying' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
postCopy
	super postCopy.
	values := values copy
! !

!OrderedHashTable class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger
	^(super new: anInteger) initialize
! !

!SFFIDescriptor methodsFor: 'calls' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
arguments: aCollection
	self replaceFrom: 1 to: aCollection size with: aCollection
! !

!SFFIDescriptor methodsFor: 'calls' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callingConvention: anInteger
	self at: self size put: anInteger
! !

!SFFIDescriptor methodsFor: 'calls' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
return: anInteger
	self at: self size - 1 put: anInteger
! !

!SFFIDescriptor class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	self initializeFFITypes; initializeCallingConventions
! !

!SFFIDescriptor class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeCallingConventions
	FFICallingConventions := Dictionary new.
	FFICallingConventions
		at: 'cdecl' put: 20;
		at: 'com' put: 21;
		at: 'callback' put: 22
! !

!SFFIDescriptor class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeFFITypes
	FFITypes := Dictionary new.
	FFITypes
		at: 'uint8' put: 0;
		at: 'sint8' put: 1;
		at: 'uint16' put: 2;
		at: 'sint16' put: 3;
		at: 'uint32' put: 4;
		at: 'sint32' put: 5;
		at: 'uint64' put: 6;
		at: 'sint64' put: 7;

		at: 'float' put: 8;
		at: 'double' put: 9;

		at: 'uchar' put: 10;
		at: 'schar' put: 11;
		at: 'ushort' put: 12;
		at: 'sshort' put: 13;
		at: 'ulong' put: 14;
		at: 'slong' put: 15;
		at: 'ularge' put: 16;
		at: 'large' put: 17;
		at: 'longdouble' put: 18;
		at: 'pointer' put: 19;
		at: 'complex-float' put: 20;
		at: 'complex-double' put: 21;
		at: 'complex-longdouble' put: 22;

		at: 'void' put: 23
! !

!SFFIDescriptor class methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ret: aString args: aCollection cc: ccName
	| args return cc result |
	args := aCollection
		collect: [ :argname | 
			FFITypes
				at: argname asString
				ifAbsent: [ self error: 'undefined argument type ' , argname ] ].
	return := FFITypes
		at: aString
		ifAbsent: [ self error: 'undefined result type ' , aString ].
	cc := FFICallingConventions
		at: ccName
		ifAbsent: [ self error: 'unsupported calling convention ' , ccName ].
	result := self new: args size + 2.
	^ result
		callingConvention: cc;
		return: return;
		arguments: args
! !

!LMRSymbol methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
flushCacheFor: species
	GlobalDispatchCache current flush: self forSpecies: species.
	SendSite flush: self
! !

!WideSymbol methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
<= aString
	^UTF16 current isString: self lessThanOrEqualTo: aString
! !

!WideSymbol methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asByteCharacters
	| n result |
	n := self size.
	result := Symbol new: n.
	1 to: n do: [:i | | code char |
		code := self codeAt: i.
		char := code < 256 ifTrue: [code] ifFalse: [$? asInteger].
		result byteAt: i put: char].
	^result
! !

!WideSymbol methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asLowercase
	^UTF16 current lowercaseOf: self
! !

!WideSymbol methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asString
	| n string |
	n := self size.
	string := WideString new: n.
	^string replaceFrom: 1 to: n with: self
! !

!WideSymbol methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asUppercase
	^UTF16 current uppercaseOf: self
! !

!WideSymbol methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asWideSymbol
	^self
! !

!WideSymbol methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index
	| cp |
	cp := self checkIndex: index; codeAt: index.
	^Character value: cp
! !

!WideSymbol methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index putCode: codePoint
	^self
		checkIndex: index;
		uLongAtOffset: index - 1 * 4 put: codePoint
! !

!WideSymbol methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atValid: index
	| cp |
	cp := self codeAt: index.
	^Character value: cp
! !

!WideSymbol methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
size
	^self _size // 4
! !

!WideSymbol methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeInBytes
	^self size * 4
! !

!WideSymbol methodsFor: 'unassigned' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicSize
	^self _size
! !

!WideSymbol methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
codeAt: index
	^self uLongAtOffset: index - 1 * 4
! !

!WideSymbol methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
species
	^WideString
! !

!WideSymbol methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
td1
	| m td1 |
	m := self size.
	td1 := Dictionary new: m.
	m to: 1 by: -1 do: [:i | | code |
		code := self uLongAtOffset: i - 1 * 4.
		td1 at: code + 1 ifAbsentPut: [m - i + 1]].
	^td1
! !

!WideSymbol methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isByteCompliant
	^false
! !

!WideSymbol methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isWide
	^true
! !

!WideSymbol methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isWideSymbol
	^true
! !

!WideSymbol class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
findInterned: aString
	| symbol string |
	string := aString reduced.
	string == aString ifFalse: [^super findInterned: string].
	symbol := aString bytes changeClassTo: self.
	^SymbolTable lookup: symbol
! !

!WideSymbol class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
intern: aString
	| symbol canonical |
	aString isByteCompliant ifTrue: [^aString reduced asSymbol].
	symbol := aString bytes changeClassTo: self.
	canonical := SymbolTable lookup: symbol.
	canonical == nil ifTrue: [^SymbolTable add: symbol].
	^canonical
! !

!WideString methodsFor: 'operations' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
, aString
	| n string |
	aString isString ifFalse: [^super , aString].
	n := self size.
	string := WideString new: n + aString size.
	^string
		replaceBytesFrom: 1 to: self sizeInBytes with: self startingAt: 1;
		replaceFrom: n + 1 to: string size with: aString startingAt: 1
! !

!WideString methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
<= aString
	^UTF16 current isString: self lessThanOrEqualTo: aString
! !

!WideString methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hash
	| hash |
	hash := self size.
	0
		to: self sizeInBytes - 4
		by: 4
		do: [:i | hash := (hash hashMultiply: 16r19660D)
			bitXor: (self uLongAtOffset: i)].
	^hash
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asByteCharacters
	| n result |
	n := self size.
	result := String new: n.
	1 to: n do: [:i | | code char |
		code := self codeAt: i.
		char := code < 256 ifTrue: [code] ifFalse: [$? asInteger].
		result byteAt: i put: char].
	^result
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asLowercase
	^UTF16 current lowercaseOf: self
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asSymbol
	^WideSymbol intern: self
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asUppercase
	^UTF16 current uppercaseOf: self
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asWideString
	^self
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
existingSymbol
	^WideSymbol findInterned: self
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
reduced
	^self isByteCompliant ifTrue: [self asByteCharacters] ifFalse: [self]
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeInBytes
	^self basicSize
! !

!WideString methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
utf8Bytes
	^UTF8 current encode: self
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index
	| cp |
	cp := self checkIndex: index; codeAt: index.
	^Character value: cp
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index putCode: codePoint
	^self
		checkIndex: index;
		uLongAtOffset: index - 1 * 4 put: codePoint
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atValid: index
	| cp |
	cp := self codeAt: index.
	^Character value: cp
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atValid: anInteger put: aCharacter
	self at: anInteger putCode: aCharacter codePoint.
	^aCharacter
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
atValid: index putCode: codePoint
	^self uLongAtOffset: index - 1 * 4 put: codePoint
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
checkByteIndex: index
	index isInteger ifFalse: [self error: 'strings are indexed by integers'].
	(index between: 1 and: self sizeInBytes)
		ifFalse: [self
			error: 'index: ' , index printString , ' is outside of string bounds']
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
codeAt: index
	^self uLongAtOffset: index - 1 * 4
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromCodePoints: aCollection
	1 to: aCollection size do: [:i | | ci |
		ci := aCollection at: i.
		self at: i putCode: ci]
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexAt: anInteger
	^anInteger
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveULongAtOffset: offset
put: anInteger
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 3 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLongAtValidOffset: offset put: anInteger
! !

!WideString methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
td1
	| m td1 |
	m := self size.
	td1 := Dictionary new: m.
	m to: 1 by: -1 do: [:i | | code |
		code := self codeAt: i.
		td1 at: code + 1 ifAbsentPut: [m - i + 1]].
	^td1
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: anInteger put: aCharacter
	self
		checkCharacter: aCharacter;
		at: anInteger putCode: aCharacter codePoint.
	^aCharacter
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAt: anInteger
	^self basicByteAt: anInteger
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAt: anInteger put: anObject
	^self basicByteAt: anInteger put: anObject
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicSize
	^self _size
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
byteAt: anInteger
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
byteAt: position put: asciiValue
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position <= self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
characterSize
	^4
! !

!WideString methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
size
	^self basicSize // 4
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
composeCharacters
	^UTF16 current compose: self
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decomposeCharacters
	^UTF16 current decompose: self
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
foldDigits
	^UTF16 current foldDigitsOf: self
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
normalizeToC
	^UTF16 current normalizeToC: self
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
normalizeToD
	^(UTF16 current normalizeToD: self) reduced
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
normalizeToKC
	^UTF16 current normalizeToKC: self
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
normalizeToKD
	^UTF16 current normalizeToKD: self
! !

!WideString methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
unaccented
	^self normalizeToD reject: [:ch | ch isNonSpacingMark]
! !

!WideString methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOfString: aString from: start to: stop td1: anArray
	| m k |
	m := aString size.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i code delta |
		i := 1.
		[i <= m and: [(aString at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		code := self codeAt: k + m.
		delta := anArray at: code + 1 ifAbsent: nil.
		delta isNil ifTrue: [delta := m + 1].
		k := k + delta].
	^0
! !

!WideString methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isByteCompliant
	1 to: self size do: [:i | | char |
		char := self at: i.
		char isByteCharacter ifFalse: [^false]].
	^true
! !

!WideString methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isCNormal
	^UTF16 current isCNormal: self
! !

!WideString methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isDNormal
	^UTF16 current isDNormal: self
! !

!WideString methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isKCNormal
	^UTF16 current isKCNormal: self
! !

!WideString methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isKDNormal
	^UTF16 current isKDNormal: self
! !

!WideString methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isWide
	^true
! !

!WideString methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isWideString
	^true
! !

!WideString methodsFor: 'inquires' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
length
	^UTF16 current lengthOf: self
! !

!WideString methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printChunkOn: aStream from: anInteger
	^self printUTF8ChunkOn: aStream from: anInteger
! !

!WideString methodsFor: 'replacing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
replace: anInteger with: aString
	1 to: anInteger do: [:i | | char |
		char := aString at: i.
		self at: i put: char]
! !

!WideString methodsFor: 'replacing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
replaceFirst: anInteger with: aString
	1 to: anInteger do: [:i | | char |
		char := aString at: i.
		self at: i put: char]
! !

!WideString methodsFor: 'replacing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
replaceFrom: start to: stop with: aString startingAt: position
	| string |
	string := self replacementFrom: aString.
	super
		replaceFrom: start - 1 * 4 + 1
		to: stop * 4
		with: string
		startingAt: position - 1 * 4 + 1
! !

!WideString methodsFor: 'replacing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
replaceFrom: start to: stop withObject: aCharacter
	self checkIndex: start; checkIndex: stop.
	start to: stop do: [:i | self at: i put: aCharacter]
! !

!WideString methodsFor: 'replacing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
replacementFrom: aString
	| n wide |
	aString class == self class ifTrue: [^aString].
	aString isExternalMemory ifTrue: [^WideString fromMemory: aString].
	n := aString size.
	wide := WideString new: n.
	1 to: n do: [:i | | ch |
		ch := aString atValid: i.
		wide atValid: i put: ch].
	^wide
! !

!WideString methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
uLongAtValidOffset: offset put: anInteger
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
	self _uLongAtOffset: offset put: anInteger.
	^anInteger
! !

!WideString class methodsFor: 'instances' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicNew: anInteger
	^self primitiveNewBytes: anInteger
! !

!WideString class methodsFor: 'instances' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger
	^self basicNew: anInteger * 4
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromBytes: aByteArray
	^UTF16 current
		decodeStringFrom: aByteArray readStream
		on: (self new: aByteArray size)
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromCodePoints: aCollection
	| string |
	string := self new: aCollection size.
	^string fromCodePoints: aCollection
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromExternalUTF16: anExternalMemory
	^UTF16 current decodeStringFrom: anExternalMemory readStream
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromExternalUTF16: anExternalMemory length: anInteger
	| stream |
	stream := anExternalMemory readStream.
	stream readLimit: anInteger.
	^UTF16 current decodeStringFrom: stream
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromExternalUTF8: anExternalMemory
	^UTF8 current decodeStringFrom: anExternalMemory readStream
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromMemory: anExternalMemory
	| s i |
	s := self new: 1.
	i := 1.
	[
		s replaceBytesFrom: 1 to: 2 with: anExternalMemory startingAt: i.
		(s codeAt: 1) = 0]
		whileFalse: [i := i + 2].
	^self fromMemory: anExternalMemory length: i - 1 // 2
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromMemory: anExternalMemory length: anInteger
	| bytes |
	bytes := anExternalMemory readStream readLimit: anInteger * 2.
	^UTF16 current decodeStringFrom: bytes on: (self new: anInteger)
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromMultiByte: aByteArray codePage: anInteger
	"
	WideString fromMultiByte: #[16rFA] codePage: 1251
	"
	| bytes string |
	bytes := aByteArray externalCopy.
	string := self
		fromMultiByteAddress: bytes
		codePage: anInteger
		size: aByteArray sizeInBytes.
	bytes free.
	^string
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromString: aString
	aString class == String ifTrue: [^aString asWideString].
	aString class == self ifTrue: [^aString].
	^self fromUTF8: aString asString utf8
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromUTF8: aByteArray
	^UTF8 current
		decodeStringFrom: aByteArray readStream
		on: (self new: aByteArray size)
! !

!WideString class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
stringFromMemory: anExternalMemory
	| s i |
	s := self new: 1.
	i := 1.
	[
		s replaceBytesFrom: 1 to: 2 with: anExternalMemory startingAt: i.
		(s codeAt: 1) = 0]
		whileFalse: [i := i + 2].
	^UTF16 decodeFromAddress: anExternalMemory length: i - 1 // 2
! !

!WideString class methodsFor: 'gs' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
newFrom: aByteArray
	^aByteArray copy changeClassTo: self
! !

!WideString class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
stringsFromAddress: anExternalMemory
	| strings memory |
	strings := OrderedCollection new.
	memory := anExternalMemory.
	[(memory at: 1) = 0 and: [(memory at: 2) = 0]] whileFalse: [| s |
		s := self stringFromMemory: memory.
		strings add: s.
		memory := memory + (s size + 1 * 2)].
	^strings
! !

!CharacterArray methodsFor: 'converting' stamp: 'KenD 29/Jun/2026, 7:12:21 pm (UTC)'!
dosToUnix
	^self species streamContents: [:s | | source |
		source := self readStream.
		[source atEnd] whileFalse: [| c |
			c := source next.
			(c = `Character cr`)
				ifTrue: [
					s nextPut: `Character lf`.
					source next]
				ifFalse: [s nextPut: c]]]! !

!CharacterArray methodsFor: 'converting' stamp: 'KenD 29/Jun/2026, 7:11:33 pm (UTC)'!
unixToMac
	| result |
	result := self species new: self size.
	self
		withIndexDo: [:c :i | (c = `Character lf`)
			ifTrue: [result at: i put: `Character cr`]
			ifFalse: [result at: i put: c]].
	^result! !

!LMRCharacterArray methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveSize
	^self _size
! !

!InlinedDictionary methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationAt: key ifAbsent: exceptionBlock
	| value |
	value := table lookupValue: key ifAbsent: [^exceptionBlock value].
	^self associationClass key: key value: value
! !

!InlinedDictionary methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: key put: element
	(table atKey: key put: element) == nil ifTrue: [self incrementTally].
	^element
! !

!InlinedDictionary methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOf: element ifAbsent: aBlock
	self keysAndValuesDo: [:key :value | value = element ifTrue: [^key]].
	^aBlock value
! !

!InlinedDictionary methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
values
	| values |
	values := Bag new.
	self do: [:element | values add: element].
	^values
! !

!InlinedDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationsDo: aBlock
	table keysAndValuesDo: [:key :value | | assoc |
		assoc := Association key: key value: value.
		aBlock evaluateWith: assoc]
! !

!InlinedDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
do: aBlock
	table keysAndValuesDo: [:key :value | aBlock evaluateWith: value]
! !

!InlinedDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keysAndElementsDo: aBlock
	self keysAndValuesDo: aBlock
! !

!InlinedDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keysAndValuesDo: aBlock
	table keysAndValuesDo: aBlock
! !

!InlinedDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keysDo: aBlock
	table keysAndValuesDo: [:key :value | aBlock evaluateWith: key]
! !

!InlinedDictionary methodsFor: 'adding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAdd: anAssociation
	self at: anAssociation key put: anAssociation value.
	^anAssociation
! !

!InlinedDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bucketClass
	^InlinedHashTable
! !

!InlinedDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
equates: key with: element
	^key = element
! !

!InlinedDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyFor: anObject
	^anObject
! !

!InlinedDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
storesAssociations
	^false
! !

!InlinedDictionary methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyAtValue: anObject ifAbsent: aBlock
	1 to: table size by: 2 do: [:index | 
		(table at: index + 1) = anObject
			ifTrue: [(table at: index) ifNotNil: [:k | ^k]]].
	^aBlock value
! !

!Namespace methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_namespaceLookup: aSymbol
	| table |
	table := namespace _basicAt: 2.
	2
		to: table _size
		do: [:j | | assoc |
			assoc := (table _basicAt: j).
			assoc == nil ifFalse: [
				assoc key == aSymbol
					ifTrue: [^table _basicAt: j + 1]]].
	^nil
! !

!Namespace class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new
	^super new
! !

!WeakIdentityDictionary methodsFor: 'adding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
add: anAssociation
	self ASSERT: anAssociation class == Ephemeron.
	^self critical: [super add: anAssociation]
! !

!WeakIdentityDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationClass
	^Ephemeron new registry: self
! !

!WeakIdentityDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
critical: aBlock
	| save |
	save := critical.
	critical := true.
	^[aBlock value] ensure: [critical := save]
! !

!WeakIdentityDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
equates: element with: ephemeron
	^element == ephemeron key
! !

!WeakIdentityDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hashFor: element
	^element basicHash
! !

!WeakIdentityDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyCollector
	^IdentitySet new: self size
! !

!WeakIdentityDictionary methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
rescue: anEphemeron
	critical
		ifTrue: [anEphemeron activate]
		ifFalse: [self removeKey: anEphemeron key ifAbsent: nil]
! !

!WeakIdentityDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationsDo: aBlock
	self critical: [
		super associationsDo: [:ephemeron | | hold |
			hold := ephemeron key.
			hold notNil ifTrue: [aBlock value: ephemeron]]]
! !

!WeakIdentityDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
do: aBlock
	self associationsDo: [:assoc | aBlock evaluateWith: assoc value]
! !

!WeakIdentityDictionary methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
ephemeronsDo: aBlock
	self associationsDo: aBlock
! !

!WeakIdentityDictionary methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
onTable: aHashTable
	critical := false.
	super onTable: aHashTable
! !

!HashedCollection methodsFor: 'adding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
add: element
	(table atKey: element put: element) == nil ifTrue: [self incrementTally].
	^element
! !

!HashedCollection methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: anInteger
	^self errorNotIndexable
! !

!HashedCollection methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: anInteger put: anObject
	^self errorNotIndexable
! !

!HashedCollection methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bucketClass
	^OpenHashTable
! !

!HashedCollection methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyFor: anObject
	^anObject
! !

!HashedCollection methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
policy
	^table notNil ifTrue: [table policy] ifFalse: [self]
! !

!HashedCollection methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
size
	^tally
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAdd: element
	tally := tally + 1.
	table basicAtKey: element put: element.
	^element
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bucketOfSize: anInteger
	^(self bucketClass new: anInteger) owner: self
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
contentOfSize: anInteger
	^self policy == self
		ifTrue: [(self bucketClass new: anInteger) owner: self]
		ifFalse: [self policy contentOfSize: anInteger]
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
contents
	^table
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
defaultPolicy
	^HashTablePolicy new
		storesAssociations: self storesAssociations;
		bucketClass: self bucketClass
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
emptySlot
	^nil
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
equates: key with: element
	^key = element
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
grow
	self resizeTo: tally * 2
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hashFor: anObject
	^anObject hash
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
incrementTally
	tally := tally + 1.
	(table isCapacityGreaterThan: tally) ifFalse: [self grow]
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
maxSlots
	^self policy == self ifFalse: [self policy maxSlots]
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
resizeTo: anInteger
	| copy t policy n |
	n := self class sizeFor: anInteger.
	t := self contentOfSize: n.
	copy := self class on: t.
	policy := self policy.
	policy == self ifFalse: [
		self ASSERT: policy class == HashTablePolicy.
		copy usePolicy: policy copy].
	self rebuildOn: copy.
	policy == self ifTrue: [table policy: self] ifFalse: [table policy: policy]
! !

!HashedCollection methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
table
	^table
! !

!HashedCollection methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicDo: aBlock
	table elementsDo: aBlock count: tally
! !

!HashedCollection methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
do: aBlock
	self basicDo: aBlock
! !

!HashedCollection methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
beWeak
	| policy |
	policy := self policy.
	policy == self ifTrue: [policy := self defaultPolicy].
	policy useWeakSlots.
	table beWeak.
	self usePolicy: policy
! !

!HashedCollection methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
maxSlots: anInteger
	| policy |
	policy := self policy.
	policy == self ifTrue: [policy := self defaultPolicy].
	policy maxSlots: anInteger.
	self usePolicy: policy
! !

!HashedCollection methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
rehash
	tally isNil ifTrue: [tally := table count].
	self resizeTo: tally
! !

!HashedCollection methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
useDefaultPolicy
	table policy == self ifTrue: [^self].
	table policy: self.
	self notEmpty ifTrue: [self rehash]
! !

!HashedCollection methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
useIdentityHash
	| policy |
	policy := self defaultPolicy.
	policy useIdentityHash.
	self usePolicy: policy
! !

!HashedCollection methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
usePolicy: aHashTablePolicy
	table isNil ifTrue: [^self].
	table policy: aHashTablePolicy.
	aHashTablePolicy usesWeakSlots
		ifTrue: [self class registerPolicy: aHashTablePolicy for: self].
	self notEmpty ifTrue: [self rehash]
! !

!HashedCollection methodsFor: 'copying' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
copy
	| copy |
	copy := super copy.
	table policy == self ifTrue: [copy useDefaultPolicy] ifFalse: [
		self ASSERT: table policy class == HashTablePolicy.
		copy usePolicy: table policy copy].
	^copy
! !

!HashedCollection methodsFor: 'copying' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
postCopy
	super postCopy.
	table := table copy
! !

!HashedCollection methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize: anInteger
	| t |
	t := self contentOfSize: anInteger.
	self onTable: t
! !

!HashedCollection methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeWeakSize: anInteger
	self initialize: anInteger.
	table beWeak
! !

!HashedCollection methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
onTable: aHashTable
	tally := 0.
	table := aHashTable
! !

!HashedCollection methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
occurrencesOf: anObject
	^(self includes: anObject) ifTrue: [1] ifFalse: [0]
! !

!HashedCollection methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
remove: anObject ifAbsent: aBlock
	table removeKey: anObject ifAbsent: [^aBlock value].
	tally := tally - 1.
	^anObject
! !

!HashedCollection methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeAll
	tally = 0 ifTrue: [^self].
	table removeAll.
	tally := 0
! !

!HashedCollection methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeAll: aCollection
	^self removeAll: aCollection ifAbsent: [self errorNotFound]
! !

!HashedCollection methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeAll: aCollection ifAbsent: aBlock
	| n |
	n := aCollection size.
	table removeKeys: aCollection ifAbsent: [
		n := n - 1.
		aBlock value].
	tally := tally - n.
	^aCollection
! !

!HashedCollection methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
storesAssociations
	^false
! !

!HashedCollection methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
usesWeakSlots
	| p |
	p := self policy.
	^p !!== self and: [p usesWeakSlots]
! !

!HashedCollection class methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializePolicies
	Policies := WeakIdentityDictionary new
! !

!HashedCollection class methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
registerPolicy: aHashTablePolicy for: aHashedCollection
	Policies at: aHashedCollection put: aHashTablePolicy
! !

!HashedCollection class methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeFor: anInteger
	^7 max: anInteger * 3 // 2
! !

!HashedCollection class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new
	^self new: 5
! !

!HashedCollection class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger
	| size |
	size := self sizeFor: anInteger.
	^self basicNew initialize: size
! !

!HashedCollection class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger using: aHashedCollectionPolicy
	| size |
	size := self sizeFor: anInteger.
	^self basicNew
		onTable: (aHashedCollectionPolicy contentOfSize: size);
		usePolicy: aHashedCollectionPolicy
! !

!HashedCollection class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
on: aHashTable
	^self new onTable: aHashTable
! !

!HashedCollection class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
withAll: aCollection
	| instance |
	instance := self new: aCollection size.
	^instance addAll: aCollection; yourself
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beFatal
	resumable := retryable := false
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beResumable
	resumable := true
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beWarning
	resumable := true
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler
	^compiler
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler: aCompiler
	compiler := aCompiler.
	compiler result error: self
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
description: aString
	description := aString
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isResumable
	^resumable

! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
proceed
	retryable := false.
	compiler result beSuccessful.
	self isResumable ifTrue: [ self resume ] ifFalse: [ self return ]
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
source
	^compiler sourceCode copyFrom: stretch start to: stretch end
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stretch
	^stretch
! !

!SCompilationError methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stretch: aStretch
	stretch := aStretch
! !

!SCompilationError methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isUndeclaredAccess
	^false
! !

!SCompilationError methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isUndeclaredAssignment
	^ false
! !

!SUndeclaredIdentifierError methodsFor: 'accessing-token' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assignment: aBoolean
	assigned := aBoolean
! !

!SUndeclaredIdentifierError methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
identifier
	^ identifier
! !

!SUndeclaredIdentifierError methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isUndeclaredAccess
	^assigned not
! !

!SUndeclaredIdentifierError methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isUndeclaredAssignment
	^assigned
! !

!SUndeclaredIdentifierError methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stretch: aStretch
	super stretch: aStretch.
	identifier := self source
! !

!StackOverflow methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
defaultDescription
	^'Stack overflow'
! !

!LMRFloat methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
* aNumber
	| new result |
	aNumber isFloat ifFalse: [^self * aNumber asFloat].
	new := Float new.
	result := self _floatMultiply: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'*' status: result
! !

!LMRFloat methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
+ aNumber
	| new result |
	aNumber isFloat ifFalse: [^aNumber addTo: self].
	new := Float new.
	result := self _floatPlus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'+' status: result
! !

!LMRFloat methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
- aNumber
	| new result |
	aNumber isFloat ifFalse: [^self - aNumber asFloat].
	new := Float new.
	result := self _floatMinus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'-' status: result
! !

!LMRFloat methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
/ aNumber
	| new result |
	aNumber isFloat ifFalse: [^self / aNumber asFloat].
	new := Float new.
	result := self _floatQuotient: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'/' status: result
! !

!LMRFloat methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
timesTwoPower: anInteger
	| result status |
	result := self copy.
	status := result _timesTwoPower: anInteger asFloat.
	(Float hasErrorFlag: status) ifFalse: [^result].
	self errorOn: #timesTwoPower status: status
! !

!LMRFloat methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
truncated
	| result |
	result := self _floatTruncated.
	(result notNil and: [result = 0 or: [result sign = self sign]])
		ifTrue: [^result].
	self isSpecialValue ifTrue: [^self].
	^self abs < 2.0e16
		ifTrue: [| q r |
			q := self quo: 536870912.0.
			"((SmallInteger largestPositive bitShift: -1) + 1) asFloat"
			r := self - (q asFloat * 536870912.0).
			q * 536870912 + r truncated]
		ifFalse: [self asTrueFraction]
! !

!LMRFloat methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
< aNumber
	| result |
	aNumber isFloat ifFalse: [^self < aNumber asFloat].
	result := self _floatLessThan: aNumber.
	result _isSmallInteger ifFalse: [^result].
	^self errorOn: #'<' status: result
! !

!LMRFloat methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
= aNumber
	| result nan equal |
	aNumber isFloat
		ifFalse: [^aNumber isNumber
			ifTrue: [self = aNumber asFloat]
			ifFalse: [false]].
	result := self _floatEquals: aNumber.
	result _isSmallInteger ifFalse: [^result].
	nan := self isNaN.
	equal := nan == aNumber isNaN.
	equal ifFalse: [^false].
	nan ifTrue: [^true].
	^self errorOn: #'=' status: result
! !

!LMRFloat methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: index
	^self basicByteAt: index
! !

!LMRFloat methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAt: index
	^self basicByteAt: index
! !

!LMRFloat methodsFor: 'random' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fractionPart
	| new result |
	new := Float new.
	result := self _floatFractionPartInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #fractionPart status: result
! !

!LMRFloat methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
significand
	| result new |
	new := Float new.
	result := self _floatSignificandInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #significand status: result
! !

!LMRFloat methodsFor: 'functions' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sqrt
	| sqrt result |
	sqrt := Float new.
	result := self _floatSqrtInto: sqrt.
	"_floatSqrtInto returns error status in result if any, else the result itself"
	result == sqrt ifTrue: [^result].
	^self errorOn: #sqrt status: result
! !

!LMRFloat class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromInteger: anInteger
	| result |
	result := Float new.
	anInteger _isSmallInteger ifTrue: [
		anInteger _asFloatInto: result.
		^result].
	anInteger isInteger
		ifTrue: [^(self fromInteger: (anInteger bitShift: -24)) * 16r1000000 asFloat
			+ (self fromInteger: (anInteger bitAnd: 16rFFFFFF))]
		ifFalse: [self error: 'number is not an integer']
! !

!LMRFloat class methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialControlAndStatusFlags
	"
	FIXME: ONLY X64 SUPPORTED FOR NOW
	We initialize MXCSR with all sticky bits clean (0-5), all exceptions masked (7-12),
	and denormal arguments of operations treated as zero (bit 6).
	We don't flush denormal results to zero (bit 15), but should think about it.
	"
	^0x1FC0
! !

!LMRFloat class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeStatus
	"
	this has to be done fairly early at startup, before
	doing any float operation, because float operations
	try to use this value, which must be already initialized
	to what the OS put in MXCSR (or equivalent) register
	"
	Status isNil ifTrue: [Status := ByteArray new: 4].
	Status uLongAtOffset: 0 put: self status
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
* aNumber
	^aNumber class == self class
		ifTrue: [aNumber multiplyScaledDecimal: self]
		ifFalse: [self retry: #'*' with: aNumber]
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
+ aNumber
	^aNumber class == self class
		ifTrue: [aNumber addToScaledDecimal: self]
		ifFalse: [self retry: #'+' with: aNumber]
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
- aNumber
	^aNumber class == self class
		ifTrue: [aNumber subtractFromScaledDecimal: self]
		ifFalse: [self retry: #'-' with: aNumber]
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
/ aNumber
	^aNumber class == self class
		ifTrue: [aNumber divideIntoScaledDecimal: self]
		ifFalse: [self retry: #'/' with: aNumber]
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
// aNumber
	| q quo |
	q := self / aNumber.
	quo := q floor.
	^(q negative andNot: [q = quo]) ifTrue: [quo] ifFalse: [quo - 1]
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
negated
	^self class fromNumber: self asFraction negated scale: scale
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
raisedTo: aNumber
	| fraction |
	fraction := super raisedTo: aNumber.
	^self class fromNumber: fraction scale: scale
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
raisedToInteger: aNumber
	| fraction |
	fraction := super raisedToInteger: aNumber.
	^self class fromNumber: fraction scale: scale
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
reciprocal
	^self class fromNumber: self asFraction reciprocal scale: scale
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sqrt
	| sqrt |
	sqrt := self asFraction sqrt.
	^sqrt isFloat
		ifTrue: [sqrt]
		ifFalse: [ScaledDecimal fromNumber: sqrt scale: scale]
! !

!ScaledDecimal methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
squared
	^super squared scale: scale
! !

!ScaledDecimal methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
< aNumber
	aNumber = 0 ifTrue: [^numerator < 0].
	^self - aNumber < 0
! !

!ScaledDecimal methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
<= aNumber
	^self < aNumber or: [self = aNumber]
! !

!ScaledDecimal methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
= aNumber
	self class == aNumber class ifTrue: [^self asFraction = aNumber asFraction].
	^self asFraction = aNumber
! !

!ScaledDecimal methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
> aNumber
	aNumber = 0 ifTrue: [^numerator > 0].
	^self - aNumber > 0
! !

!ScaledDecimal methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
>= aNumber
	^self > aNumber or: [self = aNumber]
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addToScaledDecimal: aScaledDecimal
	| s den fraction |
	s := self scale max: aScaledDecimal scale.
	den := aScaledDecimal denominator.
	fraction := denominator = den
		ifTrue: [
			self class
				numerator: numerator + aScaledDecimal numerator
				denominator: denominator]
		ifFalse: [
			self class
				numerator: numerator * den + (aScaledDecimal numerator * denominator)
				denominator: denominator * den].
	^fraction scale: s; reduced
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
coerce: aNumber
	^self class fromNumber: aNumber scale: scale
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
divideIntoScaledDecimal: aScaledDecimal
	| s fraction |
	s := scale max: aScaledDecimal scale.
	fraction := self class
		numerator: aScaledDecimal numerator * denominator
		denominator: aScaledDecimal denominator * numerator.
	^fraction scale: s; reduced
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
multiplyScaledDecimal: aScaledDecimal
	| s fraction |
	s := scale max: aScaledDecimal scale.
	fraction := self class
		numerator: aScaledDecimal numerator * numerator
		denominator: aScaledDecimal denominator * denominator.
	^fraction scale: s; reduced
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
reduced
	| gcd |
	gcd := numerator gcd: denominator.
	gcd = 1 ifTrue: [^self].
	^self class
		numerator: numerator // gcd
		denominator: denominator // gcd
		scale: self scale
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
retry: selector with: argument
	^argument isFloat
		ifTrue: [(argument coerce: self) perform: selector with: argument]
		ifFalse: [self perform: selector with: (self coerce: argument)]
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
setNumerator: num denominator: den scale: s
	den = 0 ifTrue: [^self zeroDivisorOn: #setNumerator:denominator:scale:].
	denominator := den truncated abs.
	den negative ifTrue: [numerator := numerator negated].
	numerator := num truncated.
	scale := s truncated
! !

!ScaledDecimal methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
subtractFromScaledDecimal: aScaledDecimal
	| s den fraction |
	s := scale max: aScaledDecimal scale.
	den := aScaledDecimal denominator.
	fraction := denominator = den
		ifTrue: [
			self class
				numerator: aScaledDecimal numerator - numerator
				denominator: denominator]
		ifFalse: [
			self class
				numerator: aScaledDecimal numerator * denominator - (numerator * den)
				denominator: denominator * den].
	^fraction scale: s; reduced
! !

!ScaledDecimal methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asFloat
	^numerator asFloat / denominator
! !

!ScaledDecimal methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asFraction
	^Fraction numerator: numerator denominator: denominator
! !

!ScaledDecimal methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isFraction
	^false
! !

!ScaledDecimal methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printOn: aStream
	| scaler scaled quo rem |
	scaler := 10 raisedToInteger: scale.
	scaled := numerator * scaler + (denominator bitShift: -1) // denominator.
	numerator < 0 ifTrue: [
		aStream nextPut: $-.
		scaled := scaled negated].
	quo := scaled // scaler.
	rem := scaled \\ scaler.
	quo printOn: aStream.
	scale > 0 ifTrue: [aStream nextPut: $.].
	scale timesRepeat: [
		rem := rem * 10.
		aStream nextPut: (Character digitValue: rem // scaler).
		rem := rem \\ scaler].
	aStream nextPut: $s; nextPutAll: scale asString
! !

!ScaledDecimal methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
storeOn: aStream
	(denominator = 1 or: [(10 raisedTo: scale) \\ denominator = 0])
		ifTrue: [^self printOn: aStream].
	numerator storeOn: aStream.
	aStream nextPut: $/.
	denominator storeOn: aStream.
	aStream nextPut: $s; nextPutAll: scale asString
! !

!ScaledDecimal methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
scale
	^scale
! !

!ScaledDecimal methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
scale: anInteger
	scale := anInteger
! !

!ScaledDecimal class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromNumber: aNumber scale: anInteger
	| fraction |
	fraction := aNumber asFraction.
	^self
		numerator: fraction numerator
		denominator: fraction denominator
		scale: anInteger
! !

!ScaledDecimal class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fromString: aString
	| value i n num den |
	value := super fromString: aString.
	value class == self ifTrue: [^value].
	i := aString indexOf: $..
	i = 0 ifTrue: [^self fromNumber: value scale: 0].
	n := aString size - i.
	num := (aString copyWithout: $.) asInteger.
	den := 10 raisedToInteger: n.
	^self fromNumber: num / den scale: n
! !

!ScaledDecimal class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
numerator: numerator denominator: denominator scale: scale
	"
	ScaledDecimal numerator: 1 denominator: 3 scale: 2
	"
	^(self numerator: numerator denominator: denominator) scale: scale
! !

!ArgParser methodsFor: 'commands' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
addCommand: aCommand
	commands at: aCommand name put: aCommand
! !

!ArgParser methodsFor: 'options' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
addGlobalOption: anOption
	globalOptions add: anOption
! !

!ArgParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
description
	^description
! !

!ArgParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
description: aString
	description := aString
! !

!ArgParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
name
	^name
! !

!ArgParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
name: aString
	name := aString
! !

!ArgParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
extractGlobalArgs: args
	| remaining i |
	remaining := OrderedCollection new.
	i := 1.
	[i <= args size] whileTrue: [
		| arg match rest |
		arg := args at: i.
		match := globalOptions detect: [:opt | opt matches: arg] ifNone: [nil].
		match ifNotNil: [
			match hasValue ifTrue: [i := i + 1]
		] ifNil: [
			rest := args copyFrom: i to: args size.
			^remaining addAll: rest; yourself].
		i := i + 1].
	^remaining
! !

!ArgParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
parse: args
	| remaining key command result tail |
	remaining := self extractGlobalArgs: args.
	remaining isEmpty ifTrue: [self printHelp. ^nil].
	key := remaining first.
	command := commands at: key ifAbsent: [
		self error: 'Unknown command: ', key, '. Run with no args for help.'].
	result := ParseResult new.
	result command: key.
	tail := remaining copyFrom: 2 to: remaining size.
	command parse: tail into: result.
	command action ifNotNil: [:act | act value: result].
	^result
! !

!ArgParser methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
initialize
	commands := OrderedDictionary new.
	globalOptions := OrderedCollection new
! !

!ArgParser methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
printHelp
	| text |
	text := name ifNil: ['command'].
	description ifNotNil: [
		text := text , ' - ' , description].
	text := text , String cr , String cr , 'Commands:' , String cr.
	commands keysAndValuesDo: [:key :cmd |
		text := text , '  ' , key.
		cmd description ifNotNil: [:d |
			text := text , '  - ' , d].
		text := text , String cr].
	Kernel log: text
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
action
	^action
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
action: aBlock
	action := aBlock
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
description
	^description
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
description: aString
	description := aString
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
name
	^name
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
name: aString
	name := aString
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
options
	^options
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
positionalNames
	^positionalNames
! !

!Command methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
subcommands
	^subcommands
! !

!Command methodsFor: 'configuration' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
addOption: anOption
	options add: anOption
! !

!Command methodsFor: 'configuration' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
addPositional: aString
	positionalNames add: aString
! !

!Command methodsFor: 'configuration' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
addSubcommand: aCommand
	subcommands at: aCommand name put: aCommand
! !

!Command methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
applyDefaults: aResult
	options do: [:opt |
		(aResult hasOption: opt name) ifFalse: [
			opt defaultValue ifNotNil: [:v |
				aResult setOption: opt name to: v]]]
! !

!Command methodsFor: 'private' stamp: 'KenD 1/Jul/2026, 7:35:08 pm (UTC)'!
checkRequired: aResult
	options do: [:opt |
		| aName |
		aName := opt long ifNil: [opt short].
		(opt required and: [(aResult hasOption: opt name) not])
			ifTrue: [self error: 'Required option missing: ', aName]]
! !

!Command methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
findOption: aString
	^options detect: [:opt | opt matches: aString] ifNone: [nil]
! !

!Command methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
hasSubcommands
	^subcommands notEmpty
! !

!Command methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
initialize
	options := OrderedCollection new.
	positionalNames := OrderedCollection new.
	subcommands := OrderedDictionary new
! !

!Command methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
parse: args into: result
	| i |
	i := 1.
	[i <= args size] whileTrue: [
		| arg |
		arg := args at: i.
		(arg first = $-)
			ifTrue: [i := self parseOption: arg from: args at: i into: result]
			ifFalse: [result addPositional: arg].
		i := i + 1].
	self checkRequired: result.
	self applyDefaults: result
! !

!Command methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
parseOption: aString from: anArray at: anInteger into: aResult
	| opt |
	opt := self findOption: aString.
	opt ifNil: [self error: 'Unknown option: ', aString].
	opt hasValue ifTrue: [
		| val next |
		next := anInteger + 1.
		next > anArray size ifTrue: [self error: 'Option ', aString, ' requires a value'].
		val := anArray at: next.
		aResult setOption: opt name to: val.
		^next]
	ifFalse: [
		aResult setOption: opt name to: true].
	^anInteger
! !

!Command methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
printUsageOn: aStream
	aStream nextPutAll: name.
	positionalNames do: [:pname |
		aStream nextPutAll: ' <'; nextPutAll: pname; nextPut: $>].
	options do: [:opt |
		aStream nextPutAll: ' ['.
		opt short ifNotNil: [:s | aStream nextPutAll: s].
		(opt short notNil and: [opt long notNil]) ifTrue: [aStream nextPutAll: '|'].
		opt long ifNotNil: [:l | aStream nextPutAll: l].
		opt hasValue ifTrue: [aStream nextPutAll: ' <value>'].
		aStream nextPut: $]]
! !

!Option methodsFor: 'configuration' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
beFlag
	hasValue := false.
	defaultValue := false
! !

!Option methodsFor: 'configuration' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
beRequired
	required := true
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
defaultValue
	^defaultValue
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
defaultValue: anObject
	defaultValue := anObject
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
description
	^description
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
description: aString
	description := aString
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
long
	^long
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
long: aString
	long := aString
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
name
	long ifNotNil: [^long copyFrom: 3].
	^short copyFrom: 2
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
short
	^short
! !

!Option methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
short: aString
	short := aString
! !

!Option methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
hasValue
	^hasValue
! !

!Option methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
matches: aString
	^aString = short or: [aString = long]
! !

!Option methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
required
	^required
! !

!Option methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
initialize
	required := false.
	hasValue := true.
	defaultValue := nil
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
addPositional: aString
	positionals add: aString
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
command
	^command
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
command: aString
	command := aString
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
optionAt: aString
	^options at: aString ifAbsent: [nil]
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
optionAt: aString ifAbsent: aBlock
	^options at: aString ifAbsent: aBlock
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
options
	^options
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
positionalAt: anInteger
	^positionals at: anInteger
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
positionals
	^positionals
! !

!ParseResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
setOption: aString to: aValue
	options at: aString put: aValue
! !

!ParseResult methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
hasOption: aString
	^options includesKey: aString
! !

!ParseResult methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
initialize
	positionals := OrderedCollection new.
	options := OrderedDictionary new
! !

!MethodSpec methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
= aMethodSpec
	^aMethodSpec class = self class
		and: [aMethodSpec selector == selector]
		and: [aMethodSpec classBinding = class]
! !

!MethodSpec methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
hash
	^class name hash hashWith: selector
! !

!MethodSpec methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
asCompiledMethod
	self canBeCompiled ifFalse: [^nil].
	^self
		propertyAt: #compiledMethod
		ifAbsentPut: [self compiler compileMethod: source]
! !

!MethodSpec methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
ast
	self canBeCompiled ifFalse: [^nil].
	^ast ifNil: [ast := self compiler parseMethod: source]
! !

!MethodSpec methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cannonicalAst
	^self halt propertyAt: #cannonicalAst ifAbsentPut: [self ast]
! !

!MethodSpec methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
referencedIdentifiers
	^self ast ifNil: [#()] ifNotNil: [:node | node identifiers]
! !

!MethodSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
bytecodes
	^self canBeCompiled ifTrue: [self asCompiledMethod bytecodes]
! !

!MethodSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
classname
	^class name
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
canBeCompiled
	^self compiler notNil
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
canBeParsed
	^self cannonicalAst notNil
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
equals: aMethodSpec
	^self canBeCompiled
		and: [aMethodSpec canBeCompiled]
		and: [self isFrameless not]
		and: [self isEquivalentTo: aMethodSpec]
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isEquivalentTo: aMethodSpec
	| m1 m2 |
	selector == aMethodSpec selector ifFalse: [^false].
	class == aMethodSpec classBinding ifFalse: [^false].
	m1 := self asCompiledMethod.
	m1 isNil ifTrue: [^false].
	m2 := aMethodSpec asCompiledMethod.
	m2 isNil ifTrue: [^false].
	^m1 equals: m2
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isExtension
	^class isExtension
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isFrameless
	^self halt asCompiledMethod isFrameless
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
referencesIdentifier: aString
	^self referencedIdentifiers
		anySatisfy: [:identifier | identifier name = aString]
! !

!MethodSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
usesInstanceVariableNamed: aString
	^(self ast variableNamed: aString) notNil
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
category
	^self isExtension
		ifTrue: ['*' , (module name readStream upToLast: $-)]
		ifFalse: [category]
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
category: aString
	category := aString
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
classBinding
	^class
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
classBinding: aSpeciesSpec
	class := aSpeciesSpec
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
module
	^module
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
module: aModuleSpec
	module := aModuleSpec
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeFromClass
	class removeMethod: self
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
selector
	^selector
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
selector: aSymbol
	selector := aSymbol
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
source
	^source
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
source: aString
	source := aString.
	ast := nil
! !

!MethodSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
sourceCode
	^source
! !

!MethodSpec methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: class name asString , '>>#' , selector asString
! !

!MethodSpec methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
resolveClass
	^module resolveClass: class name
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addClass: aClassSpec
	classes add: aClassSpec
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addClassExtension: aClassSpec
	extendedClasses add: aClassSpec
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addClasses: aCollection
	aCollection do: [:c | self addClass: c]
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addDependencies: aCollection
	aCollection keysAndValuesDo: [:dep :objects | 
		dependencies
			at: dep
			put: objects
			ifPresent: [:current | (current addAll: objects) withoutDuplicates]]
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addSubclassifiedClass: aClassSpec
	subclassifiedClasses addIfAbsent: aClassSpec
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
associationAt: aSymbol ifAbsent: aBlock
	^imports associationAt: aSymbol ifAbsent: aBlock
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cleanDependencies
	| needed |
	needed := OrderedCollection new.
	self methodReferences keys do: [:identifier | needed add: identifier name].
	self hierarchyReferences keys
		do: [:identifier | needed add: identifier name].
	extendedClasses do: [:c | needed add: c name].
	dependencies copy keysAndValuesDo: [:module :identifiers | 
		(identifiers keys anySatisfy: [:identifier | needed includes: identifier])
			ifFalse: [dependencies removeKey: module]]
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
hierarchyReferences
	| references |
	references := Dictionary new.
	self allClassesDo: [:c | | list |
		c superclass ifNotNil: [
			list := references at: c superclass ifAbsentPut: [OrderedCollection new].
			list add: c]].
	^references
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
methodReferences
	| references |
	references := Dictionary new.
	self allMethodsDo: [:m | 
		m referencedIdentifiers reject: #isLocal thenDo: [:identifier | | list |
			list := references at: identifier ifAbsentPut: [OrderedCollection new].
			list add: m]].
	^references
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream
		nextPut: $<;
		print: name;
		nextPutAll: '> module'
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeCategory: aSymbol inClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	class removeCategory: aSymbol
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	classes remove: class ifAbsent: nil
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeEmptyExtensions
	extendedClasses copy
		reject: #hasMethods
		thenDo: [:c | extendedClasses remove: c]
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeExtendedClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	extendedClasses remove: class ifAbsent: nil
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeMethod: aMethodSpec
	self ASSERT: (self includesClass: aMethodSpec classBinding).
	aMethodSpec classBinding removeMethod: aMethodSpec
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeSelectors: aCollection
	self allClassesDo: [:c | 
		c removeSelectors: aCollection.
		c metaclass removeSelectors: aCollection]
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeSelectors: aCollection inClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	class removeSelectors: aCollection
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeSelectors: aCollection inScope: aClassSpec
	| class all |
	class := self resolveClass: aClassSpec.
	all := self withAllSubclasses: class.
	all do: [:c | c removeSelectors: aCollection]
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeSubclassesOf: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	class allSubclasses do: [:c | self removeClass: c; removeExtendedClass: c]
! !

!ModuleSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeSubclassifiedClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	subclassifiedClasses remove: class ifAbsent: nil
! !

!ModuleSpec methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addImport: anAssociation
	imports add: anAssociation
! !

!ModuleSpec methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addImports: aCollection
	aCollection do: [:token | self addImport: token asSymbol -> nil]
! !

!ModuleSpec methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	classes := OrderedCollection new.
	extendedClasses := OrderedCollection new.
	subclassifiedClasses := OrderedCollection new.
	imports := Dictionary new.
	dependencies := Dictionary new
! !

!ModuleSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allClasses
	^classes , extendedClasses
! !

!ModuleSpec methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allClassesDo: aBlock
	classes do: aBlock.
	extendedClasses do: aBlock
! !

!ModuleSpec methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allMethods
	| methods |
	methods := OrderedCollection new.
	self allMethodsDo: [:m | methods add: m].
	^methods
! !

!ModuleSpec methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allMethodsDo: aBlock
	self allClassesDo: [:c | 
		c metaclass methods do: aBlock.
		c methods do: aBlock]
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
at: aSymbol
	^self at: aSymbol ifAbsent: nil
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
at: aSymbol ifAbsent: aBlock
	| string |
	string := aSymbol asString.
	classes do: [:c | c name = string ifTrue: [^c]].
	extendedClasses do: [:c | c name = string ifTrue: [^c]].
	subclassifiedClasses do: [:c | c name = string ifTrue: [^c]].
	^imports at: aSymbol ifAbsent: aBlock
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
classes
	^classes
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
dependencies
	^dependencies
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
dependencies: aDictionary
	dependencies := aDictionary
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
description
	^description
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
description: aString
	description := aString
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
extendedClasses
	^extendedClasses
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name
	^name
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name: aString
	name := aString
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
referencedGlobals
	| referenced |
	referenced := Dictionary new.
	self allMethodsDo: [:m | 
		m referencedIdentifiers
			select: [:identifier | | b |
				b := identifier binding.
				b refersToGlobal or: [b isUnresolved]]
			thenDo: [:global | (referenced
				at: global name
				ifAbsentPut: [OrderedCollection new])
				add: m]].
	^referenced
! !

!ModuleSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
requiredImports
	| required |
	required := Dictionary new.
	self referencedGlobals
		keysAndValuesDo: [:global :dependents | (self definesGlobal: global)
			ifFalse: [required at: global put: dependents]].
	^required
! !

!ModuleSpec methodsFor: 'resolving' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
basicResolveClass: aString
	classes do: [:c | c name asString = aString ifTrue: [^c]].
	extendedClasses do: [:c | c name asString = aString ifTrue: [^c]].
	subclassifiedClasses do: [:c | c name asString = aString ifTrue: [^c]].
	^nil
! !

!ModuleSpec methodsFor: 'resolving' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
definesGlobal: aString
	^classes anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor: 'resolving' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
resolveClass: class
	| moniker metaclass found |
	moniker := class isString ifTrue: [class] ifFalse: [class name].
	metaclass := moniker endsWith: ' class'.
	metaclass ifTrue: [moniker := moniker trimTail: ' class'].
	found := self basicResolveClass: moniker.
	^found ifNotNil: [metaclass ifTrue: [found metaclass] ifFalse: [found]]
! !

!ModuleSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
definesClassNamed: aString
	^classes anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
extendsClassNamed: aString
	^extendedClasses anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
includesClass: aClassSpec
	^(self resolveClass: aClassSpec) notNil
! !

!ModuleSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
subclassifiesClassNamed: aString
	^subclassifiedClasses anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
sortedClasses
	| remaining sorted |
	remaining := classes copy.
	sorted := OrderedCollection new.
	[remaining isEmpty] whileFalse: [| c |
		c := remaining first.
		(remaining includes: c superclass)
			ifTrue: [remaining removeFirst; add: c]
			ifFalse: [
				remaining remove: c.
				sorted add: c]].
	^sorted
! !

!ModuleSpec methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
withAllSubclasses: aClassSpec
	| all |
	all := self allClasses.
	aClassSpec isMetaclass ifTrue: [all := all collect: #metaclass].
	^all select: [:c | c withAllSuperclasses includes: aClassSpec]
! !

!SpeciesSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addMethod: aMethodSpec
	^methods add: aMethodSpec
! !

!SpeciesSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addMethods: aCollection
	aCollection do: [:m | self addMethod: m]
! !

!SpeciesSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeCategory: aSymbol
	methods removeAllSuchThat: [:m | m category == aSymbol]
! !

!SpeciesSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeMethod: aMethodSpec
	methods remove: aMethodSpec ifAbsent: nil
! !

!SpeciesSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeSelector: aSymbol
	methods removeAllSuchThat: [:m | m selector == aSymbol]
! !

!SpeciesSpec methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
removeSelectors: aCollection
	methods removeAllSuchThat: [:m | aCollection includes: m selector]
! !

!SpeciesSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allInstVarNames
	^(self withAllSuperclasses reversed gather: [:c | c instVarNames]) asArray
! !

!SpeciesSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allSharedPools
	| pools |
	pools := Set new.
	self withAllSuperclasses do: [:c | pools addAll: c sharedPools].
	^pools
! !

!SpeciesSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allSuperclasses
	| superclasses |
	superclasses := OrderedCollection new.
	self allSuperclassesDo: [:s | superclasses add: s].
	^superclasses
! !

!SpeciesSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
withAllSuperclasses
	^OrderedCollection with: self withAll: self allSuperclasses
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allSubclasses
	| all |
	all := OrderedCollection new.
	self allSubclassesDo: [:cls | all add: cls].
	^all
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allSubclassesDo: aBlock
	self subclasses do: [:class | 
		aBlock value: class.
		class allSubclassesDo: aBlock]
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
beArrayed
	format := format | IsArrayed
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
beBytes
	format := format | IsBytes
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
instVarNames
	^instanceVariables
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
instVarNames: aCollection
	instanceVariables := aCollection asOrderedCollection
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
ivars: aCollection
	instanceVariables := aCollection asOrderedCollection
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
methods
	^methods
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
module: aModuleSpec
	module := aModuleSpec
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
selectors
	^methods collect: #selector
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
subclasses
	^module allClasses select: [:c | c supername = self name]
! !

!SpeciesSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
withAllSubclasses
	^OrderedCollection with: self withAll: self allSubclasses
! !

!SpeciesSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
hasMethods
	^methods notEmpty
! !

!SpeciesSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
instancesAreArrayed
	^format anyMask: IsArrayed
! !

!SpeciesSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
instancesHavePointers
	^(format anyMask: IsBytes) not
! !

!SpeciesSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isExtension
	^module extendedClasses includes: self instanceClass
! !

!SpeciesSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isMetaclass
	^false
! !

!SpeciesSpec methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	super initialize.
	methods := OrderedCollection new.
	instanceVariables := #().
	format := 0
! !

!SpeciesSpec methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: '<' , self name , '>'
! !

!SpeciesSpec class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initializeFormatMasks
	self addNamespaceAs: #Format.
	Format
		at: 'IsArrayed' put: 0x1;
		at: 'IsBytes' put: 0x2
! !

!ClassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allMethods
	^methods & metaclass methods
! !

!ClassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
classVarNames
	^classVariables keys
! !

!ClassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
metaMethods
	^metaclass methods
! !

!ClassSpec methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allSuperclassesDo: aBlock
	| s |
	supername isNil ifTrue: [^self].
	s := self superclass.
	s isNil ifTrue: [^self].
	aBlock value: s.
	s allSuperclassesDo: aBlock
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
classVariables
	^classVariables
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
configureCompiler: aCompiler
	
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cvarNames: aCollection
	aCollection do: [:cvar | classVariables at: cvar put: nil]
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cvars: aCollection
	classVariables := aCollection
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
instanceClass
	^self
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isPointers
	^pointers
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isPointers: aBoolean
	pointers := aBoolean
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isVariable
	^variable
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isVariable: aBoolean
	variable := aBoolean
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
metaclass
	^metaclass
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
metaclass: aMetaclassSpec
	metaclass := aMetaclassSpec
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name
	^name
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name: aString
	name := aString
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
sharedPools
	^sharedPools
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
sharedPools: aCollection
	sharedPools addAll: aCollection
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
superclass
	supername ifNil: [^nil].
	^module resolveClass: supername
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
supername
	^supername
! !

!ClassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
supername: aString
	supername := aString
! !

!ClassSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
hasMethods
	^super hasMethods or: [metaclass hasMethods]
! !

!ClassSpec methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	super initialize.
	classVariables := OrderedDictionary new.
	sharedPools := OrderedCollection new
! !

!MetaclassSpec methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
allSuperclassesDo: aBlock
	| s c |
	class supername isNil ifTrue: [
		c := module resolveClass: 'Class'.
		c ifNil: [c := Class].
		c allSuperclassesDo: aBlock].
	s := self superclass.
	s isNil ifTrue: [^self].
	aBlock value: s.
	s allSuperclassesDo: aBlock
! !

!MetaclassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
classVarNames
	^class classVarNames
! !

!MetaclassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
metaMethods
	^#()
! !

!MetaclassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name
	^class name , ' class'
! !

!MetaclassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
sharedPools
	^class sharedPools
! !

!MetaclassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
superclass
	^class superclass ifNotNil: [:c | c metaclass]
! !

!MetaclassSpec methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
supername
	^self superclass name
! !

!MetaclassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
instanceClass
	^class
! !

!MetaclassSpec methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
instanceClass: aClassSpec
	class := aClassSpec
! !

!MetaclassSpec methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isMetaclass
	^true
! !

!Assembler methodsFor: 'labels' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
@ label
	self addLabel: label
! !

!Assembler methodsFor: 'labels' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addLabel: aString
	self addLabel: aString to: self currentAddress
! !

!Assembler methodsFor: 'labels' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addLabel: label to: location
	labels at: label put: location
! !

!Assembler methodsFor: 'labels' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
newLabel
	| label next |
	next := labels size + 1.
	IndexedLabels size < next ifTrue: [self class growIndexedLabelsTo: next].
	label := IndexedLabels at: next.
	self addLabel: label to: nil.
	^label
! !

!Assembler methodsFor: 'labels' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolveLabel: aString
	^labels at: aString
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
add: source1 to: source2andDest
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addImm: imm to: dest
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
alignTo: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
breakpoint
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callIndirectA
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callIndirectM
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callR
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearIntegerBit: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearSafeIntegerBit: srcAndDstReg
	self and: srcAndDstReg withImm: -2
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearSafeRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: reg1 with: reg2
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: register withLiteral: anObject
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareAwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareAwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareSwithTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareTwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareTwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareWithFalse: register
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareWithNil: register
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareWithTrue: register
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popSPindirect
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sub: src2 from: src1AndDst
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subImm: imm from: srcAndDst
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addAtoR
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addDoubleX1toX0
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addTtoR
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
andRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertAtoNativeInteger
	self subclassResponsibility
	
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertRtoNativeInteger
	self subclassResponsibility
	
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertRtoSmallInteger
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertToNativeInteger: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertToSmallInteger: srcAndDstReg
	self shiftLeft: srcAndDstReg byImm: 1; inc: srcAndDstReg
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertTtoNativeInteger
	self subclassResponsibility	
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
exchangeRindirectWithT
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithKnown: anObject
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativeCode
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushSmallInteger: integer
	| smi |
	smi := self smallInteger: integer.
	self pushImm: smi
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
setIntegerBit: srcAndDstReg
	self setSafeIntegerBit: srcAndDstReg
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
setRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
setSafeIntegerBit: srcAndDstReg
	self or: srcAndDstReg withImm: 1
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
setSafeRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLeftRwithT
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLogicalRright: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightRwithT
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRleft: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRright: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftTright: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subAfromR
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subAfromT
	self subclassResponsibility
! !

!Assembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subFromRconstant: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addLiteral: anObject
	| index |
	index := literals
		identityIndexOf: anObject
		ifAbsent: [ literals
				add: anObject;
				size ].
	^ index + 2
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load:dstReg withImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: register withLiteral: anObject
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithGlobal: aSymbol
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadAwithGindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadAwithMindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithR
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithRoffsetAtA
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithS
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithSindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithR
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadFPwithR
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadFPwithSP
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadFalseWithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadFalseWithMindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadFalseWithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadGwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadGwithMindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadGwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithGlobal: aSymbol
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadMwithGindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadNilWithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadNilWithMindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadNilWithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithE
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithFP
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadRwithMindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithM
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithS
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithSPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithSindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithT
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSPwithFP
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTrueWithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadTrueWithMindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTrueWithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadTwithMindex: index
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithR
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadWithFalse: register
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadWithNil: register
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadWithTrue: register
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reserveStackSlots: amount
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
saveCallerFrame
	self pushFP; loadFPwithSP
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testIntegerBit: aRegister
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testIntegerBitOf: aRegister
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testRwithR
	self subclassResponsibility
! !

!Assembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addSPwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addTwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
andRwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
orRwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
xorAwithR
	self subclassResponsibility
! !

!Assembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
xorFPwithFP
	self subclassResponsibility
! !

!Assembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
xorRwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
and: source1andDest with: source2
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
and: source1andDest withImm: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
or: src1AndDst with: src2
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
or: source1andDest withImm: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLeft: srcAndDst by: countReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLeft: srcAndDst byImm: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRight: srcAndDst by: countReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRight: srcAndDst byImm: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightArithmetic: srcAndDst by: countReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightArithmetic: srcAndDst byImm: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
xor: src1AndDst with: src2
	^ self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildFrame
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bytes
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
decRindirect
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
discardArguments: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithGindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithGindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithGindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pop: dstReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
push: srcReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushImm: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushIndirectR
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearFPUFlags
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareEqualDoubleX0withAindirect
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareLessThanDoubleX0withAindirect
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dropTopOfFPU
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
leadingRzeroCount
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLongMwithIPoffset: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMXCSRfromA
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexImm: indexImm
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendShortRwithRoffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
lock
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveTslots
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
readFPUStatusOnA
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scaleFloatOnRWithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeMXCSRintoA
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subTslotsToSP
	self subclassResponsibility
! !

!Assembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
writeTslots
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearRhigh32
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dec: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dropTos: count
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inc: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeS
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithAddressOfRatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLargeX0withRindirect
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLargeX1withAindirect
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLongRwithRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLongSwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRconvertingDoublePointedByR
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithArgPointer
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithAddressOfSatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadX0withRasDouble
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popA
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popE
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popFP
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popFalse
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popG
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popM
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popR
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popS
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popT
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popTrue
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushA
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushE
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushFP
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushFalse
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushG
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushM
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushR
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushS
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushT
	self subclassResponsibility
! !

!Assembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushTrue
	self subclassResponsibility
! !

!Assembler methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: register withBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareWithTrue: register ]
		ifFalse: [ self compareWithFalse: register ]
! !

!Assembler methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareAwithBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareAwithTrue ]
		ifFalse: [ self compareAwithFalse ]
! !

!Assembler methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareRwithTrue ]
		ifFalse: [ self compareRwithFalse ]
! !

!Assembler methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithSmallInteger: anInteger
	| smi |
	smi := self smallInteger: anInteger.
	self compareRwithImmediate: smi
! !

!Assembler methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
smallInteger: anInteger
	^(anInteger bitShift: 1) + 1
! !

!Assembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
currentAddress
	self subclassResponsibility
! !

!Assembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
move: srcReg to: dstReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveImm: imm to: dstReg
	self subclassResponsibility
! !

!Assembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
wordSize
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
divideDoubleX0byX1
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithTIBatR
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithThreadVariableAtR
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveX0toR
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
multiplyDoubleX0byX1
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushAatToffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
roundDoubleX0intoX1
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sqrtDoubleX0
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeAinThreadVariableAtIndexR
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeDoubleResultInRindirect
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTIBatRwithA
	self subclassResponsibility
! !

!Assembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subDoubleX1fromX0
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
extendRtoAandDividebyT
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
multiplyRbyAwideningToA
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeAinTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeByteAinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeByteTinRatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeEinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLargeX0inA
	self subclassResponsibility		
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLargeX0inT
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLongTinRatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLongTinRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinSindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeShortAinRoffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeShortTinRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeSinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTinRatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTinRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfGreaterOrEqualSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfGreaterSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfLessOrEqualSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfLessSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfNotEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfNotZeroTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfOverflowTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfSignTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfZeroTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByte: reg1 from: reg2 atOffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loop: aBlock times: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loopTtimes: aBlock
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
return
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfCarryTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfNotCarryTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfNotEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfNotZeroTo: label
	self shortJumpIfNotEqualTo: label
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfSignTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfZeroTo: label
	self shortJumpIfEqualTo: label
! !

!Assembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpOver: aBlock
	| label |
	label := self newLabel.
	self jumpTo: label.
	aBlock value.
	self @ label
! !

!Assembler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpTo: label
	self subclassResponsibility
! !

!Assembler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpToMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerBitTestOf: aRegister
	| label |
	self testIntegerBitOf: aRegister.
	label := self newLabel.
	self shortJumpIfZeroTo: label.
	^label
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerBitTestOfR
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerBitTestOfT
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerNativizationOf: aRegister
	| label |
	self convertToNativeInteger: aRegister.
	label := self newLabel.
	self shortJumpIfNotCarryTo: label.
	^label
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerNativizationOfA
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerNativizationOfR
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerNativizationOfT
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledNonIntegerBitTestOf: aRegister
	| label |
	self testIntegerBitOf: aRegister.
	label := self newLabel.
	self shortJumpIfNotZeroTo: label.
	^label
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledNonIntegerBitTestOfR
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithSmallInteger: anInteger
	| smi |
	smi := (anInteger bitShift: 1) + 1.
	self loadAwithImmediate: smi
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithRatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithSmallInteger: anInteger
	| smi |
	smi := self smallInteger: anInteger.
	self loadRwithImmediate: smi
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteRwithRatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteRwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteRwithSPatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteTwithAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendLongRwithRatA
	self subclassResponsibility
! !

!Assembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendLongRwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor: 'memory - load / store' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: dstReg fromMem: srcMemRef
	self subclassResponsibility
! !

!Assembler methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
platform: aNativizationPlatform
	self reset
! !

!Assembler methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reset
	labels := Dictionary new: 100.
	literals := OrderedCollection new.
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regA
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regA8
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regE
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFP
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFalse
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regG
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regIP
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regM
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regNil
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regR
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regR8
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regS
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regSP
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regT
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regT8
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regTrue
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regV
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX0
	self subclassResponsibility
! !

!Assembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX1
	self subclassResponsibility
! !

!Assembler methodsFor: 'epilogue' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
restoreCallerEnvironment
	self loadEwithFPindex: -2
! !

!Assembler methodsFor: 'epilogue' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
restoreCallerFrame
	self subclassResponsibility
! !

!Assembler methodsFor: 'epilogue' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
restoreCallerM
	self loadMwithFPindex: -1
! !

!Assembler methodsFor: 'epilogue' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
restoreCallerSelf
	self loadSwithFPindex: 0
! !

!Assembler class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
growIndexedLabelsTo: anInteger
	| new |
	new := (IndexedLabels size + 1 to: anInteger)
		collect: [:i | ('@' , i asString) asSymbol].
	IndexedLabels := IndexedLabels , new
! !

!Assembler class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	self initializeIndexedLabels
	
! !

!Assembler class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeIndexedLabels
	IndexedLabels := #().
	self growIndexedLabelsTo: 100
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
add: source1 to: source2andDest
	codegen add: source1 to: source2andDest
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addImm: imm to: dest
	codegen addImm: imm to: dest
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
alignTo: anInteger
	codegen alignTo: anInteger
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
breakpoint
	codegen breakpoint
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callIndirectA
	| memref |
	memref := codegen memRef: codegen regA indexImm: 1.
	codegen callIndirect: memref
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callIndirectM
	| memref |
	memref := codegen memRef: codegen regM indexImm: 1.
	codegen callIndirect: memref
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callR
	codegen call: codegen regR
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearRintegerBit
	self dec: codegen regR
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearSafeRintegerBit
	self clearSafeIntegerBit: codegen regR
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: reg1 with: reg2
	codegen compare: reg1 with: reg2
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: register withLiteral: anObject
	| index memref |
	index := self addLiteral: anObject.
	memref := codegen memRef: codegen regM indexImm: index.
	codegen compare: register withMem: memref
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareAwithFalse
	codegen compare: codegen regA with: codegen regFalse
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareAwithTrue
	codegen compare: codegen regA with: codegen regTrue
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithA
	codegen compare: codegen regR with: codegen regA
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithFalse
	codegen compare: codegen regR with: codegen regFalse
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithImmediate: imm
	codegen compare: codegen regR withImm: imm
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithNil
	codegen compare: codegen regR with: codegen regNil
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareRwithTrue
	codegen compare: codegen regR with: codegen regTrue
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareSwithTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen compare: codegen regS withMem: memref
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareTwithA
	codegen compare: codegen regT with: codegen regA
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareTwithImmediate: imm
	codegen compare: codegen regT withImm: imm
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareWithFalse: register
	codegen compare: register with: codegen regFalse
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareWithNil: register
	codegen compare: register with: codegen regNil
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareWithTrue: register
	codegen compare: register with: codegen regTrue
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popSPindirect
	| memref |
	memref := codegen memRef: codegen regSP indexImm: 1.
	codegen popIntoMem: memref
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sub: src2 from: src1AndDst
	codegen sub: src2  from: src1AndDst
! !

!GenericAssembler methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subImm: imm from: srcAndDst
	codegen subImm: imm from: srcAndDst
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addAtoR
	codegen add: codegen regA to: codegen regR
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addDoubleX1toX0
	codegen addDouble: codegen regX1 to: codegen regX0

! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addRwithImmediate: imm
	codegen addImm: imm to: codegen regR 
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addTtoR
	codegen add: codegen regT to: codegen regR
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
andRwithImmediate: imm
	codegen and: codegen regR withImm: imm
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertAtoNativeInteger
	self convertToNativeInteger: codegen regA
	
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertRtoNativeInteger
	self convertToNativeInteger: codegen regR
	
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertRtoSmallInteger
	self convertToSmallInteger: codegen regR
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertToNativeInteger: srcAndDstReg
	codegen shiftRightArithmetic: srcAndDstReg byImm: 1
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convertTtoNativeInteger
	self convertToNativeInteger: codegen regT
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
exchangeRindirectWithT
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen exchange: codegen regT withMem: memref
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithKnown: anObject
	codegen breakpoint
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativeCode
	^(NativeCode withAll: literals) code: codegen memory bytes
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
setRintegerBit
	self setIntegerBit: codegen regR
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
setSafeRintegerBit
	self setSafeIntegerBit: codegen regR
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLeftRwithT
	codegen shiftLeft: codegen regR by: codegen regT
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLogicalRright: count
	codegen shiftRight: codegen regR byImm: count
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightRwithT
	codegen shiftRightArithmetic: codegen regR by: codegen regT

! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRleft: count
	 codegen shiftLeft: codegen regR byImm: count

! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRright: count
	codegen shiftRightArithmetic: codegen regR byImm: count

! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftTright: count
	codegen shiftRightArithmetic: codegen regT byImm: count

! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subAfromR
	codegen sub: codegen regA from: codegen regR
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subAfromT
	codegen sub: codegen regA from: codegen regT    
! !

!GenericAssembler methodsFor: 'arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subFromRconstant: imm
	codegen subImm: imm from: codegen regR
! !

!GenericAssembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addSPwithImmediate: imm
	codegen addImm: imm to: codegen regSP
! !

!GenericAssembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addTwithImmediate: imm
	codegen addImm: imm to: codegen regT
! !

!GenericAssembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
andRwithA
	codegen and: codegen regR with: codegen regA
! !

!GenericAssembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
orRwithA
	codegen or: codegen regR with: codegen regA

! !

!GenericAssembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
xorAwithR
	codegen xor: codegen regA with: codegen regR
! !

!GenericAssembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
xorFPwithFP
	codegen xor: codegen regFP with: codegen regFP
! !

!GenericAssembler methodsFor: 'logic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
xorRwithA
	codegen xor: codegen regR with: codegen regA
! !

!GenericAssembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
and: source1andDest with: source2
	codegen and: source1andDest with: source2
! !

!GenericAssembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
and: source1andDest withImm: imm
	codegen and: source1andDest withImm: imm
! !

!GenericAssembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
or: src1AndDst with: src2
	^ codegen or: src1AndDst with: src2
! !

!GenericAssembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
or: source1andDest withImm: imm
	codegen or: source1andDest withImm: imm
! !

!GenericAssembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLeft: srcAndDst byImm: count
	codegen shiftLeft: srcAndDst byImm: count
! !

!GenericAssembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightArithmetic: srcAndDst by: countReg
	codegen shiftRightArithmetic: srcAndDst by: countReg
! !

!GenericAssembler methodsFor: 'operations - logical' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightArithmetic: srcAndDst byImm: count
	codegen shiftRightArithmetic: srcAndDst byImm: count
! !

!GenericAssembler methodsFor: 'relocation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
applyFixups
	codegen memory applyFixupsWith: self
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildFrame
	self
		push: codegen regFP;
		move: codegen regSP to: codegen regFP
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bytes
	^codegen bytes
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
decRindirect
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen decMem: memref
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
discardArguments: anInteger
	anInteger = 0 ifTrue: [^self].
	codegen addImm: anInteger * codegen wordSize to: codegen regSP
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithGindex: index
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithGindex: index
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithGindex: index
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pop: dstReg
	codegen pop: dstReg
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
push: srcReg
	codegen push: srcReg

! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushImm: imm
	codegen pushImm: imm
! !

!GenericAssembler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushIndirectR
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen pushMem: memref
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearFPUFlags
	codegen clearFPUFlags
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareEqualDoubleX0withAindirect
	codegen compareEqualDoubleX0withAindirect
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compareLessThanDoubleX0withAindirect
	codegen compareLessThanDoubleX0withAindirect
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dropTopOfFPU
	codegen dropTopOfFPU
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
leadingRzeroCount
	codegen leadingRzeroCount
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLongMwithIPoffset: anInteger
	codegen loadLongMwithIPoffset: anInteger
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMXCSRfromA
	codegen loadMXCSRfromA
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg
	codegen loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg

! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexImm: indexImm

	codegen
		loadZeroExtendByte: dstReg
		from: srcBaseReg
		atIndexImm: indexImm
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendShortRwithRoffset: offset
	codegen
		loadZeroExtendShortRwithRoffset: offset
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
lock
	codegen lock
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveTslots
	codegen moveTslots
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
readFPUStatusOnA
	codegen readFPUStatusOnA
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scaleFloatOnRWithA
	codegen scaleFloatOnRWithA
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeMXCSRintoA
	codegen storeMXCSRintoA
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subTslotsToSP
	codegen subTslotsToSP
! !

!GenericAssembler methodsFor: 'to-cleanup' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
writeTslots
	codegen writeTslots
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearRhigh32
	codegen clearHigh32: codegen regR

! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dec: srcAndDstReg
	codegen dec: srcAndDstReg
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dropTos: count
	codegen addImm: (count * codegen addressSize) to: codegen regSP
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inc: srcAndDstReg
	codegen inc: srcAndDstReg
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeS
	codegen move: codegen regR to: codegen regS
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithAddressOfRatA
	| memref |
	memref := codegen
		memRef: codegen regR
		index: codegen regA
		offsetImm: codegen wordSize negated.
	codegen lea: codegen regE withMem: memref
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLargeX0withRindirect
	| memref |
	memref := codegen memRef64: codegen regR indexImm: 1.
	codegen loadDouble: codegen regX0 fromMem: memref
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLargeX1withAindirect
	| memref |
	memref := codegen memRef64: codegen regA indexImm: 1.
	codegen loadDouble: codegen regX1 fromMem: memref
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLongRwithRatOffsetA
	| memref |
	memref := codegen
		memRef32: codegen regR
		offset: codegen regA.
	codegen load: codegen regR fromMem: memref

! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadLongSwithRindex: index
	| memref |
	memref := codegen memRef32: codegen regR indexImm: index.
	codegen load: codegen regS fromMem: memref

! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithA
	codegen move: codegen regA to: codegen regM
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRconvertingDoublePointedByR
	| memref |
	memref := codegen memRef64: codegen regR indexImm: 1.
	codegen load: codegen regR convertingDoubleToIntegerFromMem: memref
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithArgPointer
	| memref |
	memref := codegen memRef: codegen regFP indexImm: 3.
	codegen lea: codegen regR withMem: memref
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithAddressOfSatA
	| memref |
	memref := codegen
		memRef: codegen regS
		index: codegen regA
		offsetImm: codegen wordSize negated.
	codegen lea: codegen regS withMem: memref
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadX0withRasDouble
	codegen convert: codegen regR toDouble: codegen regX0
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popA
	codegen pop: codegen regA
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popE
	codegen pop: codegen regE
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popFP
	codegen pop: codegen regFP
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popFalse
	codegen pop: codegen regFalse
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popG
	codegen pop: codegen regG
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popM
	codegen pop: codegen regM
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popNil
	codegen pop: codegen regNil
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popR
	codegen pop: codegen regR
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popS
	codegen pop: codegen regS
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popT
	codegen pop: codegen regT
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popTrue
	codegen pop: codegen regTrue
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushA
	codegen push: codegen regA
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushE
	codegen push: codegen regE
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushFP
	codegen push: codegen regFP
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushFalse
	codegen push: codegen regFalse
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushG
	codegen push: codegen regG
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushM
	codegen push: codegen regM
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushNil
	codegen push: codegen regNil
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushR
	codegen push: codegen regR
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushS
	codegen push: codegen regS
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushT
	codegen push: codegen regT
! !

!GenericAssembler methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushTrue
	codegen push: codegen regTrue
! !

!GenericAssembler methodsFor: 'comparing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: register withBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareWithTrue: register ]
		ifFalse: [ self compareWithFalse: register ]
! !

!GenericAssembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
currentAddress
	^ codegen currentAddress
! !

!GenericAssembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
move: srcReg to: dstReg
	^ codegen move: srcReg to: dstReg

! !

!GenericAssembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveImm: imm to: dstReg
	codegen moveImm: imm to: dstReg

! !

!GenericAssembler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
wordSize
	^codegen wordSize
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
divideDoubleX0byX1
	codegen divDouble: codegen regX0 by: codegen regX1
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithTIBatR
	codegen load: codegen regR withTIBat: codegen regR
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithThreadVariableAtR
	codegen load: codegen regR withThreadVariableAt: codegen regR
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveX0toR
	codegen moveDouble: codegen regX0 into: codegen regR
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
multiplyDoubleX0byX1
	codegen mulDouble: codegen regX0 by: codegen regX1
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushAatToffset: offset
	| memref |
	memref := codegen memRef: codegen regA index: codegen regT.
	memref displacement: offset.
	codegen pushMem: memref
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
	codegen renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
roundDoubleX0intoX1
	codegen roundDouble: codegen regX0 into: codegen regX1
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sqrtDoubleX0
	codegen sqrtDouble: codegen regX0 into: codegen regX0
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeAinThreadVariableAtIndexR
	codegen store: codegen regA intoThreadVariableAt: codegen regR
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeDoubleResultInRindirect
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen storeDoubleResultIntoMem:  memref
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTIBatRwithA
	codegen store: codegen regA intoTIBat: codegen regR
! !

!GenericAssembler methodsFor: 'floting point' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subDoubleX1fromX0
	codegen subDouble: codegen regX1 from: codegen regX0
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
extendRtoAandDividebyT
	codegen divide: codegen regR extendingTo: codegen regA by: codegen regT
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
multiplyRbyAwideningToA
	codegen
		multiply: codegen regR
		by: codegen regA
		wideningTo: codegen regA
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeAinTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		store: codegen regA
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeByteAinRindex: index
	| memref |
	memref := codegen memRef8: codegen regR indexImm: index.
	codegen store: codegen regA byte intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeByteTinRatA
	| memref |
	memref := codegen memRef8: codegen regR index: codegen regA.
	codegen store: codegen regT byte intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeEinRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regE
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLargeX0inA
	| memref |
	memref := codegen memRef64: codegen regA indexImm: 1.
	codegen storeDouble: codegen regX0 intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLargeX0inT
	| memref |
	memref := codegen memRef64: codegen regT indexImm: 1.
	codegen storeDouble: codegen regX0 intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLongTinRatA
	| memref |
	memref := codegen memRef32: codegen regR index: codegen regA.
	codegen
		store: codegen regT
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeLongTinRatOffsetA
	| memref |
	memref := codegen memRef32: codegen regR offset: codegen regA.
	codegen store: codegen regT long intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinAindex: index
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinSindex: index
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeRinTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeShortAinRoffset: offset
	|  memref |
	memref := codegen memRef16: codegen regR offsetImm: offset.
	codegen store: codegen regA short intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeShortTinRatOffsetA
	| memref |
	memref := codegen memRef16: codegen regR offset: codegen regA.
	codegen store: codegen regT short intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeSinRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regS
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTinRatA
	| memref |
	memref := codegen memRef: codegen regR index: codegen regA.
	codegen
		store: codegen regT
		intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTinRatOffsetA
	| memref |
	memref := codegen memRef: codegen regR offset: codegen regA.
	codegen store: codegen regT intoMem: memref
! !

!GenericAssembler methodsFor: 'storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeTinRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regT
		intoMem: memref
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfEqualTo: label
	codegen jumpIfEqualTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfGreaterOrEqualSignedTo: label
	codegen jumpIfGreaterOrEqualSignedTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfGreaterSignedTo: label
	codegen jumpIfGreaterSignedTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfLessOrEqualSignedTo: label
	codegen jumpIfLessOrEqualSignedTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfLessSignedTo: label
	codegen jumpIfLessSignedTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfNotEqualTo: label
	codegen jumpIfNotEqualTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfNotZeroTo: label
	codegen jumpIfNotZeroTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfOverflowTo: label
	codegen jumpIfOverflowTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfSignTo: label
	codegen jumpIfSignTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpIfZeroTo: label
	codegen jumpIfZeroTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByte: reg1 from: reg2 atOffset: offset
	codegen loadZeroExtendByte: reg1 from: reg2 atOffset: offset
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loop: aBlock times: anInteger
	| loop |
	loop := self newLabel.
	self loadTwithImmediate: anInteger; @ loop.
	aBlock value.
	self dec: codegen regT; shortJumpIfNotZeroTo: loop
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loopTtimes: aBlock
	| loop end |
	loop := self newLabel.
	end := self newLabel.
	self
		compareTwithImmediate: 0;
		@ loop;
		shortJumpIfEqualTo: end.
	aBlock value.
	self
		dec: codegen regT;
		shortJumpTo: loop;
		@ end
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
	codegen renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
return
	codegen return
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfCarryTo: label
	codegen shortJumpIfCarryTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfEqualTo: label
	codegen shortJumpIfEqualTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfNotCarryTo: label
	codegen shortJumpIfNotCarryTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfNotEqualTo: label
	codegen shortJumpIfNotEqualTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpIfSignTo: label
	codegen shortJumpIfSignTo: label
! !

!GenericAssembler methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shortJumpTo: label
	codegen shortJumpTo: label
! !

!GenericAssembler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpTo: label
	codegen jumpTo: label
! !

!GenericAssembler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpToMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen jumpToMem: memref
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerBitTestOfR
	^self labeledIntegerBitTestOf: codegen regR
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerBitTestOfT
	^self labeledIntegerBitTestOf: codegen regT byte
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerNativizationOfA
	^self labeledIntegerNativizationOf: codegen regA
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerNativizationOfR
	^self labeledIntegerNativizationOf: codegen regR
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledIntegerNativizationOfT
	^self labeledIntegerNativizationOf: codegen regT
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
labeledNonIntegerBitTestOfR
	^self labeledNonIntegerBitTestOf: codegen regR
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithImmediate: imm
	self load: codegen regA withImmediate: imm
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithSmallInteger: anInteger
	| smi |
	smi := (anInteger bitShift: 1) + 1.
	self loadAwithImmediate: smi
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithImmediate: imm
	self load: codegen regR withImmediate: imm
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithRatA
	| memref |
	memref := codegen memRef: codegen regR index: codegen regA.
	self
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithImmediate: imm
	self load: codegen regT withImmediate: imm
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteRwithRatA
	self loadZeroExtendByte: codegen regR from: codegen regR atIndexAt: codegen regA
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteRwithRindex: index
	#dontOptimize.
	self loadZeroExtendByte: codegen regR from: codegen regR atIndexImm: index
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteRwithSPatA
	self loadZeroExtendByte: codegen regR from: codegen regSP atIndexAt: codegen regA
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendByteTwithAindex: index
	#dontOptimize.
	self loadZeroExtendByte: codegen regT from: codegen regA atIndexImm: index
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendLongRwithRatA
	| memref |
	memref := codegen memRef32: codegen regR index: codegen regA.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'integers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadZeroExtendLongRwithRindex: index
	| memref |
	#dontOptimize.
	memref := codegen memRef32: codegen regR indexImm: index.
	codegen
		load: codegen regR e
		fromMem: memref
! !

!GenericAssembler methodsFor: 'memory - load / store' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: dstReg fromMem: srcMemRef
	^codegen load: dstReg fromMem: srcMemRef
! !

!GenericAssembler methodsFor: 'memory - load / store' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
store: srcReg intoMem: dstMemRef
	^ codegen store: srcReg intoMem: dstMemRef
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load:dstReg withImmediate: imm
	codegen moveImm: imm to: dstReg
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: register withLiteral: anObject
	| index memref |
	index := self addLiteral: anObject.
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: register
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithAindex: index
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithFalse
	codegen move: codegen regFalse to: codegen regA
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithGlobal: aSymbol
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadAwithGindex: index
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadAwithMindex: index
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithNil
	codegen move: codegen regNil to: codegen regA
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithR
	codegen move: codegen regR to: codegen regA
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithRoffsetAtA
	| memref |
	memref := codegen memRef
				base: codegen regR;
				index: codegen regA;
				scale: 1.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithS
	codegen move: codegen regS to: codegen regA
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithSindex: index
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadAwithTrue
	codegen move: codegen regTrue to: codegen regA
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regE
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithNil
	codegen move: codegen regNil to: codegen regE
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadEwithR
	codegen move: codegen regR to: codegen regE
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadFPwithR
	codegen move: codegen regR to: codegen regFP
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadFPwithSP
	codegen move: codegen regSP to: codegen regFP
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadFalseWithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regFalse
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadGwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regG
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadMwithTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadNilWithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regNil
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithA
	codegen move: codegen regA to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithE
	codegen move: codegen regE to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithFP
	codegen move: codegen regFP to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithFalse
	codegen move: codegen regFalse to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithM
	codegen move: codegen regM to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithNil
	codegen move: codegen regNil to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithRatOffsetA
	| memref |
	memref := codegen memRef
				base: codegen regR;
				index: codegen regA;
				scale: 1.
	codegen
		load: codegen regR
		fromMem:
			memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithS
	codegen move: codegen regS to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithSPindex: index
	| memref |
	memref := codegen memRef: codegen regSP indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithSindex: index
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithT
	codegen move: codegen regT to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadRwithTrue
	codegen move: codegen regTrue to: codegen regR
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSPwithFP
	codegen move: codegen regFP to: codegen regSP
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithNil
	codegen move: codegen regNil to: codegen regS
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadSwithRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTrueWithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regTrue
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithA
	codegen move: codegen regA to: codegen regT
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithAindex: index
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithR
	codegen move: codegen regR to: codegen regT
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadTwithTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen load: codegen regT fromMem: memref
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadWithFalse: register
	codegen move: codegen regFalse to: register
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadWithNil: register
	codegen move: codegen regNil to: register
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadWithTrue: register
	codegen move: codegen regTrue to: register
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reserveStackSlots: amount
	codegen subImm: amount * codegen addressSize from: codegen regSP
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testIntegerBit: aRegister
	codegen testIntegerBit: aRegister
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testIntegerBitOf: aRegister
	codegen test: aRegister byte withImm: 1
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testRintegerBit
	codegen test: codegen regR byte withImm: 1
! !

!GenericAssembler methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
testRwithR
	codegen test: codegen regR with: codegen regR
! !

!GenericAssembler methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef
	"Return clean instance of pointer-sized memory reference"

	^ codegen memRef

! !

!GenericAssembler methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef: baseReg index: indexReg
	^ codegen memRef: baseReg index: indexReg
! !

!GenericAssembler methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef: baseReg indexImm: indexImm
	^ codegen memRef: baseReg indexImm: indexImm
! !

!GenericAssembler methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef32: baseReg indexImm: indexImm
	^ codegen memRef32: baseReg indexImm: indexImm
! !

!GenericAssembler methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef8
	"Return clean instance of byte-sized memory reference"

	^ codegen memRef8
! !

!GenericAssembler methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef8: baseReg index: indexReg
	^ codegen memRef8: baseReg index: indexReg
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regA
	^codegen regA

! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regA8
	^ codegen regA byte

! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regE
	^ codegen regE
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFP
	^ codegen regFP
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFalse
	^ codegen regFalse
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regG
	^ codegen regG
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regIP
	^ codegen regIP
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regM
	^ codegen regM
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regNil
	^ codegen regNil
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regR
	^ codegen regR
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regR8
	^ codegen regR byte
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regS
	^ codegen regS
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regSP
	^ codegen regSP
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regT
	^ codegen regT
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regT8
	^ codegen reg byte
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regTrue
	^ codegen regTrue
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regV
	^ codegen regV
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX0
	"IEEE 754 double register"
	^ codegen regX0
! !

!GenericAssembler methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX1
	"IEEE 754 double register"
	^ codegen regX1
! !

!GenericAssembler methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
platform: aNativizationPlatform
	codegen := aNativizationPlatform newCodeGenerator.
	super platform: aNativizationPlatform.
! !

!GenericAssembler methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reset
	super reset.
	codegen reset
! !

!GenericAssembler methodsFor: 'epilogue' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
restoreCallerFrame
	codegen
		move: codegen regFP to: codegen regSP;
		pop: codegen regFP
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
add: source1 to: source2andDest
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addImm: imm to: dest
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
and: source1andDest with: source2
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
and: source1andDest withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
breakpoint
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
call: srcReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearHigh32: srcAndDstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: reg1 with: reg2
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: reg1 withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compare: reg1 withMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
convert: src toDouble: dst
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dec: srcAndDstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
decMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
divDouble: src1andDstReg by: src2reg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
divide: srcAndDstReg extendingTo: extReg by: divisorReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
exchange: srcAndDstReg withMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inc: srcAndDstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpTo: label
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
jumpToMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: dstReg convertingDoubleToIntegerFromMem: srcMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: dstReg withTIBat: indexReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: dstReg withThreadVariableAt: indexReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveDouble: srcReg into: dstReg
	"move from X-type register srcReg into general purpose dstReg"
	
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveImm: imm to: dstReg
	"Load constant to register `dstImm`"

	self subclassResponsibility

! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
mulDouble: src1andDstReg by: src2reg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
multiply: src1AndDstLoReg by: src2reg wideningTo: dstHiReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
or: src1andDest withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reset
	memory reset
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftLeft: srcAndDst byImm: count
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRight: srcAndDst byImm: count
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightArithmetic: srcAndDst by: countReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shiftRightArithmetic: srcAndDst byImm: count
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sqrtDouble: srcReg into: dstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sub: src1 from: src2AndDst
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subDouble: src1 from: src2AndDst
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subImm: imm from: srcAndDst
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
test: src1Reg with: src2Reg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'basic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
test: srcReg withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'operations - arithmetic' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addDouble: source1 to: source2andDest
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addressBitSize
	^self addressSize * 8

! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addressLength
	^wordSize * 8
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addressSize
	"Return the size of address in bytes, e.g, 4 for 32bit archs
	 and 8 for 64bit archs"

	^wordSize
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bytes
	^memory bytes
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
callIndirect: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
codeSize
	^memory codeSize
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memory
	^memory
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativeCode
	^ NativeCode new code: memory bytes
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
wordSize
	^wordSize
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
wordSize: anInteger
	self ASSERT: anInteger == 8.
	wordSize := anInteger.
! !

!CodeGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
wordSizeShift
	^wordSize = 8 ifTrue: [3] ifFalse: [2]
! !

!CodeGenerator methodsFor: 'alignment' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
alignTo: aNumber
	| current count |
	current := memory position.
	count := (current alignedTo: aNumber) - current.
	self nop: count
! !

!CodeGenerator methodsFor: 'relocation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
baseAddress
	^memory baseAddress
! !

!CodeGenerator methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bitLengthOf: anInteger
	(anInteger between: -16r80 and: 16r7F) ifTrue: [^8].
	(anInteger between: -16r8000 and: 16r7FFF) ifTrue: [^16].
	(anInteger between: -16r80000000 and: 16r7FFFFFFF) ifTrue: [^32].
	(anInteger between: -16r8000000000000000 and: 16r7FFFFFFFFFFFFFFF)
		ifTrue: [^64].
	(anInteger
		between: -16r80000000000000000000000000000000
		and: 16r7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
		ifTrue: [^128].
	^nil
! !

!CodeGenerator methodsFor: 'labels' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
currentAddress
	^memory currentAddress
! !

!CodeGenerator methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	memory := RelocatableBuffer new.
! !

!CodeGenerator methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
platform: aNativizationPlatform
	abi := aNativizationPlatform abi.
	wordSize := aNativizationPlatform wordSize.
! !

!CodeGenerator methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stream
	^memory stream
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
lea: dstReg withMem: srcMemRef
	^self subclassResponsibility
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load: dstReg fromMem: srcMemRef
	"Load `dstReg` from memory location `srcMemRef`.
	 The size of data loaded is specified in `srcMemRef`.

	 When loading 32bits into 64bit register, high 32bits must be
	 cleared (in other words, 32bit value is *zero* extended to
	 64bits and stored in `dstReg`.

	 However, when loading 16bits or 8bits, high 48 or 56 bits
	 are *left intact*.

	 This somewhat weird behavior is heritage of x86.
	"

	^ self subclassResponsibility

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadDouble: dstReg fromMem: srcMemRef
	"Load 64-bit floating point `dstReg` from memory location `srcMemRef`"
	
	^ self subclassResponsibility
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef: baseReg index: indexRef
	^ self memRef 
		base: baseReg; 
		displacement: self addressSize negated;
		index: indexRef;
		scale: self addressSize;
		yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef: baseReg index: indexRef offsetImm: anInteger
	^ self memRef 
		base: baseReg; 
		displacement: anInteger;
		index: indexRef;
		scale: self addressSize;
		yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef: baseReg indexImm: indexImm
	^ self memRef 
		base: baseReg; 
		displacement: (indexImm - 1) * self addressSize;
		yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef: baseReg offset: indexReg
	^ self memRef
		base: baseReg;
		index: indexReg;
		scale: 1;
		yourself
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef16
	"Return clean instance of memory reference."

	^ self memRef length: 16; yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef16: baseReg offset: offsetReg
	^ self memRef16
		base: baseReg;
		index: offsetReg;
		scale: 1;
		yourself
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef16: baseReg offsetImm: offsetImm
	^ self memRef16
		base: baseReg;
		displacement: offsetImm;
		yourself
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef32
	"Return clean instance of memory reference."

	^ self memRef length: 32; yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef32: baseReg index: indexReg
	^ self memRef32 
		base: baseReg; 
		displacement: -4;
		index: indexReg;
		scale: 4;
		yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef32: baseReg indexImm: indexImm
	^ self memRef32 
		base: baseReg; 
		displacement: (indexImm - 1) * 4;
		yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef32: baseReg offset: offsetReg
	^ self memRef32
		base: baseReg;
		index: offsetReg;
		scale: 1;
		yourself
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef64
	"Return clean instance of memory reference."

	^ self memRef length: 64; yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef64: baseReg indexImm: indexImm
	^ self memRef64
		base: baseReg;
		displacement: (indexImm - 1) * 8;
		yourself
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef8
	"Return clean instance of memory reference."

	^ self memRef length: 8; yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef8: baseReg index: indexReg
	^ self memRef8 
		base: baseReg; 
		displacement: -1;
		index: indexReg;
		scale: 1;
		yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRef8: baseReg indexImm: indexImm
	^ self memRef8
		base: baseReg; 
		displacement: (indexImm - 1);
		yourself

! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRefAatT
^self memRef: self regA index: self regT
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
memRefSPatT
	^ self memRef: self regSP index: self regT
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
roundDouble: srcReg into: dstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
store: srcReg intoMem: dstMemRef
	"Store `srcReg` into memory location `dstMemRef`. 

	 The size of data loaded is specified in `dstMemRef`"
	^self subclassResponsibility
! !

!CodeGenerator methodsFor: 'memory' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
storeDouble: srcReg intoMem: dstMemRef
	^ self subclassResponsibility
! !

!CodeGenerator methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
move: srcReg to: dstReg
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pop: dstReg
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
popIntoMem: dstMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
push: srcReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushAOnFPUStack
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor: 'push/pop' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushROnFPUStack
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regA
	^abi regA
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regE
	^abi regE
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFP
	^abi regFP
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFalse
	^abi regFalse
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regG
	^ abi regG
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regIP
	^abi regIP
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regM
	^abi regM
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regNil
	^abi regNil
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regR
	^abi regR
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regS
	^abi regS
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regSP
	^abi regSP
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regT
	^abi regT
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regTrue
	^abi regTrue
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regV
	^abi regV
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX0
	^ abi regX0
! !

!CodeGenerator methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX1
	^ abi regX1
! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
clearHigh32: srcAndDstReg
	self
		shiftLeft: srcAndDstReg byImm: 32;
		shiftRight: srcAndDstReg byImm: 32
! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dec: srcAndDstReg
	self addImm: -1 to: srcAndDstReg

! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
decMem: aMemRef
	self addImm: -1 toMem: aMemRef

! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inc: srcAndDstReg
	self addImm: 1 to: srcAndDstReg

! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pop: srcReg
	| memref |
	memref := self memRef base: self regSP.
	self
		load: srcReg fromMem: memref;
		addImm: wordSize to: self regSP 
! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
push: srcReg
	| memref |
	memref := self memRef base: self regSP; displacement: -8.
	self
		store: srcReg intoMem: memref;
		subImm: wordSize from: self regSP 
! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pushImm: imm
	| memref |
	memref := self memRef base: self regSP; displacement: -8.
	self moveImm: imm to: self regV;
		store: self regV intoMem: memref;
		subImm: wordSize from: self regSP 
! !

!RISCCodeGenerator methodsFor: 'jumps' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
subImm: anInteger from: srcAndDstReg
	self addImm: anInteger negated to: srcAndDstReg

! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beAbsolute
	absolute := true
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
classBinding
	^source classBinding
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
for: anObject
	self target: anObject
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	absolute := false
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isAbsolute
	^absolute
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: 'Ref to '; print: target
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
source: sourceObject
	source := sourceObject
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sourceOffset
	^sourceOffset
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sourceOffset: aNumber
	sourceOffset := aNumber
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
target
	^target
! !

!NativeCodeReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
target: anObject
	target := anObject
! !

!NativeCodeReference class methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
absoluteFor: anObject
	^(self new for: anObject) beAbsolute
! !

!NativeCodeReference class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !

!RelocatableBuffer methodsFor: 'fixups' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addAbsoluteFixup: label
	| fixup |
	fixup := RelocationFixup absoluteFrom: self currentAddress to: label.
	fixups add: fixup
! !

!RelocatableBuffer methodsFor: 'fixups' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addRelativeFixup: label size: n
	| fixup |
	fixup := RelocationFixup relativeFrom: self currentAddress to: label.
	fixup size: n.
	fixups add: fixup
! !

!RelocatableBuffer methodsFor: 'fixups' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
applyFixupsWith: solver
	fixups do: [:fixup | fixup patch: self with: solver]
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
baseAddress
	^address
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bytes
	^stream contents
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
codeSize
	^stream size
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
currentAddress
	^address + stream position
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
peek
	^stream peek
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
peek: n
	^stream peek: n
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
position
	^stream position
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
position: anInteger
	stream position: anInteger
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
size
	^stream size
! !

!RelocatableBuffer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
skip: anInteger
	stream skip: anInteger
! !

!RelocatableBuffer methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	fixups := OrderedCollection new.
	address := 0.
	stream := #[] writeStream
! !

!RelocatableBuffer methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reset
	fixups := OrderedCollection new.
	stream reset
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextBytePut: byte
	| value |
	value := byte < 0 ifTrue: [ byte + 256 ] ifFalse: byte.
	stream nextBytePut: value
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextBytesPut: aByteArray
	stream nextBytesPut: aByteArray
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextLargePut: large
	stream nextLargePut: large

! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextLongPut: long
	stream nextLongPut: long

! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextPut: byte
	stream nextPut: byte
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextPutAll: aByteArray
	stream nextPutAll: aByteArray
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextULargePut: large
	stream nextULargePut: large

! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextULongPut: long
	stream nextULongPut: long
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stream
	^stream
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
writeByte: byte at: location
	| previous value |
	previous := stream position.
	value := byte < 0 ifTrue: [ byte + 256 ] ifFalse: [ byte ].
	stream
		position: location - address;
		nextBytePut: value;
		position: previous
! !

!RelocatableBuffer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
writeLong: long at: location
	| previous |
	previous := stream position.
	stream
		position: location - address;
		nextLongPut: long;
		position: previous
! !

!RelocatableBuffer methodsFor: 'relocation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
relocateTo: location with: solver
	| delta |
	delta := location - address.
	address := location.
	fixups do: [:fixup | fixup relocateBy: delta].
	self applyFixupsWith: solver
! !

!RelocatableBuffer methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stream: aStream
	stream := aStream
! !

!RelocationFixup methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addressSize
	^4
! !

!RelocationFixup methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beAbsolute
	relative := false.
	size := self addressSize
! !

!RelocationFixup methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beRelative
	relative := true
! !

!RelocationFixup methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
from: address1 to: address2
	source := address1.
	target := address2
! !

!RelocationFixup methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
size: anInteger
	size := anInteger
! !

!RelocationFixup methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
target
	^target
! !

!RelocationFixup methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isRelative
	^relative
! !

!RelocationFixup methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
patch: buffer with: solver
	| delta address |
	address := solver resolveLabel: target.
	self ASSERT: address notNil.
	relative
		ifTrue: [
			delta := address - source - size.
			size = 1
				ifTrue: [buffer writeByte: delta at: source]
				ifFalse: [buffer writeLong: delta at: source]]
		ifFalse: [buffer writeLong: address at: source]
! !

!RelocationFixup methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
relocateBy: delta
	source := source + delta
! !

!RelocationFixup methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream
	aStream
		nextPutAll: self class name;
		nextPut: $:;
		space;
		nextPutAll: target printString
! !

!RelocationFixup class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
absoluteFrom: source to: target
	^self new beAbsolute; from: source to: target
! !

!RelocationFixup class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
relativeFrom: source to: target
	^self new beRelative; from: source to: target
! !

!LookupNativizer methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
closureMethods
	^ self selectorLookupMethods , self globalLookupMethods
		, self otherLookupMethods , nativizer class undermethods
		, self sendSiteMethods
! !

!LookupNativizer methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
globalLookupMethods
	| result out global |
	result := OrderedCollection new.
	result
		add: ProtoObject >> #_cachedLookup:;
		add: ProtoObject >> #_cachedLookup:in:;
		add: Thread metaclass >> #currentGlobalLookup;
		add: GlobalDispatchCache metaclass >> #current.
	out := #(initialize flushAll: flush:forSpecies: flush:for: flush:for:startingAt:).
	global := GlobalDispatchCache methods
		reject: [ :m | out includes: m selector ].
	^ result
		addAll: global;
		yourself
! !

!LookupNativizer methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
otherLookupMethods
	^ OrderedCollection new
		add: ProtoObject >> #objectAtValid:put:;
		add: ProtoObject >> #behavior;
		add: CompiledMethod >> #prepareForExecution;
		add: CompiledMethod >> #isNativized;
		add: CompiledMethod >> #validNativeCodeAddress;
		add: CompiledMethod >> #nativeCode;
		add: CompiledMethod >> #selector;
		add: NativeCode >> #code;
		add: NativeCode >> #compiledCode;
		add: Species >> #instanceBehavior;
		add: Process >> #wantsToStepInto;
		yourself
! !

!LookupNativizer methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
selectorLookupMethods
	^ OrderedCollection new
		add: SendSite >> #_lookup:;
		add: SendSite >> #_lookup:in:;
		add: SendSite >> #_lookup:inDictionary:;
		yourself
! !

!LookupNativizer methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sendSiteMethods
	| sendsite |
	^ #(_dispatchOn: _dispatchOn:startingAt: _dispatchDebuggableOn: _dispatchDebuggableOn:startingAt: sentSelector when:use: beInvoke:using: bePolymorphic isStaticSend monomorphicMap:to: polymorphicMap:to: maxSize reset takeNextFreeMIC takeNextFreePIC)
		collect: [ :s | SendSite >> s ]
! !

!LookupNativizer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodFor: selector
	^methods detect: [:m | m selector == selector].

! !

!LookupNativizer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methods
	^methods
! !

!LookupNativizer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeMethods
	| environment | 
	methods := self closureMethods collect: [:m | nativizer compile: m ].
	environment := self newNativizationEnvironment.
	methods do: [:m | environment nativize: m]
! !

!LookupNativizer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizer: aNativizationEnvironment
	nativizer := aNativizationEnvironment
! !

!LookupNativizer methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
newNativizationEnvironment
	| environment ignored lookup invoke |
	environment := NativizationEnvironment new 
		platform: nativizer platform;
		globals: nativizer globals;
		optimizedMethods: nativizer optimizedMethods.
	ignored := HaltingSend new
		filter: #(< <= = > + - * // bitAnd: bitOr: bitXor:).
	lookup := LookupLinker new initializeFrom: environment.
	lookup
		filter:
			#(debuggableCopy acquireReferences nativize refreshBlocks doesNotUnderstandSelector: mustBeBoolean class allocateMoreCaches).
	invoke := InvokeLinker new
		invoker: environment invokeStub;
		addMethods: methods.
	^ environment
		addLinker: invoke;
		addLinker: ignored;
		addLinker: lookup;
		completeInitialization
! !

!IdentifierBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
contents
	^contents
! !

!IdentifierBinder methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
keyFor: aString
	^self subclassResponsibility
! !

!IdentifierBinder methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream
	self printOn: aStream indent: 0
! !

!IdentifierBinder methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream indent: anInteger
	self subclassResponsibility
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
at: aString
	^contents at: aString ifAbsent: nil
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
at: aString ifAbsentPut: aBlock
	^contents at: aString ifAbsentPut: aBlock
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
at: aString put: aBinding
	contents at: aString put: aBinding
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
define: aString as: aBinding
	contents at: aString put: aBinding
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
defines: identifier
	^contents includesKey: identifier
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
do: aBlock
	contents do: aBlock
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
select: aBlock
	^contents select: aBlock
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
values
	^contents values
! !

!StaticBinder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
withIndexDo: aBlock
	contents withIndexDo: aBlock
! !

!StaticBinder methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	contents := OrderedDictionary new
! !

!StaticBinder methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPut: $<.
	contents keys
		do: [:name | name printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $>
! !

!LocalEnvironment methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInlinedArgument
	^false
! !

!ArrayEnvironment methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureType
	^CaptureEnvironmentValue
! !

!ArrayEnvironment methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index
	^index
! !

!ArrayEnvironment methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index: anInteger
	index := anInteger
! !

!ArrayEnvironment methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isCurrent
	^index isNil
! !

!ArrayEnvironment methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isIndirect
	^self isCurrent not
! !

!ArrayEnvironment methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isStack
	^false
! !

!StackEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index
	^nil
! !

!StackEnvironment methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isStack
	^true
! !

!ArgumentEnvironment methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureType
	^CaptureLocalArgument
! !

!InlinedArgEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
captureType
	^CaptureInlinedArgument
! !

!InlinedArgEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isInlinedArgument
	^true
! !

!MessageInliner methodsFor: 'transforming' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inline: aMessageNode
	| s keywords |
	message := aMessageNode.
	message receiver isSuper
		ifTrue: [ ^ self ].
	message isCascadeMessage
		ifTrue: [ ^ self ].
	s := message selector value.
	s == #ifTrue:
		ifTrue: [ ^ self inlineConditional ].
	s == #ifFalse:
		ifTrue: [ ^ self inlineConditional ].
	s == #or:
		ifTrue: [ ^ self inlineConditional ].
	s == #and:
		ifTrue: [ ^ self inlineConditional ].
	s == #timesRepeat:
		ifTrue: [ ^ self inlineConditional ].
	s == #ifTrue:ifFalse:
		ifTrue: [ ^ self inlineConditional ].
	s == #ifFalse:ifTrue:
		ifTrue: [ ^ self inlineConditional ].
	s == #andNot:
		ifTrue: [ ^ self inlineConditional ].
	s == #orNot:
		ifTrue: [ ^ self inlineConditional ].
	s == #ifNil:
		ifTrue: [ ^ self inlineConditional ].
	s == #ifNotNil:
		ifTrue: [ ^ self inlineIfNotNil ].
	s == #ifNil:ifNotNil:
		ifTrue: [ ^ self inlineIfNilIfNotNil ].
	s == #ifNotNil:ifNil:
		ifTrue: [ ^ self inlineIfNotNilIfNil ].
	s == #whileTrue:
		ifTrue: [ ^ self inlineWhile ].
	s == #whileFalse:
		ifTrue: [ ^ self inlineWhile ].
	s == #whileTrue
		ifTrue: [ ^ self inlineUnitaryWhile ].
	s == #whileFalse
		ifTrue: [ ^ self inlineUnitaryWhile ].
	s == #repeat
		ifTrue: [ ^ self inlineRepeat ].
	s == #to:do:
		ifTrue: [ ^ self inlineToDo ].
	"s == #to:by:do:
		ifTrue: [ ^ self inlineToByDo ]."
	keywords := $: split: s.
	keywords last = ''
		ifTrue: [ keywords := keywords allButLast ].
	(keywords conform: [ :k | k = 'and' ])
		ifTrue: [ ^ self inlineConditional ].
	(keywords conform: [ :k | k = 'or' ])
		ifTrue: [ ^ self inlineConditional ].
	((keywords allButLast conform: [ :k | k = 'and' ])
		and: [ #('ifTrue' 'ifFalse') includes: keywords last ])
		ifTrue: [ ^ self inlineConditional ].
	((keywords allButLast conform: [ :k | k = 'or' ])
		and: [ #('ifTrue' 'ifFalse') includes: keywords last ])
		ifTrue: [ self inlineConditional ]
! !

!MessageInliner methodsFor: 'transforming' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineRepeat
	| receiver arguments |
	receiver := message receiver.
	receiver isEvaluable
		ifFalse: [ ^ self ].
	arguments := message arguments.
	arguments isEmpty
		ifFalse: [ ^ self ].
	receiver isBlockNode
		ifFalse: [ ^ self ].
	message beInlined.
	receiver beInlined
! !

!MessageInliner methodsFor: 'transforming' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineUnitaryWhile
	| receiver arguments |
	receiver := message receiver.
	receiver isEvaluable ifFalse: [^self].
	arguments := message arguments.
	arguments size = 0 ifFalse: [^self].
	self inlineConditional.
	receiver isBlockNode ifTrue: [
		message beInlined.
		receiver beInlined]
! !

!MessageInliner methodsFor: 'inlining' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineConditional
	| arguments |
	arguments := message arguments.
	arguments size >= 1 ifFalse: [^self].
	arguments do: [:arg | arg isEvaluable ifFalse: [^self]].
	message beInlined.
	arguments select: #isBlockNode thenDo: #beInlined
! !

!MessageInliner methodsFor: 'inlining' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineIfNilIfNotNil
	| arguments arg |
	arguments := message arguments.
	arguments size = 2 ifFalse: [^self].
	arguments first isEvaluable ifFalse: [^self].
	arg := arguments second.
	(arg isEvaluable or: [arg isBlockNode and: [arg arguments size = 1]])
		ifFalse: [^self].
	message beInlined.
	arguments select: #isBlockNode thenDo: #beInlined
	
! !

!MessageInliner methodsFor: 'inlining' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineIfNotNil
	| arguments arg |
	arguments := message arguments.
	arguments size = 1 ifFalse: [^self].
	arg := arguments first.
	(arg isEvaluable or: [arg isBlockNode and: [arg arguments size = 1]])
		ifFalse: [^self].
	message beInlined.
	arg isBlockNode ifTrue: [arg beInlined]
! !

!MessageInliner methodsFor: 'inlining' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineIfNotNilIfNil
	| arguments arg |
	arguments := message arguments.
	arguments size = 2 ifFalse: [^self].
	arguments second isEvaluable ifFalse: [^self].
	arg := arguments first.
	(arg isEvaluable or: [arg isBlockNode and: [arg arguments size = 1]])
		ifFalse: [^self].
	message beInlined.
	arguments select: #isBlockNode thenDo: #beInlined
! !

!MessageInliner methodsFor: 'inlining' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineToByDo
	| arguments arg step |
	arguments := message arguments.
	arguments size = 3 ifFalse: [^self].
	arg := arguments at: 3.
	arg isBlockNode ifFalse: [^self].
	arg arguments size = 1 ifFalse: [^self].
	step := arguments at: 2.
	(step isNumberNode and: [step value isSmallInteger]) ifFalse: [^self].
	message beInlined.
	arg beInlined
! !

!MessageInliner methodsFor: 'inlining' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineToDo
	| arguments last |
	arguments := message arguments.
	arguments size = 2 ifFalse: [^self].
	last := arguments at: 2.
	last isBlockNode ifFalse: [^self].
	last arguments size = 1 ifFalse: [^self].
	message beInlined.
	last beInlined
! !

!MessageInliner methodsFor: 'inlining' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlineWhile
	| receiver arguments |
	receiver := message receiver.
	receiver isEvaluable
		ifFalse: [ ^ self ].
	arguments := message arguments.
	arguments size = 1
		ifFalse: [ ^ self ].
	arguments last isNullary
		ifFalse: [ ^ self ].
	self inlineConditional.
	receiver isBlockNode
		ifTrue: [ receiver beInlined ]
! !

!SCompilationResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ast
	^ast
! !

!SCompilationResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ast: aParseNode
	ast := aParseNode
! !

!SCompilationResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler: aSmalltalkCompiler
	compiler := aSmalltalkCompiler
! !

!SCompilationResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
method
	^method
! !

!SCompilationResult methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
method: aCompiledMethod
	method := aCompiledMethod
! !

!SCompilationResult methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beSuccessful
	error := nil
! !

!SCompilationResult methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error
	^error
! !

!SCompilationResult methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error: aCompilationError
	error := aCompilationError
! !

!SCompiler methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canBeInIdentifier: aCharacter
	^aCharacter isLetter or: [aCharacter isDigit] or: [aCharacter = $_]
! !

!SCompiler methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canStartIdentifier: aCharacter
	^aCharacter isLetter or: [aCharacter = $_]
! !

!SCompiler methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
peekForIdentifier: aStream
	| char next |
	char := aStream peek.
	(self canBeInIdentifier: char) ifTrue: [
		aStream skip: 1.
		^true].
	char = $. ifFalse: [^false].
	aStream prev isLetter ifFalse: [
		aStream skip: 1.
		^false].
	next := aStream skip: 2; peek.
	next isNil ifTrue: [
		aStream skip: -1.
		^false].
	^next isLetter ifFalse: [aStream skip: -1]; yourself
! !

!SCompiler methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
protect: aBlock
	^aBlock value
! !

!SCompiler methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
classBinding
	 ^class
! !

!SCompiler methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
classBinding: aSpecies
	| instance |
	class := aSpecies.
	instance := aSpecies instanceClass.
	(instance respondsTo: #configureCompiler)
		ifTrue: [instance configureCompiler: self]
! !

!SCompiler methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize: aDictionary
	class := aDictionary at: #UndefinedObject ifAbsent: nil
! !

!SCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compile: aString
	result := self smalltalkCompiler compileMethod: aString.
	^result method
! !

!SCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parse: aString
	result := self smalltalkCompiler parseMethod: aString.
	^result ast
! !

!SCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
smalltalkCompiler
	^ SSmalltalkCompiler new frontend: self
! !

!SCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
smalltalkParser
	^ self smalltalkCompiler parser
! !

!SCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
smalltalkScanner
	^ self smalltalkCompiler scanner
! !

!SCompiler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
forClass: aClass
	| c |
	c := aClass ifNil: [UndefinedObject].
	self classBinding: c
! !

!SCompiler class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compile: aString in: aClass
	| compiler |
	compiler := self forClass: aClass.
	^compiler compile: aString
! !

!SCompiler class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parse: aString in: aClass
	| compiler |
	compiler := self forClass: aClass.
	^compiler parse: aString
! !

!SCompiler class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
forClass: aClass
	^self new forClass: aClass
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visit: aParseNode
	^aParseNode notNil ifTrue: [aParseNode acceptVisitor: self] 
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitAssignment: anAssignmentNode
	^self visitParseNode: anAssignmentNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitBlock: aBlockNode
	^self visitParseNode: aBlockNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitBraceNode: aBraceNode
	^self visitParseNode: aBraceNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitCascade: aCascadeNode
	^self visitParseNode: aCascadeNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitCascadeMessage: aCascadeMessageNode
	^self visitMessage: aCascadeMessageNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitForeignNode: anForeignNode
	self visitLiteral: anForeignNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitIdentifier: anIdentifierNode
	^self visitParseNode: anIdentifierNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitLiteral: aLiteralNode
	^self visitParseNode: aLiteralNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitMessage: aMessageNode
	^self visitParseNode: aMessageNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitMethod: aMethodNode
	^self visitParseNode: aMethodNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitNumberNode: aNumberNode
	^self visitLiteral: aNumberNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitParseNode: aParseNode
	^self subclassResponsibility
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitPragma: aPragmaNode
	^self visitParseNode: aPragmaNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitReturn: aReturnNode
	^self visitParseNode: aReturnNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitSelector: aSelectorNode
	^self visitParseNode: aSelectorNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitString: aStringNode
	^self visitLiteral: aStringNode
! !

!SParseTreeVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitSymbolicPragma: aPragmaNode
	^self visitPragma: aPragmaNode
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeAssignment: anAssignmentNode
	anAssignmentNode assignees
		do: [:v | self analyzeIdentifier: v assignee: true]
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeBlock: aBlockNode while: aBlock
	aBlockNode isInlined
		ifFalse: [aBlockNode index: aBlockNode compiler blockIndex].
	self analyzeScript: aBlockNode while: aBlock
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeIdentifier: anIdentifierNode
	self analyzeIdentifier: anIdentifierNode assignee: false
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeIdentifier: anIdentifierNode assignee: aBoolean
	| script binding |
	anIdentifierNode resolveAssigning: aBoolean.
	aBoolean ifTrue: [anIdentifierNode beAssigned].
	script := anIdentifierNode compiler activeScript.
	binding := anIdentifierNode binding.
	script reference: binding.
	binding isLocal ifTrue: [binding := script scope captureLocal: binding].
	anIdentifierNode binding: binding
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeMessage: aMessageNode
	inliner inline: aMessageNode.
	aMessageNode isInlined ifFalse: [aMessageNode compiler noticeSend]
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeMethod: aMethodNode while: aBlock
	self analyzeScript: aMethodNode while: aBlock
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeReturn: aReturnNode
	aReturnNode compiler activeScript realScript captureHome
! !

!SSemanticVisitor methodsFor: 'analizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
analyzeScript: aScriptNode while: aBlock
	aScriptNode compiler activate: aScriptNode while: aBlock
! !

!SSemanticVisitor methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	inliner := MessageInliner new
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitAssignment: anAssignmentNode
	self analyzeAssignment: anAssignmentNode.
	anAssignmentNode expression acceptVisitor: self
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitBlock: aBlockNode
	self
		analyzeBlock: aBlockNode
		while: [aBlockNode statements do: [:node | node acceptVisitor: self]]
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitBraceNode: aBraceNode
	aBraceNode isLiteral
		ifFalse: [aBraceNode asMessageNode acceptVisitor: self]
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitCascade: aCascadeNode
	aCascadeNode receiver acceptVisitor: self.
	aCascadeNode messages do: [:msg | msg acceptVisitor: self]
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitIdentifier: anIdentifierNode
	self analyzeIdentifier: anIdentifierNode
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitMessage: aMessageNode
	self analyzeMessage: aMessageNode.
	aMessageNode receiver acceptVisitor: self.
	aMessageNode arguments do: [:arg | arg acceptVisitor: self]
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitMethod: aMethodNode
	self analyzeMethod: aMethodNode while: [
		aMethodNode bindLocals.
		aMethodNode statements do: [:s | s acceptVisitor: self].
		aMethodNode positionLocals]
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitParseNode: aParseNode
	"
	do nothing
	"
	
! !

!SSemanticVisitor methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitReturn: aReturnNode
	aReturnNode expression acceptVisitor: self.
	self analyzeReturn: aReturnNode
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiledBlockIndexOf: aBlockNode
	| index |
	index := method
		findFirst: [:literal | literal isBlock
			and: [literal blockNumber == aBlockNode index]].
	^index
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeArgument: anInteger env: environment
	| encoded |
	encoded := self encodedEnvironment: environment.
	self
		nextPut: ArgumentId;
		nextIntegerPut: anInteger;
		nextIntegerPut: encoded
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeClosureElements: aBlockNode
	| scope parent |
	scope := aBlockNode scope.
	parent := aBlockNode realParent.
	^Array streamContents: [:s |
		scope capturesSelf ifTrue: [ s nextPut: CaptureSelf ].
		scope capturedEnvironments do: [:e | | index |
			e == parent ifTrue: [s nextPut: CaptureEnvironment] ifFalse: [
				index := aBlockNode environmentIndexOf: e.
				self ASSERT: index notNil.
				s nextPut: CaptureEnvironmentValue; nextPut: index]].
		scope capturedArguments do: [:a | | binding |
			binding := aBlockNode parent scope resolve: a name.
			s 	nextPut: binding environmentCaptureType; nextPut: binding index]]
	
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeDynamicVar: name
	stream nextPut: DynamicVarId.
	self nextSymbolPut: name
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeFalse
	stream nextPut: FalseId
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeLoadRvisitingReceiver
	stream nextPut: LoadRvisitingReceiverId
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeNestedDynamicVar: name
	stream nextPut: NestedDynamicVarId.
	self nextLiteralPut: name 
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeNil
	stream nextPut: NilId
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodePopR
	stream nextPut: PopRid 
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodePushR
	stream nextPut: PushRid 
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeSelf
	stream nextPut: SelfId
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeSuper
	stream nextPut: SuperId
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeTemporary: anInteger env: environment
	| encoded |
	encoded := self encodedEnvironment: environment.
	self
		nextPut: TemporaryId;
		nextIntegerPut: anInteger;
		nextIntegerPut: encoded
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeTrue
	stream nextPut: TrueId
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodedEnvironment: aLocalEnvironment
	aLocalEnvironment isStack
		ifTrue: [ ^ aLocalEnvironment isInlinedArgument
				ifTrue: [ -1 ]
				ifFalse: [ -2 ] ].
	aLocalEnvironment isCurrent
		ifTrue: [ ^ 0 ].
	^ aLocalEnvironment index
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextBigIntegerPut: anInteger
	stream
		nextPut: 16r80;
		nextInt64Put: anInteger
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextBooleanPut: aBoolean
	stream nextPut: aBoolean asParameter

! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextIntegerPut: anInteger
	| value |
	(anInteger > 127 or: [ anInteger < -127 ])
		ifTrue: [ ^ self nextBigIntegerPut: anInteger ].
	value := anInteger >= 0
		ifTrue: [ anInteger ]
		ifFalse: [ anInteger + 16r100 ].
	stream nextPut: value
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextLiteralPut: anObject
	| index |
	index := method
		indexOf: anObject
		ifAbsent: [ self ASSERT: false ].
	self nextIntegerPut: index
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextPut: anInteger
	stream nextPut: anInteger
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextPutAll: aCollection
	stream nextPut: aCollection size; nextPutAll: aCollection
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextSymbolPut: aSymbol
	| index |
	index := method
		indexOf: aSymbol asSymbol
		ifAbsent: [ self ASSERT: false ].
	self nextIntegerPut: index
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextTypePut: anInteger
	stream nextPut: anInteger
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitAssignment: anAssignmentNode
	| assignees |
	self nextTypePut: AssignmentId.
	assignees := anAssignmentNode assignees.
	self nextIntegerPut: assignees size.
	assignees do: [ :node | node acceptVisitor: self ].
	anAssignmentNode expression acceptVisitor: self
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitBlock: aBlockNode
	| args inlined |
	self nextTypePut: BlockId.
	inlined := aBlockNode isInlined.
	self nextBooleanPut: inlined.
	inlined
		ifTrue: [ args := aBlockNode arguments collect: [ :id | id binding index ].
			self nextPutAll: args asArray ]
		ifFalse: [ | index captured |
			index := self compiledBlockIndexOf: aBlockNode.
			self nextPut: index.
			captured := self encodeClosureElements: aBlockNode.
			self nextPutAll: captured ].
	self visitScript: aBlockNode
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitBraceNode: aBraceNode
	aBraceNode isLiteral
		ifTrue: [self visitLiteral: aBraceNode asLiteralNode]
		ifFalse: [self visitCascade: aBraceNode asMessageNode]
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitCascade: aCascadeNode
	| messages |
	self nextTypePut: CascadeId.
	aCascadeNode receiver acceptVisitor: self.
	messages := aCascadeNode messages.
	self nextIntegerPut: messages size.
	messages do: [ :node | self visitCascadeMessage: node ]
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitCascadeMessage: aCascadeMessageNode
	| arguments |
	self nextSymbolPut: aCascadeMessageNode selector symbol.
	arguments := aCascadeMessageNode arguments.
	self nextIntegerPut: arguments size.
	arguments do: [ :arg | arg acceptVisitor: self ]
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitIdentifier: anIdentifierNode
	self nextTypePut: IdentifierId.
	anIdentifierNode binding encodeUsing: self
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitLiteral: aLiteralNode
	| index |
	index := method indexOf: aLiteralNode value.
	self
		nextTypePut: LiteralId;
		nextIntegerPut: index.
	index = 0
		ifTrue: [ self nextIntegerPut: aLiteralNode value ]
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitMessage: aMessageNode
	| arguments |
	self
		nextTypePut: MessageId;
		nextBooleanPut: aMessageNode isInlined;
		nextSymbolPut: aMessageNode selector symbol.
	aMessageNode receiver acceptVisitor: self.
	arguments := aMessageNode arguments.
	self nextIntegerPut: arguments size.
	arguments do: [ :arg | arg acceptVisitor: self ]
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitMethod: aMethodNode
	| pragma |
	self nextTypePut: MethodId.
	pragma := aMethodNode pragma.
	pragma isUsed
		ifTrue: [ self nextTypePut: PragmaId.
			pragma name
				ifNotNil: [ self nextSymbolPut: pragma name ]
				ifNil: [ self nextPut: 0 ] ].
	self visitScript: aMethodNode.
	^ stream contents 
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitParseNode: aParseNode
	^self ASSERT: false
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitReturn: aReturnNode
	self
		nextTypePut: ReturnId;
		nextBooleanPut: script realScript isMethod.
	
		aReturnNode expression acceptVisitor: self
! !

!TreecodeEncoder methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
visitScript: aScriptNode
	| prev statements |
	prev := script.
	script := aScriptNode.
	statements := aScriptNode statements.
	self nextIntegerPut: statements size.
	statements do: [ :node | node acceptVisitor: self ].
	script := prev
! !

!TreecodeEncoder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	stream := #[] writeStream
! !

!TreecodeEncoder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
method: aCompiledMethod
	method := aCompiledMethod
! !

!TreecodeEncoder class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeBindingIds
	| named |
	named := self addNamespaceAs: #BindingIds.
	named
		at: #NilId put: 1;
		at: #TrueId put: 2;
		at: #FalseId put: 3;
		at: #ArgumentId put: 4;
		at: #TemporaryId put: 5;
		at: #SelfId put: 6;
		at: #SuperId put: 7;
		at: #DynamicVarId put: 14;
		at: #NestedDynamicVarId put: 15;
		at: #PushRid put: 50;
		at: #PopRid put: 51
! !

!TreecodeEncoder class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeTreecodeIds
	| named |
	named := self addNamespaceAs: #TreecodeIds.
	named
		at: #MethodId put: 101;
		at: #BlockId put: 102;
		at: #IdentifierId put: 103;
		at: #LiteralId put: 104;
		at: #MessageId put: 105;
		at: #CascadeId put: 106;
		at: #BraceId put: 107;
		at: #AssignmentId put: 108;
		at: #ReturnId put: 109;
		at: #PragmaId put: 110
! !

!ScriptScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
capturesSelf
	^ captureSelf
! !

!ScriptScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
describe: identifier
	| binding type |
	binding := self resolve: identifier.
	type := self class name asLowercase allButLast: 'scope' size.
	^binding description , ' of ' , type
! !

!ScriptScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentSize
	^envSize
! !

!ScriptScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scopeOf: aString
	| s |
	s := self scriptDefining: aString.
	^s notNil ifTrue: [s scope]
! !

!ScriptScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stackSize
	^stackSize
! !

!ScriptScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
defineArgument: identifier
	| binding |
	(self resolves: identifier) ifTrue: [self redefinitionError: identifier].
	binding := ArgumentBinding new name: identifier.
	arguments define: identifier as: binding.
	^binding
! !

!ScriptScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
defineTemporary: identifier
	| binding |
	(temporaries defines: identifier)
		ifTrue: [self redefinitionError: identifier].
	binding := TemporaryBinding new name: identifier.
	temporaries define: identifier as: binding.
	^binding
! !

!ScriptScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
defines: aString
	^(temporaries defines: aString) or: [arguments defines: aString]
! !

!ScriptScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
localBindings
	^arguments values , temporaries values
! !

!ScriptScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolveLocal: aString
	(temporaries at: aString) ifNotNil: [:binding | ^binding].
	^arguments at: aString
! !

!ScriptScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolves: aString
	^(self resolve: aString) isDynamic not
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
growEnvironment
	^envSize := envSize + 1
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
growStack
	^stackSize := stackSize + 1
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionDefinedArguments
	arguments withIndexDo: [:binding :index | binding index: index]
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionDefinedLocals
	self positionDefinedTemporariesIn: self; positionDefinedArguments
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionDefinedTemporariesIn: aScriptScope
	temporaries do: [:binding | | position |
		position := binding isInStack
			ifTrue: [aScriptScope growStack]
			ifFalse: [aScriptScope growEnvironment].
		binding index: position]
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionLocals
	self positionDefinedLocals
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
realScope
	^script realScript scope
! !

!ScriptScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
redefinitionError: name
	| scope description |
	scope := self scopeOf: name.
	description := scope describe: name.
	script compiler
		warning: name , ' already declared as ' , description
		at: script stretch
! !

!ScriptScope methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	arguments := StaticBinder new.
	temporaries := StaticBinder new.
	stackSize := envSize := 0.
		captureSelf := false.
! !

!ScriptScope methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
script: aScriptNode
	script := aScriptNode
! !

!ScriptScope class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
on: aScriptNode
	^self new script: aScriptNode
! !

!BlockScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureArgument: anArgumentBinding
	| name |
	name := anArgumentBinding name.
	^captured at: name ifAbsentPut: [| transferred copy |
		transferred := self parent transferLocal: name.
		copy := self copyLocal: transferred.
		copy declaration: transferred declaration]
! !

!BlockScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
localBindings
	^super localBindings , captured values
! !

!BlockScope methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolve: aString
	(self resolveLocal: aString) ifNotNil: [:binding | ^binding].
	^self parent resolve: aString
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureEnvironment: aScriptNode
	script == aScriptNode ifTrue: [^self].
	(environments includesIdentical: aScriptNode) ifTrue: [^self].
	self realParent captureEnvironment: aScriptNode.
	aScriptNode isMethod
		ifTrue: [environments addFirst: aScriptNode]
		ifFalse: [environments addLast: aScriptNode]
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
capturedEnvironmentIndexOf: aScriptNode
	| index |
	aScriptNode realScript == script realScript
		ifTrue: [ ^ nil ].
	index := environments indexOf: aScriptNode ifAbsent: nil.
	self ASSERT: index notNil.
	^self capturesSelf ifTrue: [ index + 1 ] ifFalse: [ index ]
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
copyLocal: binding
	^script isInlined ifTrue: [binding] ifFalse: [binding copy beInArray]
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentIndexOf: aScriptNode
	"
	temporal compatibility
	"
	(aScriptNode isKindOf: SScriptNode)
		ifFalse: [ self ASSERT: false. ^nil ].
	^self capturedEnvironmentIndexOf: aScriptNode
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentSizeUpToCapturedArguments
	^self environmentSizeUpToEnvironments + self capturedArguments size
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentSizeUpToEnvironments
	| receiver |
	receiver := self capturesSelf ifTrue: [ 1 ] ifFalse: [ 0 ].
	^receiver + environments size
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parent
	^script parent scope
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionCapturedArgument: anArgumentBinding
	anArgumentBinding index: self growEnvironment
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionCapturedLocals
	script isInlined ifTrue: [^self].
	envSize := self environmentSizeUpToEnvironments.
	captured do: [:binding | 
		binding isArgument
			ifTrue: [self positionCapturedArgument: binding]
			ifFalse: [self positionCapturedTemporary: binding]]
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionCapturedTemporary: aTemporaryBinding
	| outest index declaration |
	outest := self scriptDefining: aTemporaryBinding name.
	index := self capturedEnvironmentIndexOf: outest realScript.
	aTemporaryBinding environmentIndex: index.
	declaration := outest scope resolve: aTemporaryBinding name.
	self ASSERT: declaration index isInteger.
	aTemporaryBinding index: declaration index
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionDefinedArgumentsIn: aScriptScope
	arguments do: [:binding | | index |
		index := binding isInArray
			ifTrue: [aScriptScope growEnvironment]
			ifFalse: [aScriptScope growStack].
		binding index: index]
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionDefinedLocals
	| real |
	script isInlined
		ifTrue: [
			real := self realScope.
			self
				positionDefinedTemporariesIn: real;
				positionDefinedArgumentsIn: real]
		ifFalse: [super positionDefinedLocals]
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionLocals
	self positionCapturedLocals.
	super positionLocals
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
realParent
	^script realParent scope
! !

!BlockScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
transferLocal: name
	| binding copy |
	(self resolveLocal: name) ifNotNil: [:b | ^b].
	binding := self parent transferLocal: name.
	copy := self copyLocal: binding.
	captured at: name put: copy.
	^copy
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureLocal: aLocalBinding
	(self defines: aLocalBinding name) ifTrue: [^aLocalBinding].
	^aLocalBinding isTemporary
		ifTrue: [self captureTemporary: aLocalBinding]
		ifFalse: [self captureArgument: aLocalBinding]
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureSelf
	captureSelf ifTrue: [^self].
	captureSelf := true.
	self parent captureSelf
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureTemporary: aTemporaryBinding
	| name |
	name := aTemporaryBinding name.
	(self defines: name) ifTrue: [^aTemporaryBinding].
	^captured at: name ifAbsentPut: [| parent declaration transferred copy |
		parent := self parent.
		declaration := parent scriptDefining: name.
		self realScope captureEnvironment: declaration realScript.
		transferred := parent transferLocal: name.
		copy := self copyLocal: transferred.
		copy isInArray ifTrue: [aTemporaryBinding beInArray].
		copy declaration: transferred declaration]
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
capturedArguments
	^captured select: [:b | b isArgument]
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
capturedEnvironments
	^environments
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
capturesHome
	^self home notNil
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environments
	"
	compatibility, removes the home environment
	"
	| first |
	environments isEmpty ifTrue: [^#()].
	first := environments first.
	^first isMethod ifTrue: [environments allButFirst] ifFalse: [environments]
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
home
	| first |
	environments isEmpty ifTrue: [^nil].
	first := environments first.
	^first isMethod ifTrue: [first]
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolveLocal: aString
	(super resolveLocal: aString) ifNotNil: [:binding | ^binding].
	^captured at: aString
! !

!BlockScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scriptDefining: aString
	(self defines: aString) ifTrue: [^script].
	^self parent scriptDefining: aString
! !

!BlockScope methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	captured := StaticBinder new.
	environments := OrderedCollection new
! !

!MethodScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureEnvironment: aScriptNode
	self ASSERT: aScriptNode == script
! !

!MethodScope methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
transferLocal: name
	^self resolveLocal: name
! !

!MethodScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureLocal: aLocalBinding
	self ASSERT: (self resolveLocal: aLocalBinding name) notNil.
	^aLocalBinding
! !

!MethodScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureSelf
	captureSelf := true.

! !

!MethodScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentIndexOf: aScriptNode
	self ASSERT: aScriptNode == script.
	^nil
! !

!MethodScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolve: aString
	(self resolveLocal: aString) ifNotNil: [ :binding | ^ binding ].
	(self resolvePseudo: aString) ifNotNil: [ :binding | ^ binding ].
	^ DynamicBinding named: aString
! !

!MethodScope methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scriptDefining: aString
	(self resolveLocal: aString) ifNotNil: [^script].
	self ASSERT: false.
	^nil
! !

!MethodScope methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	self initializePseudoVars
! !

!MethodScope methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializePseudoVars
	pseudo := StaticBinder new.
	pseudo
		at: 'nil' put: NilBinding new;
		at: 'true' put: TrueBinding new;
		at: 'false' put: FalseBinding new;
		at: 'self' put: SelfBinding new;
		at: 'super' put: SuperBinding new
! !

!MethodScope methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolvePseudo: aString
	^pseudo at: aString

! !

!Binding methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beReferencedFrom: aScriptNode
	
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canBeAssigned
	^true
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
declaration
	^self
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEncoder
	self ASSERT: false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isArgument
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isClassBinding
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isClassVariable
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isConstantBinding
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isDynamic
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isGlobal
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInStack
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInstVar
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isLiteral
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isLocal
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isPoolVariableBinding
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSelf
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSelfOrSuper
	^self isSelf or: [self isSuper]
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSuper
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isTemporary
	^false
! !

!Binding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
literal
	^nil
! !

!Binding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	^name
! !

!Binding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name: aString
	name := aString
! !

!Binding methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printNameOn: aStream
		aStream
		print: name

! !

!Binding methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream
	self printNameOn: aStream.
	aStream
		nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPutAll: ')'
! !

!DynamicBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beReferencedFrom: aScriptNode
	"a dynamic binding could refer to an ivar, so we have to be conservative"
	aScriptNode useSelf
! !

!DynamicBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeDynamicVar: name
! !

!DynamicBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isDynamic
	^true
! !

!DynamicBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
literal
	^name asSymbol
! !

!DynamicBinding class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
default
	^Default ifNil: [Default := self new name: '<unresolved>']
! !

!DynamicBinding class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
named: aString
	| index first second |
	index := aString indexOf: $..
	index = 0 ifTrue: [ ^self new name: aString ].
	first := aString copyFrom: 1 to: index - 1.
	second := aString copyFrom: index + 1 to: aString size.
	^NestedDynamicBinding new name: { first. second }
! !

!NestedDynamicBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeNestedDynamicVar: name
! !

!NestedDynamicBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
literal
	^name collect: [ :n | n asSymbol]
! !

!NestedDynamicBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printNameOn: aStream
	name do: [ :n | aStream nextPutAll: n ] separatedBy: [ aStream nextPut: $. ]
! !

!LiteralBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isLiteral
	^true
! !

!FalseBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeFalse
! !

!FalseBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	^'false'
! !

!FalseBinding methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value
	^false
! !

!NilBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeNil
! !

!NilBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
name
	^'nil'
! !

!NilBinding methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
value
	^nil
! !

!TrueBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeTrue
! !

!TrueBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	^'true'
! !

!TrueBinding methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value
	^true
! !

!LocalBinding methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beInArray
	environment := ArrayEnvironment new
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
declaration
	^declaration
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
declaration: anIdentifierNode
	declaration := anIdentifierNode
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environment
	^environment index
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentCaptureType
	^environment captureType
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentIndex
	^environment index
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentIndex: anInteger
	environment index: anInteger
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentObject
	^environment
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index
	^index
! !

!LocalBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index: aNumber
	index := aNumber
! !

!LocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInArray
	^self isInStack not
! !

!LocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInStack
	^environment isStack
! !

!LocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isLocal
	^true
! !

!ArgumentBinding methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beInlined
	environment := InlinedArgEnvironment new
! !

!ArgumentBinding methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
description
	^'argument ' , name
! !

!ArgumentBinding methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEncoder
	aTreecodeEncoder encodeArgument: index env: environment
! !

!ArgumentBinding methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInlined
	^environment isInlinedArgument
! !

!ArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canBeAssigned
	^false
! !

!ArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index: aNumber
	index := aNumber.

! !

!ArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isArgument
	^true
! !

!ArgumentBinding methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	environment := ArgumentEnvironment new
! !

!TemporaryBinding methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
description
	^'temporary ' , name
! !

!TemporaryBinding methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEncoder
	aTreecodeEncoder encodeTemporary: index env: environment
! !

!TemporaryBinding methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	environment := StackEnvironment new
! !

!TemporaryBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isTemporary
	^true
! !

!SelfBinding methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beReferencedFrom: aScriptNode
	aScriptNode useSelf
! !

!SelfBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canBeAssigned
	^false
! !

!SelfBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeSelf
! !

!SelfBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSelf
	^true
! !

!SelfBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	^'self'
! !

!SuperBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeSuper
! !

!SuperBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	^'super'
! !

!SuperBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSelf
	^false
! !

!SuperBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSuper
	^true
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
activate: aScriptNode while: aBlock
	| current |
	current := activeScript.
	activeScript := aScriptNode.
	aBlock value.
	activeScript := current
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
activeScope
	^activeScript scope
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
activeScript
	^activeScript
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
activeScript: aParseNode
	activeScript := aParseNode
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ast
	^ast
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
frontend
	^frontend
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
frontend: aCompiler
	frontend := aCompiler
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parser
	^SSmalltalkParser new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
result
	^result
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scanner
	^SSmalltalkScanner new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sourceCode
	^source
! !

!SSmalltalkCompiler methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sourceCode: aString
	source := aString
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assignmentNode
	^SAssignmentNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
blockNode
	^SBlockNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
braceNode
	^SBraceNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildMethod
	result method: ast buildMethod
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
cascadeMessageNode
	^SCascadeMessageNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
cascadeNode
	^SCascadeNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
commentNode
	^SCommentNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compileMethod: aString
	source := aString.
	frontend protect: [
		self
			parseMethod;
			resolveSemantics;
			buildMethod].
	^result
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
delimiterToken
	^SDelimiterToken new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
endToken
	^SEndToken new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasBlocks
	^ blocks > 0
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasSends
^ leaf not
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
identifierNode
	^SIdentifierNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	self reset

! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
literalNode
	^SLiteralNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
messageNode
	^SMessageNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodNode
	^SMethodNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
noticeSend
	leaf := false
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
numericLiteralNode
	^SNumberNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pragmaNode
	^SPragmaNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reset
	self resetResult.
	leaf := true.
	blocks := 0.
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
returnNode
	^SReturnNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
selectorNode
	^SSelectorNode new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'nodes' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stringToken
	^SStringToken new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'emitting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
blockCount
	^blocks
! !

!SSmalltalkCompiler methodsFor: 'emitting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
blockIndex
	blocks := blocks + 1.
	^blocks - 1
! !

!SSmalltalkCompiler methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compilationError: aString stretch: aStretch
	^SCompilationError new
		compiler: self;
		stretch: aStretch;
		description: aString
! !

!SSmalltalkCompiler methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error: aString at: anInteger
	| stretch |
	stretch := anInteger thru: anInteger.
	^self error: aString stretch: stretch
! !

!SSmalltalkCompiler methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error: aString stretch: aStretch
	| error |
	error := self compilationError: aString stretch: aStretch.
	^error beFatal; signal
! !

!SSmalltalkCompiler methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
warning: aString at: aStretch
	| error |
	error := self compilationError: aString stretch: aStretch.
	error beWarning; signal
! !

!SSmalltalkCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseFragment
	headless := false.
	self reset.
	ast := self parser methodFragment.
	result ast: ast
! !

!SSmalltalkCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseFragment: aString
	source := aString.
	[self parseFragment; resolveSemantics] on: SCompilationError do: [].
	^ast
! !

!SSmalltalkCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseMethod
	headless := false.
	self reset.
	ast := self parser method.
	result ast: ast
! !

!SSmalltalkCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseMethod: aString
	source := aString.
	frontend protect: [self parseMethod; resolveSemantics].
	^result
! !

!SSmalltalkCompiler methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolveSemantics
	ast acceptVisitor: SSemanticVisitor new
! !

!SSmalltalkCompiler methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resetResult
	result := SCompilationResult new compiler: self
! !

!SSmalltalkCompiler methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
supportsBraceNodes
	^true
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addBodyTo: aMethodNode
	self
		addTemporariesTo: aMethodNode;
		addPragmaTo: aMethodNode;
		addStatementsTo: aMethodNode
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addStatementsTo: aMethodNode
	aMethodNode
		position: token position;
		addStatements: self statements;
		end: token position;
		moveCommentsFrom: token.
	token isEnd
		ifFalse: [^self unexpectedStatementError: aMethodNode statements]
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addTemporariesTo: aMethodNode
	aMethodNode temporaries: self temporaries
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
cascadeSequence: aMessageNode
	| cascade receiver messages msg node |
	(token is: $;) ifFalse: [^aMessageNode].
	cascade := self buildNode: compiler cascadeNode at: aMessageNode position.
	receiver := aMessageNode receiver.
	cascade receiver: receiver.
	node := compiler cascadeMessageNode from: aMessageNode.
	node cascade: cascade.
	messages := OrderedCollection with: node.
	[token is: $;] whileTrue: [
		self step.
		msg := self buildCascadeMessageNode: receiver.
		msg
			cascade: cascade;
			position: token position;
			moveCommentsFrom: token.
		messages add: msg.
		self cascadeMessage: msg].
	^cascade messages: messages asArray; end: msg end
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
expression
	| primary expression |
	(token isNameToken and: [self peek isAssignment]) ifTrue: [^self assignment].
	primary := self primary ifNil: [^self missingExpression].
	expression := self unarySequence: primary.
	expression := self binarySequence: expression.
	expression := self keywordSequence: expression.
	expression == primary
		ifFalse: [expression := self cascadeSequence: expression].
	token endsExpression ifFalse: [self errorIn: primary].
	^expression
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
keywordSignature
	| selector arguments node |
	selector := '' writeStream.
	arguments := OrderedCollection new.
	node := self buildNode: compiler selectorNode at: token position.
	[token isKeyword] whileTrue: [
		selector nextPutAll: token value.
		node addKeyword: token asSelectorNode.
		self step.
		token isNameToken ifFalse: [self missingArgument].
		arguments add: token asIdentifierNode.
		self step].
	arguments isEmpty ifTrue: [^nil].
	node
		symbol: selector contents;
		end: token end;
		moveCommentsFrom: token.
	^self buildMethodNode: node arguments: arguments
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodPragma
	self step.
	^[| method |
		method := self methodSignature.
		self addTemporariesTo: method; attachPragmaTo: method.
		method pragma]
		on: SCompilationError
		do: [:ex | ex return: compiler pragmaNode]
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodSignature
	self keywordSignature ifNotNil: [:m | ^m].
	self binarySignature ifNotNil: [:m | ^m].
	self unarySignature ifNotNil: [:m | ^m].
	self error: 'method signature expected'
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parenthesizedExpression
	| start open expression |
	start := token position.
	open := self step.
	expression := self expression.
	expression moveCommentsFrom: open.
	(token is: $)) ifFalse: [self missingToken: ')'].
	expression isImmediate
		ifFalse: [expression position: start; end: token position].
	self step.
	^expression
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
primary
	token isNameToken ifTrue: [^self step asIdentifierNode].
	token isLiteral ifTrue: [^self step].
	(token is: $[) ifTrue: [^self block].
	(token is: $() ifTrue: [^self parenthesizedExpression].
	(token is: #'#(') ifTrue: [^self literalArray].
	(token is: #'#[') ifTrue: [^self literalByteArray].
	(compiler supportsBraceNodes and: [token is: ${]) ifTrue: [^self bracedArray].
	(token is: #'-') ifTrue: [^self negativeNumber].
	(token is: #'<') ifTrue: [^self taggedNode].
	^nil
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
return
	| return expression end node |
	return := self step.
	expression := self expression.
	expression moveCommentsFrom: token.
	end := token position.
	self skipDots.
	node := self buildNode: compiler returnNode at: return position.
	^node
		return: return;
		end: end;
		expression: expression;
		moveCommentsFrom: return
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
statement
	| expression |
	((token is: $^) or: [token is: $↑]) ifTrue: [^self return].
	expression := self expression.
	token moveCommentsTo: expression.
	^expression
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
statements
	| statements |
	statements := OrderedCollection new.
	[
		token endsExpression ifTrue: [^statements].
		statements add: self statement.
		token is: $.]
		whileTrue: [self skipDots].
	^statements
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
step
	| save comments |
	save := token.
	self next isComment ifFalse: [^save].
	comments := OrderedCollection new: 2.
	[
		comments add: token.
		self next isComment] whileTrue.
	token comments: comments.
	^save
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
temporaries
	| temporaries |
	(token is: #'||') ifTrue: [
		self step.
		^#()].
	token isBar ifFalse: [^#()].
	temporaries := OrderedCollection new.
	[
		self step.
		token isNameToken]
		whileTrue: [
			self validateLocalName: token.
			temporaries add: token asIdentifierNode].
	token isBar ifFalse: [self missingToken: '|'].
	self step.
	^temporaries
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
unaryMessage: aMessageNode
	| selector |
	selector := self unarySelector.
	aMessageNode
		selector: selector;
		end: selector end;
		arguments: #();
		moveCommentsFrom: selector
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
unarySelector
	| selector start end node |
	selector := token value.
	start := token position.
	end := start + selector size - 1.
	self step.
	node := self buildNode: compiler selectorNode at: start.
	^node
		symbol: selector;
		end: end;
		moveCommentsFrom: token
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
unarySequence: aParseNode
	| node receiver |
	node := aParseNode.
	node isNameToken ifTrue: [node := node asIdentifierNode].
	[
		receiver := node.
		self hasUnarySelector]
		whileTrue: [
			node := self buildMessageNode: receiver.
			self unaryMessage: node].
	^node moveCommentsFrom: token
! !

!SSmalltalkParser methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
unarySignature
	self hasUnarySelector ifFalse: [^nil].
	^self buildMethodNode: self unarySelector arguments: #()
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addByteTo: aCollection
	| byte |
	byte := token isLiteral ifTrue: [token value] ifFalse: [token literalValue].
	byte isInteger ifFalse: [self nonIntegerToken].
	(byte between: 0 and: 255) ifFalse: [self invalidByteValue].
	aCollection add: byte
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assignment
	| position variable delimiter expression assignment |
	position := token position.
	variable := self step asIdentifierNode moveCommentsFrom: token.
	delimiter := self step.
	expression := self expression.
	expression isAssign
		ifTrue: [^expression assign: variable operator: delimiter].
	expression moveCommentsFrom: token.
	assignment := self buildNode: compiler assignmentNode at: position.
	^assignment assign: variable with: expression operator: delimiter
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
attachPragmaTo: aMethodNode
	| start pragma |
	(aMethodNode isHeadless orNot: [token is: #'<']) ifTrue: [^false].
	start := token position.
	self step.
	pragma := token isKeyword
		ifTrue: [self ffiOrPrimitive: aMethodNode]
		ifFalse: [self symbolicPragma].
	pragma position: start; end: token position.
	aMethodNode pragma: pragma.
	(token is: #'>') ifFalse: [self missingToken: '>'].
	^true
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildBraceNode: elements at: position
	| node |
	node := self buildNode: compiler braceNode at: position.
	^node elements: elements
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildCascadeMessageNode: receiver
	| node |
	node := self buildNode: compiler cascadeMessageNode at: receiver position.
	^node receiver: receiver
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildMessageNode: receiver
	| node |
	node := self buildNode: compiler messageNode at: receiver position.
	^node receiver: receiver
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildMethodNode: selector arguments: arguments
	| node |
	node := self buildNode: compiler methodNode at: selector position.
	compiler activeScript: node.
	^node selector: selector; arguments: arguments
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildNode: aParserNode at: anInteger
	^aParserNode position: anInteger; end: token position
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildNode: aParseNode at: anInteger with: anObject
	| node |
	node := scanner buildToken: aParseNode at: anInteger with: anObject.
	^node end: token position
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
cascadeMessage: aMessageNode
	| msg |
	self hasUnarySelector ifTrue: [^self unaryMessage: aMessageNode].
	self hasBinarySelector ifTrue: [^self binaryMessage: aMessageNode].
	self hasKeywordSelector ifTrue: [^self keywordMessage: aMessageNode].
	msg := token value = ''
		ifTrue: ['unfinished cascade']
		ifFalse: [token value asString , ' not allowed in cascade'].
	self error: msg
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ffiArguments
	| args type |
	args := OrderedCollection new.
	self step.
	token value !!= $(
		ifTrue: [ self error: 'expected "("' ].
	self peek value = $)
		ifTrue: [ self step.
			^ args ].
	[ type := self ffiType.
	args add: type.
	self step.
	token value = #, ] whileTrue.
	token value !!= $)
		ifTrue: [ self error: 'expected ")"' ].
	^ args
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ffiCall: aBoolean method: aMethodNode
	| cc return name args descriptor |
	cc := token value.
	return := self ffiType.
	aBoolean
		ifTrue: [ self step.
			name := token value ifNil: [ self error: 'invalid function name' ] ].
	args := self ffiArguments.
	args size = aMethodNode selector arity
		ifFalse:
			[ ^ self error: 'method arity does not match with function arguments' ].
	self step.
	descriptor := SFFIDescriptor ret: return args: args cc: cc.
	^ compiler pragmaNode ffi: cc name: name with: descriptor
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ffiOrPrimitive: aMethodNode
	| tag |
	tag := token value asLowercase.
	tag last = $: ifFalse: [self invalidPragma].
	tag := tag allButLast.
	token value: tag.
	tag = 'primitive' ifTrue: [^self primitive].
	tag = 'callback' ifTrue: [ ^self ffiCall: false method: aMethodNode ].
	tag = 'callout' ifTrue: [ ^self ffiCall: true method: aMethodNode ].	
	self invalidPragma
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ffiType
	| type |
	self step.
	token isNameToken ifFalse: [self error: 'expected type name'].
	type := token value.
	type = 'struct' ifFalse: [ ^type].
	self step.
	token isNameToken ifFalse: [self error: 'expected type name'].	
	^token value
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasKeywordSelector
	^token isKeyword
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasUnarySelector
	^token isNameToken
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
invalidPragma
	| position stretch |
	position := token position.
 	stretch := position thru: position.
	^SInvalidPragmaError new stretch: stretch; signal
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
keywordArgument
	| arg |
	arg := self primary ifNil: [self missingArgument].
	arg := self unarySequence: arg.
	^self binarySequence: arg
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
keywordMessage: aMessageNode
	| selector arguments node |
	node := self buildNode: compiler selectorNode at: token position.
	selector := '' writeStream.
	arguments := OrderedCollection new.
	[token isKeyword] whileTrue: [
		selector nextPutAll: token value.
		node addKeyword: self step.
		arguments add: self keywordArgument].
	node symbol: selector contents; end: token prevPosition.
	aMessageNode
		arguments: arguments;
		end: token prevPosition;
		selector: node
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
keywordSequence: aParseNode
	| expression |
	self hasKeywordSelector ifFalse: [^aParseNode].
	expression := self buildMessageNode: aParseNode.
	self keywordMessage: expression.
	^expression
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
literalKeyword
	| keyword |
	keyword := token value , scanner nextKeyword value.
	^keyword reduced asSymbol
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
namedPrimitive
	| name pragma |
	token isNameToken
		ifFalse: [ self invalidPragma ].
	name := token value.
	pragma := self buildNode: compiler pragmaNode at: token position.
	^ pragma primitive: 0 name: name asSymbol
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
negativeNumber
	token := nil.
	^self negativeNumberOrBinary; step
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
numberedPrimitive
	| number pragma |
	number := token value.
	number isInteger ifFalse: [self invalidPragma].
	pragma := self buildNode: compiler pragmaNode at: token position.
	^pragma primitive: number name: nil
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
primitive
	| primitive |
	self step.
	primitive := token isNumberNode
		ifTrue: [self numberedPrimitive]
		ifFalse: [self namedPrimitive].
	self step.
	^primitive
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
pseudoLiteralValue
	| value |
	token isPoolLiteral ifTrue: [^token literalValue].
	value := token value.
	value = 'nil' ifTrue: [^nil].
	value = 'true' ifTrue: [^true].
	value = 'false' ifTrue: [^false].
	^token isPoolLiteral ifTrue: [token literalValue] ifFalse: [value asSymbol]
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
skipDots
	[token is: $.] whileTrue: [self step]
! !

!SSmalltalkParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
validateLocalName: aSmalltalkToken
	aSmalltalkToken isDelimitedIdentifier ifTrue: [^self].
	(aSmalltalkToken value includes: $.)
		ifTrue: [self error: 'invalid embedded dot']
! !

!SSmalltalkParser methodsFor: 'api support' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addPragmaTo: aMethodNode
	(self attachPragmaTo: aMethodNode) ifTrue: [self step]
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
arrayBody
	| literals position |
	literals := OrderedCollection new.
	position := token position.
	[
		self step.
		(token is: $)) or: [token isEnd]]
		whileFalse: [| element |
			element := self arrayElement.
			literals add: element].
	token isEnd ifTrue: [self missingToken: ')'].
	^self buildNode: compiler literalNode at: position with: literals asArray
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
arrayElement
	token isLiteral ifTrue: [^token value].
	token isNameToken ifTrue: [^self pseudoLiteralValue].
	token isKeyword ifTrue: [^self literalKeyword].
	(token is: #'-') ifTrue: [^self negativeNumberOrBinary].
	token hasSymbol ifTrue: [^token value].
	(token is: $() ifTrue: [^self arrayBody value].
	(token is: #'#(') ifTrue: [^self arrayBody value].
	(token is: #'#[') ifTrue: [^self byteArrayBody value].
	self invalidArrayToken
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
braceBody
	| elements position |
	elements := OrderedCollection new.
	position := token position.
	self step.
	[
		token isEnd ifTrue: [self missingToken: '}'].
		token is: $}]
		whileFalse: [
			elements add: self expression.
			(token is: $.) ifTrue: [self step]].
	^self buildBraceNode: elements at: position
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bracedArray
	| array |
	array := self braceBody.
	self step.
	^array
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
byteArrayBody
	| bytes save start array node |
	bytes := OrderedCollection new.
	save := token.
	start := token position.
	[
		self step.
		token isLiteral or: [token isPoolLiteral]]
		whileTrue: [self addByteTo: bytes].
	(token is: $]) ifFalse: [
		token isNameToken
			ifTrue: [self missingLiteral]
			ifFalse: [self missingToken: ']']].
	array := ByteArray new: bytes size.
	bytes withIndexDo: [:b :i | array at: i put: b].
	node := self buildNode: compiler literalNode at: start with: array.
	^node moveCommentsFrom: save
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
literalArray
	| array |
	array := self arrayBody.
	self step.
	^array
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
literalByteArray
	| node |
	node := self byteArrayBody.
	self step.
	^node
! !

!SSmalltalkParser methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
negativeNumberOrBinary
	self peek isNumberNode
		ifTrue: [token := self next negate position: token position - 1].
	^token value
! !

!SSmalltalkParser methodsFor: 'binary' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
binaryMessage: aMessageNode
	| selector primary argument |
	selector := self step.
	primary := self primary.
	primary isNil ifTrue: [
		((selector is: $:) and: [token is: #'='])
			ifTrue: [self
				error: 'stray whitespaces left in assignment'
				at: token position - 1]
			ifFalse: [self error: 'primary missing']].
	argument := self unarySequence: primary.
	aMessageNode
		selector: selector asSelectorNode;
		end: argument end;
		arguments: {argument}
! !

!SSmalltalkParser methodsFor: 'binary' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
binarySequence: aParseNode
	| node rcvr |
	node := aParseNode.
	[
		rcvr := node.
		self hasBinarySelector]
		whileTrue: [
			node := self buildMessageNode: rcvr.
			self binaryMessage: node].
	^node
! !

!SSmalltalkParser methodsFor: 'binary' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
binarySignature
	| selector arguments |
	((token isStringToken and: [token hasSymbol])
		or: [token is: $^]
		or: [token is: $:])
		ifFalse: [^nil].
	selector := self step asSelectorNode.
	token isNameToken ifFalse: [self missingArgument].
	self validateLocalName: token.
	arguments := {token asIdentifierNode}.
	self step.
	token moveCommentsTo: selector.
	^self buildMethodNode: selector arguments: arguments
! !

!SSmalltalkParser methodsFor: 'binary' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasBinarySelector
	^(token isStringToken and: [token hasSymbol])
		or: [token is: $^]
		or: [token is: $:]
! !

!SSmalltalkParser methodsFor: 'blocks' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
block
	| block |
	block := self buildNode: compiler blockNode at: token position.
	block parent: compiler activeScript.
	compiler activate: block while: [
		token moveCommentsTo: block.
		self step.
		block
			arguments: self blockArguments;
			temporaries: self temporaries;
			addStatements: self statements.
		(token is: $]) ifFalse: [self missingToken: ']'].
		block end: token position.
		token moveCommentsTo: block.
		self step].
	^block
! !

!SSmalltalkParser methodsFor: 'blocks' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
blockArguments
	| arguments |
	(token is: $:) ifFalse: [^#()].
	arguments := OrderedCollection new.
	[
		self step.
		token isNameToken ifFalse: [self missingArgument].
		self validateLocalName: token.
		arguments add: self step asIdentifierNode.
		token is: $:] whileTrue.
	token isBar ifTrue: [self step] ifFalse: [
		(token is: #'||')
			ifTrue: [token value: #'|']
			ifFalse: [self missingToken: '|']].
	^arguments
! !

!SSmalltalkParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler
	^compiler
! !

!SSmalltalkParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler: aSmalltalkCompiler
	compiler := aSmalltalkCompiler.
	scanner := compiler scanner
! !

!SSmalltalkParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
next
	token := next.
	next := nil.
	^token ifNil: [token := scanner next]
! !

!SSmalltalkParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
on: aString
	scanner on: aString
! !

!SSmalltalkParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
peek
	| comments |
	next ifNotNil: [^next].
	next := scanner next.
	next isComment ifFalse: [^next].
	comments := OrderedCollection new: 2.
	[
		comments add: next.
		next := scanner next.
		next isComment] whileTrue.
	^next comments: comments
! !

!SSmalltalkParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
token
	^token
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error: aString
	self error: aString at: token position
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error: aString at: position
	^compiler error: aString at: position
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
invalidArrayToken
	self error: 'invalid literal entry'
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
invalidByteValue
	self error: 'value not between 0 and 255'
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
missingArgument
	self error: 'argument missing'
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
missingExpression
	self error: 'missing expression'
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
missingLiteral
	self error: 'missing literal or named literal'
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
missingToken: aString
	self error: 'missing ' , aString
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nonIntegerToken
	self error: 'non-integer token'
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
notify: aString
	compiler notify: aString at: token position
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
notify: aString at: position
	compiler notify: aString at: position
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
warning: aString
	compiler warning: aString at: token position
! !

!SSmalltalkParser methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
warning: aString at: position
	compiler warning: aString at: position
! !

!SSmalltalkParser methodsFor: 'productions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
headlessMethod
	| method |
	self step.
	method := compiler methodNode.
	compiler activeScript: method.
	self addBodyTo: method.
	^method
! !

!SSmalltalkParser methodsFor: 'productions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
method
	| method |
	self step.
	method := self methodSignature.
	method isNil ifTrue: [^nil].
	self addBodyTo: method.
	^method
! !

!SSmalltalkParser methodsFor: 'productions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodFragment
	| method |
	self step.
	method := self methodSignature.
	method isNil ifTrue: [^nil].
	[self addBodyTo: method] on: SCompilationError do: [].
	^method
! !

!SSmalltalkParser methodsFor: 'productions' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodSelector
	self step.
	^self methodSignature ifNotNil: [:m | m selectorNode]
! !

!SSmalltalkParser methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parse: aString
	^self on: aString; method
! !

!SSmalltalkParser methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseExpression: aString
	^self on: aString; headlessMethod
! !

!SSmalltalkParser methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseFragment: aString
	| method |
	self on: aString; step.
	[
		method := self methodSignature.
		method notNil ifTrue: [self addBodyTo: method]]
		on: SCompilationError
		do: [].
	^method
! !

!SSmalltalkParser methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseTemporaries: aString
	self on: aString; step.
	^self methodSignature notNil ifTrue: [self temporaries]
! !

!SSmalltalkParser methodsFor: 'ffi support' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
symbolicPragma
	| position symbol pragma |
	position := token position.
	symbol := self step value.
	pragma := self buildNode: compiler pragmaNode at: position.
	^pragma symbol: symbol
! !

!SSmalltalkParser class methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parseSelector: aString
	| cmp parser |
    cmp := SCompiler new. 
	parser := self new compiler: cmp smalltalkCompiler; on: aString.
	^parser methodSelector ifNotNil: [:n | n value]
! !

!SSmalltalkScanner methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildToken: aSmalltalkToken
	^self buildToken: aSmalltalkToken at: stream position
! !

!SSmalltalkScanner methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildToken: aSmalltalkToken at: anInteger
	| string |
	string := stream copyFrom: anInteger to: stream position.
	^self buildToken: aSmalltalkToken at: anInteger with: string
! !

!SSmalltalkScanner methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildToken: aSmalltalkToken at: anInteger with: anObject
	^aSmalltalkToken
		position: anInteger;
		value: anObject;
		end: stream position
! !

!SSmalltalkScanner methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canBeInIdentifier: aCharacter
	^compiler frontend canBeInIdentifier: aCharacter
! !

!SSmalltalkScanner methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canStartIdentifier: aCharacter
	(compiler frontend canStartIdentifier: aCharacter) ifFalse: [^false].
	aCharacter = $_
		ifTrue: [^stream peek ifNil: [false] ifNotNil: [:ch | ch asInteger >= 33]].
	^true
! !

!SSmalltalkScanner methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler
	^compiler
! !

!SSmalltalkScanner methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler: aSmalltalkCompiler
	compiler := aSmalltalkCompiler.
	compiler sourceCode ifNotNil: [:s | self sourceCode: s]
! !

!SSmalltalkScanner methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
on: aString
	stream := aString readStream.
	compiler notNil ifTrue: [compiler sourceCode: aString]
! !

!SSmalltalkScanner methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sourceCode: aString
	stream := aString readStream
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
end
	^self buildToken: compiler endToken at: stream position + 1
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isBinary: aCharacter
	| code |
	aCharacter isNil ifTrue: [^false].
	code := aCharacter asInteger.
	code < 128 ifTrue: [
		^#($+ $- $< $> $= $* $/ $\ $| $& $~ $, $@ $% $? $!! $: $^)
			includes: aCharacter].
	^code > 255
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
next
	^self nextToken
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextArrayPrefix
	| string |
	string := stream copyFrom: stream position - 1 to: stream position.
	^self
		buildToken: compiler delimiterToken
		at: stream position - 1
		with: string
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextAssignment
	^self buildToken: compiler delimiterToken at: stream position with: #':='
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextBinarySelector
	stream back.
	^self
		buildToken: compiler stringToken
		at: stream position + 1
		with: self scanBinarySymbol
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextBinarySymbol
	^self
		buildToken: compiler literalNode
		at: stream position
		with: self scanBinarySymbol
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextColon
	| start char |
	start := stream position.
	char := stream peek.
	((char = Character space or: [char = Character tab]) and: [(stream peek: 2) second = $=]) ifTrue: [
		stream skip: 1.
		char := $=].
	char = $= ifTrue: [
		stream skip.
		^self nextAssignment position: start].
	^(self isBinary: stream peek)
		ifTrue: [self nextBinarySelector]
		ifFalse: [self nextSpecialCharacter]

! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextComment
	| start comment |
	start := stream position.
	[ stream atEnd not and:[stream peek !!== $"] ] whileTrue: [stream next].
	stream atEnd ifTrue: [self error: 'unfinished comment' at: start].
	stream position: start.
	comment := stream upTo: $".
	^self buildToken: compiler commentNode at: start with: comment

! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextIdentifierOrKeyword
	| start |
	start := stream position.
	self skipIdentifier.
	((stream peekFor: $:) and: [stream peekFor: $=]) ifTrue: [stream skip: -2].
	^self buildToken: compiler stringToken at: start
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextKeyword
	| start string |
	start := stream position + 1.
	self skipKeyword.
	string := stream copyFrom: start to: stream position.
	^self buildToken: compiler literalNode at: start - 1 with: string asSymbol
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextLiteralCharacter
	stream atEnd ifTrue: [^self error: 'character expected'].
	^self
		buildToken: compiler literalNode
		at: stream position
		with: stream next
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextLiteralString
	^self
		buildToken: compiler literalNode
		at: stream position
		with: self scanString reduced
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextNumber
	| parser assoc |
	stream skip: -1.
	parser := NumberParser new on: stream.
	assoc := parser next.
	parser error ifNotNil: [:e | ^self error: e key at: e value].
	^self
		buildToken: compiler numericLiteralNode
		at: assoc value start
		with: assoc key
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextQuotedSymbol
	| node |
	node := self nextLiteralString.
	^node beSymbol; position: node position - 1
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextSpecialCharacter
	| token |
	token := self buildToken: compiler delimiterToken.
	^token beCharacter
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextSymbolOrArrayPrefix
	| char |
	stream atEnd ifTrue: [self error: 'character expected'].
	char := stream peek.
	(self canBeInIdentifier: char) ifTrue: [^self nextKeyword].
	(self isBinary: char) ifTrue: [^self nextBinarySymbol].
	stream next.
	(char = $[ or: [char = $(]) ifTrue: [^self nextArrayPrefix].
	char = $' ifTrue: [^self nextQuotedSymbol].
	self error: 'character expected'
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nextToken
	| first |
	first := self scanChar.
	first isNil ifTrue: [^self end].
	(self canStartIdentifier: first) ifTrue: [^self nextIdentifierOrKeyword].
	(first = $→ or: [first = $_]) ifTrue: [^self nextAssignment].
	first = $: ifTrue: [^self nextColon].
	first = $' ifTrue: [^self nextLiteralString].
	first = $$ ifTrue: [^self nextLiteralCharacter].
	first = $# ifTrue: [^self nextSymbolOrArrayPrefix].
	first = $" ifTrue: [^self nextComment].
	first isDigit ifTrue: [^self nextNumber].
	(first !!= $^ and: [first !!= $↑ and: [self isBinary: first]])
		ifTrue: [^self nextBinarySelector].
	^self nextSpecialCharacter
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scanBinarySymbol
	| start symbol |
	start := stream position.
	self skipBinary.
	symbol := stream copyFrom: start + 1 to: stream position.
	^symbol asSymbol
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scanChar
	^(stream skipSeparators; atEnd) ifFalse: [stream next]

! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scanString
	| current start |
	start := current := stream position.
	^String streamContents: [:writer | 
		[| fragment |
			fragment := stream upTo: $'.
			writer nextPutAll: fragment.
			(current < stream position and: [(stream back; next) = $'])
				ifFalse: [self error: 'string end expected' at: start].
			stream peekFor: $']
			whileTrue: [
				writer nextPut: $'.
				current := stream position]]
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
skipBinary
	[self isBinary: stream peek] whileTrue: [stream next]
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
skipIdentifier
	| frontend |
	frontend := compiler frontend.
	[stream atEnd]
		whileFalse: [(frontend peekForIdentifier: stream) ifFalse: [^self]]
! !

!SSmalltalkScanner methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
skipKeyword
	| frontend continue pos |
	frontend := compiler frontend.
	[
		self skipIdentifier.
		continue := false.
		(stream peekFor: $:) ifTrue: [
			pos := stream position.
			stream atEnd
				ifFalse: [continue := frontend canStartIdentifier: stream peek]].
		continue] whileTrue.
	pos isNil ifFalse: [stream position: pos]
! !

!SSmalltalkScanner methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error: aString
	^self error: aString at: stream position
! !

!SSmalltalkScanner methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
error: aString at: anInteger
	^compiler error: aString at: anInteger
! !

!SToken methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
comment
	^comments notNil ifTrue: [comments anyOne]
! !

!SToken methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
comments
	^comments
! !

!SToken methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
comments: aCollection
	aCollection isNil ifTrue: [^self].
	comments isNil
		ifTrue: [comments := aCollection]
		ifFalse: [comments addAll: aCollection]
! !

!SToken methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moveCommentsTo: aParseNode
	aParseNode comments: comments.
	comments := nil
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compileWarning: aString
	compiler notify: aString at: self stretch
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler
	^compiler
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
compiler: aSmalltalkCompiler
	compiler := aSmalltalkCompiler
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
end
	^stretch end
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
end: aNumber
	stretch end: aNumber
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
position
	^stretch start
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
position: aNumber
	stretch start: aNumber
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
prevPosition
	^stretch start - 1
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
source
	^compiler sourceCode copyFrom: stretch start to: stretch end
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stretch
	^stretch
! !

!SToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
stretch: aStretch
	stretch := aStretch
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
endsExpression
	^self isEnd
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasSymbol
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
is: anObject
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isAssignment
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isBar
	^(self is: #'|') or: [self is: #'/']
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isBlockNode
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isComment
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isDelimiter
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isEnd
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isIdentifier
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isKeyword
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isLiteral
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isNameToken
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isNumberNode
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isPoolLiteral
	^false
! !

!SToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isStringToken
	^false
! !

!SToken methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	stretch := 1 thru: 0
! !

!SToken methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isDelimitedIdentifier
	^false
! !

!SEndToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isEnd
	^true
! !

!SEndToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
position: aNumber
	super position: aNumber - 1
! !

!SEndToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
prevPosition
	^stretch start
! !

!SEndToken methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value: aString
	''
! !

!SParseNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitParseNode: self
! !

!SParseNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
allNodesDo: aBlock
	self nodesDo: aBlock includingDeclarations: true
! !

!SParseNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
nodeWithLiteral: anObject
	^self nodesDetect: [:n | (n isLiteral or: [n isSelector]) and: [n value = anObject]] ifAbsent: nil

! !

!SParseNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
nodesDetect: aBlock ifAbsent: absentBlock
	self nodesDo: [:node | (aBlock value: node) ifTrue: [ ^node ] ] includingDeclarations: false.
	^absentBlock value
! !

!SParseNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
nodesDo: aBlock
	self nodesDo: aBlock includingDeclarations: false
! !

!SParseNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	aBlock value: self
! !

!SParseNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
ast
	^compiler ast
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
hasAssign
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isAssign
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isBraceNode
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isCascade
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isCascadeMessage
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isEvaluable
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isImmediate
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isMessageNode
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isMethod
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isMethodArgument
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isMethodTemporary
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isReturn
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isSelector
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isSelf
	^false
! !

!SParseNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isSuper
	^false
! !

!SParseNode methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
moveCommentsFrom: aParseNode
	aParseNode moveCommentsTo: self
! !

!SParseNode methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
variableNamed: aString
	self
		allNodesDo: [:node | (node isIdentifier and: [node name = aString])
			ifTrue: [^node]].
	^nil
! !

!SAssignmentNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitAssignment: self
! !

!SAssignmentNode methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assign: anIdentifierNode operator: aDelimiterToken
	assignees add: anIdentifierNode.
	operators add: aDelimiterToken
! !

!SAssignmentNode methodsFor: 'adding / removing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assign: anIdentifierNode with: aParseNode operator: aDelimiterToken
	assignees add: anIdentifierNode.
	operators add: aDelimiterToken.
	expression := aParseNode
! !

!SAssignmentNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assignees
	^assignees
! !

!SAssignmentNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
expression
	^expression
! !

!SAssignmentNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
operators
	^operators
! !

!SAssignmentNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasAssign
	^true
! !

!SAssignmentNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isAssign
	^true
! !

!SAssignmentNode methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	assignees := OrderedCollection new: 1.
	operators := OrderedCollection new: 1
! !

!SAssignmentNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	assignees do: [:v | v nodesDo: aBlock includingDeclarations: aBoolean].
	expression nodesDo: aBlock includingDeclarations: aBoolean
! !

!SBraceNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitBraceNode: self
! !

!SBraceNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
asMessageNode
	message notNil ifTrue: [^message].
	^message := self expanded
! !

!SBraceNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isBraceNode
	^true
! !

!SBraceNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
elements
	^elements
! !

!SBraceNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
elements: aCollection
	elements := aCollection asArray
! !

!SBraceNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
expanded
	| receiver n new argument array messages i you yourself cascade |
	receiver := compiler identifierNode name: 'Array'.
	n := elements size.
	new := compiler selectorNode symbol: #new:.
	argument := compiler numericLiteralNode value: n.
	array := compiler messageNode.
	array receiver: receiver.
	array selector: new.
	array arguments: (Array with: argument).
	i := 0.
	messages := elements collect: [:elem | | msg sel idx args |
		i := i + 1.
		msg := compiler cascadeMessageNode position: elem position; end: elem end.
		sel := compiler selectorNode symbol: #at:put:.
		idx := compiler numericLiteralNode value: i.
		args := Array with: idx with: elem.
		msg selector: sel; arguments: args].
	you := compiler selectorNode symbol: #yourself.
	yourself := compiler cascadeMessageNode.
	yourself selector: you.
	yourself arguments: #().
	messages := messages copyWith: yourself.
	cascade := compiler cascadeNode receiver: array.
	messages do: [:msg | msg cascade: cascade].
	^cascade messages: messages
! !

!SBraceNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	elements do: [:n | n nodesDo: aBlock includingDeclarations: aBoolean]
! !

!SCascadeNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitCascade: self
! !

!SCascadeNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasAssign
	receiver hasAssign ifTrue: [^true].
	messages detect: [:msg | msg hasAssign] ifNone: [^false].
	^true
! !

!SCascadeNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isCascade
	^true
! !

!SCascadeNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	receiver nodesDo: aBlock includingDeclarations: aBoolean.
	messages do: [:msg | msg nodesDo: aBlock includingDeclarations: aBoolean]
! !

!SCascadeNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
messages
	^messages
! !

!SCascadeNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
messages: aCollection
	messages := aCollection
! !

!SCascadeNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
receiver
	^receiver
! !

!SCascadeNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
receiver: rcvr
	receiver := rcvr
! !

!SCommentNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isComment
	^true
! !

!SCommentNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value
	^value
! !

!SCommentNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value: aString
	value := aString
! !

!SIdentifierNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitIdentifier: self
! !

!SIdentifierNode methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beAssigned
	| immutable |
	binding canBeAssigned ifTrue: [^self].
	immutable := binding isClassBinding
		ifTrue: ['class']
		ifFalse: [compiler activeScope describe: binding name].
	self compileError: 'cannot assign to ' , immutable
! !

!SIdentifierNode methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
resolveAssigning: aBoolean
	binding := compiler activeScope resolve: name.
	^binding

! !

!SIdentifierNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
binding
	^binding
! !

!SIdentifierNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
binding: aBinding
	binding := aBinding
! !

!SIdentifierNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	binding := DynamicBinding default
! !

!SIdentifierNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	^name
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
checkLowercase
	| char |
	char := name first.
	(char isLetter and: [char isUppercase]) ifFalse: [^self].
	self compileWarning: name storeString , ' should start with lowercase'
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isEvaluable
	^self isIdentifierLiteral
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isIdentifier
	^true
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isIdentifierLiteral
	binding isDynamic ifFalse: [^binding isLiteral].
	^self ast ifNil: [false] ifNotNil: [:ast | | b |
		b := ast scope resolve: name.
		b isLiteral]
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isImmediate
	^true
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isLocal
	^binding isLocal
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isMethodArgument
	| ast |
	binding isArgument ifFalse: [^false].
	ast := self ast ifNil: [^false].
	^ast arguments includes: self declaration
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isMethodTemporary
	^self ast temporaries includes: self declaration
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSelf
	^binding isSelf
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isSuper
	^binding isSuper
! !

!SIdentifierNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sourceIntervals
	| stretchs declaration ast string code index |
	stretchs := OrderedCollection new.
	declaration := binding declaration.
	ast := self ast.
	ast allNodesDo: [:node | 
		(node class == self class and: [node binding declaration == declaration])
			ifTrue: [stretchs add: node stretch]].
	string := self source.
	code := compiler sourceCode.
	index := ast stretch end.
	[
		index := code indexOfString: string startingAt: index + 1.
		index > 0]
		whileTrue: [stretchs add: (index to: index + string size - 1)].
	^stretchs
! !

!SIdentifierNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
declaration
	^binding declaration
! !

!SIdentifierNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
defineArgumentIn: aScriptScope
	binding := aScriptScope defineArgument: name.
	binding declaration: self
! !

!SIdentifierNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
defineTemporaryIn: scope
	binding := scope defineTemporary: name.
	binding declaration: self
! !

!SIdentifierNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream
	aStream nextPut: $<;
	nextPutAll: name;
	nextPutAll: '> ('.
	super printOn: aStream.
	aStream nextPut: $)
! !

!SIdentifierNode methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name: aString
	name := aString reduced
! !

!SLiteralNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitLiteral: self
! !

!SLiteralNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
hasSymbol
	^value isSymbol
! !

!SLiteralNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isEvaluable
	^true
! !

!SLiteralNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isImmediate
	^true
! !

!SLiteralNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isLiteral
	^true
! !

!SLiteralNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
beSymbol
	value := value asSymbol
! !

!SLiteralNode methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
value
	^value
! !

!SLiteralNode methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
value: anObject
	value := anObject
! !

!SNumberNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitNumberNode: self
! !

!SNumberNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isNumberNode
	^true
! !

!SNumberNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
negate
	value := value negated
! !

!SMessageNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitMessage: self
! !

!SMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
arguments
	^arguments
! !

!SMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
arguments: aCollection
	arguments := aCollection
! !

!SMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
receiver
	^receiver
! !

!SMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
receiver: node
	receiver := node
! !

!SMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
selector
	^selector
! !

!SMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
selector: node
	selector := node
! !

!SMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
symbol
	^selector symbol
! !

!SMessageNode methodsFor: 'emitting - inlined' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beInlined
	inlined := true
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasAssign
	receiver hasAssign ifTrue: [^true].
	^arguments anySatisfy: [:arg | arg hasAssign]
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasVolatileArguments
	^arguments anySatisfy: [:arg | 
		arg isIdentifier
			ifTrue: [arg binding canBeAssigned]
			ifFalse: [arg isBlockNode not andNot: [arg isLiteral]]]
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasVolatileReceiver
	^ compiler hasBlocks
		  or: [ receiver isMethodTemporary not ]
		  or: [ arguments anySatisfy: [ :arg | arg hasAssign ] ]
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	inlined := false
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isCascadeMessage
	^false
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInlined
	^inlined
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isMessageNode
	^true
! !

!SMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
needsStrictEvaluationOrder
	arguments size = 0 ifTrue: [^false].
	receiver isBlockNode ifTrue: [^false].
	receiver isLiteral ifTrue: [^false].
	receiver isSelf ifTrue: [^false].
	receiver isSuper ifTrue: [^false].
	receiver isMethodArgument ifTrue: [^false].
	self hasVolatileReceiver ifFalse: [^false].
	(receiver isImmediate
		and: [arguments conform: [:arg | arg isImmediate or: [arg isBlockNode]]])
		ifTrue: [^false].
	receiver hasAssign ifTrue: [^true].
	receiver isMessageNode ifTrue: [ ^true ]. 
	^self hasVolatileArguments
! !

!SMessageNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	receiver nodesDo: aBlock includingDeclarations: aBoolean.
	arguments do: [:arg | arg nodesDo: aBlock includingDeclarations: aBoolean].
	selector nodesDo: aBlock includingDeclarations: aBoolean
! !

!SCascadeMessageNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitCascadeMessage: self
! !

!SCascadeMessageNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
cascade: aCascadeNode
	cascade := aCascadeNode.
	receiver := cascade receiver
! !

!SCascadeMessageNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
from: aMessageNode
	arguments := aMessageNode arguments.
	receiver := aMessageNode receiver.
	selector := aMessageNode selector.
	inlined := aMessageNode isInlined.
	stretch := aMessageNode stretch.
	comments := aMessageNode comments
! !

!SCascadeMessageNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isCascadeMessage
	^true
! !

!SCascadeMessageNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	aBlock value: self.
	arguments do: [:arg | arg nodesDo: aBlock includingDeclarations: aBoolean]
! !

!SReturnNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitReturn: self
! !

!SReturnNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
expression
	^expression
! !

!SReturnNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
expression: node
	expression := node
! !

!SReturnNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
return: aSmalltalkToken
	return := aSmalltalkToken
! !

!SReturnNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasAssign
	^expression hasAssign
! !

!SReturnNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isReturn
	^true
! !

!SReturnNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	expression nodesDo: aBlock includingDeclarations: aBoolean
! !

!SScriptNode methodsFor: 'add/remove' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addChild: aBlockNode
	children add: aBlockNode
! !

!SScriptNode methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addStatements: anOrderedCollection
	statements addAll: anOrderedCollection
! !

!SScriptNode methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
identifiers
	| result |
	result := OrderedCollection new.
	self nodesDo: [:node | node isIdentifier ifTrue: [result add: node]].
	^result withoutDuplicates
! !

!SScriptNode methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	statements := OrderedCollection new.
	arguments := #().
	temporaries := #().
	children := OrderedCollection new
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
arguments
	^arguments
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
arguments: aCollection
	arguments := aCollection
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
children
	^children
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentSize
	^scope environmentSize
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
realScript
	self subclassResponsibility
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
statements
	^statements
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
temporaries
	^temporaries
! !

!SScriptNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
temporaries: aCollection
	temporaries := aCollection
! !

!SScriptNode methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bindLocals
	arguments do: [:arg | arg defineArgumentIn: scope].
	temporaries do: [:temp | temp checkLowercase; defineTemporaryIn: scope].
	children do: [:block | block bindLocals]
! !

!SScriptNode methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
positionLocals
	scope positionLocals.
	children do: [:b | b positionLocals]
! !

!SScriptNode methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
reference: aBinding
	aBinding beReferencedFrom: self
! !

!SScriptNode methodsFor: 'binding' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
scope
	^scope
! !

!SScriptNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasAssign
	statements do: [:s | s hasAssign ifTrue: [^true]].
	^false
! !

!SScriptNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	aBoolean ifTrue: [
		arguments do: [:a | a nodesDo: aBlock includingDeclarations: aBoolean].
		temporaries do: [:a | a nodesDo: aBlock includingDeclarations: aBoolean]].
	statements do: [:s | s nodesDo: aBlock includingDeclarations: aBoolean]
! !

!SScriptNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
useSelf
	scope captureSelf
! !

!SBlockNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitBlock: self
! !

!SBlockNode methodsFor: 'emitting - inlined' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beInlined
	inlined := true.
	arguments do: [:arg | arg binding beInlined]
! !

!SBlockNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
buildBlock
	| block |
	self isInlined ifTrue: [ ^ nil ].
	block := CompiledBlock new.
	^ block
		blockNumber: index;
		argumentCount: arguments size;
		tempCount: scope stackSize;
		environmentCount: scope environmentSize;
		capturesSelf: scope capturesSelf;
		capturesHome: scope capturesHome
! !

!SBlockNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
captureHome
	scope captureEnvironment: self ast
! !

!SBlockNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environmentIndexOf: aParseNode
	^scope environmentIndexOf: aParseNode
! !

!SBlockNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isBlockNode
	^true
! !

!SBlockNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isEvaluable
	^self isNullary
! !

!SBlockNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isInlined
	^inlined
! !

!SBlockNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isNullary
	^arguments isEmpty
! !

!SBlockNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
usesHome
	^inlined
		ifTrue: [children anySatisfy: [:block | block usesHome]]
		ifFalse: [scope capturesHome]
! !

!SBlockNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index
	^index
! !

!SBlockNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
index: aNumber
	index := aNumber
! !

!SBlockNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parent
	^parent
! !

!SBlockNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
parent: aScriptNode
	parent := aScriptNode addChild: self
! !

!SBlockNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
realParent
	^parent realScript
! !

!SBlockNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
realScript
	^inlined ifTrue: [parent realScript] ifFalse: [self]
! !

!SBlockNode methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	inlined := false.
	scope := BlockScope on: self
! !

!SMethodNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitMethod: self
! !

!SMethodNode methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
buildMethod
	| cm encoder treecodes |
	cm := self methodClass withAll: self literals.
	cm
		blockCount: compiler blockCount;
		tempCount: scope stackSize;
		argumentCount: arguments size;
		environmentCount: scope environmentSize;
		capturesSelf: scope capturesSelf;
		hasEnvironment: self needsEnvironment;
		hasFrame: self needsFrame;
		selector: self selector;
		sourceObject: compiler sourceCode;
		classBinding: compiler frontend classBinding.
	cm pragma: pragma.
	cm blocks do: [ :block | block method: cm ].
	encoder := TreecodeEncoder new method: cm.
	treecodes := self acceptVisitor: encoder.
	^ cm treecodes: treecodes
! !

!SMethodNode methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
captureHome
	
! !

!SMethodNode methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
literals
	| literals v l |
	literals := OrderedCollection new.
	pragma isUsed
		ifTrue: [ literals add: pragma name ].
	self
		nodesDo: [ :n | 
			n isLiteral
				ifTrue: [ v := n value.
					v isSmallInteger
						ifFalse: [ literals add: v ] ].
			n isMessageNode
				ifTrue: [ literals add: n symbol ].
			n isBraceNode
				ifTrue: [ n isLiteral
						ifTrue: [ self halt ]
						ifFalse: [ literals
								add: #Array;
								add: #new:;
								add: #at:put:;
								add: #yourself ] ].
			(n isIdentifier
				and: [ l := n binding literal.
					l notNil ])
				ifTrue: [ literals add: l ].
			(n isBlockNode andNot: [ n isInlined ])
				ifTrue: [ literals add: n buildBlock ] ].
	^ literals withoutDuplicates
! !

!SMethodNode methodsFor: 'parsing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
methodClass
	| type |
	type := pragma type.
	type = #callback
		ifTrue: [ ^ CallbackMethod ].
	type = #callout
		ifTrue: [ ^ CalloutMethod ].
	^ CompiledMethod
! !

!SMethodNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
compiler: aSmalltalkCompiler
	super compiler: aSmalltalkCompiler.
	scope := MethodScope new script: self.
	pragma := aSmalltalkCompiler pragmaNode
! !

!SMethodNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
pragma
	^pragma
! !

!SMethodNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
pragma: anObject
	pragma := anObject
! !

!SMethodNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
realScript
	^self
! !

!SMethodNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
selector
	^selector value
! !

!SMethodNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
selector: aSelectorNode
	selector := aSelectorNode
! !

!SMethodNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
selectorNode
	^selector
! !

!SMethodNode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
environmentIndexOf: aParseNode
	^nil
! !

!SMethodNode methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
header
	"
	(Object >> #printOn:) ast header
	"
	| interval |
	interval := selector stretch.
	arguments notEmpty
		ifTrue: [interval := interval start thru: arguments last stretch end].
	^compiler sourceCode copyFrom: interval start to: interval end
! !

!SMethodNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isHeadless
	^selector isNil
! !

!SMethodNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isMethod
	^true
! !

!SMethodNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
needsEnvironment
	^scope environmentSize > 0
		or: [children anySatisfy: [:block | block usesHome]]
! !

!SMethodNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
needsFrame
	scope stackSize > 0 ifTrue: [ ^ true ].
	arguments size > 16 ifTrue: [ ^ true ].
	compiler hasSends ifTrue: [ ^ true ].
	compiler hasBlocks ifTrue: [ ^ true ].
	^ false
! !

!SMethodNode methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	(aBoolean and: [selector notNil]) ifTrue: [aBlock value: selector]
! !

!SSelectorNode methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitSelector: self
! !

!SSelectorNode methodsFor: 'accessing' stamp: 'KenD 30/Jun/2026, 3:25:59 pm (UTC)'!
addKeyword: aSelectorNode
	keywords isNil ifTrue: [keywords := OrderedCollection new].
	keywords add: aSelectorNode
! !

!SSelectorNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
end
	stretch end ifNotNil: [:e | ^e].
	^keywords notNil ifTrue: [keywords last end]
! !

!SSelectorNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
keywords
	^keywords isNil ifTrue: [{self}] ifFalse: [keywords]
! !

!SSelectorNode methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
positions
	^self keywords collect: [:node | node position]
! !

!SSelectorNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
hasSymbol
	^symbol isSymbol
! !

!SSelectorNode methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isSelector
	^true
! !

!SSelectorNode methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
isBinary
	^symbol isBinary
! !

!SSelectorNode methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
symbol
	^symbol
! !

!SSelectorNode methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
symbol: aString
	symbol := aString asSymbol
! !

!SSelectorNode methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
value
	^symbol
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
acceptVisitor: aVisitor
	self isFFI ifTrue: [^aVisitor visitFFIPragma: self].
	self isPrimitive ifTrue: [^aVisitor visitPrimitivePragma: self].
	self isSymbolic ifTrue: [^aVisitor visitSymbolicPragma: self]
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ffi: cc name: aString with: anFFIDescriptor
	type := cc.
	name := aString.
	info := anFFIDescriptor
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ffi: aString with: anFFIDescriptor
	type := #ffi.
	name := aString.
	info := anFFIDescriptor
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
info
	^info
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isUsed
	^type notNil
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	^name
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
primitive: anInteger name: aString
	type := #primitive.
	name := aString.
	info := anInteger
! !

!SPragmaNode methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
type
	^type
! !

!SSymbolicToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
is: anObject
	^value == anObject
! !

!SSymbolicToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value
	^value
! !

!SSymbolicToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value: anObject
	value := anObject
! !

!SDelimiterToken methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
asSelectorNode
	^compiler selectorNode symbol: value asString; stretch: stretch
! !

!SDelimiterToken methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
beCharacter
	value := value isCharacter ifTrue: [value] ifFalse: [value first]
! !

!SDelimiterToken methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
value: aString
	super value: aString asSymbol
! !

!SDelimiterToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
endsExpression
	^value = $. or: [value = $]] or: [value = $)] or: [value = $}]
! !

!SDelimiterToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isAssignment
	^self is: #':='
! !

!SDelimiterToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isDelimiter
	^true
! !

!SStringToken methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
asIdentifierNode
	^compiler identifierNode
		name: value;
		stretch: stretch;
		comments: comments
! !

!SStringToken methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
asSelectorNode
	^compiler selectorNode symbol: value; stretch: stretch
! !

!SStringToken methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isStringToken
	^true
! !

!SStringToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
hasSymbol
	^value isSymbol
! !

!SStringToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isBinary
	^value isSymbol
! !

!SStringToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isDelimitedIdentifier
	^value first = ${
! !

!SStringToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isKeyword
	^value last = $:
! !

!SStringToken methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
isNameToken
	^(self isKeyword or: [self isBinary]) not
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: value within: anEggRuntime
	^ self subclassResponsibility
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: value within: anEvaluationContext ifUnbound: aClosure
	^self assign: value within: anEvaluationContext

! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isArgument
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isAssociation
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isClassBinding
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isClassVar
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isDynamic
	^ false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInstVar
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isLiteral
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isPoolVar
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSelf
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSuper
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isTemporary
	^false
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name
	^self printString
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ self subclassResponsibility
! !

!SBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext ifUnbound: aClosure
	^self valueWithin: anEvaluationContext
! !

!SBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^self subclassResponsibility
! !

!SAssociationBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: value within: anEvaluationContext
	anEvaluationContext storeAssociation: association value: value
! !

!SAssociationBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
	^ index
! !

!SAssociationBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	 index := anInteger 
! !

!SAssociationBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isAssociation
	^true
! !

!SAssociationBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isConstant
	^ false
! !

!SAssociationBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ anEvaluationContext loadAssociationValue: association
! !

!SAssociationBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
association
	^association
! !

!SAssociationBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
association: anAssociation
	association := anAssociation
! !

!SDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: value within: anEvaluationContext ifUnbound: aClosure

	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	cache ifNil: [ ^ aClosure value ].
	cache assign: value within: anEvaluationContext
! !

!SDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isDynamic
	^true
! !

!SDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupWithin: anEvaluationContext
	cache := anEvaluationContext staticBindingFor: name
! !

!SDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name
	name
! !

!SDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name: aSymbol
	name := aSymbol
! !

!SDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream
		nextPutAll: 'DinamicVarId. ';
		nextPutAll: name printString
! !

!SDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext ifUnbound: aClosure

	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	cache ifNil: [ ^ aClosure value ].
	^ cache valueWithin: anEvaluationContext
! !

!SDynamicBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^ aTreecodeDecoder decodeDynamicVar
! !

!SNestedDynamicBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupWithin: anEvaluationContext
	cache := anEvaluationContext staticBindingForNested: name
! !

!SNestedDynamicBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^ aTreecodeDecoder decodeNestedDynamicVar
! !

!SInstVarBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: value within: anEvaluationContext
	anEvaluationContext instanceVarAt: index put: value
! !

!SInstVarBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInstVar
	^true
! !

!SInstVarBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: 'InstVarId. '; nextPutAll: index printString
! !

!SInstVarBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
	^index
! !

!SInstVarBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	index := anInteger
! !

!SInstVarBinding methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ anEvaluationContext instanceVarAt: index
! !

!SInstVarBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeInstVar
! !

!SLiteralBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isLiteral
	^true
! !

!SLiteralBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^self new
! !

!SFalseBinding methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: 'FalseId'
! !

!SFalseBinding methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
value
	^false
! !

!SFalseBinding methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ anEvaluationContext false
! !

!SNilBinding methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: 'NilId'
! !

!SNilBinding methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
value
	^nil
! !

!SNilBinding methodsFor: 'evaluating' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ anEvaluationContext nil
! !

!SLocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
environment
	^environment
! !

!SLocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
environment: anInteger
	environment := anInteger
! !

!SLocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
	^position
! !

!SLocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	position := anInteger
! !

!SLocalBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInStack
	self ASSERT: false.
	^ environment = 0
! !

!SArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: value within: anEvaluationContext
	self halt
! !

!SArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isArgument
	^true
! !

!SArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInlined
	^ environment = -1
! !

!SArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream
		nextPutAll: 'SArgument ';
		print: position;
		nextPutAll: ' @ env ';
		print: environment
! !

!SArgumentBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ anEvaluationContext argumentAt: position in: environment
! !

!SArgumentBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeArgument
! !

!STemporaryBinding methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: value within: anEvaluationContext
	anEvaluationContext temporaryAt: position in: environment put: value
! !

!STemporaryBinding methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream
		nextPutAll: 'STemporary ';
		print: position;
		nextPutAll: ' @ env ';
		print: environment
! !

!STemporaryBinding methodsFor: 'as yet unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ anEvaluationContext temporaryAt: position in: environment
! !

!STemporaryBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInCurrentEnvironment
	^environment = 1
! !

!STemporaryBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isTemporary
	^true
! !

!STemporaryBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeTemporary
! !

!SSelfBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSelf
	^true
! !

!SSelfBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
valueWithin: anEvaluationContext
	^ anEvaluationContext receiver
! !

!SSelfBinding methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: 'SelfId'
! !

!SSelfBinding class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^self new
! !

!SSuperBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSelf
	^false
! !

!SSuperBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSuper
	^true
! !

!SSuperBinding methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: 'SuperId'
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^self subclassResponsibility
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isAssignment
	^false
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isCascade
	^false
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isCascadeMessage
	^false
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isIdentifier
	^false
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isLiteral
	^false
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isMessage
	^false
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isReturn
	^false
! !

!SExpression methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSuper
	^ false
! !

!SExpression methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInstVar
	^false
! !

!SExpression methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isMethod
	^false
! !

!SExpression methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	self printOn: aStream indent: 0
! !

!SExpression methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	super printOn: aStream
! !

!SAssignment methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitAssignment: self
! !

!SAssignment methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assignees
	^assignees
! !

!SAssignment methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
expression
	^expression
! !

!SAssignment methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
expression: anSExpression
	expression := anSExpression
! !

!SAssignment methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	assignees := OrderedCollection new
! !

!SAssignment methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assign: anSIdentifier
	assignees add: anSIdentifier
! !

!SAssignment methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isAssignment
	^true
! !

!SAssignment methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPutAll: '{AssignmentId.'.
	assignees
		do: [:identifier | 
			aStream cr.
			identifier printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '.'].
	aStream nextPutAll: '.'; cr.
	expression printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '}'
! !

!SAssignment class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeAssignment
! !

!SAssignment class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !

!SCascade methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitCascade: self
! !

!SCascade methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isCascade
	^true
! !

!SCascade methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
messages
	^messages
! !

!SCascade methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
messages: aCollection
	messages := aCollection
! !

!SCascade methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
receiver
	^receiver
! !

!SCascade methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
receiver: anSExpression
	receiver := anSExpression
! !

!SCascade class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeCascade
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitCascadeMessage: self
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
argumentCount
	^arguments size
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
arguments
	^arguments
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
arguments: aCollection
	arguments := aCollection
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cache: anSCompiledMethod when: type
	cache ifNil: [ ^ cache := Array with: type with: anSCompiledMethod ].
	cache := cache , (Array with: type with: anSCompiledMethod)
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cacheUndermessage: aBlockClosure
	cache := aBlockClosure
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cachedUndermessage
	^ cache isBlock
		ifTrue: [ cache ]
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cascade
	cascade
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cascade: anSCascade
	cascade := anSCascade
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
flushCache
	cache := nil
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isCascadeMessage
	^true
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
methodFor: requiredType
	| type |
	cache ifNil: [ ^ nil ].
	1 to: cache size by: 2 do: [ :i | 
		type := cache at: i.
		type == requiredType
			ifTrue: [ ^ cache at: i + 1 ] ].
	^ nil
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
receiver
	^cascade receiver
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
registerCacheWith: runtime
	cache ifNil: [ runtime registerCache: self for: selector ]
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
selector
	^selector
! !

!SCascadeMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
selector: aSymbol
	selector := aSymbol
! !

!SCascadeMessage class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeCascadeMessage
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitIdentifier: self
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
binding: aBinding
	binding := aBinding
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isArgument
	^binding isArgument
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isAssociation
	^binding isAssociation
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isIdentifier
	^true
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInstVar
	^binding isInstVar
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isLiteral
	^binding isLiteral
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSelf
	^binding isSelf
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSelfOrSuper
	^binding isSelf or: [binding isSuper]
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isSuper
	^binding isSuper
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isTemporary
	^binding isTemporary
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isVariable
	^true
! !

!SIdentifier methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream
		tab: anInteger;
		nextPutAll: '{IdentifierId. ';
		print: binding;
		nextPutAll: '}'
! !

!SIdentifier methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
binding
	^binding
! !

!SIdentifier class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeIdentifier
! !

!SLiteralVar methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
	^index
! !

!SLiteralVar methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	index := anInteger
! !

!SLiteral methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitLiteral: self
! !

!SLiteral methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isLiteral
	^true
! !

!SLiteral methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
value
	^value
! !

!SLiteral methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
value: anObject
	value := anObject
! !

!SLiteral methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream
		tab: anInteger;
		nextPutAll: '{LiteralId. ';
		print: value;
		nextPutAll: '}'
! !

!SLiteral class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeLiteral
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitMessage: self
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
arguments
	^arguments
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
arguments: aCollection
	arguments := aCollection
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cache: anSCompiledMethod when: type
	cache
		ifNil: [ ^ cache := Array with: type with:
			anSCompiledMethod].
	cache := cache
		,
			(Array with: type with: 
			anSCompiledMethod)
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cacheUndermessage: aBlockClosure
	cache := aBlockClosure
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
cachedUndermessage
	^cache isBlock ifTrue: [ cache ]
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
flushCache
	cache := nil
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	super initialize.
	arguments := #().
	inlined := false
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInlined
	^ inlined
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isMessage
	^true
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
methodFor: requiredType
	| type |
	cache ifNil: [ ^ nil ].
	1 to: cache size by: 2 do: [ :i | 
		type := cache at: i.
		type == requiredType
			ifTrue: [ ^ cache at: i + 1 ] ].
	^ nil
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPutAll: '{MessageId. '; print: selector; nextPutAll: '. '; cr.
	receiver printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '.'; cr.
	arguments
		do: [:statement | statement printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '. '; cr].
	aStream nextPutAll: '}'
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
receiver
	^receiver
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
receiver: anSExpression
	receiver := anSExpression
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
registerCacheWith: runtime
	cache ifNil: [ runtime registerCache: self for: selector ]
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
selector
	^selector
! !

!SMessage methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
selector: aSelector
	selector := aSelector
! !

!SMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
argumentCount
	^arguments size
! !

!SMessage methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlined: aBoolean
	inlined := aBoolean
! !

!SMessage class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeMessage
! !

!SMessage class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !

!SOpJump methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpJump: self
! !

!SOpJump methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: self class name withArticle; nextPutAll: ' after '; print: target
! !

!SOpJump methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
target
	^target
! !

!SOpJump methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
target: anInteger
	 target := anInteger
! !

!SOpJumpFalse methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpJumpFalse: self
! !

!SOpJumpTrue methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpJumpTrue: self
! !

!SOpLoadRfromFrame methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpLoadRfromFrame: self
! !

!SOpLoadRfromFrame methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
^	index
! !

!SOpLoadRfromFrame methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	index := anInteger
! !

!SOpPopR methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpPopR: self
! !

!SOpStoreRintoFrame methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpStoreRintoFrame: self
! !

!SOpStoreRintoFrame methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
	^ index
! !

!SOpStoreRintoFrame methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	index := anInteger
! !

!SOpAssign methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpAssign: self
! !

!SOpAssign methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assignees
	^assignees
! !

!SOpAssign methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assignees: aCollection
	assignees := aCollection
! !

!SOpDispatchMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpDispatchMessage: self
! !

!SOpDispatchMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
message
	^ message
! !

!SOpDispatchMessage methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
message: anSMessage
	message := anSMessage
! !

!SOpDropToS methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpDropToS: self
! !

!SOpDropToS methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
count
	^count
! !

!SOpDropToS methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
count: anInteger
	count := anInteger 
! !

!SOpLoadRfromStack methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpLoadRfromStack: self
! !

!SOpLoadRfromStack methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
	^index
! !

!SOpLoadRfromStack methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	index := anInteger
! !

!SOpLoadRwithNil methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpLoadRwithNil: self
! !

!SOpLoadRwithSelf methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpLoadRwithSelf: self
! !

!SOpPrimitive methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpPrimitive: self
! !

!SOpPrimitive methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
block
	^block
! !

!SOpPrimitive methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
block: aBlockClosure
	block := aBlockClosure
! !

!SOpPushR methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpPushR: self
! !

!SOpRestart methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpRestart: self
! !

!SOpReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpReturn: self
! !

!SPragma methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name
	^ name
! !

!SPragma methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name: aString
	name := aString
! !

!SReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitReturn: self
! !

!SReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
expression
	^expression
! !

!SReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
expression: anSExpression
	expression := anSExpression
! !

!SReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isReturn
	^true
! !

!SReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
local
	^local
! !

!SReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
local: aBoolean
	local := aBoolean
! !

!SReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPutAll: '{ReturnId.'; cr.
	expression printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '}'
! !

!SReturn class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeReturn
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
argumentCount
	^compiledCode argumentCount
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
compiledCode
	^compiledCode
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
compiledCode: anObject
	compiledCode := anObject
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	statements := #()
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	statements
		do: [:statement | statement printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '.'; cr]
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
statements
	^statements
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
statements: aCollection
	statements := aCollection
! !

!SScript methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
tempCount
	^compiledCode tempCount
! !

!SScript methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
optimizedCode: anObject
	^ self compiledCode optimizedCode: anObject
! !

!SScript class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !

!SBlock methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitBlock: self
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
capturedVariables
	^capturedVariables
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
capturedVariables: aCollection
	capturedVariables := aCollection
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
capturesHome
	^compiledCode capturesHome
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index
	^index
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
index: anInteger
	index := anInteger
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlinedArgs
	^ inlinedArgs
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlinedArgs: anArray
	inlinedArgs:= anArray 
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
offsetOfCurrentEnvironment
	^ 2
! !

!SBlock methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
optimizedCode
	^compiledCode optimizedCode
! !

!SBlock methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	capturedVariables := #()
! !

!SBlock methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isBlock
	^true
! !

!SBlock methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isInlined
	^ compiledCode isNil
! !

!SBlock methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream
		tab: anInteger;
		nextPutAll: '{BlockId. capturedVariables: ';
		print: capturedVariables;
		cr.
	super printOn: aStream indent: anInteger.
	aStream nextPutAll: '}'
! !

!SBlock class methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeBlock
! !

!SMethod methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^visitor visitMethod: self
! !

!SMethod methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isMethod
	^true
! !

!SMethod methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
offsetOfCurrentEnvironment
	^ 0
! !

!SMethod methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
offsetOfEnvironment: anInteger
	^0
! !

!SMethod methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
pragma
	^pragma
! !

!SMethod methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
pragma: anSPragma
	pragma := anSPragma
! !

!SMethod methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
primitive
	^pragma ifNotNil: [ pragma name ]
! !

!SMethod methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream indent: anInteger
	aStream nextPutAll: '{MethodId. '; cr.
	pragma ifNotNil: [ (pragma isKindOf: SExpression) ifTrue: [ pragma printOn: aStream indent: anInteger + 1] ifFalse: [ aStream tab: anInteger + 1; print: pragma ] ].
	super printOn: aStream indent: anInteger.
	aStream nextPutAll: '}'
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
bindingTypeOf: id
	^ BindingTypes at: id
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeArgument
	^ SArgumentBinding new
		index: self nextInteger;
		environment: self nextEnvironment
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeAssignment
	| assignment assignees |
	assignment := SAssignment new.
	
	assignees := self nextExpressionArray.
	assignment expression: self nextExpression.
	assignees do: [ :identifier | assignment assign: identifier ].
	^ assignment
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeBlock

	| expression inlined block index code |
	expression := SBlock new.
	inlined := self nextBoolean.
	inlined
		ifTrue: [ expression inlinedArgs: self nextArray ]
		ifFalse: [ 
			index := self nextInteger.
			block := self literalAt: index.
			builder ifNotNil: [ 
				code := builder newExecutableCodeFor: expression.
				builder blockExecutableCode: block put: code ].
			expression
				compiledCode: block;
				index: index;
				capturedVariables: self nextArray ].
	expression statements: self nextExpressionArray.
	^ expression
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeCascade
	| cascade receiver messages message count |
	cascade := SCascade new.
	receiver := self nextExpression.
	count := self nextInteger.
	messages := (1 to: count)
		collect: [ :i | 
			message := SCascadeMessage decodeUsing: self.
			message cascade: cascade ].
	^ cascade
		receiver: receiver;
		messages: messages
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeCascadeMessage
	| selector arguments |
	selector := self nextSymbol.
	arguments := self nextExpressionArray.
	^ SCascadeMessage new
		selector: selector;
		arguments: arguments
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeDynamicVar
	^ SDynamicBinding new name: self nextSymbol
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeIdentifier
	| type binding |
	type := self bindingTypeOf: self nextInteger.
	binding := type decodeUsing: self.
	^ SIdentifier new binding: binding
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeLiteral
	| index value |
	index := self nextInteger.
	value := index = 0
		ifTrue: [ self nextLiteralInteger ]
		ifFalse: [ self literalAt: index ].
	^ SLiteral new
		index: index;
		value: value
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeMessage
	| inlined selector receiver arguments |
	inlined := self nextBoolean.
	selector := self nextSymbol.
	receiver := self nextExpression.
	arguments := self nextExpressionArray.
	^ SMessage new
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		inlined: inlined
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeMethod
	| type node next pragma |
	type := stream next.
	type !!= MethodId
		ifTrue: [ self error: 'method treecode expected' ].
	node := SMethod new.
	next := stream peek.
	next = PragmaId
		ifTrue: [ stream next.
			pragma := SPragma new name: self nextSymbolOrNil.
			node pragma: pragma ].
	node
		compiledCode: method;
		statements: self nextExpressionArray.
	^ node
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeNestedDynamicVar
	^ SNestedDynamicBinding new
		name:
			self nextSymbol.

! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeReturn
	| expression local |
	local := self nextBoolean.
	expression := self nextExpression.
	^ SReturn new
		local: local;
		expression: expression
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
decodeTemporary
	^ STemporaryBinding new
		index: self nextInteger;
		environment: self nextEnvironment
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextArray
	| count |
	count := self nextInteger.
	^ stream next: count
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextEnvironment
	| value |
	value := self nextInteger.
	^ value !!= -2
		ifTrue: [ value ]
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextExpression
	| type |
	type := self nodeTypeOf: stream next.
	^type decodeUsing: self.

! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextExpressionArray
	| count |
	count := self nextInteger.
	^(1 to: count) collect: [ :arg | self nextExpression ]
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextSymbol
	| index |
	index := self nextInteger.
	^ self literalAt: index
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextSymbolOrNil
	| index |
	index := self nextInteger.
	^index !!= 0 ifTrue: [ self literalAt: index]
! !

!TreecodeDecoder methodsFor: 'public' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nodeTypeOf: id
	^NodeTypes at: id
! !

!TreecodeDecoder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
builder: aRuntime
	builder := aRuntime
! !

!TreecodeDecoder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
method: aMethod
	method := aMethod
! !

!TreecodeDecoder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
stream: aStream
	stream := aStream
! !

!TreecodeDecoder methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
literalAt: anInteger
	^ builder ifNil: [method at: anInteger] ifNotNil: [builder method: method literalAt: anInteger]
! !

!TreecodeDecoder methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextLiteralInteger
	| value |
	value := self nextInteger.
	^ builder
		ifNil: [ value ]
		ifNotNil: [ builder newInteger: value ]
! !

!TreecodeDecoder methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextBoolean
	^ stream next = 1
! !

!TreecodeDecoder methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextInteger
	| value |
	value := stream next.
	value = 16r80
		ifTrue: [ ^ stream int64 ].
	^ value <= 127
		ifTrue: [ value ]
		ifFalse: [ value - 16r100 ]
! !

!TreecodeDecoder methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nextUnsignedInteger
	| value |
	value := self nextByte.
	^value < 128
		ifTrue: [value]
		ifFalse: [value - 128 + (self nextUnsignedInteger bitShift: 7)]
! !

!TreecodeDecoder class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initializeBindingTypes
	BindingTypes := Dictionary new.
	BindingTypes
		at: NilId put: SNilBinding;
		at: TrueId put: STrueBinding;
		at: FalseId put: SFalseBinding;
		at: ArgumentId put: SArgumentBinding;
		at: TemporaryId put: STemporaryBinding;
		at: SelfId put: SSelfBinding;
		at: SuperId put: SSuperBinding;
		at: DynamicVarId put: SDynamicBinding;
		at: NestedDynamicVarId put: SNestedDynamicBinding
! !

!TreecodeDecoder class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initializeNodeTypes
	NodeTypes := Dictionary new.
	NodeTypes
		at: AssignmentId put: SAssignment;
		at: BlockId put: SBlock;
		at: CascadeId put: SCascade;
		at: LiteralId put: SLiteral;
		at: IdentifierId put: SIdentifier;
		at: MessageId put: SMessage;
		at: ReturnId put: SReturn
! !

!TreecodeDecoder class methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initializePools
	"TODO: would be best to share this code with encoder. However, both can be loaded (or not) independently"
	self addNamespaceAs: #BindingIds.
	BindingIds
		at: #NilId put: 1;
		at: #TrueId put: 2;
		at: #FalseId put: 3;
		at: #ArgumentId put: 4;
		at: #TemporaryId put: 5;
		at: #SelfId put: 6;
		at: #SuperId put: 7;
		at: #DynamicVarId put: 14;
		at: #NestedDynamicVarId put: 15;
		at: #PushRid put: 50;
		at: #PopRid put: 51.

	self addNamespaceAs: #TreecodeIds.
	TreecodeIds
		at: #MethodId put: 101;
		at: #BlockId put: 102;
		at: #IdentifierId put: 103;
		at: #LiteralId put: 104;
		at: #MessageId put: 105;
		at: #CascadeId put: 106;
		at: #BraceId put: 107;
		at: #AssignmentId put: 108;
		at: #ReturnId put: 109;
		at: #PragmaId put: 110

! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
at: aString
			^merged at: aString ifAbsent: [nil]
! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
at: aString ifAbsent: aBlock
			^merged at: aString ifAbsent: aBlock
! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dependencies
			^self at: 'dependencies' ifAbsent: [OrderedDictionary new]
! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
modulePaths
	| paths section |
	paths := self at: 'paths'.
	paths ifNil: [^#()].
	section := paths at: 'modules' ifAbsent: [nil].
	section ifNil: [^#()].
	^section
! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name
	| section |
	section := self at: 'project'.
	section ifNil: [^nil].
	^section at: 'name' ifAbsent: [nil]
! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
project
			^project
! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
user
			^user
! !

!Config methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
version
	| section |
	section := self at: 'project'.
	section ifNil: [^nil].
	^section at: 'version' ifAbsent: [nil]
! !

!Config methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load
			self loadUser.
	self loadProject.
	self merge
! !

!Config methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadProject
	| cwd path contents |
	cwd := Kernel currentDirectory.
	path := cwd, '/epm.toml'.
	(Kernel pathExists: path)
		ifTrue: [
			contents := Kernel readFile: path.
			project := TOMLParser parse: contents]
		ifFalse: [project := OrderedDictionary new]
! !

!Config methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadUser
	| home path contents |
	home := Kernel getEnv: 'HOME'.
	home ifNil: [user := OrderedDictionary new. ^self].
	path := home, '/.egg/config.toml'.
	(Kernel pathExists: path)
		ifTrue: [
			contents := Kernel readFile: path.
			user := TOMLParser parse: contents]
		ifFalse: [user := OrderedDictionary new]
! !

!Config methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
merge
			merged := OrderedDictionary new.
	self mergeFrom: user into: merged.
	self mergeFrom: project into: merged
! !

!Config methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
mergeFrom: aSource into: aTarget
			aSource keysAndValuesDo: [:k :v |
		| existing |
		existing := aTarget at: k ifAbsent: [nil].
		(v isKindOf: OrderedDictionary)
			ifTrue: [
				(existing isKindOf: OrderedDictionary)
					ifTrue: [self mergeFrom: v into: existing]
					ifFalse: [
						| copy |
						copy := OrderedDictionary new.
						self mergeFrom: v into: copy.
						aTarget at: k put: copy]]
			ifFalse: [aTarget at: k put: v]]
! !

!Config class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
load
			^self new load
! !

!ProjectGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
dir: aString
	dir := aString
! !

!ProjectGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
moduleName
	| first |
	first := name first asUppercase.
	^(String with: first), (name copyFrom: 2)
! !

!ProjectGenerator methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
name: aString
	name := aString
! !

!ProjectGenerator methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
ensureDir
	dir ifNil: [
		dir := Kernel currentDirectory, '/', name].
	Kernel createDirectory: dir
! !

!ProjectGenerator methodsFor: 'generating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
generate
	| modules module |
	self ensureDir.
	modules := dir, '/modules'.
	module := modules, '/', self moduleName.
	Kernel createDirectory: modules.
	Kernel createDirectory: module.
	self generateToml.
	self generateModule: module
! !

!ProjectGenerator methodsFor: 'generating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
generateModule: aString
	| filename contents module |
	module := self moduleName.
	filename := aString, '/', module, 'Module.st'.
	contents := '"
    See (MIT) license in root directory.
"

Class {
	#name : #', module, 'Module,
	#superclass : #Module,
	#instVars : [],
	#category : #', module, '
}

{ #category : #main }
', module, 'Module >> main: args [
	Kernel log: ''Hello from ', name, '''
]
'.
	Kernel writeFile: filename contents: contents
! !

!ProjectGenerator methodsFor: 'generating' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
generateToml
	| filename contents |
	self ensureDir.
	filename := dir, '/epm.toml'.
	contents := '[project]
name = "', name, '"
version = "0.1.0"
description = ""

[dependencies]
'.
	Kernel writeFile: filename contents: contents
! !

!Builder methodsFor: 'degugging' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
activateDebugMode
	closure activateDebugMode
! !

!Builder methodsFor: 'closure' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addBoundary: anObject as: aSymbolicReference
	closure addBoundary: anObject as: aSymbolicReference
! !

!Builder methodsFor: 'closure' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addNilToken
	closure analyze: closure nilToken from: HashTable nilToken
! !

!Builder methodsFor: 'closure' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
build
	| metaclasses |
    classes := module classes.
	classes do: [:c | self mapClass: c].
	module prepareForSnapshot: self.
	metaclasses := classes collect: [:c | c class].
	closure scope: classes , metaclasses; traverse: module.
! !

!Builder methodsFor: 'closure' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
importNilToken
	closure addBoundary: closure nilToken as: SymbolicReference nilToken
! !

!Builder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
closure
	^closure
! !

!Builder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
imports
	^closure boundary
! !

!Builder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
map: anObject to: anotherObject
	closure map: anObject to: anotherObject
! !

!Builder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapping
	^closure mapping
! !

!Builder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
module
	^module
! !

!Builder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
module: aModule
	module := aModule.
! !

!Builder methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
objects
	^closure objects
! !

!Builder methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapClass: aClass
	self
		mapSubclassesOf: aClass;
		mapMethodsOf: aClass;
		mapMethodsOf: aClass class
! !

!Builder methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapMethod: method
	| copy |
	copy := method copy.
	closure map: method to: copy.
	method hasBlocks ifFalse: [^self].
	method withIndexDo: [:b :i | | bcopy |
		b isBlock ifTrue: [
			bcopy := copy at: i.
			closure map: b to: bcopy]]
! !

!Builder methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapMethodsOf: aClass
    | original saved |
    original := aClass methodDictionary.
	saved := original collect: [:method | module originalMethodFor: method].
    saved := saved select: [:method | method notNil].
	saved do: [:method | self mapMethod: method].
    closure map: original to: saved
! !

!Builder methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapSubclassesOf: aClass
    | original saved |
    original := aClass subclasses.
    saved := original select: [:s | module classes includes: s].
    closure map: original to: saved
! !

!Builder methodsFor: 'initializing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	closure := ObjectClosure new builder: self
! !

!ObjectClosure methodsFor: 'closure' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addSlotsOf: anObject
	self analyze: anObject behavior from: anObject.
	1 to: anObject _pointersSize do: [ :i | | slot |
		slot := anObject _basicAt: i.
		self analyze: slot from: anObject]
! !

!ObjectClosure methodsFor: 'closure' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
analyze: anObject from: source
	| surrogate |
	surrogate := self surrogateFor: anObject.
	(boundary includesKey: surrogate) ifTrue: [^self].
	(added includes: surrogate) ifTrue: [^self].
	(surrogate shouldBeStoredIn: self) ifFalse: [^self addBoundary: surrogate].
	self isDebugging ifTrue: [reversePaths at: anObject put: source].
	added add: surrogate.
	objects add: surrogate.
	queue add: surrogate.
! !

!ObjectClosure methodsFor: 'closure' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
traverse: anObject
	| obj |
	queue add: anObject.
	[ queue isEmpty ]
		whileFalse: [
			obj := queue removeFirst.
			self addSlotsOf: obj ]
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addBoundary: anObject
	self addBoundary: anObject as: anObject asSymbolicReference
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addBoundary: anObject as: aSymbolicReference
	boundary at: anObject put: aSymbolicReference
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
boundary
	^boundary
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
builder
	^builder
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
builder: aBuilder
	builder := aBuilder
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapping
	^mapping
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
module
	^builder module
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nilToken
	^nilToken
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
roots: aCollection
	roots := aCollection
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
scope
	^scope
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
scope: classes
	scope addAll: classes
! !

!ObjectClosure methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
surrogateFor: anObject
	anObject == HashTable nilToken ifTrue: [^nilToken].
	^mapping at: anObject ifAbsent: [anObject]
! !

!ObjectClosure methodsFor: 'degugging' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
activateDebugMode
	debug := true.
	reversePaths := IdentityDictionary new: 100.
! !

!ObjectClosure methodsFor: 'degugging' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
isDebugging
	^debug
! !

!ObjectClosure methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	mapping := IdentityDictionary new.
	queue := OrderedCollection new: 2000.
	added := IdentitySet new: 2000.
	objects := OrderedCollection new: 2000.
	boundary := IdentityDictionary new: 100.
	nilToken := Object new.
	scope := Set new.
	debug := false.
! !

!ObjectClosure methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
map: anObject to: anotherObject
	mapping at: anObject put: anotherObject
! !

!ObjectClosure methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
objects
	^objects
! !

!ObjectClosure methodsFor: 'debugging' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
reversePathOf: anObject
	| path current |
	path := OrderedCollection new.
	current:= anObject.
	[
		path add: current.
		current := reversePaths at: current ifAbsent: [^path].
	] repeat
! !

!HashTablePolicy methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationClass
	^associationClass
! !

!HashTablePolicy methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bucketOfSize: anInteger
	| bucket |
	bucket := (bucketClass new: anInteger) policy: self.
	weak ifTrue: [bucket beWeak].
	^bucket
! !

!HashTablePolicy methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
equates: key with: anObject
	| item |
	item := storesAssociations ifTrue: [anObject key] ifFalse: [anObject].
	^comparison isNil
		ifTrue: [key = item]
		ifFalse: [comparison evaluateWith: key with: item]
! !

!HashTablePolicy methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hashFor: anObject
	^hasher notNil
		ifTrue: [hasher evaluateWith: anObject]
		ifFalse: [anObject hash]
! !

!HashTablePolicy methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyFor: anObject
	^storesAssociations ifTrue: [anObject key] ifFalse: [anObject]
! !

!HashTablePolicy methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
useWeakSlots
	weak := true
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationClass: aClass
	associationClass := aClass
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bucketClass: aClass
	bucketClass := aClass
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
comparison: evaluableObject
	comparison := evaluableObject
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
emptySlot
	^weak ifTrue: [EmptySlot]
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hasher: evaluableObject
	hasher := evaluableObject
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
maxSlots
	^maxSlots
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
maxSlots: anInteger
	maxSlots := anInteger
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
storesAssociations: aBoolean
	storesAssociations := aBoolean
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
useIdentityHash
	self
		hasher: [:key | key basicHash * 16273];
		comparison: [:a :b | a == b]
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
useStringHash
	self
		hasher: [:key | key stringHash];
		comparison: [:a :b | a equals: b]
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
usesWeakSlots
	^weak
! !

!HashTablePolicy methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
weak: aBoolean
	weak := aBoolean
! !

!HashTablePolicy methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
contentOfSize: anInteger
	| table |
	table := bucketClass new: anInteger.
	table policy: self.
	weak ifTrue: [table beWeak].
	^table
! !

!HashTablePolicy methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	associationClass := Association.
	weak := storesAssociations := false
! !

!HashTablePolicy class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
emptySlot
	^EmptySlot
! !

!HashTablePolicy class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeEmptySlot
	EmptySlot := Object new
! !

!ImageSegment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
name
	^name
! !

!ImageSegment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
name: aString
	name := aString
! !

!ImageSegment class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
load: filename
	"TO BE IMPLEMENTED!!"
	^nil
! !

!LMRObject methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
size
	^self primitiveSize
! !

!MatchAlgorithm methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
failBecause: aString
	failure := aString
! !

!MatchAlgorithm methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
reset
	| end |
	failure := nil.
	tokens := pattern tokens.
	string start: start.
	end := stop notNil ifTrue: [stop] ifFalse: [string string size].
	string stop: end.
	ranges := OrderedCollection new: tokens size
! !

!MatchAlgorithm methodsFor: 'outputs' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
failure
	^failure
! !

!MatchAlgorithm methodsFor: 'outputs' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hasMatched
	^failure isNil and: [tokens isEmpty]
! !

!MatchAlgorithm methodsFor: 'outputs' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchRange
	| sorted |
	sorted := ranges collect: #value thenSelect: [:p | p x <= p y].
	sorted := sorted asSortedCollection: [:p :q | p x < q x].
	^sorted notEmpty ifTrue: [sorted first x @ sorted last y]
! !

!MatchAlgorithm methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hasTokens
	^failure isNil and: [tokens notEmpty]
! !

!MatchAlgorithm methodsFor: 'inputs' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
index: anInteger
	start := anInteger
! !

!MatchAlgorithm methodsFor: 'inputs' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
pattern: aStringPattern
	pattern := aStringPattern
! !

!MatchAlgorithm methodsFor: 'inputs' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
string: aString
	string := MatchToken on: aString from: 1 to: aString size
! !

!MatchAlgorithm methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	super initialize.
	start := 1
! !

!MatchAlgorithm methodsFor: 'computing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchFirstStar
	| range |
	range := string start @ nil.
	ranges add: tokens first -> range.
	tokens removeFirst.
	self hasTokens
		ifTrue: [tokens first matchFirstAfterStartOn: self]
		ifFalse: [
			range y: string stop.
			string stop: string start - 1]
! !

!MatchAlgorithm methodsFor: 'computing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchFirstToken
	| token min match save |
	token := tokens first.
	min := token length.
	match := false.
	save := string start.
	[
		string length >= min and: [
			match := string beginsWith: token.
			match not]]
		whileTrue: [string start: string start + 1].
	match
		ifTrue: [
			ranges add: token -> (string start @ (string start + min - 1)).
			string start: string start + token length.
			tokens removeFirst]
		ifFalse: [
			tokens size = 1 ifTrue: [
				string start: save.
				^self privateMatchLastToken].
			self
				failBecause: token asString , ' not present at position '
					, string start printString]
! !

!MatchAlgorithm methodsFor: 'computing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchFirstTokenAfterStar
	| token i |
	token := tokens first.
	i := string indexOf: token.
	i = 0
		ifTrue: [
			self
				failBecause: token asString , ' not present in inteval ['
					, string start printString
					, ', '
					, string stop printString]
		ifFalse: [
			ranges last value y: i - 1.
			ranges add: token -> (i @ (i + token length - 1)).
			string start: i + token length.
			tokens removeFirst]
! !

!MatchAlgorithm methodsFor: 'computing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchLastToken
	tokens size = 1
		ifTrue: [self matchFirstToken]
		ifFalse: [self privateMatchLastToken]
! !

!MatchAlgorithm methodsFor: 'computing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchNextToken
	tokens first matchFirstOn: self
! !

!MatchAlgorithm methodsFor: 'computing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
privateMatchLastToken
	| token min match |
	token := tokens last.
	min := token length.
	match := false.
	[
		string length >= min and: [
			match := string endsWith: token.
			match not]]
		whileTrue: [string stop: string stop - 1].
	match
		ifTrue: [
			ranges add: token -> (string stop - min + 1 @ string stop).
			string stop: string stop - token length.
			tokens removeLast]
		ifFalse: [
			self
				failBecause: token asString , ' not present at position '
					, (string stop - token length + 1) printString]
! !

!MatchAlgorithm methodsFor: 'computing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
run
	self reset.
	tokens isEmpty ifTrue: [^self].
	tokens last matchLastOn: self.
	[self hasTokens] whileTrue: [self matchNextToken]
! !

!MatchToken methodsFor: 'converting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
asString
	^string copyFrom: start to: stop
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: i
	^string at: i
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
length
	^stop - start + 1
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
start
	^start
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
start: anInteger
	start := anInteger
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
stop
	^stop
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
stop: anInteger
	stop := anInteger
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
string
	^string
! !

!MatchToken methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
string: aString
	string := aString
! !

!MatchToken methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
beginsWith: aMatchToken
	self length >= aMatchToken length ifFalse: [^false].
	aMatchToken start to: aMatchToken stop do: [:i | | char |
		char := aMatchToken at: i.
		((self at: start + i - 1) = char or: [char isQuestionMark]) ifFalse: [^false]].
	^true
! !

!MatchToken methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
endsWith: aMatchToken
	| end |
	self length >= aMatchToken length ifFalse: [^false].
	end := aMatchToken stop.
	end to: aMatchToken start by: -1 do: [:i | | char |
		char := aMatchToken at: i.
		((self at: stop - end + i) = char or: [char isQuestionMark]) ifFalse: [^false]].
	^true
! !

!MatchToken methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexOf: aMatchToken
	^string indexOfString: aMatchToken asString from: start to: stop
! !

!MatchToken methodsFor: 'double dispatching' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchFirstAfterStartOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstTokenAfterStar
! !

!MatchToken methodsFor: 'double dispatching' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchFirstOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstToken
! !

!MatchToken methodsFor: 'double dispatching' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchLastOn: aMatchAlgorithm
	aMatchAlgorithm matchLastToken
! !

!MatchToken methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printOn: aStream
	start to: stop do: [:i | aStream nextPut: (string at: i)]
! !

!MatchToken class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
on: aString from: start to: stop
	^self new
		string: aString;
		start: start;
		stop: stop
! !

!Module methodsFor: 'snapshotting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
prepareForSnapshot: aBuilder
	aBuilder
		importNilToken;
		addBoundary: Symbol symbolTable as: SymbolicReference symbolTable;
		map: overriden to: Dictionary new
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addClass: aClass
	classes add: aClass.
	self exportClass: aClass
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addExtension: aCompiledMethod
	| collection | 
	collection := extensions at: aCompiledMethod classBinding symbol ifAbsentPut: [OrderedCollection new].
	collection add: aCompiledMethod.
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addOverride: aCompiledMethod
	overriden at: aCompiledMethod signature put: aCompiledMethod
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bind
	classes
		reject: [:c | classes includes: c superclass]
		thenDo: [:c | c superclass addSubclass: c].
	extensions keysAndValuesDo: [:s :methods | | meta key target |
		meta := s endsWith: ' class'.
		key := meta ifTrue: [(s trimTail: ' class') asSymbol] ifFalse: [s].
		target := namespace at: key ifAbsent: [self _halt].
		meta ifTrue: [target := target class].
		methods do: [:m | | current extension |
			current := target compiledMethodAt: m selector.
			extension := m asExtensionFor: self.
			target addSelector: m selector withMethod: extension.
			current notNil ifTrue: [current module addOverride: current]]
	]
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bind: anObject as: aSymbol
	namespace at: aSymbol put: anObject.
	self justDefined: aSymbol
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bindKernelExports
	| bindings |
	bindings := Dictionary new.
	{
		Object. Class. Metaclass. CompiledMethod.
		Array. OrderedCollection. Set. Dictionary.
		SmallInteger. String. Character.
	} do: [:class |
			bindings at: class symbol put: class].
	bindings at: #Kernel put: Kernel.
	self bindAll: bindings
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
export: anObject as: aSymbol
	namespace at: aSymbol put: anObject.
	exports add: aSymbol
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
exportClass: aClass
	self export: aClass as: aClass name asSymbol
! !

!Module methodsFor: 'services' stamp: 'KenD 1/Jul/2026, 7:36:13 pm (UTC)'!
exports
	| result |
	result := Dictionary new.
	result at: '__module__' put: self.
	exports do: [:aName | | value |
		value := namespace at: aName.
		result at: aName put: value].
	^result
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
import: moduleName
	| module |
	namespace at: moduleName ifPresent: [:loaded | ^loaded].
	module := Kernel load: moduleName.
	self bind: module as: moduleName.
	^module
! !

!Module methodsFor: 'services' stamp: 'KenD 1/Jul/2026, 7:37:00 pm (UTC)'!
import: aName from: moduleName
	^self import: aName from: moduleName as: aName
! !

!Module methodsFor: 'services' stamp: 'KenD 1/Jul/2026, 7:37:23 pm (UTC)'!
import: aName from: moduleName as: newName
	| module import |
	module := Kernel load: moduleName.
	import := module namespace at: aName.
	self bind: import as: newName
! !

!Module methodsFor: 'services' stamp: 'KenD 1/Jul/2026, 7:38:33 pm (UTC)'!
importDescriptor: descriptor
	| moduleName token exportNames |
	moduleName := descriptor key.
	token := descriptor value.
	exportNames := token isArray ifTrue: [token] ifFalse: [{token}].
	exportNames do: [:aName | self import: aName from: moduleName]
! !

!Module methodsFor: 'services' stamp: 'KenD 1/Jul/2026, 7:38:42 pm (UTC)'!
importRequiredModules
	requires do: [:aName | self import: aName].
	self imports do: [:descriptor | self importDescriptor: descriptor]
! !

!Module methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
imports
	"
	Returns an array of import descriptors. A descriptor can be:
	 - A composite symbol (i.e #Core.Modules.Writer) (NOT IMPLEMENTED YET).
	 - An association of module name and exported name (i.e #Core.Modules.JSON -> #Writer)
	 - An association of module name, exported name and rename (i.e. #Core.Modules.JSON -> (#Writer -> #JSONWriter)) (NOT IMPLEMENTED YET)
	"
	^#()
! !

!Module methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicInitialize
	name := self defaultName.
	namespace ifNil: [namespace := Namespace new].
	exports := Set new.
	cachedLookups := Dictionary new.
	classes := OrderedCollection new.
	extensions := Dictionary new.
	overriden := Dictionary new.
	requires := #()
! !

!Module methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
defaultName
	| classname |
	classname := self class name.
	(classname endsWith: 'Module') ifTrue: [^classname trimTail: 'Module'].
	(classname beginsWith: 'Module') ifTrue: [^classname trimPrefix: 'Module'].
	^classname
! !

!Module methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bindAll: aDictionary
	aDictionary keysAndValuesDo: [:symbol :value |
		namespace at: symbol put: value.
		self justDefined: symbol].
! !

!Module methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
justDefined: aSymbol
	| lookups |
	lookups := cachedLookups at: aSymbol ifAbsent: [^nil].
	lookups do: [:lookup | lookup flush]
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
classes
	^classes
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
extensions
	^extensions
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
justLoaded
	self bind
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
name
	^name
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
name: aString
	name := aString
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
namespace
	^namespace
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
originalMethodFor: aCompiledMethod
	aCompiledMethod module == self ifTrue: [^aCompiledMethod].
	^overriden at: aCompiledMethod signature ifAbsent: nil
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
overriden
	^overriden
! !

!Module methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
requires
	^requires
! !

!Module methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
classNamed: aString
	^classes detect: [:cls | cls name = aString ] ifNone: nil
! !

!Module methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
extensionClasses
	^extensions keys
		collect: [:s | | key |
			key := (s endsWith: ' class') ifTrue: [(s trimTail: ' class') asSymbol] ifFalse: [s].
			namespace at: key ifAbsent: [Class new name: (s , '__Not_Found') asSymbol]]
! !

!Module methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isModule
	^true
! !

!Module class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new
	^self basicNew basicInitialize
! !

!ArgParserModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
imports
	^{
		#Kernel -> #(Error OrderedDictionary).
	}
! !

!CodeSpecsModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
imports
	^{
		#Kernel -> #(#OrderedDictionary).
	}
! !

!TestsModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
imports
	^{
		#Kernel -> #(Array Error Exception OrderedCollection UndefinedObject WideString WideSymbol).
		#Compiler -> #(SCompiler SCompilationError SMethodNode SSelectorNode SMessageNode SStringToken InlinedArgEnvironment MethodScope).
		#SUnit -> #(TestCase TestResult TestSuite)
	}
! !

!TestsModule methodsFor: 'main' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
main: anArray
	| suite result |
	Kernel log: 'Running Compiler tests...
'.
	suite := TestSuite forModule: self.
	Kernel log: 'suite built with ', suite tests size printString, ' tests
'.
	result := suite run.
	Kernel log: 'Done.
'.
	Kernel log: result printString.
	Kernel log: '
'
! !

!CompilerModule methodsFor: 'initializing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	TreecodeEncoder initializeBindingIds; initializeTreecodeIds.
	self initializeClosureElementIds
! !

!CompilerModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
imports
	^{
		#Kernel -> #(Error ByteArray CompiledBlock Module NumberParser Species OrderedDictionary)
	}
! !

!CompilerModule methodsFor: 'class initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeClosureElementIds
	self namespace
		at: #CaptureSelf put: 0;
		at: #CaptureLocalArgument put: 1;
		at: #CaptureEnvironment put: 2;
		at: #CaptureEnvironmentValue put: 3;
		at: #CaptureInlinedArgument put: 4
! !

!LMRModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
imports
	^{
		#Kernel -> #(ProcessStack ProtoObject SequenceableCollection WordSize).
		#Kernel.LMR -> #(LMRProtoObject)
	}
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
globalNamed: aSymbol
	| index |
	index := self class indexOfGlobal: aSymbol.
	^globals at: index
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
globalNamed: aSymbol put: anObject
	| index |
	index := self class indexOfGlobal: aSymbol.
	globals at: index put: anObject
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
globals
	^globals
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
invokeStub
	^(self globalNamed: #Invoke) code
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookup
	^self globalNamed: #Lookup
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupDebuggableStub
	^(self globalNamed: #DebuggableLookup) code
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupStub
	^(self globalNamed: #Lookup) code
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupSuper
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^globals at: index
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupSuperDebuggableStub
	| index |
	index := self class indexOfGlobal: #DebuggableLookupSuper.
	^(globals at: index) code
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupSuperStub
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^(globals at: index) code
! !

!LMRModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
safepoint
	^(self globalNamed: #Safepoint) code
! !

!LMRModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initializeGlobalsWithStubs
	| items |
	globals := Array new: self class globalNames size.

	self globalNamed: #SmallIntegerBehavior put: SmallInteger instanceBehavior.

	items := Dictionary withAll: {
		#Lookup                -> (NativeCode new code: 'Lookup Placeholder').
		#LookupSuper           -> (NativeCode new code: 'LookupSuper Placeholder').
		#DebuggableLookup      -> (NativeCode new code: 'DebuggableLookup placeholder').
		#DebuggableLookupSuper -> (NativeCode new code: 'DebuggableLookupSuper placholder').
		#Invoke                -> (NativeCode new code: 'Invoke placeholder').
		#Safepoint             -> (NativeCode new code: 'SafepointCheck placeholder').
		#WriteBarrier          -> (NativeCode new code: 'Write Barrier placeholder')}.
	items
		keysAndValuesDo: [ :key :placeholder | self globalNamed: key put: placeholder ]
! !

!LMRModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initializeMemory
	| kernel |
	kernel := GCSpace new.
	kernel name: 'Kernel'.
	memory := Memory new
		addKernelSpace: kernel;
		fromSpace: kernel;
		eden: kernel
! !

!LMRModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
justLoaded
	super justLoaded.
	SendSite initializeFormatFlags.
	GlobalDispatchCache initialize.
	self
		initializeMemory;
		initializeGlobalsWithStubs.
! !

!LMRModule methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapGlobal: aSymbol to: nativeCode
	placeholder := self globalNamed: aSymbol.
	placeholder code become: nativeCode code.
	placeholder become: nativeCode.
! !

!LMRModule class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
globalNames
	^#(Lookup LookupSuper WriteBarrier Safepoint SmallIntegerBehavior Invoke DebuggableLookup DebuggableLookupSuper)
! !

!LMRModule class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
indexOfGlobal: aSymbol
	^self globalNames
		indexOf: aSymbol
		ifAbsent: [self error: 'global not found']
! !

!SExpressionsModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
imports
	^{
	}
! !

!SExpressionsModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
justLoaded
	super justLoaded.
	TreecodeDecoder initializePools; initializeBindingTypes; initializeNodeTypes
! !

!EPMModule methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addCommand: aString description: aDescription action: aSymbol
	| command |
	command := Command new
		name: aString;
		description: aDescription.
	command action: [:result | self perform: aSymbol with: result].
	parser addCommand: command.
	^command
! !

!EPMModule methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadConfig
	| host |
	config := Config load.
	host := Kernel host.
	config modulePaths do: [:path |
		host prependSearchPath: path type: #tonel.
		host prependSearchPath: path type: #ems]
! !

!EPMModule methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
setupParser
	| create |
	parser := ArgParser new name: 'epm'; description: 'Egg Package Manager'.
	create := self addCommand: 'new' description: 'Create a new project' action: #commandNew:.
	create addPositional: 'name'.
	self addCommand: 'init' description: 'Initialize epm.toml in current directory' action: #commandInit:.
	self addCommand: 'start' description: 'Run current project' action: #commandStart:.
	self addCommand: 'dev' description: 'Start development environment for current project' action: #commandDev:.
	self addCommand: 'install' description: 'Install dependencies from epm.toml' action: #commandInstall:.
	self addCommand: 'list' description: 'List project dependencies' action: #commandList:.
	((self addCommand: 'test' description: 'Run tests for a module' action: #commandTest:)
		addPositional: 'module';
		addOption: (Option new
			long: '--debug';
			description: 'Run tests without swallowing exceptions';
			beFlag;
			yourself))
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 1/Jul/2026, 7:39:29 pm (UTC)'!
commandDev: aResult
	| cwd aName dev module |
	cwd := Kernel currentDirectory.
	aName := cwd copyAfterLast: $/.
	dev := Kernel load: #Development.
	module := Kernel load: aName asSymbol.
	dev main: args
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 1/Jul/2026, 7:39:50 pm (UTC)'!
commandInit: aResult
	| cwd aName generator |
	cwd := Kernel currentDirectory.
	aName := cwd copyAfterLast: $/.
	aName isEmpty ifTrue: [aName := 'myproject'].
	generator := ProjectGenerator new.
	generator name: aName.
	generator dir: cwd.
	generator generateToml.
	Kernel log: 'Initialized epm.toml for: ', aName
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 1/Jul/2026, 7:40:07 pm (UTC)'!
commandInstall: aResult
	| dependencies |
	config ifNil: [self loadConfig].
	dependencies := config dependencies.
	dependencies isEmpty ifTrue: [
		Kernel log: 'No dependencies to install'.
		^self].
	Kernel log: 'Installing dependencies...'.
	dependencies keysAndValuesDo: [:aName :constraint |
		Kernel log: '  ', aName, ' (', constraint asString, ')'].
	Kernel log: 'Done'
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 1/Jul/2026, 7:40:56 pm (UTC)'!
commandList: aResult
	| dependencies |
	config ifNil: [self loadConfig].
	dependencies := config dependencies.
	dependencies isEmpty ifTrue: [
		Kernel log: 'No dependencies'.
		^self].
	Kernel log: config name ifNil: ['(unnamed project)'].
	dependencies keysAndValuesDo: [:aName :constraint |
		Kernel log: '  ', aName, ' ', constraint asString]
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 1/Jul/2026, 7:41:17 pm (UTC)'!
commandNew: aResult
	| aName generator |
	aResult positionals isEmpty ifTrue: [
		^self error: 'Usage: epm new <project-name>'].
	aName := aResult positionalAt: 1.
	generator := ProjectGenerator new.
	generator name: aName.
	generator generate.
	Kernel log: 'Created project: ', aName
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 1/Jul/2026, 7:41:28 pm (UTC)'!
commandStart: aResult
	| cwd aName module |
	cwd := Kernel currentDirectory.
	aName := cwd copyAfterLast: $/.
	module := Kernel load: aName asSymbol.
	module main: args
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 1/Jul/2026, 7:41:49 pm (UTC)'!
commandTest: aResult
	| aName module positionals |
	positionals := aResult positionals.
	aName := positionals isEmpty
		ifTrue: [self projectName]
		ifFalse: [positionals first].
	aName ifNil: [
		^self error: 'Usage: epm test [module-name]'].
	module := Kernel load: (aName, '.Tests') asSymbol.
	(aResult optionAt: 'debug') == true
		ifTrue: [self debugTestModule: module]
		ifFalse: [module main: args]
! !

!EPMModule methodsFor: 'commands' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
debugTestModule: aModule
	Kernel log: 'Running ', aModule name, ' tests in debug mode...'; log: String cr.
	(TestSuite forModule: aModule) runDebug.
	Kernel log: 'Done.'; log: String cr
! !

!EPMModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
imports
	^{
		#Kernel -> #(Error OrderedDictionary).
		#ArgParser -> #(ArgParser Command Option).
		#SUnit -> #(TestSuite).
		#TOML -> #(TOMLParser TOMLWriter).
	}
! !

!EPMModule methodsFor: 'main' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
main: aCollection
	| params |
	args := aCollection.
	self loadConfig.
	self setupParser.
	params := OrderedCollection new.
	3 to: args size do: [:i |
		| arg |
		arg := args at: i.
		params add: arg].
	parser parse: params asArray
! !

!EPMModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
projectName
	^config ifNotNil: [config name]
! !

!ImageSegmentBuilderModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
imports
	^{
		#Kernel -> {
			#Behavior. #Boolean. #False. #HashTable. #IdentityDictionary. #IdentitySet. #KernelModule. 
			#Module. #Symbol. #SymbolicReference. #True. #UndefinedObject
		}
	}
! !

!KernelModule methodsFor: 'snapshotting' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
prepareForSnapshot: aBuilder
	| dict loaders |
	dict := Dictionary new.
	dict at: #Kernel put: self.
	loaders := OrderedCollection new.
	loaders add: moduleLoaders first.
	aBuilder
		addNilToken;
		map: loadedModules to: dict;
		map: moduleLoaders to: loaders
! !

!KernelModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bootstrap
	| shift |
	CompiledBlock initializeFormatFlags.
	CompiledMethod initializeFormatFlags.
	Species initializeFormatFlags.
	Character initializeCharacters; initializeNamedCharacters; initializeLatin1Tables.
	Closure initializeIndexes.
	Float initializeConstants.
	HashTable initializeConstants; initializeSizes.
	HashTablePolicy initializeEmptySlot.
	HashedCollection initializePolicies.
	LargeInteger initializeBase.
	LargeNegativeInteger initializeConstants.
	SmallInteger initializeConstants.
	cachedLookups := Dictionary new.
	shift := WordSize = 8 ifTrue: [3] ifFalse: [2].
	namespace 
		at: #nil put: nil;
		at: #true put: true;
		at: #false put: false;
		at: #WordSize put: WordSize;
		at: #WordSizeShift put: shift;
		at: #Kernel put: self;
		at: #KnownSymbols put: #(+ - < > <= >= = == not);
		at: #Processor put: ProcessorScheduler new.
	StarToken initializeCurrent.
	utf8 := UTF8 new.
	utf16 := UTF16 new.
	utf32 := UTF32 new.
	Symbol initializeSymbolTable.
	namespace at: #SymbolTable put: Symbol symbolTable.
	Stream initializePools.
	CharacterArray initializePools.
	ProtoObject initializeConstants; initializeBitMasks.

	#FFICall. "hack to have this symbol (used by primitiveFFICall) in kernel ims"
	self initialize.
	CRITICAL := false.
	self suspendOnUnhandledExceptions
! !

!KernelModule methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addModuleLoader: aModuleLoader
	moduleLoaders add: aModuleLoader
! !

!KernelModule methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	"
		We cannot use addClass: because it creates new symbol instances, which must be
		avoided during bootstrap (else we would end with duplicated symbols)
	"
	self basicInitialize; freezeOnUnhandledExceptions.
	host := HostSystem new.
	moduleLoaders := OrderedCollection new.
	loadedModules := Dictionary new.
	loadedModules at: #Kernel put: self.
	namespace 
		keys do: [:symbol | | obj |
			obj := namespace at: symbol.
			obj isClass ifTrue: [classes add: obj].
			exports add: symbol].
	session := SmalltalkSession new.
	properties := WeakIdentityDictionary new.

! !

!KernelModule methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
rehashWeakRegistries
	session rehashWeakRegistries.
	properties rehash
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
createDirectory: aString
	^host createDirectory: aString
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
critical: aBlock
	"critical meaning is: run without GC and without interrupts. On unhandled errors, don't
	try to halt this process and continue with others, just freeze this OS process or exit."
	prev := CRITICAL.
	CRITICAL := true.
	result := aBlock value.
	CRITICAL := prev.
	aBlock value
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
currentDirectory
	^host currentDirectory
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
freezeOnUnhandledExceptions
	unhandledErrorHandler := [:exception | self _halt]
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
getEnv: aString
	^host getEnv: aString
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
load: aSymbol
	| filename |
	loadedModules at: aSymbol ifPresent: [:module | ^module].
	moduleLoaders do: [:loader | 
		(loader load: aSymbol) ifNotNil: [:module | 
			loadedModules at: aSymbol put: module.
			^module]].
	^self error: 'module not found'
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
loadModuleFromPath: aString
	^host loadModuleFromPath: aString
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
pathExists: aString
	^host pathExists: aString
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
prepareForExecution: aCompiledMethod
	self errorVMSpecific
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
readFile: filename
	^host readFile: filename
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
suspendOnUnhandledExceptions
	unhandledErrorHandler := [:exception | self suspendBecause: exception]
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
terminateOnUnhandledExceptions
	unhandledErrorHandler := [:exception | self terminateSessionBecause: exception description]
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
terminateSessionBecause: aString
	host logError: aString; logError: Processor activeProcess backtrace; exit: -1
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
unhandledException: anException
	| debuggable |
	CRITICAL ifTrue: [self _error: 'process failed in a critical moment'].
	unhandledErrorHandler value: anException
! !

!KernelModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
writeFile: aFilename contents: aString
	^host writeFile: aFilename contents: aString
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
ensurePropertyTableFor: anObject
	^properties at: anObject ifAbsentPut: [IdentityDictionary new]
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
exit
	host exit: 0
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
finalizer
	^session finalizer
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
host
	^host
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
loadedModules
	^loadedModules
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
memory
	^memory
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
processor
	^Processor
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
properties
	^properties
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
propertiesFor: anObject
	^properties at: anObject ifAbsent: nil
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
unhandledExceptionHandler: aClosure
	unhandledErrorHandler := aClosure
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
utf16
	^utf16
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
utf32
	^utf32
! !

!KernelModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
utf8
	^utf8
! !

!KernelModule methodsFor: 'startup/shutdown' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
ephemeronsDo: aBlock
	session ephemeronsDo: aBlock.
	properties ephemeronsDo: aBlock
! !

!KernelModule methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
loadedModuleNamed: aSymbol
	^loadedModules at: aSymbol ifAbsent: []
! !

!KernelModule methodsFor: 'logging' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
log: aString
	^host log: aString level: 2
! !

!KernelModule methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeKey: aSymbol from: aMethodDictionary ifAbsent: aBlock
	| cm |
	cm := aMethodDictionary at: aSymbol ifAbsent: [^aBlock value].
	^aMethodDictionary basicRemoveKey: aSymbol asSymbol ifAbsent: aBlock
! !

!KernelModule methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
suspendBecause: anException
	| active process |
	active := Processor activeProcess.
	process := Process sending: #suspended:because: to: host with: {active. anException}.
	process takeControl
! !

!KernelModule methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
useHostModuleLoader
	host setupDefaultSearchPaths.
	self addModuleLoader: host.
! !

!ModuleImporterModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
imports
	^{
		#Kernel -> #(#InternalReadStream #Character #CharacterArray #IdentitySet #Module).
		#Tonel -> #(#TonelReader).
		#CodeSpecs -> #(#ModuleSpec #ClassSpec #MetaclassSpec #MethodSpec).
		#STON -> #(#STONReader).
		#Compiler -> #(#SCompiler).
	}
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
bootstrap: anLMRModule with: aPlatform
	environment := self newNativizationEnvironmentFor: aPlatform.

	self
		nativizeInvokeFor: anLMRModule;
		nativizeWriteBarrierFor: anLMRModule;
		nativizeLookupFor: anLMRModule;
		nativizeSendSiteStubs.

	environment initializeLinkersFor: anLMRModule; completeInitialization
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeFor: anLMRModule with: aPlatform
	environment := self newNativizationEnvironmentFor: aPlatform.
	environment initializeLinkersFor: anLMRModule; completeInitialization
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeInvokeFor: anLMRModule
	| invoke |
	invoke := SendSite >> #_invokeOn:.
	environment nativizeOptimizing: invoke.
	anLMRModule mapGlobal: #Invoke to: invoke
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeLookupFor: anLMRModule
	| nativizer lookup lookupSuper |
	nativizer := LookupNativizer new
		environment: environment;
		nativizeMethods.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	anLMRModule
		mapGlobal: #Lookup to: lookup executableCode;
		mapGlobal: #LookupSuper to: lookupSuper executableCode
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeMonomorphicCache
	| asm lookup next smiGlobal lookupGlobal |
	asm := environment newAssembler.
	lookup := asm newLabel.
	smiGlobal := self indexOfGlobal: #SmallIntegerBehavior.
	lookupGlobal := self indexOfGlobal: #Lookup
	asm
		loadTwithAindex: 3;
		loadSwithGindex: smiGlobal.
	next := asm labeledNonIntegerBitTestOfR.
	asm
		loadLongSwithRindex: 0;
		@ next;
		compareSwithTindex: 1;
		shortJumpIfNotEqualTo: lookup;
		loadMwithTindex: 2;
		jumpToMindex: 1;
		@ lookup;
		loadMwithGindex: lookupGlobal;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizePolymorphicCache
	| asm smi lookupGlobal case2 case3 case4 case5 case6 case7 lookup |
	asm := environment newAssembler.
	smi := asm newLabel.
	case2 := asm newLabel.
	case3 := asm newLabel.
	case4 := asm newLabel.
	case5 := asm newLabel.
	case6 := asm newLabel.
	case7 := asm newLabel.
	lookup := asm newLabel.
	asm loadTwithAindex: 3.
	smi := asm labeledNonIntegerBitTestOfR.
	lookupGlobal := self indexOfGlobal: #Lookup.
	asm
		loadLongSwithRindex: 0;
		compareSwithTindex: 1;
		shortJumpIfNotEqualTo: case2;
		loadMwithTindex: 2;
		jumpToMindex: 1;
		@ case2;
		compareSwithTindex: 3;
		shortJumpIfNotEqualTo: case3;
		loadMwithTindex: 4;
		jumpToMindex: 1;
		@ case3;
		compareSwithTindex: 5;
		shortJumpIfNotEqualTo: case4;
		loadMwithTindex: 6;
		jumpToMindex: 1;
		@ case4;
		compareSwithTindex: 7;
		shortJumpIfNotEqualTo: case5;
		loadMwithTindex: 8;
		jumpToMindex: 1;
		@ case5;
		compareSwithTindex: 9;
		shortJumpIfNotEqualTo: case6;
		loadMwithTindex: 10;
		jumpToMindex: 1;
		@ case6;
		compareSwithTindex: 11;
		shortJumpIfNotEqualTo: case7;
		loadMwithTindex: 12;
		jumpToMindex: 1;
		@ case7;
		compareSwithTindex: 13;
		shortJumpIfNotEqualTo: lookup;
		loadMwithTindex: 14;
		jumpToMindex: 1;
		@ lookup;
		loadMwithGindex: lookupGlobal;
		jumpToMindex: 1;
		@ smi;
		loadMwithTindex: 15;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeSendSiteStubs
	SendSite 
		monomorphicCache: self nativizeMonomorphicCache;
		polymorphicCache: self nativizePolymorphicCache.
! !

!NativizerModule methodsFor: 'bootstrapping' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeWriteBarrierFor: anLMRModule
	| map inlined barrier dispatcher |
	map := {
		(Memory class -> #(current)).
		(Memory -> #(isYoung: isYoungSafe: remember:)).
		(CriticalArray -> #(unsafeAdd: #unsafeAt:put:)).
		(Magnitude -> #(#between:and:))
	}.
	inlined := self methodSubset: map.
	inlined addAll: self undermethods.
	barrier := ProtoObject >> #holdRefererIfNeeded:.
	dispatcher := LookupLinker new initializeFrom: nativizer.
	NativizationEnvironment new
		platform: environment platform;
		inlinedMethods: inlined;
		messageLinker: dispatcher;
		completeInitialization;
		nativizeOptimizing: barrier.
	anLMRModule mapGlobal: #WriteBarrier to: barrier executableCode
! !

!NativizerModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
environment
	^environment
! !

!NativizerModule methodsFor: 'spec' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
imports
	^{
		#Kernel -> #(Behavior CharacterArray Closure CompiledBlock CompiledMethod Float OrderedCollection ProtoObject Species String).
		#Kernel.LMR -> #(LMRProtoObject LMRFloat LMRSpecies).
		#LMR -> #(CriticalArray GCSpace GlobalDispatchCache Memory NativeCode SendSite Thread).
	}
! !

!NativizerModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlinedMethods
	| map |
	map := {
		(ProtoObject -> #(#basicObjectIndexOf: #class #objectAtValid: #objectAtValid:put:)).
		(LMRProtoObject -> #(#behavior #primitiveAt: #_cachedLookup: #_cachedLookup:in:)).
		(Object -> #(#byteAtValid: #byteAtValid:put: #at:put:)).
		(Species -> #(#instSize #_instancesAreArrayed #_instancesHavePointers #instanceBehavior)).
		(LMRSpecies -> #(#memory #primitiveNew #primitiveNew:)).
		(CompiledMethod -> #(#prepareForExecution #isNativized #executableCode #blockCount #literalIndexFrom:)).
		(CompiledBlock -> #(#argumentCount #blockNumber #blockCode #method)).
		(NativeCode -> #(#code)).
		(GCSpace -> #(#commitedLimit #nextFree #nextFree:)).
		(CharacterArray -> #(#characterAtValid:))}.
	^self undermethods , (self methodSubset: map)
! !

!NativizerModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
invokedMethods
	| map |
	map := {
		(ProtoObject -> #(class)).
		(LMRProtoObject -> #(behavior #initializeExtended:contentSize: primitiveAt:)).
		(Object -> #(_replaceFrom:to:with:)).
		(Species -> #(instanceBehavior _instancesAreArrayed _instancesHavePointers)).
		(LMRSpecies -> #(allocate:size: nil:slotsOf: memory primitiveNewBytes: primitiveNewPointers: zero:bytesOf:))}.
	^self undermethods , (self methodSubset: map)
! !

!NativizerModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
justLoaded
	InlineMessageLinker initializeInlineMessageLinkerFlags
! !

!NativizerModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodSubset: associations
	| result dict |
	result := OrderedCollection new.
	dict := Dictionary withAll: associations.
	dict keysAndValuesDo: [ :species :selectors | 
		selectors collect: [:sel | | m | species >> sel ifNil: [self ASSERT: false] ] in: result].
	^result
! !

!NativizerModule methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
optimizedMethods
	| map |
	map := {
		(ProtoObject -> #(basicByteAt: #basicByteAt:put: basicObjectAt: #basicObjectAt:put: class)).
		(LMRProtoObject -> #(behavior primitiveAt: #primitiveAt:put: #initializeExtended:contentSize:)). 
		(Object -> #(at: #at:put: byteAtValid: #byteAtValid:put: #replaceBytesForwardFrom:to:with:startingAt:)).
		(SendSite -> #(_dispatchOn: #_dispatchOn:startingAt: _dispatchDebuggableOn: #_dispatchDebuggableOn:startingAt:)).
		(Species -> #(instSize)).
		(LMRSpecies -> #(allocate:size: primitiveNew primitiveNew: primitiveNewBytes: primitiveNewPointers:)).
		(LMRFloat class -> #(new)).
		(CompiledBlock -> #(argumentCount arity blockCode method)).
		(Closure -> #(value value: #value:value:)).
		(CompiledMethod -> #(blockCount isNativized)).
		(String -> #(at: #at:put: byteAt: #byteAt:put:)).
		(GCSpace -> #(lockedAllocateIfPossible: shallowCopy:)).
		(Memory -> #(shallowCopy:))}.
	^self undermethods , (self methodSubset: map)
! !

!NativizerModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
newNativizationEnvironmentFor: aPlatform
	^NativizationEnvironment new
		platform: aPlatform;
		inlinedMethods: self inlinedMethods;
		invokedMethods: self invokedMethods;
		optimizedMethods: self optimizedMethods
! !

!NativizerModule methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
undermethods
	^SendSite undermethods
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
checkNumberEnd: position
	| char |
	stream atEnd ifTrue: [^self].
	char := stream peek.
	char = $. ifFalse: [^self].
	stream skip: 1.
	stream atEnd
		ifFalse: [stream peek isDigit
			ifTrue: [self error: 'invalid number' at: position]].
	stream skip: -1
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
completeFloat: anInteger
	| tenth |
	tenth := 10 raisedToInteger: self nextExponent.
	^(anInteger * tenth) asFloat
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
completeNumber: anInteger after: aCharacter
	aCharacter = $. ifTrue: [
		^(stream peekFor: $s)
			ifTrue: [self nextScaledFrom: anInteger fractionDigits: 0]
			ifFalse: [self nextFloat: anInteger]].
	(aCharacter = $e or: [aCharacter = $E])
		ifTrue: [^self completeFloat: anInteger].
	aCharacter = $r ifTrue: [^self nextIntegerRadix: anInteger].
	aCharacter = $s ifTrue: [^self nextScaledFrom: anInteger fractionDigits: 0].
	(anInteger = 0 and: [aCharacter = $x or: [aCharacter = $X]])
		ifTrue: [^self nextIntegerRadix: 16].
	stream skip: -1.
	^anInteger
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
completeNumber: anInteger at: start
	| number |
	stream atEnd ifTrue: [^anInteger].
	number := anInteger.
	number := self completeNumber: anInteger after: stream next.
	self checkNumberEnd: start.
	^number
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
digitFromChar: char base: radix
	| c |
	char isDigit ifTrue: [^char digitValue].
	char = $r ifTrue: [^nil].
	char = $x ifTrue: [^nil].
	char = $X ifTrue: [^nil].
	c := char asUppercase.
	(c asInteger between: $A asInteger and: $Z asInteger) ifFalse: [^nil].
	(c !!= $E and: [radix <= c digitValue]) ifTrue: [^nil].
	(c = $E and: [radix = 10]) ifTrue: [^nil].
	^c digitValue
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
endToken
	self error: 'end of stream' at: stream position
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
error: aString at: position
	error := aString -> position.
	return value: nil
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
negativeNumber
	| position |
	stream atEnd ifTrue: [^nil].
	stream peek isDigit ifFalse: [^nil].
	position := stream position.
	^self next key negated -> position
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
next
	| char |
	return isNil ifTrue: [return := [:value | ^value]].
	char := self nextChar.
	char isNil ifTrue: [^self endToken].
	char = $- ifTrue: [^self negativeNumber].
	char = $+ ifTrue: [^self positiveNumber].
	char isDigit ifTrue: [^self nextNumber: char].
	^nil
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextChar
	^stream skipWhitespace atEnd ifFalse: [stream next]
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextDigit: radix
	| char digit |
	stream atEnd ifTrue: [^nil].
	char := stream next.
	digit := self digitFromChar: char base: radix.
	digit isNil ifTrue: [
		stream skip: -1.
		^nil].
	radix <= digit
		ifTrue: [self error: 'digit greater than radix' at: stream position].
	^digit
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextExponent
	| negated exp |
	negated := false.
	(stream peekFor: $+) ifFalse: [negated := stream peekFor: $-].
	exp := self nextIntegerRadix: 10.
	negated ifTrue: [exp := exp negated].
	^exp
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextFloat: aNumber
	| base digit e exp |
	digit := self nextDigit: 10.
	digit isNil ifTrue: [
		stream skip: -1.
		^aNumber].
	e := 1.
	base := aNumber * 10 + digit.
	[
		digit := self nextDigit: 10.
		digit isNil]
		whileFalse: [
			base := base * 10 + digit.
			e := e + 1].
	((stream peekFor: $E) or: [stream peekFor: $e]) ifTrue: [
		exp := self nextExponent.
		^(base * (10 raisedToInteger: exp - e)) asFloat].
	(stream peekFor: $s) ifTrue: [^self nextScaledFrom: base fractionDigits: e].
	^(base * (10 raisedToInteger: e negated)) asFloat
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextIntegerRadix: radix
	| value valid digit |
	value := 0.
	valid := false.
	[
		digit := self nextDigit: radix.
		digit isNil]
		whileFalse: [
			valid := true.
			value := value * radix + digit].
	valid ifFalse: [self error: 'digit missing' at: stream position + 1].
	^value
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextNumber: aCharacter
	| start number digit |
	start := stream position.
	number := aCharacter digitValue.
	[
		digit := self nextDigit: 10.
		digit isNil]
		whileFalse: [number := number * 10 + digit].
	number := self completeNumber: number at: start.
	^number -> (start thru: stream position)
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextScaledFrom: aNumber fractionDigits: digits
	| scale denominator sd |
	scale := (stream atEnd not and: [stream peek isDigit])
		ifTrue: [self nextIntegerRadix: 10].
	denominator := 10 raisedToInteger: digits.
	sd := ScaledDecimal
		numerator: aNumber
		denominator: denominator
		scale: scale.
	^sd reduced
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
positiveNumber
	| position |
	stream peek isDigit ifFalse: [^nil].
	position := stream position.
	^self next key -> position
! !

!NumberParser methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
reset
	stream reset.
	return := nil
! !

!NumberParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
error
	^error
! !

!NumberParser methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
on: aString
	stream := aString readStream.
	return := nil
! !

!NumberParser methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nextValue
	^self next ifNil: [0] ifNotNil: [:assoc | assoc key]
! !

!ObjectReference methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
beAbsolute
	absolute := true
! !

!ObjectReference methodsFor: 'actions' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
classBinding
	^source classBinding
! !

!ObjectReference methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
for: anObject
	self target: anObject
! !

!ObjectReference methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	absolute := false
! !

!ObjectReference methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isAbsolute
	^absolute
! !

!ObjectReference methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isMethod
	^false
! !

!ObjectReference methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: 'Ref to ' , target printString
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
source: sourceObject
	source := sourceObject
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sourceOffset
	^sourceOffset
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sourceOffset: aNumber
	sourceOffset := aNumber
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
target
	^target
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
target: anObject
	target := anObject
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
targetOffset
	^0
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
valueToWriteAt: sourceAddress with: wordSize
	^self
		valueToWriteAt: sourceAddress
		targeting: target _asSmallInteger
		with: wordSize
! !

!ObjectReference methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
valueToWriteWith: wordSize
	^self valueToWriteAt: source _asSmallInteger + sourceOffset with: wordSize
! !

!ObjectReference methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
valueToWriteAt: sourceAddress targeting: targetAddress with: wordSize
	| address correction |
	address := targetAddress + self targetOffset.
	correction := absolute
		ifTrue: [0]
		ifFalse: [sourceAddress + sourceOffset + wordSize].
	^address - correction
! !

!ObjectReference class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
absoluteFor: anObject
	^(self new for: anObject) beAbsolute
! !

!SmalltalkSession methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
args
	^args
! !

!SmalltalkSession methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
args: anArray
	args := anArray
! !

!SmalltalkSession methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
finalizer
	^finalizer
! !

!SmalltalkSession methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
name
	^name
! !

!SmalltalkSession methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
resourceRegistry
	^resources
! !

!SmalltalkSession methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
username
	^username
! !

!SmalltalkSession methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
username: aString
	username := aString
! !

!SmalltalkSession methodsFor: 'startup/shutdown' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
closeExternalResources
	resources do: [:object | object sessionShutdown]
! !

!SmalltalkSession methodsFor: 'startup/shutdown' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
ephemeronsDo: aBlock
	resources ephemeronsDo: aBlock.
	finalizer ephemeronsDo: aBlock.
! !

!SmalltalkSession methodsFor: 'startup/shutdown' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
startUp
	self initializeFinalizationBlocks.
	resources do: [:object | object sessionStartup]
! !

!SmalltalkSession methodsFor: 'shutdown' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
exit: code
	[self shutdown] ensure: [Kernel host exit: code]
! !

!SmalltalkSession methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	super initialize.
	name := 'egg session'.
	finalizer := WeakIdentitySet new.
	resources := WeakIdentitySet new
! !

!SmalltalkSession methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeFinalizationBlocks
	finalizer finalizer: [:object | object finalize].
	resources finalizer: [:object | object finalize]
! !

!SmalltalkSession methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
rehashWeakRegistries
	resources rehash.
	finalizer rehash
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
add: anAssociation
	self ASSERT: Smalltalk !!== self.
	^globals add: anAssociation
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationAt: aSymbol
	^globals associationAt: aSymbol
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationAt: aSymbol ifAbsent: aBlock
	^globals associationAt: aSymbol ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationClass
	^globals associationClass
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
associationsDo: aBlock
	globals associationsDo: aBlock
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: aSymbol
	^globals at: aSymbol
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: aSymbol ifAbsent: aBlock
	^globals at: aSymbol ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: aSymbol ifAbsentPut: aBlock
	^self at: aSymbol ifAbsent: [self at: aSymbol put: aBlock value]
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
at: aSymbol put: anObject
	| key global |
	key := aSymbol asSymbol.
	global := globals at: key ifAbsent: nil.
	global isClass ifTrue: [
		anObject == global ifTrue: [^self].
		global symbol == key
			ifTrue: [^self error: 'Overriding classes is not allowed']].
	globals at: key put: anObject.
	self justDefined: aSymbol.
	^anObject
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
classNamed: aString
	| name tag meta global |
	name := aString.
	tag := ' class'.
	meta := aString endsWith: tag.
	meta ifTrue: [name := name allButLast: tag size].
	global := self at: name asSymbol ifAbsent: [^nil].
	^global isSpecies ifTrue: [meta ifTrue: [global class] ifFalse: [global]]
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
eventDispatcher
	^eventDispatcher
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
eventDispatcher: anEventDispatcher
	eventDispatcher := anEventDispatcher
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
finalizer
	^finalizer
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
globals
	^globals
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
globals: aNamespace
	globals := aNamespace
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hasDebugger
	^false
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keyAtValue: anObject
	^globals keyAtValue: anObject
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
keys
	^globals keys
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
messageQueue
	^eventDispatcher messageQueue
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nameOfGlobal: anObject
	^globals keyAtValue: anObject
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nativizer
	^nativizer
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nativizer: anObject
	nativizer := anObject
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
processAllMessages
	eventDispatcher processAllMessages
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
register: aSet for: aClass
	registeredEvents at: aClass put: aSet
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
registeredEventsFor: aClass
	^registeredEvents at: aClass ifAbsent: nil
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeClass: aClass
	aClass isDeleted ifTrue: [^self].
	self devenv forgetClass: aClass.
	globals basicRemoveKey: aClass symbol ifAbsent: nil.
	aClass class superclass isNil
		ifFalse: [aClass class superclass removeSubclass: aClass class].
	aClass superclass isNil ifFalse: [aClass superclass removeSubclass: aClass].
	aClass beDeleted
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeKey: aSymbol from: aMethodDictionary ifAbsent: aBlock
	| cm |
	cm := aMethodDictionary at: aSymbol ifAbsent: [^aBlock value].
	self devenv forgetMethod: cm.
	^aMethodDictionary basicRemoveKey: aSymbol asSymbol ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
transcript
	^globals at: #Transcript
! !

!SmalltalkSystem methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
version
	^'0.1.1'
! !

!SmalltalkSystem methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAdd: anAssociation
	globals basicAdd: anAssociation.
	self justDefined: anAssociation key.
	^anAssociation
! !

!SmalltalkSystem methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicAt: aSymbol put: anObject
	| assoc |
	assoc := Association key: aSymbol value: anObject.
	self basicAdd: assoc.
	^anObject
! !

!SmalltalkSystem methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicRemoveKey: key ifAbsent: aBlock
	^globals removeKey: key ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeKey: key
	^globals removeKey: key
! !

!SmalltalkSystem methodsFor: 'removing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeKey: aSymbol ifAbsent: aBlock
	| selector global |
	selector := aSymbol asSymbol.
	global := globals at: selector ifAbsent: [^aBlock value].
	(global isClass and: [global symbol == selector]) ifTrue: [
		global allInstances notEmpty
			ifTrue: [^self error: 'The class being removed still has instances'].
		global delete.
		^selector].
	^globals basicRemoveKey: selector ifAbsent: aBlock
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
beep
	^self operatingSystem beep
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bindEventTable: aDictionary to: anObject
	aDictionary isNil
		ifTrue: [eventHandlers removeKey: anObject ifAbsent: []]
		ifFalse: [eventHandlers at: anObject put: aDictionary]
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
collectGarbage
	memory forceCompact
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
eventTableFor: anObject
	^eventHandlers at: anObject ifAbsent: nil
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
flushNativizedSends
	ImageSegment bound do: [:s | 
		s overriddenMethods ifNotNil: [:overridden | 
			overridden
				do: [:m | m isNativized ifTrue: [m currentVersion prepareForExecution]];
				do: [:m | SendSite flush: m selector]]].
	SendSite flush
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
flushOverriddenSends
	ImageSegment bound do: [:s | s flushOverriddenSends].
	SendSite flush
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
ignoreHalts: aBoolean
	Halt ignoreSignals: aBoolean.
	AssertionFailure ignoreSignals: aBoolean
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
ignoreOSMessagesWhile: aBlock
	^eventDispatcher isNil
		ifTrue: [aBlock value]
		ifFalse: [aBlock evaluateAtomically]
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveNamed: aString
	^NamedPrimitives at: aString ifAbsent: nil
! !

!SmalltalkSystem methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
showBacktraceOf: aProcess label: aString
	| writer logger |
	writer := '' writeStream.
	aProcess
		backtraceOn: writer
		maxLevels: 100
		stopWhen: [:cm | cm isDoit]
		filtered: false
		arguments: false.
	logger := self at: #Transcript ifAbsent: nil.
	logger isNil
		ifTrue: [session logError: writer contents]
		ifFalse: [logger nextPutAll: aString; cr; nextPutAll: writer contents].
	aProcess isResumable ifTrue: [aProcess performDeferred: #resume]
! !

!SmalltalkSystem methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
canOpenBacktrace
	^true
! !

!SmalltalkSystem methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hasDebuggerTool
	^false
! !

!SmalltalkSystem methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
includes: anObject
	^globals includes: anObject
! !

!SmalltalkSystem methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
includesKey: aSymbol
	^globals includesKey: aSymbol
! !

!SmalltalkSystem methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isBee
	^true
! !

!SmalltalkSystem methodsFor: 'startup/shutdown' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
exit
	session exit
! !

!SmalltalkSystem methodsFor: 'startup/shutdown' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
startUp
	session startUp.
	self ephemeronsDo: [:e | e activate].
	Float startUp.
	memory startUp.
	"platform startUp."
! !

!SmalltalkSystem methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	eventHandlers := WeakIdentityDictionary new.
	registeredEvents := WeakIdentityDictionary new
! !

!SmalltalkSystem methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
rehashWeakRegistries
	eventHandlers rehash.
	registeredEvents rehash
! !

!SmalltalkSystem methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printOn: aStream
	self == Smalltalk
		ifTrue: [aStream nextPutAll: 'Smalltalk']
		ifFalse: [super printOn: aStream]
! !

!SmalltalkSystem methodsFor: 'updating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
renameClass: aClass to: aSymbol
	| symbol token assoc |
	symbol := aSymbol asSymbol.
	(globals includesKey: symbol)
		ifTrue: [self error: 'the global ' , symbol , ' already exists'].
	token := aClass symbol.
	assoc := globals associationAt: token.
	globals basicRemoveKey: token ifAbsent: nil.
	assoc key: symbol.
	globals basicAdd: assoc.
	aClass name: symbol
! !

!SmalltalkSystem methodsFor: 'binding libraries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
segmentLoaded: anImageSegment
	
! !

!SmalltalkSystem methodsFor: 'binding libraries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
segmentUnloaded: anImageSegment
	
! !

!SmalltalkSystem methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
select: aBlock thenDo: anotherBlock
	globals select: aBlock thenDo: anotherBlock
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_instancesAreArrayed
	^format & Variable = Variable
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_instancesAreFixed
	^format & Variable = 0
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_instancesHavePointers
	^format & Pointers !!= 0
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
canUnderstand: aSymbol
	^instanceBehavior implements: aSymbol
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
includesSelector: aSymbol
	^self methodDictionary includesKey: aSymbol
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instancesAreArrayed
	^self _instancesAreArrayed
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instancesHavePointers
	^self _instancesHavePointers
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isBytes
	^self _instancesHavePointers not
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isCategorized
	^self organization notNil
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isSpecies
	^true
! !

!Species methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isVariable
	^self _instancesAreArrayed
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
>> aSelector
	^self compiledMethodAt: aSelector
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
classVariableAssociationAt: aString
	| c assoc |
	c := self.
	[
		c isNil ifTrue: [^nil].
		c classVariables notNil and: [
			assoc := c classVariables associationAt: aString ifAbsent: nil.
			assoc notNil]]
		whileFalse: [c := c superclass].
	^assoc
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
classVariableString
	| stream |
	stream := '' writeStream.
	self classVarNames asSortedCollection
		do: [:cvar | stream nextPutAll: cvar]
		separatedBy: [stream space].
	^stream contents
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
compiledMethodAt: aSymbol
	^self methodDictionary at: aSymbol ifAbsent: nil
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
fillFrom: aClass
	| ivars |
	self == aClass ifTrue: [^self].
	format := aClass format.
	ivars := aClass instVarNames.
	instanceVariables := ivars notEmpty ifTrue: [ivars]
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
format
	^format
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
format: anInteger
	format := anInteger
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instVarNames: aCollection
	instanceVariables := aCollection isEmpty 
		ifFalse: [
			self isBytes ifTrue: [^self error: 'byte objects cannot have named instance variables'].
			aCollection asArray].
	self updateInstSize; allSubspeciesDo: [:class | class updateInstSize]
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instanceBehavior
	^instanceBehavior
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
methodDictionary
	^instanceBehavior methods
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
selectors
	^self methodDictionary keys
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
superclass
	^superclass
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
superclass: aClass
	superclass := aClass
! !

!Species methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
timestamp
	^organization notNil ifTrue: [organization timestamp]
! !

!Species methodsFor: 'add/remove' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addSelector: aSymbol withMethod: aCompiledMethod
	| selector |
	selector := aSymbol asSymbol.
	self methodDictionary at: selector put: aCompiledMethod.
	self organization notNil ifTrue: [self organization classify: selector]
! !

!Species methodsFor: 'add/remove' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeSelector: aSymbol
	self methodDictionary removeKey: aSymbol ifAbsent: [].
	self organization notNil ifTrue: [self organization remove: aSymbol]
! !

!Species methodsFor: 'add/remove' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
removeSubclass: aClass
	"
	do nothing
	"
	
! !

!Species methodsFor: 'hierarchy' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addSubclass: aClass
	| copy |
	(self subclasses includes: aClass) ifTrue: [^self].
	copy := self subclasses copyWith: aClass.
	self subclasses: copy.
	aClass superclass: self
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allClassVarNames
	^(self withAllSuperclasses reversed gather: [:cls | cls classVarNames]) asArray
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allInstVarNames
	^(self withAllSuperclasses reversed gather: [:class | class instVarNames]) asArray
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allSubclasses
	| all |
	all := OrderedCollection new.
	self allSubclassesDo: [:cls | all add: cls].
	^all
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allSubclassesDo: aBlock
	self subclassesDo: [:class | 
		aBlock value: class.
		class allSubclassesDo: aBlock]
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allSubinstances
	| subinstances |
	subinstances := OrderedCollection new.
	[
		self
			withAllSubclassesDo: [:cls | subinstances
				addAll: cls allExistingInstances]]
		evaluateAtomically.
	^subinstances asArray
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allSubspecies
	| all |
	all := OrderedCollection new.
	self allSubspeciesDo: [:cls | all add: cls].
	^all
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allSubspeciesDo: aBlock
	self subspeciesDo: [:class | 
		aBlock value: class.
		class allSubspeciesDo: aBlock]
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allSuperclasses
	| superclasses |
	superclasses := OrderedCollection new.
	self allSuperclassesDo: [:s | superclasses add: s].
	^superclasses
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allSuperclassesDo: aBlock
	superclass isNil ifTrue: [^self].
	aBlock value: superclass.
	superclass allSuperclassesDo: aBlock
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
methodsReadingInstVar: aString
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm usesInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
methodsReferencingClassVar: aString
	| methods assoc |
	methods := OrderedCollection new.
	assoc := self classVariableAssociationAt: aString.
	assoc isNil ifTrue: [^methods].
	self instanceClass methodDictionary
		& self instanceClass class methodDictionary
		select: [:cm | cm referencesAssociation: assoc]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
methodsReferencingInstVar: aString
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm referencesInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
methodsWritingInstVar: aString
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm assignsInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
selectorsInCategory: aSymbol
	^self organization selectorsFor: aSymbol
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
withAllSubclasses
	^OrderedCollection with: self withAll: self allSubclasses
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
withAllSubspecies
	^OrderedCollection with: self withAll: self allSubspecies
! !

!Species methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
withAllSuperclasses
	^OrderedCollection with: self withAll: self allSuperclasses
! !

!Species methodsFor: 'instances' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allInstances
	^Kernel memory allInstancesOf: self
! !

!Species methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicNew
	^self errorVMSpecific
! !

!Species methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicNew: anInteger
	^self errorVMSpecific
! !

!Species methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new
	^self errorVMSpecific
! !

!Species methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger
	^self errorVMSpecific
! !

!Species methodsFor: 'flags' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
bePointers
	format := Pointers + self instSize
! !

!Species methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
browse
	Smalltalk browsingTools browse: self
! !

!Species methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
buildBehavior
	| behavior |
	behavior := Behavior with: self methodDictionary copy.
	superclass ifNotNil: [behavior next: superclass instanceBehavior].
	instanceBehavior := behavior
! !

!Species methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instVarNames
	instanceVariables isNil ifTrue: [^#()].
	instanceVariables isArray ifTrue: [^instanceVariables].
	^instanceVariables substrings
! !

!Species methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instanceVariableString
	^String streamContents: [:strm | 
		self instVarNames
			do: [:ivar | strm nextPutAll: ivar]
			separatedBy: [strm space]]
! !

!Species methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
kindOfSubclass
	self _instancesAreFixed ifTrue: [^'subclass:'].
	self isBytes ifTrue: [^'variableByteSubclass:'].
	self _instancesHavePointers ifTrue: [^'variableSubclass:'].
	self error: 'invalid type of subclass'
! !

!Species methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
updateClassifications
	organization notNil ifTrue: [organization updateOn: self]
! !

!Species methodsFor: 'organization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
categories
	^self organization notNil
		ifTrue: [self organization categoriesOn: self]
		ifFalse: [#()]
! !

!Species methodsFor: 'organization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
categorizedSelectors
	^self organization notNil
		ifTrue: [self organization allSelectors]
		ifFalse: [#()]
! !

!Species methodsFor: 'organization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
hasUnclassifiedSelectors
	^self categorizedSelectors size < self methodDictionary size
! !

!Species methodsFor: 'organization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
organization
	organization isNil ifTrue: [self initializeOrganization].
	^organization
! !

!Species methodsFor: 'organization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
organization: aClassOrganizer
	organization := aClassOrganizer
! !

!Species methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
categoryFor: selector
	| category |
	self organization notNil ifTrue: [
		category := self organization categoryFor: selector.
		category notNil ifTrue: [^category]].
	^ClassOrganizer default
! !

!Species methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
classImplementing: aSymbol
	(self methodDictionary includesKey: aSymbol) ifTrue: [^self].
	^self allSuperclasses
		detect: [:class | class includesSelector: aSymbol]
		ifNone: []
! !

!Species methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
depth
	"
	Object depth
	SmallInteger depth 4
	"
	| depth ancestor |
	depth := 0.
	ancestor := self superclass.
	ancestor notNil ifTrue: [depth := ancestor depth + 1].
	^depth
! !

!Species methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
inheritsFrom: aClass
	| class |
	class := self.
	[class == nil] whileFalse: [
		class == aClass ifTrue: [^true].
		class := class superclass].
	^false
! !

!Species methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instSize
	^format & 16r7F
! !

!Species methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
shouldBeHidden: aSymbol
	^false
! !

!Species methodsFor: 'copying' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
deepCopy
	^self
! !

!Species methodsFor: 'copying' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
shallowCopy
	^self
! !

!Species methodsFor: 'errors' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
errorNotIndexable
	^self error: 'Instances of ' , self name , ' are not indexable'
! !

!Species methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeOrganization
	self
		organization: (ClassOrganizer new classifyAll: self selectors under: nil)
! !

!Species methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
instanceBehavior: aBehavior
	instanceBehavior := aBehavior
! !

!Species methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
updateInstSize
	| size |
	size := superclass isNil ifTrue: [0] ifFalse: [superclass instSize].
	format := format - self instSize + size + self instVarNames size
! !

!Species methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveNewBytes: size
	^self errorVMSpecific
! !

!Species methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printOn: aStream
	aStream nextPutAll: self name
! !

!Species methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
withAllSubclassesDo: aBlock
	aBlock evaluateWith: self.
	self allSubclassesDo: aBlock
! !

!Species methodsFor: 'enumerating' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
withAllSuperclassesDo: aBlock
	aBlock evaluateWith: self.
	self allSuperclassesDo: aBlock
! !

!Species class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeFormatFlags
	Flags := self addNamespace.
	Flags
		at: #Variable put: 16r2000;
		at: #Pointers put: 16r4000
! !

!Species class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
maxInstVarCount
	^16r7F
! !

!StarToken methodsFor: 'double dispatching' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchFirstAfterStartOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstStar
! !

!StarToken methodsFor: 'double dispatching' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchFirstOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstStar
! !

!StarToken methodsFor: 'double dispatching' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matchLastOn: aMatchAlgorithm
	"
	do nothing
	"
	
! !

!StarToken methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printOn: aStream
	aStream nextPut: $*
! !

!StarToken class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
current
	^current
! !

!StarToken class methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeCurrent
	current := self new
! !

!StringPattern methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addStar
	stream atEnd ifTrue: [^self].
	tokens add: StarToken current.
	stream next.
	[stream peek ifNil: [^self] ifNotNil: [:c | c isAsterisk]]
		whileTrue: [stream next]
! !

!StringPattern methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
addToken
	| star pos end token |
	star := false.
	pos := stream position + 1.
	[stream atEnd or: [star := stream next isAsterisk]] whileFalse.
	star ifTrue: [stream skip: -1].
	end := stream position.
	pos <= end ifTrue: [
		token := MatchToken on: stream collection from: pos to: end.
		tokens add: token]
! !

!StringPattern methodsFor: 'scanning' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
scan
	[stream atEnd] whileFalse: [self addToken; addStar]
! !

!StringPattern methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
input
	^stream contents
! !

!StringPattern methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
on: aString
	stream := aString readStream.
	tokens := OrderedCollection new.
	self scan
! !

!StringPattern methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
tokens
	^tokens copy
! !

!StringPattern methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
match: aString
	^self match: aString index: 1
! !

!StringPattern methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
match: aString ifAbsent: aBlock
	^self match: aString index: 1 ifAbsent: aBlock
! !

!StringPattern methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
match: aString index: anInteger
	^self match: aString index: anInteger ifAbsent: nil
! !

!StringPattern methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
match: aString index: anInteger ifAbsent: aBlock
	| algorithm |
	algorithm := MatchAlgorithm new
		pattern: self;
		string: aString;
		index: anInteger.
	algorithm run.
	algorithm hasMatched ifTrue: [^algorithm matchRange].
	^aBlock notNil ifTrue: [
		aBlock arity = 0
			ifTrue: [aBlock value]
			ifFalse: [aBlock evaluateWith: algorithm failure]]
! !

!StringPattern methodsFor: 'inquiries' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
matches: aString
	| range |
	range := self match: aString.
	^range notNil and: [range x = 1 and: [range y = aString size]]
! !

!StringPattern methodsFor: 'printing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
printOn: aStream
	tokens do: [:t | t printOn: aStream]
! !

!StringPattern class methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
on: aString
	^self new on: aString
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
characterIndexOf: aString at: anInteger
	| index s |
	index := 0.
	s := 0.
	[s < anInteger] whileTrue: [| ch len |
		index := index + 1.
		ch := aString at: index.
		len := self sizeOfCharacter: ch.
		s := s + len].
	^index
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeStringFrom: aStream
	^self
		decodeStringFrom: aStream
		length: aStream size // self minBytesPerChar
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeStringFrom: aStream length: anInteger
	| string |
	string := String new: anInteger.
	^self decodeStringFrom: aStream on: string
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeStringFrom: aStream on: buffer
	| bytes code string index n |
	bytes := true.
	index := 0.
	code := nil.
	string := buffer.
	n := string size.
	[aStream atEnd or: [code = 0] or: [index >= n]] whileFalse: [
		code := self decodeFrom: aStream.
		(bytes andNot: [Ansi isAnsi: code]) ifTrue: [
			bytes := false.
			string := string asWideString].
		code = 0 ifFalse: [
			index := index + 1.
			string at: index putCode: code]].
	^index < string size ifTrue: [string copyTo: index] ifFalse: [string]
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
externalCopyOf: aString
	| bytes |
	aString isNil ifTrue: [^nil].
	bytes := self parameterFrom: aString.
	^bytes externalCopy
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexesOf: aString from: start to: end
	"
	UTF16 current indexesOf: (WideString with: $𝑎 with: $_ with: $𝑎 with: $→) from: 2 to: 3
	"
	| s e |
	s := 1.
	1 to: start - 1 do: [:i | | ch len |
		ch := aString at: i.
		len := self sizeOfCharacter: ch.
		s := s + len].
	e := s - 1.
	start to: end do: [:i | | ch len |
		ch := aString at: i.
		len := self sizeOfCharacter: ch.
		e := e + len].
	^s thru: e
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isString: s1 greaterThan: s2
	^(self compareStringiW: s1 with: s2) > 0
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isString: s1 greaterThanOrEqualTo: s2
	^(self compareStringiW: s1 with: s2) >= 0
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isString: s1 lessThan: s2
	^(self compareStringiW: s1 with: s2) < 0
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isString: s1 lessThanOrEqualTo: s2
	^(self compareStringiW: s1 with: s2) <= 0
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lowercaseOf: aString
	^UTF16 current lowercaseOf: aString
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeInBytesOf: aString
	| size |
	size := self sizeOfCharacter: Character null.
	1 to: aString size do: [:i | | ch s |
		ch := aString at: i.
		s := self sizeOfCharacter: ch.
		size := size + s].
	^size
! !

!Unicode methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
uppercaseOf: aString
	^UTF16 current uppercaseOf: aString
! !

!Unicode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
compareStringiW: aString1 with: aString2
	^UTF16 current compareStringiW: aString1 with: aString2
! !

!Unicode methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
minBytesPerChar
	^1
! !

!Unicode methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decode: aByteArray
	^self decodeStringFrom: aByteArray readStream
! !

!Unicode methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeFrom: aStream
	self subclassResponsibility
! !

!Unicode methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encode: aString
	^ByteArray
		streamContents: [:strm | aString do: [:ch | self encode: ch on: strm]]
! !

!Unicode methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encode: aCharacter on: aStream
	self subclassResponsibility
! !

!Unicode class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decode: aByteArray
	^self current decode: aByteArray
! !

!Unicode class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeBytes: aByteArray
	| decoder stream |
	stream := aByteArray readStream.
	decoder := self decoderFor: stream.
	^decoder decode: stream upToEnd
! !

!Unicode class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeFromAddress: externalAddress length: anInteger
	^self current
		decodeStringFrom: externalAddress readStream
		length: anInteger
! !

!Unicode class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decoderFor: aStream
	(aStream peekForAll: UTF32 prefix) ifTrue: [^UTF32].
	(aStream peekForAll: UTF16 prefix) ifTrue: [^UTF16].
	^UTF8
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
characterIndexOf: aString at: anInteger
	(self isDBS: aString upTo: anInteger - 1) ifTrue: [^anInteger].
	^super characterIndexOf: aString at: anInteger * 2
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
characterIndexesOf: aString from: start to: end
	"
	UTF16 current characterIndexesOf: '𝑎𝑎𝑎x' from: 3 to: 5
	"
	| i e s max n |
	aString isWideString ifFalse: [^start thru: end].
	s := i := self characterIndexOf: aString at: start.
	n := aString size.
	max := end * 2.
	e := start * 2.
	[i < n and: [e <= max]] whileTrue: [| ch len |
		i := i + 1.
		ch := aString at: i.
		len := self sizeOfCharacter: ch.
		e := e + len].
	^s thru: i - 1
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
indexesOf: aString from: start to: end
	| e stretch delta |
	e := start - 1 max: end - 1.
	(self isDBS: aString upTo: e) ifTrue: [
		delta := end > 0
			ifTrue: [self sizeOfCharacter: (aString at: end)]
			ifFalse: [0].
		^start thru: end - 1 + (delta // 2)].
	stretch := super indexesOf: aString from: start to: end.
	^stretch + 1 // 2
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isDBS: aString
	^self isDBS: aString upTo: aString size
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
isDBS: aString upTo: anInteger
	aString isWide ifFalse: [^true].
	2
		to: anInteger * 4
		by: 4
		do: [:i | (aString uShortAtOffset: i) = 0 ifFalse: [^false]].
	^true
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lengthOf: aString
	^(self encode: aString) size // 2
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
parameterFrom: aString
	| strm |
	strm := (ByteArray new: aString size + 1 * 2) writeStream.
	aString isCharacter
		ifTrue: [self encode: aString on: strm]
		ifFalse: [aString do: [:char | self encode: char on: strm]].
	strm nextPut: 0; nextPut: 0.
	^strm contents
! !

!UTF16 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeInBytesOf: aString
	aString isWideString ifFalse: [^aString size + 1 * 2].
	^super sizeInBytesOf: aString
! !

!UTF16 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeFrom: aStream
	| b1 b2 hi b3 b4 lo |
	b1 := aStream nextByte.
	b2 := aStream nextByte.
	hi := b1 + (b2 bitShift: 8).
	b2 < 16rD8 ifTrue: [^hi].
	hi := hi - 16rD800.
	hi < 16r400 ifFalse: [^b2 * 256 + b1].
	hi := (hi bitShift: 10) + 16r10000.
	b3 := aStream nextByte.
	b4 := aStream nextByte.
	lo := (b4 bitShift: 8) - 16rDC00 + b3.
	^hi + lo
! !

!UTF16 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encode: aCharacter on: aStream
	| code c20 hi lo |
	code := aCharacter codePoint.
	code < 128 ifTrue: [
		aStream nextPut: code; nextPut: 0.
		^self].
	code < 16rD800 ifTrue: [
		aStream
			nextPut: (code bitAnd: 16rFF);
			nextPut: (code bitShift: -8).
		^self].
	code < 16rE000 ifTrue: [self error: 'invalid code point'].
	code < 16r10000 ifTrue: [
		aStream
			nextPut: (code bitAnd: 16rFF);
			nextPut: (code bitShift: -8).
		^self].
	code < 16r110000 ifTrue: [
		c20 := code - 16r10000.
		hi := (c20 bitShift: -10) + 16rD800.
		lo := (c20 bitAnd: 16r3FF) + 16rDC00.
		aStream
			nextPut: (hi bitAnd: 16rFF);
			nextPut: (hi bitShift: -8);
			nextPut: (lo bitAnd: 16rFF);
			nextPut: (lo bitShift: -8).
		^self].
	self error: 'invalid code point'
! !

!UTF16 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeOfCharacter: aCharacter
	^aCharacter codePoint < 16r10000 ifTrue: [2] ifFalse: [4]
! !

!UTF16 methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
minBytesPerChar
	^2
! !

!UTF16 class methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeFromAddress: externalAddress length: anInteger
	| stream |
	stream := externalAddress readStream readLimit: anInteger * 2.
	^self current decodeStringFrom: stream length: anInteger
! !

!UTF16 class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
prefix
	^#[16rFE 16rFF]
! !

!UTF32 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decode: aByteArray
	^WideString newFrom: aByteArray
! !

!UTF32 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encode: aCharacter on: aStream
	aStream nextULongPut: aCharacter codePoint
! !

!UTF32 class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
prefix
	^#[16rFE 16rFF 0 0]
! !

!UTF8 methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
accepts: aByteArray
	| stream |
	stream := aByteArray readStream.
	[stream atEnd] whileFalse: [| s |
		s := self sizeOfEncoding: stream next.
		s = 0 ifTrue: [^false].
		s - 1 timesRepeat: [
			stream atEnd ifTrue: [^false].
			(stream next bitAnd: 0xC0) = 0x80 ifFalse: [^false]]].
	^true
! !

!UTF8 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decode: aByteArray
	aByteArray isExternalMemory
		ifTrue: [^self class decodeMemory: aByteArray length: aByteArray length].
	1
		to: aByteArray size
		do: [:i | (aByteArray at: i) asInteger > 127
			ifTrue: [^super decode: aByteArray]].
	^aByteArray asString
! !

!UTF8 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeFrom: aStream
	| b1 flags count bytes b2 b3 b4 |
	b1 := aStream nextByte.
	b1 < 128 ifTrue: [^b1].
	flags := b1 bitAnd: 16rF8.
	count := self trailing: flags.
	count isNil ifTrue: [^b1].
	bytes := aStream peek: count.
	bytes size < count ifTrue: [^b1].
	1
		to: count
		do: [:i | ((bytes byteAt: i) bitAnd: 16rC0) = 16r80 ifFalse: [^b1]].
	aStream skip: count.
	count = 1 ifTrue: [
		b2 := bytes byteAt: 1.
		b1 := b1 bitAnd: 16r1F.
		^(b1 bitShift: 6) + (b2 bitAnd: 16r3F)].
	count = 2 ifTrue: [
		b2 := (bytes byteAt: 1) bitAnd: 16r3F.
		b3 := (bytes byteAt: 2) bitAnd: 16r3F.
		b1 := b1 bitAnd: 16rF.
		^(b1 bitShift: 12) + (b2 bitShift: 6) + b3].
	b2 := (bytes byteAt: 1) bitAnd: 16r3F.
	b3 := (bytes byteAt: 2) bitAnd: 16r3F.
	b4 := (bytes byteAt: 3) bitAnd: 16r3F.
	b1 := b1 bitAnd: 7.
	^(b1 bitShift: 18) + (b2 bitShift: 12) + (b3 bitShift: 6) + b4
! !

!UTF8 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encode: aString
	aString class = String ifTrue: [
		1
			to: aString size
			do: [:i | (aString codeAt: i) < 128 ifFalse: [^super encode: aString]].
		^aString asByteArray].
	^super encode: aString
! !

!UTF8 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encode: aCharacter on: aStream
	| code b1 b2 b3 b4 |
	code := aCharacter codePoint.
	code < 128 ifTrue: [
		aStream nextBytePut: code.
		^self].
	code < 16r800 ifTrue: [
		b1 := code bitShift: -6.
		b1 := b1 bitOr: 16rC0.
		b2 := code bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		aStream nextBytePut: b1; nextBytePut: b2.
		^self].
	code < 16r10000 ifTrue: [
		b1 := code bitShift: -12.
		b1 := b1 bitOr: 16rE0.
		b2 := code bitShift: -6.
		b2 := b2 bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		b3 := code bitAnd: 16r3F.
		b3 := b3 bitOr: 16r80.
		aStream
			nextBytePut: b1;
			nextBytePut: b2;
			nextBytePut: b3.
		^self].
	b1 := code bitShift: -18.
	b1 := b1 bitOr: 16rF0.
	b2 := code bitShift: -12.
	b2 := b2 bitAnd: 16r3F.
	b2 := b2 bitOr: 16r80.
	b3 := code bitShift: -6.
	b3 := b3 bitAnd: 16r3F.
	b3 := b3 bitOr: 16r80.
	b4 := code bitAnd: 16r3F.
	b4 := b4 bitOr: 16r80.
	aStream
		nextBytePut: b1;
		nextBytePut: b2;
		nextBytePut: b3;
		nextBytePut: b4
! !

!UTF8 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encodeCharacter: aCharacter
	| code b1 b2 b3 b4 |
	code := aCharacter codePoint.
	code < 128 ifTrue: [^ByteArray with: code].
	code < 16r800 ifTrue: [
		b1 := code bitShift: -6.
		b1 := b1 bitOr: 16rC0.
		b2 := code bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		^ByteArray with: b1 with: b2].
	code < 16r10000 ifTrue: [
		b1 := code bitShift: -12.
		b1 := b1 bitOr: 16rE0.
		b2 := code bitShift: -6.
		b2 := b2 bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		b3 := code bitAnd: 16r3F.
		b3 := b3 bitOr: 16r80.
		^ByteArray with: b1 with: b2 with: b3].
	b1 := code bitShift: -18.
	b1 := b1 bitOr: 16rF0.
	b2 := code bitShift: -12.
	b2 := b2 bitAnd: 16r3F.
	b2 := b2 bitOr: 16r80.
	b3 := code bitShift: -6.
	b3 := b3 bitAnd: 16r3F.
	b3 := b3 bitOr: 16r80.
	b4 := code bitAnd: 16r3F.
	b4 := b4 bitOr: 16r80.
	^ByteArray with: b1 with: b2 with: b3 with: b4
! !

!UTF8 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeOfCharacter: aCharacter
	| code |
	code := aCharacter codePoint.
	code < 128 ifTrue: [^1].
	code < 16r800 ifTrue: [^2].
	code < 16r10000 ifTrue: [^3].
	^4
! !

!UTF8 methodsFor: 'encoding / decoding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
sizeOfEncoding: code
	code < 0x80 ifTrue: [^1].
	code < 0xC0 ifTrue: [^0].
	code < 0xE0 ifTrue: [^2].
	code < 0xF0 ifTrue: [^3].
	code < 0xF8 ifTrue: [^4].
	^0
! !

!UTF8 methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
parameterFrom: aString
	| strm |
	strm := (ByteArray new: aString size + 1) writeStream.
	aString isCharacter
		ifTrue: [self encode: aString on: strm]
		ifFalse: [aString do: [:char | self encode: char on: strm]].
	strm nextPut: 0.
	^strm contents
! !

!UTF8 methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
trailing: byte
	(byte bitAnd: 2r11100000) = 2r11000000 ifTrue: [^1].
	(byte bitAnd: 2r11110000) = 2r11100000 ifTrue: [^2].
	(byte bitAnd: 2r11111000) = 2r11110000 ifTrue: [^3].
	^nil
! !

!UTF8 class methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
accepts: aByteArray
	^self current accepts: aByteArray
! !

!UTF8 class methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
decodeMemory: anExternalMemory length: anInteger
	^Smalltalk os utf8ToWide: anExternalMemory length: anInteger
! !

!UTF8 class methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
encodeMemory: anExternalMemory length: anInteger
	"
	UTF8 encodeMemory: '→' externalCopy length: 2
	"
	Smalltalk os wideToUtf8: anExternalMemory length: anInteger
! !

!UTF8 class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
prefix
	^#[16rEF 16rBB 16rBF]
! !

!ModuleLoader methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
loadModuleNamed: aString
	| classes moduleName moduleSpec moduleClass |
	spec := self readModuleSpecNamed: aString.
	classes := self classesSortedBySuperclass: spec classes.
	moduleName := ('.' split: spec name) last asSymbol.
	moduleSpec := spec classes detect: [:cls | cls name = (moduleName , #Module)] ifNone: nil.
	moduleSpec ifNil: [ moduleSpec := spec classes detect: [:cls | cls name = (#Module , moduleName)] ifNone: nil].
	moduleSpec
		ifNil: [
			moduleClass := Module.]
		ifNotNil: [ 
			moduleClass := self createNewClassFrom: moduleSpec in: nil.
			classes remove: moduleSpec ].
	module := self createNewModule: moduleClass.
	module name isEmpty ifTrue: [ module name: moduleName asString ].
	classes do: [:c | self createNewClassFrom: c in: module ].
	spec extendedClasses do: [:c | self createExtensionMethodsOf: c ].
	module justLoaded.
	Kernel loadedModules at: module name asSymbol put: module.
	^ module
! !

!ModuleLoader methodsFor: 'loading' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
readModuleSpecNamed: aString
	| reader |
	reader := ModuleSpecReader new.
	reader path: '../../modules/', aString.
	^reader read
! !

!ModuleLoader methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
classesSortedBySuperclass: anArray
	| result seen s dfs |
	result := OrderedCollection new.
	seen := IdentitySet new.
	dfs := [ :class | 
	       s := class superclass.
	       ((anArray includes: s) andNot: [ seen includes: s ]) ifTrue: [ 
		       dfs value: s ].	
	       result add: class.
	       seen add: class ].
	anArray do: [ :class | (seen includes: class) ifFalse: [ dfs value: class ] ].
	self ASSERT: result asSet = anArray asSet.
	^ result
! !

!ModuleLoader methodsFor: 'creating' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
createExtensionMethodsOf: aClassSpec
	| class metaclass |
	class := module namespace at: aClassSpec name asSymbol.
	metaclass := class behavior classBinding.
	aClassSpec methods do: [ :m | | cm |
		 cm := self createNewMethod: m in: class.
		module ifNotNil: [ module addExtension: cm ] ].
	aClassSpec metaclass methods do: [ :m | | cm | 
		cm := self createNewMethod: m in: metaclass.
		module ifNotNil: [ module addExtension: cm ] ].
	^ module
! !

!ModuleLoader methodsFor: 'creating' stamp: 'KenD 1/Jul/2026, 7:43:23 pm (UTC)'!
createNewClassFrom: aClassSpec in: aModule
	| superclass metaclass class |
	superclass := (aModule ifNil: [ Kernel ]) namespace at: aClassSpec supername asSymbol.
	class := Class newSubclassOf: superclass.
	metaclass := class class.
	class name: aClassSpec name; instVarNames: aClassSpec instVarNames; classVarNames: aClassSpec classVarNames.
	aClassSpec methods do: [ :m | self createNewMethod: m in: class ].
	aClassSpec metaclass methods do: [ :m | self createNewMethod: m in: metaclass ].
	aModule ifNotNil: [
		aModule addClass: class.
		class module: aModule].
	^ class
! !

!ModuleLoader methodsFor: 'creating' stamp: 'KenD 28/Jun/2026, 8:27:37 pm (UTC)'!
createNewMethod: aMethodSpec in: aSpecies
	| method selector |
	method := SCompiler new compile: aMethodSpec sourceCode.
	selector := method selector.
	method classBinding: aSpecies.
	aSpecies methodDictionary at: selector put: method.
	aSpecies organization classify: selector under: method category.
	^method
! !

!ModuleLoader methodsFor: 'creating' stamp: 'KenD 1/Jul/2026, 7:43:47 pm (UTC)'!
createNewModule: aClass
	| aModule |
	aModule := aClass new.
	aModule bindKernelExports; importRequiredModules.
	aClass name !!= #Module ifTrue: [ aClass module: aModule. aModule addClass: aClass].
	^aModule
! !

!ModuleSpecReader methodsFor: 'read' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
read
	self readMetadata; readClasses; readExtendedClasses.
	^module
! !

!ModuleSpecReader methodsFor: 'read' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
readClass: aString
	| filename reader definition pointers variable class metasclass stream contents |
	filename := path / aString ,  '.st'.
	contents := Kernel readFile: filename.
	contents size = 0 ifTrue: [
		filename := path / aString , '.class.st'.
		contents := Kernel readFile: filename.
		contents size = 0 ifTrue: [
			self error: 'Cannot find file for class ' , aString]].
	stream := InternalReadStream on: contents.
	reader := TonelReader on: stream.
	[reader read] ensure: [stream close].
	definition := reader definition.
	variable := pointers := true.
	definition at: #type ifPresent: [:type |
		variable := true.
		type = #bytes ifTrue: [pointers := false]].
	class := ClassSpec new
		module: module;
		name: (definition at: #name) asString;
		supername: (definition at: #superclass ifAbsent: nil) asString;
		ivars: (definition at: #instVars ifAbsent: #());
		cvarNames: (definition at: #classVars ifAbsent: #());
		sharedPools: (definition at: #pools ifAbsent: #());
		isVariable: variable;
		isPointers: pointers.
	metasclass := MetaclassSpec new
		module: module;
		instanceClass: class;
		ivars: (definition at: #classInstVars ifAbsent: #()).
	class metaclass: metasclass.
	module addClass: class.
	reader methods do: [:m | self readMethod: m]
! !

!ModuleSpecReader methodsFor: 'read' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
readClasses
	(metadata at: #classes) do: [:name | self readClass: name]
! !

!ModuleSpecReader methodsFor: 'read' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
readExtendedClass: aString

	| filename contents stream reader definition class metaclass |
	filename := path / aString ,  '.st'.
	contents := Kernel readFile: filename.
	contents size = 0 ifTrue: [
			self error: 'Cannot find file for extended class ' , aString].
	stream := InternalReadStream on: contents.
	reader := TonelReader on: stream.
	[reader read] ensure: [stream close].
	definition := reader definition.
	class := ClassSpec new
		module: module;
		name: (definition at: #name) asString.
	metaclass := MetaclassSpec new module: module; instanceClass: class.
	class metaclass: metaclass.
	module addClassExtension: class.
	reader methods do: [:m | self readMethod: m]
! !

!ModuleSpecReader methodsFor: 'read' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
readExtendedClasses
	(metadata at: #extendedClasses ifAbsent: [#()])
		do: [:name | self readExtendedClass: name]
! !

!ModuleSpecReader methodsFor: 'read' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
readMetadata
	| stream name classes |
	stream := (Kernel  readFile: path , '/package.st') readStream.
	stream throughAll: 'Package '.
	metadata := (STONReader on: stream) parseMap.
	name := (metadata at: #name) replace: $- with: Character space.
	module name: name asString.
	classes := metadata at: #classes.
	classes := classes copyWith: name asString, 'Module'.
	metadata at: #classes put: classes
! !

!ModuleSpecReader methodsFor: 'read' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
readMethod: aDictionary
	| classname selector category class signature body source method |
	classname := aDictionary at: #class.
	selector := aDictionary at: #selector.
	category := aDictionary at: #category.
	class := module resolveClass: classname.
	class isNil ifTrue: [
		self
			error: 'Cannot find class for method ' , classname , ' >> #'
				, selector asString].
	signature := aDictionary at: #signature.
	body := aDictionary at: #body.
	source := signature dosToUnix unixToMac , String cr
		, body dosToUnix unixToMac.
	method := MethodSpec new
		module: module;
		classBinding: class;
		selector: selector;
		category: category;
		source: source.
	class addMethod: method
! !

!ModuleSpecReader methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initialize
	super initialize.
	module := ModuleSpec new
! !

!ModuleSpecReader methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
module
	^module
! !

!ModuleSpecReader methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
module: aModuleSpec
	module := aModuleSpec
! !

!ModuleSpecReader methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
path: aFilename
	path := aFilename
! !

!InlinedMessageNativizer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
assembler: anAssembler
	assembler := anAssembler 
! !

!InlinedMessageNativizer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
message: aMessageTreecode
	message := aMessageTreecode 
! !

!InlinedMessageNativizer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
nativizer: aTreecodeNativizer
	nativizer := aTreecodeNativizer 
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineAnd
	| skip conditions |
	skip := assembler newLabel.
	conditions := Array
		with: message receiver
		withAll: message arguments allButLast.
	conditions do: [ :c | self inlineAndCondition: c skip: skip ].
	message arguments last statements
		do: [ :s | s acceptVisitor: nativizer ].
	assembler @ skip
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineAndCondition: anSExpression skip: skip
	| retry failed |
	retry := assembler newLabel.
	failed := assembler newLabel.
	anSExpression acceptVisitor: nativizer.
	assembler
		@ retry;
		compareRwithFalse;
		jumpIfEqualTo: skip;
		compareRwithTrue;
		jumpIfNotEqualTo: failed.
	nativizer
		addFallback: [ assembler @ failed.
			nativizer sendMustBeBoolean.
			assembler jumpTo: retry ]
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineAndNot
	| skip conditions |
	skip := assembler newLabel.
	conditions := Array
		with: message receiver
		withAll: message arguments allButLast.
	conditions do: [ :c | self inlineAndCondition: c skip: skip ].
	message arguments last statements
		do: [ :s | s acceptVisitor: nativizer ].
	self negateBoolean.
assembler		@ skip
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineBinaryWhile: aBoolean
	| retry failed block continue |
	start := assembler newLabel.
	retry := assembler newLabel.
	failed := assembler newLabel.
	block := assembler newLabel.
	continue := assembler newLabel.
	assembler
		alignTo: 16;
		@ start.
	message receiver statements do: [ :s | s acceptVisitor: nativizer ].
	assembler
		@ retry;
		compareRwithBoolean: aBoolean;
		jumpIfEqualTo: block;
		compareRwithBoolean: aBoolean not;
		jumpIfNotEqualTo: failed;
		jumpTo: continue;
		@ block.
	message arguments first statements
		do: [ :s | s acceptVisitor: nativizer ].
	assembler
		jumpTo: start;
		@ continue.
	nativizer
		addFallback: [ assembler @ failed.
			nativizer sendMustBeBoolean.
			assembler jumpTo: retry ]
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineBranchIf: aBoolean
	| retry failed first second |
	retry := assembler newLabel.
	failed := assembler newLabel.
	end := assembler newLabel.
	message receiver acceptVisitor: nativizer.
	first := aBoolean not.
	second := aBoolean.
	assembler
		@ retry;
		loadAwithR;
		loadRwithNil;
		compareAwithBoolean: first;
		jumpIfEqualTo: end;
		compareAwithBoolean: second;
		jumpIfNotEqualTo: failed.
	message arguments first statements
		do: [ :s | s acceptVisitor: nativizer ].
	assembler @ end.
	nativizer
		addFallback: [ assembler @ failed; loadRwithA.
			nativizer sendMustBeBoolean.
			assembler jumpTo: retry ]
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineBranchIfNil: aBoolean

	end := assembler newLabel.
	message receiver acceptVisitor: nativizer.
	assembler
		compareRwithNil.
	aBoolean
		ifTrue: [ assembler jumpIfNotEqualTo: end ]
		ifFalse: [ assembler jumpIfEqualTo: end ].
	message arguments first acceptVisitor: nativizer.
	assembler @ end
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineBranchIfNilIfNotNil: aBoolean
	| second |
	second := assembler newLabel.
	end := assembler newLabel.
	message receiver acceptVisitor: nativizer.
	assembler compareRwithNil.
	aBoolean
		ifTrue: [ assembler jumpIfNotEqualTo: second ]
		ifFalse: [ assembler jumpIfEqualTo: second ].
	message arguments first acceptVisitor: nativizer.
	assembler
		jumpTo: end;
		@ second.
	message arguments first acceptVisitor: nativizer.
	assembler @ end
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineIfTrueIfFalse: aBoolean
	| retry other failed first second |
	retry := assembler newLabel.
	other := assembler newLabel.
	failed := assembler newLabel.
	end := assembler newLabel.
	message receiver acceptVisitor: nativizer.
	first := aBoolean not.
	second := aBoolean.
	assembler
		@ retry;
		compareRwithBoolean: first;
		jumpIfEqualTo: other;
		compareRwithBoolean: second;
		jumpIfNotEqualTo: failed.
	message arguments first statements
		do: [ :s | s acceptVisitor: nativizer ].
	assembler
		jumpTo: end;
		@ other.
	message arguments second statements
		do: [ :s | s acceptVisitor: nativizer ].
	assembler @ end.
	nativizer
		addFallback: [ assembler @ failed.
			nativizer sendMustBeBoolean.
			assembler jumpTo: retry ]
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineMessage
	| selector |
	selector := message selector.
	selector = #ifTrue:
		ifTrue: [ ^ self inlineBranchIf: true ].
	selector = #ifFalse:
		ifTrue: [ ^ self inlineBranchIf: false ].
	selector = #ifNil:
		ifTrue: [ ^ self inlineBranchIfNil: true ].
	selector = #ifNotNil:
		ifTrue: [ ^ self inlineBranchIfNil: false ].
	selector = #ifNil:ifNotNil:
		ifTrue: [ ^ self inlineBranchIfNilIfNotNil: true ].
	selector = #ifNil:ifNotNil:
		ifTrue: [ ^ self inlineBranchIfNilIfNotNil: false ].
	selector = #ifTrue:ifFalse:
		ifTrue: [ ^ self inlineIfTrueIfFalse: true ].
	selector = #ifFalse:ifTrue:
		ifTrue: [ ^ self inlineIfTrueIfFalse: false ].
	selector = #whileTrue
		ifTrue: [ ^ self inlineUnitaryWhile: true ].
	selector = #whileFalse
		ifTrue: [ ^ self inlineUnitaryWhile: false ].
	selector = #whileTrue:
		ifTrue: [ ^ self inlineBinaryWhile: true ].
	selector = #whileFalse:
		ifTrue: [ ^ self inlineBinaryWhile: false ].
	selector = #repeat
		ifTrue: [ ^ self inlineRepeat ].
	selector = #to:do:
		ifTrue: [ ^ self inlineToDo ].
	selector = #to:by:do:
		ifTrue: [ ^ self inlineToByDo].
	selector = #timesRepeat:
		ifTrue: [ ^ self inlineTimesRepeat ].
	(selector beginsWith: #or:)
		ifTrue: [ ^ self inlineOr ].
	(selector beginsWith: #and:)
		ifTrue: [ ^ self inlineAnd ].
	selector = #andNot:
		ifTrue: [ ^ self inlineAndNot ].
	selector = #orNot:
		ifTrue: [ ^ self inlineOrNot ].
	self ASSERT: false
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineOr
	| skip conditions |
	skip := assembler newLabel.
	conditions := Array
		with: message receiver
		withAll: message arguments allButLast.
	conditions do: [ :c | self inlineOrCondition: c skip: skip ].
	message arguments last statements
		do: [ :s | s acceptVisitor: nativizer ].
	assembler @ skip
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineOrBlock: b skip: skip
	| retry failed |
	retry := assembler newLabel.
	failed := assembler newLabel.
	b statements acceptVisitor: nativizer.
	assembler
		@ retry;
		compareRwithTrue;
		jumpIfEqualTo: skip;
		compareRwithFalse;
		jumpIfNotEqualTo: failed.
	nativizer
		addFallback: [ assembler @ failed.
			nativizer sendMustBeBoolean.
			assembler jumpTo: retry ]
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineOrCondition: anSExpression skip: skip
	| retry failed |
	retry := assembler newLabel.
	failed := assembler newLabel.
	
	anSExpression acceptVisitor: nativizer.
	assembler
		@ retry;
		compareRwithTrue;
		jumpIfEqualTo: skip;
		compareRwithFalse;
		jumpIfNotEqualTo: failed.
	nativizer
		addFallback: [ assembler @ failed.
			nativizer sendMustBeBoolean.
			assembler jumpTo: retry ]
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineOrNot
	| skip conditions |
	skip := assembler newLabel.
	conditions := Array
		with: message receiver
		withAll: message arguments allButLast.
	conditions do: [ :c | self inlineOrCondition: c skip: skip ].
	message arguments last statements
		do: [ :s | s acceptVisitor: nativizer ].
	self negateBoolean.
	assembler @ skip
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineRepeat
	start := assembler newLabel.
	assembler
		alignTo: 16;
		@ start.
	message receiver statements do: [ :s | s acceptVisitor: nativizer ].
	assembler jumpTo: start
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineTimesRepeat
	| head block continue nonInteger nonDecrementable current |
	head := assembler newLabel.
	block := assembler newLabel.
	continue := assembler newLabel.
	nonInteger := assembler newLabel.
	nonDecrementable := assembler newLabel.
	message receiver acceptVisitor: nativizer.
	current := nativizer pushR.
	assembler
		alignTo: 16;
		@ head;
		testIntegerBitOf: assembler regR;
		jumpIfZeroTo: nonInteger;
		compareRwithSmallInteger: 0;
		jumpIfLessOrEqualSignedTo: continue;
		@ block.
	message arguments first statements
		do: [ :s | s acceptVisitor: nativizer ].
	nativizer loadRwithStack: current.
	assembler
		testIntegerBitOf: assembler regR;
		jumpIfZeroTo: nonDecrementable;
		subFromRconstant: 2.
	nativizer storeRInStack: current.
	assembler
		jumpTo: head;
		@ continue.
	nativizer
		dropTos;
		addFallback: [ assembler
				@ nonDecrementable;
				pushSmallInteger: 1.
			nativizer
				emitSend: #-;
				storeRInStack: current.
			assembler jumpTo: head ];
		addFallback: [ assembler
				@ nonInteger;
				pushSmallInteger: 0.
			nativizer emitSend: #>.
			assembler
				compareRwithTrue;
				jumpIfEqualTo: block;
				jumpTo: continue ]

! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineToByDo
	| head block continue nonInteger nonIncrementable overflow current limit by increment |
	head := assembler newLabel.
	block := assembler newLabel.
	continue := assembler newLabel.
	nonInteger := assembler newLabel.
	nonIncrementable := assembler newLabel.
	overflow := assembler newLabel.
	message receiver acceptVisitor: nativizer.
	current := message arguments third inlinedArgs first.
	nativizer temporaryInStackAtPut: current.
	message arguments first acceptVisitor: nativizer.
	limit := nativizer pushR.
	assembler loadAwithR.
	nativizer temporaryInStackAt: current.
	assembler
		alignTo: 16;
		@ head;
		testIntegerBitOf: assembler regA;
		jumpIfZeroTo: nonInteger;
		testIntegerBitOf: assembler regR;
		jumpIfZeroTo: nonInteger;
		compareRwithA.
	by := message arguments second value.
	by > 0
		ifTrue: [ assembler jumpIfGreaterSignedTo: continue ]
		ifFalse: [ assembler jumpIfLessSignedTo: continue ].
	increment := (assembler smallInteger: by) - 1.
	assembler @ block.
	message arguments third statements
		do: [ :s | s acceptVisitor: nativizer ].
	nativizer temporaryInStackAt: current.
	assembler
		testIntegerBitOf: assembler regR;
		jumpIfZeroTo: nonIncrementable;
		addRwithImmediate: increment;
		jumpIfOverflowTo: overflow.
	nativizer
		temporaryInStackAtPut: current;
		loadAwithStack: limit.
	assembler
		jumpTo: head;
		@ continue.
	nativizer dropTos;
		addFallback: [ assembler
				@ overflow;
				subFromRconstant: increment;
				@ nonIncrementable;
				pushSmallInteger: 1.
			nativizer
				emitSend: #+;
				temporaryInStackAtPut: current;
				loadAwithStack: limit.
			assembler jumpTo: head ];
		addFallback: [ assembler
				@ nonInteger;
				pushA.
			nativizer emitSend: #<=.
			assembler
				compareRwithTrue;
				jumpIfEqualTo: block;
				jumpTo: continue ]

! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineToDo
	| head block continue nonInteger nonIncrementable overflow current limit |
	head := assembler newLabel.
	block := assembler newLabel.
	continue := assembler newLabel.
	nonInteger := assembler newLabel.
	nonIncrementable := assembler newLabel.
	overflow := assembler newLabel.
	message receiver acceptVisitor: nativizer.
	current := message arguments second inlinedArgs first.
	nativizer temporaryInStackAtPut: current.
	message arguments first acceptVisitor: nativizer.
	limit := nativizer pushR.
	assembler loadAwithR.
	nativizer temporaryInStackAt: current.
	assembler
		alignTo: 16;
		@ head;
		testIntegerBitOf: assembler regA;
		jumpIfZeroTo: nonInteger;
		testIntegerBitOf: assembler regR;
		jumpIfZeroTo: nonInteger;
		compareRwithA;
		jumpIfGreaterSignedTo: continue;
		@ block.
	message arguments second statements
		do: [ :s | s acceptVisitor: nativizer ].
	nativizer temporaryInStackAt: current.
	assembler
		testIntegerBitOf: assembler regR;
		jumpIfZeroTo: nonIncrementable;
		addRwithImmediate: 2;
		jumpIfOverflowTo: overflow.
	nativizer
		temporaryInStackAtPut: current;
		loadAwithStack: limit.
	assembler
		jumpTo: head;
		@ continue.
	nativizer dropTos;
		addFallback: [ assembler
				@ overflow;
				subFromRconstant: 2;
				@ nonIncrementable;
				pushSmallInteger: 1.
			nativizer
				emitSend: #+;
				temporaryInStackAtPut: current;
				loadAwithStack: limit.
			assembler jumpTo: head ];
		addFallback: [ assembler
				@ nonInteger;
				pushA.
			nativizer emitSend: #<=.
			assembler
				compareRwithTrue;
				jumpIfEqualTo: block;
				jumpTo: continue ]

! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
inlineUnitaryWhile: aBoolean
	| continue failed |
	start := assembler newLabel.
	continue := assembler newLabel.
	failed := assembler newLabel.
	assembler
		alignTo: 16;
		@ start.
	message receiver statements do: [ :s | s acceptVisitor: nativizer ].
	assembler
		compareRwithBoolean: aBoolean;
		jumpIfEqualTo: start;
		compareRwithBoolean: aBoolean not;
		jumpIfNotEqualTo: failed;
		@ continue.
	nativizer
		addFallback: [ assembler @ failed.
			nativizer sendMustBeBoolean.
			assembler jumpTo: continue ]
! !

!InlinedMessageNativizer methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
negateBoolean
		| retry failed done |
	retry := assembler newLabel.
	failed := assembler newLabel.
		done := assembler newLabel.
	assembler
		@ retry;
		loadAwithR;
		loadRwithFalse;
		compareRwithA;
		jumpIfEqualTo: done;
		loadRwithTrue;
		compareRwithA;
		jumpIfNotEqualTo: failed; @done.
	nativizer
		addFallback: [ assembler @ failed.
			nativizer sendMustBeBoolean.
			assembler jumpTo: retry ]
! !

!MessageLinker methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
canInline: aSymbol
	filter ifNil: [ ^true ].
	filter == aSymbol ifTrue: [ ^true ].
	^(filter includes: aSymbol)
! !

!MessageLinker methodsFor: 'testing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
filter: anObject
	filter := anObject.
	filter isCollection ifTrue: [filter := filter asIdentitySet]
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleAsFloatInto
	#_asFloatInto:.
	assembler
		loadX0withRasDouble;
		storeLargeX0inA.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleAsNative
	| noninteger |
	#_asNative.
	noninteger := assembler labeledIntegerBitTestOfR.
	assembler
		convertRtoNativeInteger;
		@ noninteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleAsObject
	#_asObject.
	assembler clearSafeRintegerBit
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleAsPointer
	| nonInteger |
	#_asPointer.
	nonInteger := assembler labeledIntegerBitTestOfR.
	assembler
		convertRtoNativeInteger;
		@ nonInteger;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleAsSmallInteger
	#_asSmallInteger.
	assembler convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicAt
	| oop |
	#_basicAt:.
	oop := assembler labeledIntegerNativizationOfA.
	assembler
		loadRwithRatA;
		@ oop
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicAtPut
	| nonInteger |
	#_basicAt:put:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeTinRatA;
		@ nonInteger;
		loadRwithT
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicCopyFromToWith
	#_basicCopyFrom:to:with:.
	assembler
		pushE;
		convertAtoNativeInteger;
		convertTtoNativeInteger;
		loadEwithAddressOfRatA;
		loadSwithAddressOfSatA;
		subAfromT;
		addTwithImmediate: 1;
		moveTslots;
		popE
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicFlags
	#_basicFlags.
	self emitByteAtOffset: _Flags
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicFlagsPut
	#_basicFlags:.
	self emitByteAtOffsetPut: _Flags
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicHash
	#_basicHash.
	assembler
		loadZeroExtendShortRwithRoffset: _Hash;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicHashPut
	| nonInteger |
	#_basicHash:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeShortAinRoffset: _Hash;
		@ nonInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicSize
	#_smallSize.
	self emitByteAtOffset: _SmallSize
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicSizePut
	#_smallSize:.
	self emitByteAtOffsetPut: _SmallSize
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicULongAt
	| nonInteger |
	#_basicULongAt:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		loadZeroExtendLongRwithRatA;
		@ nonInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBasicULongAtPut
	| nonInteger |
	#_basicULongAt:put:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeLongTinRatA;
		@ nonInteger;
		loadRwithT
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBeCurrent
	#_beCurrent.
	assembler
		loadRwithRindex: 1;
		clearSafeRintegerBit;
		loadFPwithR
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBeEnvironment
	#_beEnvironment.
	assembler loadEwithR
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBeFramePointer
	#_beFramePointer.
	assembler storeRinFPindex: 1
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBitShiftLeft
	| success |
	#_bitShiftLeft:.
	success := assembler newLabel.
	assembler
		loadTwithA;
		loadAwithR;
		clearSafeRintegerBit;
		convertTtoNativeInteger;
		shiftLeftRwithT;
		setSafeRintegerBit;
		pushR;
		shiftRightRwithT;
		setSafeRintegerBit;
		compareRwithA;
		popR;
		shortJumpIfEqualTo: success;
		loadRwithNil;
		@ success
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBitShiftRight
	#_bitShiftRight:.
	assembler
		move: assembler regA to: assembler regT;
		convertToNativeInteger: assembler regT;
		shiftRightArithmetic: assembler regR by: assembler regT b;
		setIntegerBit: assembler regR
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleBusyWait
	| loop |
	#_busyWait.
	loop := assembler newLabel.
	assembler
		loadTwithImmediate: 0;
		@ loop;
		exchangeRindirectWithT;
		compareTwithImmediate: 0;
		shortJumpIfEqualTo: loop
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleByteAt
	| nonInteger |
	#_byteAt:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		loadZeroExtendByteRwithRatA;
		convertRtoSmallInteger;
		@ nonInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleByteAtPut
	| nonInteger1 nonInteger2 |
	#_byteAt:put:.
	nonInteger1 := assembler labeledIntegerNativizationOfA.
	nonInteger2 := assembler labeledIntegerNativizationOfT.
	assembler
		storeByteTinRatA;
		@ nonInteger1;
		@ nonInteger2;
		loadRwithT;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleCDeclCallWithArguments
	#_cdeclCallWithArguments:.
	assembler
		loadZeroExtendByteTwithAindex: _SmallSize + 1;
		shiftTright: assembler wordSizeShift;
		pushS;
		saveCallerFrame;
		subTslotsToSP;
		assemble: 'and' with: assembler regSP with: -16;
		loopTtimes: [ assembler
				load: assembler regS
				fromMem: assembler memRefAatT;
				store: assembler regS
				intoMem: assembler memRefSPatT ].
	assembler addressSize = 8
		ifTrue: [ self loadArgumentsIntoRegisters ].
	assembler
		callR;
		restoreCallerFrame;
		popS
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleCallWithArguments
	#_stdcallWithArguments:.
	assembler
		loadZeroExtendByteTwithAindex: _SmallSize + 1;
		shiftTright: assembler wordSizeShift;
		loopTtimes: [ assembler pushAatToffset: 0 - assembler addressSize ].
	assembler addressSize = 8
		ifTrue: [ self loadArgumentsIntoRegisters ].
	assembler callR
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleEnvironment
	#_environment.
	assembler loadRwithE
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleExpandInStackSized
	#_expandInStackSized:.
	assembler
		convertAtoNativeInteger;
		loadTwithA;
		loopTtimes: [ assembler
				pushIndirectR;
				addRwithImmediate: assembler wordSize ]
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleExtendedSize
	#_largeSize.
	assembler
		loadZeroExtendLongRwithRindex: _ExtendedSize;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatEquals
	"
	first compare magnitudes to set error bit if NaN
	"
	#_floatEquals:.
	assembler
		pushR;
		loadLargeX0withRindirect;
		compareLessThanDoubleX0withAindirect;
		popR;
		loadLargeX0withRindirect;
		compareEqualDoubleX0withAindirect;
		moveX0toR;
		addRwithImmediate: 1;
		convertRtoSmallInteger.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatFractionPartInto
	#_floatFractionPartInto:.
	assembler
		loadLargeX0withRindirect;
		roundDoubleX0intoX1;
		subDoubleX1fromX0;
		storeLargeX0inA.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatLessThan
	#_floatLessThan:.
	assembler
		loadLargeX0withRindirect;
		compareLessThanDoubleX0withAindirect;
		moveX0toR;
		addRwithImmediate: 1;
		convertRtoSmallInteger.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatMinusInto
	#_floatMinus:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		subDoubleX1fromX0;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatMultiplyInto
	#_floatMultiply:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		multiplyDoubleX0byX1;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatPlusInto
	#_floatPlus:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		addDoubleX1toX0;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatQuotientInto
	#_floatQuotient:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		divideDoubleX0byX1;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatSqrtInto
	#_floatSqrtInto:.
	assembler
		loadLargeX0withRindirect;
		sqrtDoubleX0;
		storeLargeX0inA.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFloatTruncated
	#_floatTruncated.
	assembler loadRconvertingDoublePointedByR.
	self readFloatStatus.
	assembler convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleFramePointer
	#_framePointer.
	assembler loadRwithFPindex: 1
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleGetTIBValue
	| nonInteger |
	#_getThreadInformationBlockValue.
	nonInteger := assembler labeledIntegerNativizationOfR.
	assembler
		loadRwithTIBatR;
		@ nonInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleGetThreadValue
	| nonInteger uninitialized |
		#_getThreadValue.
	nonInteger := assembler labeledIntegerNativizationOfR.
	uninitialized := assembler newLabel.
	assembler
		loadRwithThreadVariableAtR;
		compareRwithImmediate: 0;
		shortJumpIfEqualTo: uninitialized.
	assembler
		jumpOver: [ assembler
				@ uninitialized;
				@ nonInteger;
				loadRwithNil ]
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleHigh16
	#_high16.
	assembler wordSize > 4
		ifTrue: [ assembler clearRhigh32 ].
	assembler
		shiftRright: 15;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleHigh32
	#_high32.
	assembler
		shiftLogicalRright: 31;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleHoldRefererIfNeeded
	#_holdRefererIfNeeded:.
	assembler
		pushA;
		loadAwithGlobal: #WriteBarrier;
		callIndirectA;
		popA
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleIntegerMultiplyByInto
	#_integerMultiplyBy:into:.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		multiplyRbyAwideningToA;
		storeRinTindex: 1;
		storeAinTindex: 2;
		loadRwithT
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleInvoke
	#_invoke:.
	assembler
		loadMwithA;
		callIndirectM
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleLeadingZeroBitCount
	#_leadingZeroBitCount.
	assembler
		convertRtoNativeInteger;
		leadingRzeroCount;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleLoadFloatStatusFrom
	#_status:.
	assembler loadMXCSRfromA
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleLow16
	#_low16.
	assembler
		andRwithImmediate: 16rFFFF;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleLow32
	#_low32.
	assembler wordSize > 4
		ifTrue: [ assembler
				andRwithImmediate: 16rFFFFFFFF;
				convertRtoSmallInteger ]
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleNativeHalt
	#_halt.
	assembler breakpoint
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleNilSlots
	#_nilSlots:.
	assembler
		pushE;
		loadEwithR;
		loadRwithNil;
		loadTwithA;
		convertTtoNativeInteger;
		writeTslots;
		popE
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleObjectAtOffset
	| nonInteger1 |
	#_objectAtOffset:.
	nonInteger1 := assembler labeledIntegerNativizationOfA.
	assembler
		loadRwithRatOffsetA;
		@ nonInteger1
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleObjectAtOffsetPut
	| oop |
	#_objectAtOffset:put:.
	oop := assembler labeledIntegerNativizationOfA.
	assembler
		storeTinRatOffsetA;
		@ oop;
		loadRwithT;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleOop
	#_oop.
	^ assembler convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleQuotientTowardZero
	#_quotientTowardZero:.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		loadTwithA;
		extendRtoAandDividebyT;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleRelease
	#_release.
	assembler
		lock;
		decRindirect
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleRemainderTowardZero
	| adapt convert |
	#_remainderTowardZero:.
	adapt := assembler newLabel.
	convert := assembler newLabel.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		loadTwithA;
		xorAwithR;
		jumpIfSignTo: adapt;
		extendRtoAandDividebyT;
		loadRwithA;
		jumpTo: convert;
		@ adapt;
		extendRtoAandDividebyT;
		loadRwithA;
		testRwithR;
		jumpIfZeroTo: convert;
		addTtoR;
		@ convert;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleRestore
	#_restore.
	assembler loadEwithR
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleRestoreAndTransferControlWithContext
	#_restoreAndTransferControlWithContext:.
	assembler
		clearSafeRintegerBit;
		loadFPwithR;
		loadSPwithFP;
		loadRwithA;
		clearSafeRintegerBit;
		loadFPwithR;
		popR;
		loadEwithR;
		restoreCallerSelf;
		restoreCallerM;
		loadRwithS;
		return: 0
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleRestoreWithContext
	#_restoreWithContext:.
	assembler
		clearSafeRintegerBit;
		loadFPwithR;
		loadSPwithFP;
		loadRwithA;
		clearSafeRintegerBit;
		loadFPwithR
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleSaveCurrentEnvironment
	#_saveCurrentEnvironment.
	assembler
		clearSafeRintegerBit;
		pushE;
		popT;
		storeTinRindex: 1;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleSetTIBValue
	#_setThreadInformationBlockValue:.
	assembler
		convertRtoNativeInteger;
		storeTIBatRwithA
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleSetThreadValue
	| nonInteger |
	#_setThreadValue:.
	nonInteger := assembler labeledIntegerNativizationOfR.
	assembler
		storeAinThreadVariableAtIndexR;
		convertRtoSmallInteger.
	assembler @ nonInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleSmallIntegerByteAt
	| nonInteger |
	#_smallIntegerByteAt:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		convertRtoNativeInteger;
		pushR;
		loadZeroExtendByteRwithSPatA;
		convertRtoSmallInteger;
		popA;
		@ nonInteger
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleStoreDoubleResult
	#_storeDoubleResult.
	assembler storeDoubleResultInRindirect
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleStoreFloatStatusInto
	#_readStatusOn:.
	assembler storeMXCSRintoA
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleTestSmallInteger
	| integer |
	#_isSmallInteger.
	integer := assembler newLabel.
	assembler
		testRintegerBit;
		loadRwithTrue;
		shortJumpIfNotZeroTo: integer;
		loadRwithFalse;
		@ integer
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleThisContext
	#_thisContext.
	assembler loadRwithFP setRintegerBit
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleTimesTwoPower
	#_timesTwoPower:.
	assembler clearFPUFlags scaleFloatOnRWithA clearFPUFlags
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleTransferControlDiscardingLastArgTo
	#_transferControlDiscardingLastArgTo:.
	assembler
		restoreCallerFrame;
		popSPindirect;
		loadMwithA;
		jumpToMindex: 1
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleTransferControlTo
	#_transferControlTo:.
	assembler restoreCallerFrame; loadMwithA; jumpToMindex: 1
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleULargeAtOffset
	| overflow1 overflow2 end |
	#_uLargeAtOffset:.
	overflow1 := assembler newLabel.
	overflow2 := assembler newLabel.
	end := assembler newLabel.
	assembler
		convertAtoNativeInteger;
		loadRwithRatOffsetA;
		shiftRleft: 1;
		shortJumpIfCarryTo: overflow1;
		shortJumpIfSignTo: overflow2;
		setRintegerBit;
		shortJumpTo: end.
	assembler
		@ overflow1;
		@ overflow2;
		loadRwithNil;
		@ end
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleULargeAtOffsetInto
	#_uLargeAtOffset:into:.
	assembler
		convertAtoNativeInteger;
		loadAwithRoffsetAtA;
		storeAinTindex: 1;
		loadRwithT
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleULargeAtOffsetPut
	| end notSmall |
	#_uLargeAtOffset:put:.
	notSmall := assembler
		convertAtoNativeInteger;
		labeledIntegerBitTestOfT.
	end := assembler newLabel.
	assembler
		convertTtoNativeInteger;
		shortJumpTo: end;
		@ notSmall;
		loadTwithTindex: 1;
		@ end;
		storeTinRatOffsetA
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleULongAtOffset
	| overflow1 overflow2 end |
	#_uLongAtOffset:.
	overflow1 := assembler newLabel.
	overflow2 := assembler newLabel.
	end := assembler newLabel.
	assembler
		convertAtoNativeInteger;
		loadLongRwithRatOffsetA;
		shiftRleft: 1;
		shortJumpIfCarryTo: overflow1;
		shortJumpIfSignTo: overflow2;
		setRintegerBit;
		shortJumpTo: end.
	assembler
		@ overflow1;
		@ overflow2;
		loadRwithNil;
		@ end
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleULongAtOffsetInto
	#_uLongAtOffset:into:.
	assembler
		convertAtoNativeInteger;
		loadLongRwithRatOffsetA;
		storeRinTindex: 1;
		loadRwithT
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleULongAtOffsetPut
	| end oop |
	#_uLongAtOffset:put:.
	oop := assembler
		convertAtoNativeInteger;
		labeledIntegerBitTestOfT.
	end := assembler newLabel.
	assembler
		convertTtoNativeInteger;
		shortJumpTo: end;
		@ oop;
		loadTwithTindex: 1;
		@ end;
		storeLongTinRatOffsetA
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleUShortAtOffsetPut
	| end notSmall |
	#_uShortAtOffset:put:.
	notSmall := assembler
		convertAtoNativeInteger;
		labeledIntegerBitTestOfT.
	end := assembler newLabel.
	assembler
		convertTtoNativeInteger;
		shortJumpTo: end.
	assembler
		@ notSmall;
		loadTwithTindex: 1;
		@ end;
		storeShortTinRatOffsetA
! !

!InlineMessageLinker methodsFor: 'private - assemble' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assembleZeroSlots
	#_zeroSlots:.
	assembler
		pushE;
		loadEwithR;
		loadRwithImmediate: 0;
		loadTwithA;
		convertTtoNativeInteger;
		writeTslots;
		popE
! !

!InlineMessageLinker methodsFor: 'private - helpers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
emitByteAtOffset: offset
	assembler
		loadZeroExtendByteRwithRindex: offset + 1;
		convertRtoSmallInteger 
! !

!InlineMessageLinker methodsFor: 'private - helpers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
emitByteAtOffsetPut: offset
	| nonInteger |
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeByteAinRindex: offset + 1;
		@ nonInteger 
! !

!InlineMessageLinker methodsFor: 'private - helpers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
loadArgumentsIntoRegisters
	| stack1 stack2 stack3 stack4 |
	stack1 :=assembler memRef: rsp indexImm: 1.
	stack2 :=assembler memRef: rsp indexImm: 2.
	stack3 :=assembler memRef: rsp indexImm: 3.
	stack4 :=assembler memRef: rsp indexImm: 4.
	assembler
		load: rcx fromMem: stack1;
		load: rdx fromMem: stack2;
		load: r8 fromMem: stack3;
		load: r9 fromMem: stack4;
		assemble: 'movq' with: xmm0 with: rcx;
		assemble: 'movq' with: xmm1 with: rdx;
		assemble: 'movq' with: xmm2 with: r8;
		assemble: 'movq' with: xmm3 with: r9
! !

!InlineMessageLinker methodsFor: 'private - helpers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
readFPUStatus
	assembler
		loadAwithKnown: #FloatStatus;
		readFPUStatusOnA
! !

!InlineMessageLinker methodsFor: 'private - helpers' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
readFloatStatus
	assembler
		loadAwithKnown: #FloatStatus;
		storeMXCSRintoA
! !

!InlineMessageLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
emitSend: aSymbol using: anAssembler
	| arity selector | 
	assembler := anAssembler.
	arity := aSymbol arity. 
	arity > 2 ifTrue: [assembler pop: assembler regS].
	arity > 1 ifTrue: [assembler pop: assembler regT].
	arity > 0 ifTrue: [assembler pop: assembler regA].
	self ASSERT: arity <= 3 .
	selector := map at: aSymbol.
	self perform: selector
! !

!InlineMessageLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
emitSendDebuggable: aSymbol using: anAssembler
	self emitSend: aSymbol using: anAssembler 
! !

!InlineMessageLinker methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	map := Dictionary new.
	self class supported do:[:each|map add: each].
	self filter: map keys asIdentitySet

	"
	InlineMessageLinker new
	"

! !

!InlineMessageLinker class methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeInlineMessageLinkerFlags
	self addNamespaceAs: #InlineMessageLinkerFlags.
	InlineMessageLinkerFlags
		at: #_Flags put: -5;
		at: #_SmallSize put: -6;
		at: #_Hash put: -8;
		at: #_Reserved put: -2;
		at: #_ExtendedSize put: -3.

! !

!InlineMessageLinker class methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
supported
	| selectors |
	selectors := self organization selectorsFor: #'private - assemble'.
	^selectors collect: [:selector | | cm key |
		cm := self >> selector.
		key := cm literals detect: [:each | each isSymbol and:[each first == $_ ]].
		key -> selector]. 

	"
	InlineMessageLinker supported
	"

! !

!InvokeLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addMethod: aCompiledMethod
	self addMethod: aCompiledMethod for: aCompiledMethod selector
! !

!InvokeLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addMethod: aCompiledMethod for: aSymbol
	| instructions send |
	filter add: aSymbol.
	instructions := invoker ifNil: [ aCompiledMethod nativeCode code ].
	send := SendSite invoking: aCompiledMethod using: instructions.
	sends at: aSymbol put: send
! !

!InvokeLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
addMethods: aCollection
	aCollection do: [:m | self addMethod: m]
! !

!InvokeLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
emitSend: aSymbol using: anAssembler
	| send |
	send := sends at: aSymbol.
	anAssembler
		loadAwithLiteral: send;
		callIndirectA;
		discardArguments: aSymbol arity
! !

!InvokeLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	super initialize.
	sends := Dictionary new.
	self filter: #()
! !

!InvokeLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
invoker: aNativeCode
	invoker := aNativeCode
! !

!LookupLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
emitSend: aSymbol using: anAssembler
	| send |
	send := SendSite new lookup: aSymbol using: lookup.
	anAssembler
		loadAwithLiteral: send;
		callIndirectA;
		discardArguments: aSymbol arity.
	^send
! !

!LookupLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
emitSendSuper: aSymbol from: aClass using: anAssembler
	| send behavior |
	send := SendSite new lookup: aSymbol using: lookupSuper; beSuperSend.
	behavior := aClass superclass map instanceBehavior.
	anAssembler
		loadAwithLiteral: send;
		loadTwithLiteral: behavior;
		callIndirectA;
		discardArguments: aSymbol arity.
	^send
! !

!LookupLinker methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initializeFrom: anLMRModule
	lookup := anLMRModule lookupStub.
	lookupSuper := anLMRModule lookupSuperStub.

! !

!LookupLinker methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookup: aByteArray
	lookup := aByteArray
! !

!LookupLinker methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
lookupSuper: aByteArray
	lookupSuper := aByteArray
! !

!LazyLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
emitSend: aSymbol using: anAssembler
	| send |
	send := super emitSend: aSymbol using: anAssembler.
	sends add: send
! !

!LazyLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	super initialize.
	sends := OrderedCollection new

! !

!LazyLinker methodsFor: 'nativizing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sends
	^sends

! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
abi
	^platform abi
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
addLinker: aLinker
	messageLinker add: aLinker
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlinedMethods
	^inlinedMethods
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
inlinedMethods: aCollection
	inlinedMethods := aCollection
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
invokedMethods
	^invokedMethods
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
invokedMethods: aCollection
	invokedMethods := aCollection asOrderedCollection 
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
messageLinker
	^messageLinker
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
messageLinker: aLinker
	messageLinker := aLinker 
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodNativizer
	^cachedNativizer
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
optimizedMethods
	^optimizedMethods
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
optimizedMethods: aCollection
	optimizedMethods := aCollection
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
platform
	^platform
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
platform: aNativizationPlatform
	platform := aNativizationPlatform
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
safepointCheck: anObject
	safepointCheck := anObject 
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
wordSize
	^self abi wordSize
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
wordSizeShift
	^self abi wordSizeShift
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
writeBarrier
	^writeBarrier
! !

!NativizationEnvironment methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
writeBarrier: aCompiledMethod
	writeBarrier := aCompiledMethod.
	invokedMethods add: writeBarrier 
! !

!NativizationEnvironment methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
completeInitialization
	cachedNativizer := self newTemplateJIT 
! !

!NativizationEnvironment methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initialize
	busy := false.
	optimizedMethods := OrderedCollection new.
	invokedMethods := OrderedCollection new.
	inlinedMethods := OrderedCollection new.
	messageLinker := CompositeMessageLinker new.
	messageLinker add: InlineMessageLinker new.
! !

!NativizationEnvironment methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
initializeLinkersFor: anLMRModule
	| invoker dispatcher |
	invoker := InvokeLinker new invoker: anLMRModule invokeStub; addMethods: invokedMethods.
	dispatcher := LookupLinker new initializeFrom: anLMRModule.
	self
		addLinker: invoker;
		addLinker: dispatcher;
		completeInitialization
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativize: aCompiledMethod
	^(self shouldOptimize: aCompiledMethod)
		  ifTrue: [ self nativizeOptimizing: aCompiledMethod ]
		  ifFalse: [ self nativizeWithoutOptimizing: aCompiledMethod ] 
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeOptimizing: aCompiledMethod
	self optimizingNativizer
		method: aCompiledMethod;
		nativize
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizeWithoutOptimizing: aCompiledMethod
	| method |
	method := self
		nativizerDuring: [ :jit | jit nativize: aCompiledMethod ].
	^method
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativizerDuring: aBlock
	^busy
		  ifFalse: [ 
			  busy := true.
			  [ aBlock value: cachedNativizer ] ensure: [ busy := false ] ]
		  ifTrue: [ 
			  | old |
			  old := cachedNativizer. 
			  [ 
			  cachedNativizer := self newTemplateJIT.
			  aBlock value: cachedNativizer ] ensure: [ cachedNativizer := old ] ]
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
newAssembler
	^platform newAssembler
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
newTemplateJIT
	^TemplateJIT new environment: self
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
optimizingNativizer
	^OptimizingNativizer new environment: self
! !

!NativizationEnvironment methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
sexpressionOffsetsOf: code
	| method |
	method := code method.
	(self shouldOptimize: method) ifTrue: [ ^#(  ) ].
	^self nativizerDuring: [ :nativizer |
		  method nativeCode ifNotNil: [ method := method copy ].
		  nativizer compile: method.
		  nativizer sexpressionOffsetsOf: code ]
! !

!NativizationEnvironment methodsFor: 'printing & storing' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
printOn: aStream
	"append a printed representation of the receiver to the argument, aStream"

	super printOn: aStream.
	aStream nextPutAll: '(platform: '.
	platform name printOn: aStream.
	aStream nextPut: $)
! !

!NativizationEnvironment methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shouldInline: aSymbol
	^inlinedMethods anySatisfy: [ :m | m selector = aSymbol ]
! !

!NativizationEnvironment methodsFor: 'queries' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
shouldOptimize: method
	| selector classname |
	selector := method selector.
	classname := method classBinding name.
	^optimizedMethods anySatisfy: [:m | m selector = selector and: [ m classBinding name = classname ]  ]
! !

!NativizationPlatform methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
abi
	self ASSERT: abi notNil.  
	^ abi
! !

!NativizationPlatform methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name
	self ASSERT: name notNil.
	^ name
! !

!NativizationPlatform methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
wordSize
	self ASSERT: wordSize notNil.
	^ wordSize
! !

!NativizationPlatform methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
wordSizeShift
	^ #(0 0 0 2 0 0 0 3) at: self wordSize
! !

!NativizationPlatform methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
abi: anABI
	self ASSERT: abi isNil.
	self ASSERT: anABI notNil.

	abi := anABI.
! !

!NativizationPlatform methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
codeGeneratorClass: aClass
	self ASSERT: codeGeneratorClass isNil.
	self ASSERT: aClass notNil.

	codeGeneratorClass := aClass.
! !

!NativizationPlatform methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	"super initialize.   -- commented since inherited method does nothing"
! !

!NativizationPlatform methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
name: aString
	self ASSERT: name isNil.
	self ASSERT: aString notNil.

	name := aString.
! !

!NativizationPlatform methodsFor: 'initialization' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
wordSize: anInteger
	self ASSERT: wordSize isNil.
	self ASSERT:(anInteger == 8 or:[ anInteger == 4]).

	wordSize := anInteger.
! !

!NativizationPlatform methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
newAssembler
	^ abi newAssembler platform: self
! !

!NativizationPlatform methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
newCodeGenerator
	self ASSERT: codeGeneratorClass notNil.

	^ codeGeneratorClass new platform: self.
! !

!NativizationPlatform methodsFor: 'printing & storing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
printOn: aStream
	super printOn:aStream.
	aStream nextPut: $(.
	name printOn:aStream.
	aStream nextPut: $).
! !

!NativizationPlatform class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
host
	"Return platform for the machine this code is running on."

	| host |

	host := Kernel host.
	host = 'x86_64-linux-gnu' ifTrue:[ ^ self x86_64_linux_gnu ].
	host = 'x86_64-darwin' ifTrue:[ ^ self x86_64_darwin ].
	host = 'x86_64-win32' ifTrue:[ ^self x86_64_win32 ].

	host = 'riscv64-linux-gnu' ifTrue:[ ^ self riscv64_linux_gnu ].

	self error:'Unssuported host: ', host.
! !

!NativizationPlatform class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
x86_64_darwin
	^ self new
		name: 'x86_64-darwin';
		wordSize: 8;
		abi: SysVX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;
		yourself
! !

!NativizationPlatform class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
x86_64_linux_gnu
	^ self new
		name: 'x86_64-linux-gnu';
		wordSize: 8;
		abi: SysVX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;   
		yourself
! !

!NativizationPlatform class methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
x86_64_win32
	^ self new
		name: 'x86_64-win32';
		wordSize: 8;
		abi: WinX64ABI new;
		codeGeneratorClass: AMD64CodeGenerator;   
		yourself
! !

!ABI methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
is32bits
	^self bits = 32
! !

!ABI methodsFor: 'unclassified' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
is64bits
	^self bits = 64
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regA
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regE
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFP
	^ self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regFalse
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regG
	^ self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regIP
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regM
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regNil
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regR
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regS
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regSP
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regT
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regTrue
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regV
	^self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX0
	^ self subclassResponsibility
! !

!ABI methodsFor: 'registers - IR' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
regX1
	^ self subclassResponsibility
! !

!Writer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
closure: anObjectClosure
	closure := anObjectClosure
! !

!Writer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
exports: aDictionary
	exports := aDictionary
! !

!Writer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
image
	^stream contents
! !

!Writer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
imports: anIdentityDictionary
	imports := anIdentityDictionary
! !

!Writer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
mapping: aDictionary
	mapping := aDictionary
! !

!Writer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
objects: aCollection
	objects := aCollection
! !

!Writer methodsFor: 'accessing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
stream: aWriteStream
	stream := aWriteStream
! !

!Writer methodsFor: 'initializing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
initialize
	stream := '' writeStream.
! !

!Writer methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
write
	self subclassResponsibility
! !

!Writer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
writeTo: aStream
	self stream: aStream; write.
! !

!Writer methodsFor: 'writing' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
writeToFile: filename
	filename binaryWriteStreamDo: [ :s | self writeTo: byteStream ]
! !

!MessageInlinerTest methodsFor: 'helpers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
ast: source
	^SCompiler new parse: source
! !

!MessageInlinerTest methodsFor: 'helpers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
cascadeMessagesIn: source
	| ast cascadeMessages |
	ast := self ast: source.
	cascadeMessages := OrderedCollection new.
	ast nodesDo: [:n |
		(n isMessageNode and: [n isCascadeMessage])
			ifTrue: [cascadeMessages add: n]].
	^cascadeMessages
! !

!MessageInlinerTest methodsFor: 'tests - cascade' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testCascadeAndKeywordIsNotInlined
	"Regression: a keyword cascade message such as `at:put:` must not be inlined."
	| messages |
	messages := self cascadeMessagesIn: 'foo
		^Dictionary new at: #a put: 1; at: #b put: 2; yourself'.
	messages do: [:m | self deny: m isInlined]
! !

!MessageInlinerTest methodsFor: 'tests - cascade' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testCascadeIfTrueIsNotInlined
	"Regression: ifTrue: as the first message of a cascade must not be inlined,
	 because the cascade machinery needs the receiver (a Boolean) to receive
	 the subsequent messages. This is the pattern that the original
	 InternalReadStream>>peekFor: relied on:
		^self peek = token ifTrue: [position := position + 1]; yourself"
	| messages |
	messages := self cascadeMessagesIn: 'foo
		^true ifTrue: [42]; yourself'.
	self assert: messages size = 2.
	messages do: [:m | self deny: m isInlined]
! !

!MessageInlinerTest methodsFor: 'tests - cascade' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testCascadeWhileTrueIsNotInlined
	"Regression: whileTrue: in a cascade must not be inlined either."
	| messages |
	messages := self cascadeMessagesIn: 'foo
		^[true] whileTrue: [^1]; yourself'.
	messages do: [:m | self deny: m isInlined]
! !

!MessageInlinerTest methodsFor: 'tests - non-cascade' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testNonCascadeIfTrueIsInlined
	"Sanity check: outside a cascade, ifTrue: is still inlined as expected."
	| ast inlined |
	ast := self ast: 'foo
		^true ifTrue: [42]'.
	inlined := false.
	ast nodesDo: [:n |
		(n isMessageNode and: [n isInlined])
			ifTrue: [inlined := true]].
	self assert: inlined
! !

!SmalltalkScannerTest methodsFor: 'setup' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
setUp
	super setUp.
	scanner := SCompiler new smalltalkScanner
! !

!SmalltalkScannerTest methodsFor: 'numbers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
test0xNotation
	| node |
	node := SCompiler new smalltalkParser parseExpression: '0x10'.
	self assert: node statements first value = 16.
	node := SCompiler new smalltalkParser parseExpression: '0X10'.
	self assert: node statements first value = 16
! !

!SmalltalkScannerTest methodsFor: 'numbers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testFloat
	| node |
	scanner on: '0.1'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 0.1;
		assert: node source = '0.1'.
	scanner on: '0.1e-35'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 0.1e-35;
		assert: node source = '0.1e-35'
! !

!SmalltalkScannerTest methodsFor: 'numbers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testInteger
	| node |
	scanner on: '0 12 -35'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 0;
		assert: node source = '0'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 12;
		assert: node source = '12'.
	node := scanner next.
	self
		deny: node isNumberNode;
		assert: (node is: #'-');
		assert: node source = '-'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 35;
		assert: node source = '35'
! !

!SmalltalkScannerTest methodsFor: 'numbers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testIntegerRadix
	| node |
	scanner on: '16rFA2'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 16rFA2;
		assert: node source = '16rFA2'
! !

!SmalltalkScannerTest methodsFor: 'arrays' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testArrayStart
	| node |
	scanner on: '#()'.
	node := scanner next.
	self
		assert: (node is: #'#(');
		assert: node source = '#('.
	scanner on: '#['.
	node := scanner next.
	self
		assert: (node is: #'#[');
		assert: node source = '#['.
	scanner on: '#''hello'''.
	node := scanner next.
	self
		assert: node value = #hello;
		assert: node source = '#''hello'''
! !

!SmalltalkScannerTest methodsFor: 'strings' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testBinary
	| node |
	scanner on: '-
		--
		---
		==>
		~!!|\/%&*+=><'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'-';
		assert: node source = '-'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'--';
		assert: node source = '--'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'---';
		assert: node source = '---'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'==>';
		assert: node source = '==>'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'~!!|\/%&*+=><';
		assert: node source = '~!!|\/%&*+=><'
! !

!SmalltalkScannerTest methodsFor: 'strings' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testCharacter
	| node |
	scanner on: '$a$b'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = $a;
		assert: node source = '$a'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = $b;
		assert: node source = '$b'
! !

!SmalltalkScannerTest methodsFor: 'strings' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testEmpty
	scanner on: ''.
	self assert: scanner next isEnd
! !

!SmalltalkScannerTest methodsFor: 'strings' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testString
	| node quote |
	scanner on: '' storeString.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = '';
		assert: node source = (String with: $' with: $').
	scanner on: 'Hello World!!' storeString.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = 'Hello World!!';
		assert: node source = 'Hello World!!' storeString.
	quote := String with: $'.
	scanner on: quote storeString.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = quote;
		assert: node source = quote storeString
! !

!SmalltalkScannerTest methodsFor: 'symbols' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testBinarySymbol
	| node |
	scanner on: '#='.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node hasSymbol;
		assert: node value = #'='
! !

!SmalltalkScannerTest methodsFor: 'symbols' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testDashStartingSymbol
	| node |
	scanner on: '#++'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'++';
		assert: node source = '#++'.
	scanner on: '#//'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'//';
		assert: node source = '#//'.
	scanner on: '#--'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'--';
		assert: node source = '#--'.
	scanner on: '#+-'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'+-';
		assert: node source = '#+-'
! !

!SmalltalkScannerTest methodsFor: 'symbols' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testNumericSymbol
	scanner on: '#35'.
	self assert: scanner next value = '35' asSymbol
! !

!SmalltalkScannerTest methodsFor: 'symbols' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testSymbol
	| node |
	scanner on: '#-'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'-';
		assert: node source = '#-'.
	scanner on: '#a:'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #a:;
		assert: node source = '#a:'.
	scanner on: '#-!!'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'-!!';
		assert: node source = '#-!!'.
	scanner on: '#a:b:'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #a:b:;
		assert: node source = '#a:b:'.
	scanner on: '#a:b'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #a:;
		assert: node source = '#a:'.
	node := scanner next.
	self assert: node value = 'b'; assert: node source = 'b'
! !

!SmalltalkScannerTest methodsFor: 'colons' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testColon
	| node |
	scanner on: ':a'.
	node := scanner next.
	self
		assert: (node is: $:);
		assert: node source = ':'.
	node := scanner next.
	self
		assert: node value = 'a';
		assert: node source = 'a'.
	scanner on: ':='.
	node := scanner next.
	self
		assert: node isAssignment;
		assert: node source = ':='
! !

!SmalltalkScannerTest methodsFor: 'colons' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testColon2
	| node |
	scanner on: '::'.
	node := scanner next.
	self
		assert: node class = SStringToken;
		assert: node source = '::'
! !

!SmalltalkScannerTest methodsFor: 'comments' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testComment
	| node |
	scanner on: '"comment"a'.
	node := scanner next.
	self
		assert: node isComment;
		assert: node value = 'comment';
		assert: node source = '"comment"'.
	scanner on: '"comment"'.
	node := scanner next.
	self
		assert: node isComment;
		assert: node source = '"comment"';
		assert: node position = 1.
	scanner on: 'a"comment"'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a';
		assert: node source = 'a'.
	node := scanner next.
	self
		assert: node isComment;
		assert: node position = ('a' size + 1)
! !

!SmalltalkScannerTest methodsFor: 'identifiers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testIdentifier
	| node |
	scanner on: 'a'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a';
		assert: node source = 'a'.
	scanner on: ' a1'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a1';
		assert: node source = 'a1'.
	scanner on: '_a'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = '_a';
		assert: node source = '_a'.
	scanner on: 'a_1b'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a_1b';
		assert: node source = 'a_1b'
! !

!SmalltalkScannerTest methodsFor: 'identifiers' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testKeyword
	| node node2 |
	scanner on: 'a:'.
	node := scanner next.
	self
		assert: node isKeyword;
		assert: node value = 'a:';
		assert: node source = 'a:'.
	scanner on: 'ab:cd:'.
	node := scanner next.
	node2 := scanner next.
	self
		assert: node isKeyword;
		assert: node value = 'ab:';
		assert: node source = 'ab:';
		assert: node2 isKeyword;
		assert: node2 value = 'cd:';
		assert: node2 source = 'cd:'
! !

!SmalltalkScannerTest methodsFor: 'unicode' stamp: 'KenD 28/Jun/2026, 8:27:41 pm (UTC)'!
testUnicodeScanning
	"#knownIssue: depends on Character class>>value: path that resolves UnicodeLibrary,
	 which is not yet defined in the egg Kernel. Re-enable once UnicodeLibrary is ported."
	| next three tensor |
	#knownIssue.
	self assert: false.
	scanner on: '3 + 4' asWideString.
	self assert: scanner next value = 3.
	next := scanner next.
	self
		assert: next value == #'+';
		assert: scanner next value = 4.
	scanner on: '3' asWideString , 8855 asCharacter asString , '4' asWideString.
	three := scanner next.
	self assert: three value = 3.
	tensor := scanner next.
	self assert: tensor value = 8855 asCharacter asString asSymbol
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyFor: aCompiledMethod
	^ NativizationEnvironment forTesting
		newTemplateJIT nativize: aCompiledMethod
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForBlock
	^self assemblyForSource: 'foo [1] value'
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForIfTrue
	^self assemblyForSource: 'foo x ifTrue: [1]' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForMessage
	^self assemblyForSource: 'foo self bar'
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForMessageCascade
	^self assemblyForSource: 'foo self bar; baz'
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForMethod: aCompiledMethod

^	self
		assemblyForSource: aCompiledMethod sourceCode
		in: aCompiledMethod classBinding value.

! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForPoint_1_plus_y
	^self assemblyForSource: 'foo 1 + y' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForPoint_ret_x_eq_1
	^ self assemblyForSource: 'foo ^x = 1' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForPoint_x
	^ self assemblyForMethod: Point >> #x
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForPoint_x_eq_1
	^self assemblyForSource: 'foo x = 1' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForPoint_x_eq_eq_1
	^self assemblyForSource: 'foo x == 1' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForPoint_x_plus_1
	^self assemblyForSource: 'foo x + 1' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForPoint_x_plus_y
	^self assemblyForSource: 'foo x + y' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForSource: aString
	^self assemblyForSource: aString in: UndefinedObject
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForSource: aString in: aSpecies
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self assemblyFor: method
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForSourceOrig: aString
	^self assemblyForSourceOrig: aString in: UndefinedObject
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForSourceOrig: aString in: aSpecies
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self assemblyOrigFor: method
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyForWhileTrue
	^self assemblyForSource: 'foo [x := x + 1. true] whileTrue' in: Point
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
assemblyOrigFor: aCompiledMethod
	^ NativizationEnvironment forTesting nativize:
		  aCompiledMethod
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodBasicAdd
	| source |
	source := 'basicAdd: anObject
	end = contents size ifTrue: [self makeRoomBehind].
	end := end + 1.
	contents at: end put: anObject.
	^anObject'.
	^self methodForSource: source in: OrderedCollection
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodForSource: aString
	^self methodForSource: aString in: UndefinedObject
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodForSource: aString in: aSpecies
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self nativize: method
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
methodWithBlock
	^self methodForSource: 'foo [1] value'
! !

!TemplateJITTest methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:40 pm (UTC)'!
nativize: aCompiledMethod
	^ NativizationEnvironment forTesting newTemplateJIT
		nativize: aCompiledMethod
! !

!SOpNonLocalReturn methodsFor: 'visiting' stamp: 'KenD 28/Jun/2026, 8:27:39 pm (UTC)'!
acceptVisitor: visitor
	^ visitor visitOpNonLocalReturn: self
! !

!LMRProtoObject methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_cachedLookup: aSymbol
	^self _cachedLookup: aSymbol in: self behavior
! !

!LMRProtoObject methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_cachedLookup: aSymbol in: behavior
	^GlobalDispatchCache current lookupAndCache: aSymbol in: behavior
! !

!LMRProtoObject methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_invoke: aNativeCode
	"
	senders of _invoke: MUST have at least 1 temporary. The argument of
	_invoke: is removed twice: once here and once again after returning from
	_invoke. If no temps are present, the second pop smashes the compiled
	method of the frame, which happens to be in the top of the stack. This
	would only be noticed by random crashes when executing debuggable
	methods (because they send a message after _invoke: and before returning)
	"
	^self _transferControlDiscardingLastArgTo: aNativeCode
! !

!LMRProtoObject methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_lookup: aSymbol
	^self _lookup: aSymbol in: self behavior
! !

!LMRProtoObject methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_lookup: aSymbol in: behavior
	| methods cm next |
	methods := behavior _basicAt: 2.
	cm := self _lookup: aSymbol inDictionary: methods.
	cm == nil ifFalse: [^cm].
	next := behavior _basicAt: 3.
	^next == nil ifFalse: [self _lookup: aSymbol in: next]
! !

!LMRProtoObject methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_lookup: aSymbol inDictionary: methodDictionary
	| table |
	table := methodDictionary _basicAt: 2.
	2
		to: table _size
		by: 2
		do: [:j | (table _basicAt: j) == aSymbol ifTrue: [^table _basicAt: j + 1]].
	^nil
! !

!LMRProtoObject methodsFor: 'lookup' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
lookupAndInvoke: aSymbol
	| cm |
	cm := self _cachedLookup: aSymbol.
	cm == nil ifTrue: [^self doesNotUnderstandSelector: aSymbol].
	cm prepareForExecution.
	self _transferControlDiscardingLastArgTo: cm validNativeCodeAddress _asNative
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_flagsMask: mask
	self _basicFlags: (self _basicFlags bitAnd: mask)
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_flagsSet: mask
	self _basicFlags: (self _basicFlags bitOr: mask)
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_hasBeenSeen
	^(self _basicFlags bitAnd: HasBeenSeen) == HasBeenSeen
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_hasNamedSlots
	^(self _basicFlags bitAnd: IsNamed) = IsNamed
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_headerSizeInBytes
	^self _isSmall ifTrue: [8] ifFalse: [16]
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isArrayed
	^false == self _isFixed
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isBytes
	^(self _basicFlags bitAnd: IsBytes) = IsBytes
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isFixed
	^(self _basicFlags bitAnd: IsArrayed) == 0
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isLarge
	^(self _basicFlags bitAnd: IsSmall) == 0
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isProxy
	^self _hasBeenSeen
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isRemembered
	^(self _basicFlags bitAnd: IsRemembered) = IsRemembered
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isSecondGeneration
	^(self _basicFlags bitAnd: IsSecondGeneration) = IsSecondGeneration
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isSmall
	^(self _basicFlags bitAnd: IsSmall) = IsSmall
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_isSpecial
	^(self _basicFlags bitAnd: IsSpecial) = IsSpecial
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_largeSize: size
	self _basicULongAt: _ExtendedSize put: size _asNative
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_makeExtendedSize: size
	self
		_beLarge;
		_smallSize: 4;
		_largeSize: size;
		_basicULongAt: _Reserved put: 0 _asNative
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_nextBasePointer
	^self _asPointer + self _sizeInBytes _asPointer
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_objectFromBasePointer
	| offset |
	offset := (self _asObject _byteAt: 4) > 127 ifTrue: [8] ifFalse: [16].
	^(self + offset _asPointer) _asObject
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_pointersSize
	^self _isBytes ifTrue: [0] ifFalse: [self _size]
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_sizeInBytes
	| total |
	total := self _size.
	^self _isBytes
		ifTrue: [total + WordSize - 1 bitAnd: 0 - WordSize]
		ifFalse: [total * WordSize]
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_strongPointersSize
	^(self _isBytes or: [self _isSpecial]) ifTrue: [0] ifFalse: [0 + self _size]
! !

!LMRProtoObject methodsFor: 'header access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
initializeExtended: aBoolean contentSize: size
	self _basicULongAt: -1 put: 0 _asNative.
	aBoolean
		ifTrue: [
			self
				_smallSize: 4;
				_basicULongAt: _ExtendedSize put: size _asNative;
				_basicULongAt: _Reserved put: 0 _asNative]
		ifFalse: [self _smallSize: size; _beSmall]
! !

!LMRProtoObject methodsFor: 'underprimitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_highHalf
	^self _oop bitShift: WordSize * 8 // -2
! !

!LMRProtoObject methodsFor: 'underprimitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_low32
	^WordSize > 4 ifTrue: [self bitAnd: 0xFFFFFFFF] ifFalse: [self]
! !

!LMRProtoObject methodsFor: 'underprimitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_lowHalf
	^self _oop bitAnd: 16rFFFF
! !

!LMRProtoObject methodsFor: 'underprimitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_oop
	^self _asPointer * 2
! !

!LMRProtoObject methodsFor: 'underprimitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
smallOop
	^self _asPointer
! !

!LMRProtoObject methodsFor: 'raw access' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_uLongAtValidOffset: offset put: anInteger
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
	self _primitiveULongAtOffset: offset put: anInteger.
	^anInteger
! !

!LMRProtoObject methodsFor: 'unwinding' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
_returnTo: aBeeFrame
	[#forceEnvironment].
	aBeeFrame _beCurrent.
	^self
! !

!LMRProtoObject methodsFor: 'system' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allReferences
	^Memory current collectAndCompactOldSpace; referencesTo: self
! !

!LMRProtoObject methodsFor: 'system' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
perform: aSymbol withArguments: anArray
	| size |
	size := anArray basicSize.
	aSymbol arity = size ifFalse: [^self error: 'incorrect arity'].
	anArray _expandInStackSized: size.
	^self lookupAndInvoke: aSymbol
! !

!LMRProtoObject methodsFor: 'services' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
become: anotherObject
	Memory current make: self become: anotherObject
! !

!LMRProtoObject methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
doesNotUnderstandSelector: selector
	| arguments message |
	arguments := StackFrameCursor top moveNext
		argumentsWithArity: selector arity.
	message := Message receiver: self selector: selector arguments: arguments.
	^self doesNotUnderstand: message
! !

!LMRProtoObject methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
holdRefererIfNeeded: referent
	| memory |
	#savePreviousSelf.
	self _isSmallInteger ifTrue: [^self].
	referent _isRemembered ifTrue: [^self].
	memory := Memory current.
	(memory isYoungSafe: referent)
		ifFalse: [(memory isYoungSafe: self) ifTrue: [memory remember: referent]]
! !

!LMRProtoObject methodsFor: 'private' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
shouldBeInRememberedSet
	| m |
	m := Memory current.
	(m isYoung: self) ifTrue: [^false].
	(m isYoung: self behavior) ifTrue: [^true].
	1 to: self _pointersSize do: [:index | | ivar |
		ivar := self _basicAt: index.
		ivar _isSmallInteger ifFalse: [(m isYoung: ivar) ifTrue: [^true]]].
	^false
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
allocate: byteSize size: size
	| headerSize totalSize buffer object extended |
	extended := size > 255.
	headerSize := extended ifTrue: [16] ifFalse: [8].
	totalSize := headerSize + byteSize.
	buffer := self memory allocate: totalSize.
	object := (buffer + headerSize _asPointer) _asObject.
	object
		_basicULongAt: _Behavior put: self instanceBehavior;
		initializeExtended: extended contentSize: size.
	^object
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicNew
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
basicNew: anInteger
	^self primitiveNew: anInteger
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
memory
	^Memory current
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
new: anInteger
	^self primitiveNew: anInteger
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveNew
	^self memory newPointers: instanceBehavior size: self instSize
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveNew: size
	size _isSmallInteger ifFalse: [self error: 'invalid size'].
	self _instancesAreArrayed ifFalse: [self errorNotIndexable].
	^self _instancesHavePointers
		ifTrue: [self primitiveNewPointers: size + self instSize]
		ifFalse: [self primitiveNewBytes: size]
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveNewBytes: size
	^self memory newArrayedBytes: instanceBehavior size: size
! !

!LMRSpecies methodsFor: 'Primitives' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
primitiveNewPointers: size
	^self memory
		newArrayedPointers: instanceBehavior
		size: size
		named: self instSize > 0
! !

!LMRSpecies methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
nil: size slotsOf: object
	object _nilSlots: size
! !

!LMRSpecies methodsFor: 'instance creation' stamp: 'KenD 28/Jun/2026, 8:27:38 pm (UTC)'!
zero: size bytesOf: object
	object _zeroSlots: (size bitShift: 0 - WordSizeShift)
! !
SFFIDescriptor initialize!
Assembler initialize!
