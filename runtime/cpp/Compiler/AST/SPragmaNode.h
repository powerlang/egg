/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _PRAGMA_NODE_H_
#define _PRAGMA_NODE_H_

#include <vector>
#include "SParseNode.h"
#include <string>

namespace Egg {

/**
 * Pragma node (<primitive: 1>)
 * Corresponds to SPragmaNode in Smalltalk
 */
class SPragmaNode : public SParseNode {
public:
    enum class Type {
        None,
        Primitive,
        FFI,
        Symbolic
    };
    
private:
    Type _type;
    Egg::string _name;
    int _primitiveNumber; // For primitive pragmas
    void* _info; // For FFI descriptors (placeholder for now)
    std::vector<uint8_t> _ffiDescriptor;
    
public:
    SPragmaNode(SSmalltalkCompiler* compiler) 
        : SParseNode(compiler), _type(Type::None), _primitiveNumber(0), _info(nullptr) {}
    virtual ~SPragmaNode() {}
    
    void acceptVisitor_(SParseNodeVisitor* visitor) override;
    
    Type type() const { return _type; }
    void type_(Type t) { _type = t; }
    
    Egg::string name() const { return _name; }
    void name_(const Egg::string& n) { _name = n; }
    
    int primitiveNumber() const { return _primitiveNumber; }
    void primitiveNumber_(int n) { _primitiveNumber = n; }
    
    void* info() const { return _info; }
    void info_(void* i) { _info = i; }
    
    bool isPragma() const override { return true; }
    bool isPrimitive() const { return _type == Type::Primitive; }
    bool isFFI() const { return _type == Type::FFI; }
    bool isSymbolic() const { return _type == Type::Symbolic; }
    bool isUsed() const { return _type != Type::None; }
    
    void bePrimitive_(int number, const Egg::string& name) {
        _type = Type::Primitive;
        _primitiveNumber = number;
        _name = name;
    }
    
    void beFFI_(const Egg::string& name, void* descriptor) {
        _type = Type::FFI;
        _name = name;
        _info = descriptor;
    }
    
    const std::vector<uint8_t>& ffiDescriptor() const { return _ffiDescriptor; }
    void ffiDescriptor_(const std::vector<uint8_t>& bytes) { _ffiDescriptor = bytes; }

    void beSymbolic_(const Egg::string& symbol) {
        _type = Type::Symbolic;
        _name = symbol;
    }
};

} // namespace Egg

#endif // _PRAGMA_NODE_H_
