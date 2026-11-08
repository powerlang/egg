/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
*/
#ifndef _PSEUDOVARIABLEBINDINGS_H_
#define _PSEUDOVARIABLEBINDINGS_H_
#include "Binding.h"
#include "../AST/SScriptNode.h"
#include <vector>

namespace Egg {

class TreecodeEncoder;

class NilBinding : public Binding {
public:
    NilBinding() : Binding(Kind::Constant, "nil", 0) {}
    bool isLiteral() const override { return true; }
    
    void encodeUsing_(TreecodeEncoder* encoder) override;
    
    Binding* copy_() override {
        return new NilBinding();
    }
};

class TrueBinding : public Binding {
public:
    TrueBinding() : Binding(Kind::Constant, "true", 0) {}
    bool isLiteral() const override { return true; }
    
    void encodeUsing_(TreecodeEncoder* encoder) override;
    
    Binding* copy_() override {
        return new TrueBinding();
    }
};

class FalseBinding : public Binding {
public:
    FalseBinding() : Binding(Kind::Constant, "false", 0) {}
    bool isLiteral() const override { return true; }
    
    void encodeUsing_(TreecodeEncoder* encoder) override;
    
    Binding* copy_() override {
        return new FalseBinding();
    }
};

class SelfBinding : public Binding {
public:
    SelfBinding() : Binding(Kind::Argument, "self", 0) {}
    bool canBeAssigned() const override { return false; }
    
    void beReferencedFrom_(SScriptNode* aScriptNode) override;
    
    void encodeUsing_(TreecodeEncoder* encoder) override;
    
    Binding* copy_() override {
        return new SelfBinding();
    }
};

class SuperBinding : public Binding {
public:
    SuperBinding() : Binding(Kind::Argument, "super", 0) {}
    bool canBeAssigned() const override { return false; }
    
    void beReferencedFrom_(SScriptNode* aScriptNode) override;
    
    void encodeUsing_(TreecodeEncoder* encoder) override;
    
    Binding* copy_() override {
        return new SuperBinding();
    }
};

class DynamicBinding : public Binding {
public:
    DynamicBinding(const Egg::string& name) 
        : Binding(Kind::Global, name, 0) {}
    
    static DynamicBinding* named_(const Egg::string& name);
    
    bool isDynamic() const override { return true; }
    
    void beReferencedFrom_(SScriptNode* aScriptNode) override;
    
    void encodeUsing_(TreecodeEncoder* encoder) override;
    
    std::optional<LiteralValue> literal() const override { return LiteralValue::fromSymbol(name()); }
    
    Binding* copy_() override {
        return new DynamicBinding(name());
    }
};

class NestedDynamicBinding : public DynamicBinding {
private:
    std::vector<Egg::string> _names;
    
public:
    NestedDynamicBinding(const std::vector<Egg::string>& names) 
        : DynamicBinding(buildCompositeName(names)), _names(names) {}
    
    const std::vector<Egg::string>& names() const { return _names; }
    
    void encodeUsing_(TreecodeEncoder* encoder) override;

    std::optional<LiteralValue> literal() const override {
        std::vector<LiteralValue> symbols;
        for (const auto& name : _names)
            symbols.push_back(LiteralValue::fromSymbol(name));
        return LiteralValue::fromArray(symbols);
    }
    
    Binding* copy_() override {
        return new NestedDynamicBinding(_names);
    }
    
private:
    static Egg::string buildCompositeName(const std::vector<Egg::string>& names) {
        Egg::string result;
        for (size_t i = 0; i < names.size(); ++i) {
            if (i > 0) result += ".";
            result += names[i];
        }
        return result;
    }
};

} // namespace Egg

#endif // _PSEUDOVARIABLEBINDINGS_H_
