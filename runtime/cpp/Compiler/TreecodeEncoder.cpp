#include "TreecodeEncoder.h"
#include "AST/SParseNode.h"
#include "AST/SScriptNode.h"
#include "Binding/LocalBinding.h"
#include "Binding/ArrayEnvironment.h"
#include "Binding/BlockScope.h"
#include <stdexcept>
#include <cstring>

namespace Egg {

TreecodeEncoder::TreecodeEncoder() : _method(nullptr), script_(nullptr) {
}

void TreecodeEncoder::method_(SCompiledMethod* method) {
    _method = method;
}

SCompiledMethod* TreecodeEncoder::method() const {
    return _method;
}

std::vector<uint8_t> TreecodeEncoder::encodeMethod(SMethodNode* method) {
    stream_.clear();
    visitMethod_(method);
    return stream_;
}

void TreecodeEncoder::visitMethod_(SMethodNode* node) {
    nextTypePut(MethodId);
    
    if (node->pragma() && node->pragma()->isUsed()) {
        nextTypePut(PragmaId);
        const Egg::string& pragmaName = node->pragma()->name();
        if (!pragmaName.empty()) {
            nextSymbolPut(pragmaName);
        } else {
            nextPut(0);
        }
    }
    
    visitScript_(node);
}

void TreecodeEncoder::visitBlock_(SBlockNode* node) {
    nextTypePut(BlockId);
    
    bool inlined = node->isInlined();
    nextBooleanPut(inlined);
    
    if (inlined) {
        const auto& args = node->arguments();
        std::vector<uint8_t> argIndices;
        for (auto* arg : args) {
            if (auto* idNode = dynamic_cast<SIdentifierNode*>(arg)) {
                if (auto* localBinding = dynamic_cast<LocalBinding*>(idNode->binding())) {
                    argIndices.push_back(static_cast<uint8_t>(localBinding->index()));
                }
            }
        }
        nextPutAll(argIndices);
    } else {
        int index = compiledBlockIndexOf_(node);
        nextPut(static_cast<uint8_t>(index));
        
        std::vector<uint8_t> captured = encodeClosureElements_(node);
        nextPutAll(captured);
    }
    
    visitScript_(node);
}

void TreecodeEncoder::visitMessage_(SMessageNode* node) {
    nextTypePut(MessageId);
    
    nextBooleanPut(node->isInlined());
    
    Egg::string selectorStr = node->selector()->symbol();
    nextSymbolPut(selectorStr);
    
    if (node->receiver()) {
        node->receiver()->acceptVisitor_(this);
    }
    
    const auto& args = node->arguments();
    nextIntegerPut(args.size());
    for (auto* arg : args) {
        if (arg) {
            arg->acceptVisitor_(this);
        }
    }
}

void TreecodeEncoder::visitIdentifier_(SIdentifierNode* node) {
    nextTypePut(IdentifierId);
    
    if (node->binding()) {
        node->binding()->encodeUsing_(this);
    } else {
        // No binding resolved — check for pseudo variables first
        auto name = node->name();
        if (name == "self") {
            encodeSelf();
        } else if (name == "super") {
            encodeSuper();
        } else if (name == "nil") {
            encodeNil();
        } else if (name == "true") {
            encodeTrue();
        } else if (name == "false") {
            encodeFalse();
        } else {
            encodeDynamicVar_(name);
        }
    }
}

void TreecodeEncoder::visitLiteral_(SLiteralNode* node) {
    const auto& lv = node->literalValue();
    int index = _method->indexOf(lv);
    nextTypePut(LiteralId);
    nextIntegerPut(index);
    if (index == 0) {
        nextIntegerPut(lv.intVal);
    }
}

void TreecodeEncoder::visitAssignment_(SAssignmentNode* node) {
    nextTypePut(AssignmentId);
    
    const auto& assignees = node->assignees();
    nextIntegerPut(assignees.size());
    
    for (auto* assignee : assignees) {
        if (assignee) {
            assignee->acceptVisitor_(this);
        }
    }
    
    if (node->expression()) {
        node->expression()->acceptVisitor_(this);
    }
}

void TreecodeEncoder::visitReturn_(SReturnNode* node) {
    nextTypePut(ReturnId);
    
    bool isMethod = script_ && script_->realScript()->isMethod();
    nextBooleanPut(isMethod);
    
    if (node->expression()) {
        node->expression()->acceptVisitor_(this);
    }
}

void TreecodeEncoder::visitCascade_(SCascadeNode* node) {
    nextTypePut(CascadeId);
    
    if (node->receiver()) {
        node->receiver()->acceptVisitor_(this);
    }
    
    const auto& messages = node->messages();
    nextIntegerPut(messages.size());
    
    for (auto* msg : messages) {
        Egg::string selectorStr = msg->selector()->symbol();
       
        nextSymbolPut(selectorStr);
        
        const auto& args = msg->arguments();
        nextIntegerPut(args.size());
        for (auto* arg : args) {
            if (arg) {
                arg->acceptVisitor_(this);
            }
        }
    }
}

void TreecodeEncoder::visitStatements(const std::vector<SParseNode*>& statements) {
    nextIntegerPut(statements.size());
    for (auto* stmt : statements) {
        if (stmt) {
            stmt->acceptVisitor_(this);
        }
    }
}

void TreecodeEncoder::visitScript_(SScriptNode* node) {
    SScriptNode* prev = script_;
    script_ = node;
    
    const auto& statements = node->statements();
    nextIntegerPut(statements.size());
    for (auto* stmt : statements) {
        if (stmt) {
            stmt->acceptVisitor_(this);
        }
    }
    
    script_ = prev;
}

void TreecodeEncoder::visitBrace_(SBraceNode* node) {
    auto cascadeNode = dynamic_cast<SCascadeNode*>(node->asSMessageNode());
    if (cascadeNode) {
        visitCascade_(cascadeNode);
    } else {
        nextTypePut(BraceId);
    }
}

void TreecodeEncoder::nextPut(uint8_t byte) {
    stream_.push_back(byte);
}

void TreecodeEncoder::nextPutAll(const std::vector<uint8_t>& bytes) {
    nextIntegerPut(bytes.size());
    stream_.insert(stream_.end(), bytes.begin(), bytes.end());
}

void TreecodeEncoder::nextIntegerPut(int64_t value) {
    if (value > 127 || value < -127) {
        nextBigIntegerPut(value);
        return;
    }
    
    uint8_t byte = (value >= 0) ? value : (value + 0x100);
    nextPut(byte);
}

void TreecodeEncoder::nextBigIntegerPut(int64_t value) {
    nextPut(0x80);
    
    for (int i = 7; i >= 0; i--) {
        nextPut((value >> (i * 8)) & 0xFF);
    }
}

void TreecodeEncoder::nextBooleanPut(bool value) {
    nextPut(value ? 1 : 0);
}

void TreecodeEncoder::nextSymbolPut(const Egg::string& symbol) {
    auto symLv = LiteralValue::fromSymbol(symbol);
    int index = _method->indexOf(symLv);
    ASSERT(index != 0);
    nextIntegerPut(index);
}

void TreecodeEncoder::nextLiteralPut(const Egg::string& literal) {
    auto litLv = LiteralValue::fromString(literal);
    int index = _method->indexOf(litLv);
    ASSERT(index != 0);
    nextIntegerPut(index);
}

void TreecodeEncoder::nextTypePut(uint8_t typeId) {
    nextPut(typeId);
}

void TreecodeEncoder::visitSelector_(SSelectorNode* node) {
    nextSymbolPut(node->symbol());
}

void TreecodeEncoder::visitNumberNode_(SNumberNode* node) {
    visitLiteral_(node);
}

void TreecodeEncoder::visitString_(SStringNode* node) {
    visitLiteral_(node);
}


void TreecodeEncoder::visitPragma_(SPragmaNode* node) {
    nextTypePut(PragmaId);
    
    if (node->isPrimitive()) {
        nextIntegerPut(static_cast<int>(SPragmaNode::Type::Primitive));
        nextIntegerPut(node->primitiveNumber());
        nextSymbolPut(node->name());
    } else if (node->isFFI()) {
        nextIntegerPut(static_cast<int>(SPragmaNode::Type::FFI));
        nextSymbolPut(node->name());
    } else if (node->isSymbolic()) {
        nextIntegerPut(static_cast<int>(SPragmaNode::Type::Symbolic));
        nextSymbolPut(node->name());
    }
}

void TreecodeEncoder::visitPrimitivePragma_(SPragmaNode* node) {
    visitPragma_(node);
}

void TreecodeEncoder::visitFFIPragma_(SPragmaNode* node) {
    visitPragma_(node);
}

void TreecodeEncoder::visitSymbolicPragma_(SPragmaNode* node) {
    visitPragma_(node);
}

void TreecodeEncoder::visitComment_(SCommentNode* node) {
}


void TreecodeEncoder::encodeNil() {
    stream_.push_back(NilBindingId);
}

void TreecodeEncoder::encodeTrue() {
    stream_.push_back(TrueBindingId);
}

void TreecodeEncoder::encodeFalse() {
    stream_.push_back(FalseBindingId);
}

void TreecodeEncoder::encodeSelf() {
    stream_.push_back(SelfBindingId);
}

void TreecodeEncoder::encodeSuper() {
    stream_.push_back(SuperBindingId);
}

void TreecodeEncoder::encodePushR() {
    stream_.push_back(PushRid);
}

void TreecodeEncoder::encodePopR() {
    stream_.push_back(PopRid);
}

void TreecodeEncoder::encodeDynamicVar_(const Egg::string& name) {
    stream_.push_back(DynamicVarId);
    nextSymbolPut(name);
}

void TreecodeEncoder::encodeNestedDynamicVar_(const Egg::string& name) {
    stream_.push_back(NestedDynamicVarId);
    nextLiteralPut(name);
}

void TreecodeEncoder::encodeArgument_env_(int index, LocalEnvironment* environment) {
    int encoded = encodedEnvironment_(environment);
    nextPut(ArgumentBindingId);
    nextIntegerPut(index);
    nextIntegerPut(encoded);
}

void TreecodeEncoder::encodeTemporary_env_(int index, LocalEnvironment* environment) {
    int encoded = encodedEnvironment_(environment);
    nextPut(TemporaryBindingId);
    nextIntegerPut(index);
    nextIntegerPut(encoded);
}

int TreecodeEncoder::encodedEnvironment_(LocalEnvironment* environment) {
    if (environment->isStack()) {
        return environment->isInlinedArgument() ? -1 : -2;
    }
    
    auto arrayEnv = dynamic_cast<ArrayEnvironment*>(environment);
    if (arrayEnv && arrayEnv->isCurrent()) {
        return 0;
    }
    
    int* indexPtr = environment->index();
    return indexPtr ? *indexPtr : 0;
}

std::vector<uint8_t> TreecodeEncoder::encodeClosureElements_(SBlockNode* node) {
    std::vector<uint8_t> result;
    
    auto scope = dynamic_cast<BlockScope*>(node->scope());
    if (!scope) return result;
    
    auto parent = node->parent()->realScript();
    
    if (scope->capturesSelf()) {
        result.push_back(ClosureSelf);
    }
    
    auto capturedEnvs = scope->capturedEnvironments_();
    for (auto* env : capturedEnvs) {
        if (env == parent) {
            result.push_back(ClosureEnvironment);
        } else {
            // the closure is built in the parent's context, so use the parent's layout
            int* idx = parent->scope()->environmentIndexOf_(dynamic_cast<SScriptNode*>(env));
            if (idx) {
                result.push_back(ClosureEnvironmentValue);
                result.push_back(static_cast<uint8_t>(*idx));
            }
        }
    }
    
    auto capturedArgs = scope->capturedArguments_();
    for (auto* binding : capturedArgs) {
        // Resolve from parent scope to get original binding (matches Smalltalk:
        // binding := aBlockNode parent scope resolve: a name)
        auto parentBinding = node->parent()->scope()->resolve_(binding->name());
        if (auto* localBinding = dynamic_cast<LocalBinding*>(parentBinding)) {
            result.push_back(localBinding->environmentObject()->captureType());
            result.push_back(static_cast<uint8_t>(localBinding->index()));
        }
    }
    
    return result;
}

int TreecodeEncoder::compiledBlockIndexOf_(SBlockNode* node) {
    // Search the method's literals for a Block literal with matching id
    // (matches Smalltalk's compiledBlockIndexOf: which searches method's pool)
    int blockId = node->index();
    const auto& literals = _method->literals();
    for (size_t i = 0; i < literals.size(); i++) {
        if (literals[i].isBlock() && literals[i].asBlock().id == blockId) {
            return i + 1; // 1-based index
        }
    }
    throw std::runtime_error("TreecodeEncoder: block not found in method pool");
}

} // namespace Egg
