"
	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #OCompilerModule,
	#superclass : #Module,
	#category : #OCompiler
}

{ #category : #spec }
OCompilerModule >> imports [
	^{
		#Kernel -> #(Array Association ByteArray CharacterArray CompiledBlock CompiledMethod Error Object OrderedCollection Dictionary IdentityDictionary ProtoObject Species String).
		#'Kernel.LMR' -> #(LMRProtoObject LMRSpecies).
		#LMR -> #(BindSite GCSpace NativeCode SendSite).
		#'LMR.SExpressions' -> #(STemporaryBinding).
		#'LMR.Nativizer.Assembly.Intel' -> #(AMD64CodeGenerator AMD64TemplateAssembler Register).
		#'LMR.Nativizer.Assembly' -> #(GenericAssembler).
		#'LMR.Nativizer.OCompiler.IR' -> #(OBasicBlock OBeginInstruction OEndInstruction OInstruction OMessageSend OActivationContext OValue OOperand OVariable OReadVariable OWriteVariable OReturn OJump OJumpTrue OJumpFalse OJumpConditional OConstant OLoadConstant OLoadImplicit ODefineArgument OTemporary OBlockParameter OLiveRange OComposedLiveRange OSimpleLiveRange OTiling OPrimitiveOperation OBinaryOperation OBinaryConstantOperation OBinaryVariableOperation OTernaryOperation OUnaryOperation OBlockClosure OUseVariable)
	}
]
