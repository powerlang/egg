#ifndef TREECODE_ENCODER_H
#define TREECODE_ENCODER_H

#include "AST/SParseNode.h"
#include "AST/SParseNodeVisitor.h"
#include "AST/SMethodNode.h"
#include "AST/SBlockNode.h"
#include "AST/SMessageNode.h"
#include "AST/SIdentifierNode.h"
#include "AST/SLiteralNode.h"
#include "AST/SAssignmentNode.h"
#include "AST/SReturnNode.h"
#include "AST/SCascadeNode.h"
#include "AST/SBraceNode.h"
#include "AST/SCascadeMessageNode.h"
#include "AST/SSelectorNode.h"
#include "AST/SNumberNode.h"
#include "AST/SStringNode.h"
#include "AST/SPragmaNode.h"
#include "AST/SCommentNode.h"
#include "Backend/SCompiledMethod.h"
#include "Binding/LocalEnvironment.h"
#include "CompilerTypes.h"
#include <vector>
#include <cstdint>
#include <map>
#include <string>
#include <functional>

namespace Egg {

class SScriptNode;
class LocalEnvironment;

using TreecodeId = AstNodeType;
using BindingId = AstBindingType;

/**
 * TreecodeEncoder converts AST nodes to the Egg treecode format.
 * This is a tree-based intermediate representation used by the Egg runtime.
 */
class TreecodeEncoder : public SParseNodeVisitor {
public:
    TreecodeEncoder();
    
    std::vector<uint8_t> encodeMethod(SMethodNode* method);
    
    void visitMethod_(SMethodNode* node) override;
    void visitBlock_(SBlockNode* node) override;
    void visitMessage_(SMessageNode* node) override;
    void visitIdentifier_(SIdentifierNode* node) override;
    void visitLiteral_(SLiteralNode* node) override;
    void visitAssignment_(SAssignmentNode* node) override;
    void visitReturn_(SReturnNode* node) override;
    void visitCascade_(SCascadeNode* node) override;
    void visitBrace_(SBraceNode* node) override;
    void visitSelector_(SSelectorNode* node) override;
    void visitNumberNode_(SNumberNode* node) override;
    void visitString_(SStringNode* node) override;
    void visitPragma_(SPragmaNode* node) override;
    void visitPrimitivePragma_(SPragmaNode* node) override;
    void visitFFIPragma_(SPragmaNode* node) override;
    void visitSymbolicPragma_(SPragmaNode* node) override;
    void visitComment_(SCommentNode* node) override;
    
    const std::vector<uint8_t>& treecode() const { return stream_; }
    
    void method_(SCompiledMethod* method);
    SCompiledMethod* method() const;
    
    void encodeNil();
    void encodeTrue();
    void encodeFalse();
    void encodeSelf();
    void encodeSuper();
    void encodePushR();
    void encodePopR();
    void encodeDynamicVar_(const Egg::string& name);
    void encodeNestedDynamicVar_(const Egg::string& name);
    void encodeArgument_env_(int index, LocalEnvironment* environment);
    void encodeTemporary_env_(int index, LocalEnvironment* environment);
    std::vector<uint8_t> encodeClosureElements_(SBlockNode* node);
    
private:
    std::vector<uint8_t> stream_;  // Output stream for treecode bytes
    SCompiledMethod* _method;  // The method whose literal pool we index into
    SScriptNode* script_;  // Current script node (for context tracking)
    
    void nextPut(uint8_t byte);
    void nextPutAll(const std::vector<uint8_t>& bytes);
    void nextIntegerPut(int64_t value);
    void nextBigIntegerPut(int64_t value);
    void nextBooleanPut(bool value);
    void nextSymbolPut(const Egg::string& symbol);
    void nextLiteralPut(const Egg::string& literal);
    void nextTypePut(uint8_t typeId);
    
    int encodedEnvironment_(LocalEnvironment* environment);
    
    int compiledBlockIndexOf_(SBlockNode* node);
    
    void visitStatements(const std::vector<SParseNode*>& statements);
    void visitScript_(SScriptNode* node);
    

};

} // namespace Egg

#endif // TREECODE_ENCODER_H
