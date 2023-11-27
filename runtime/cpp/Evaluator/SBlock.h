#ifndef _SBLOCK_H_
#define _SBLOCK_H_

#include "SScript.h"
#include "SExpressionVisitor.h"

namespace Egg {


class SBlock : public SScript {
    int _index;
    std::vector<SExpression*> _capturedVariables;
    std::vector<SArgumentBinding*> _inlinedArgs;
public:

    SBlock(int index) : _index(index) {
        _index = 0;
    }

    void acceptVisitor(SExpressionVisitor* visitor) override {
        visitor->visitBlock(this);
    }

    const std::vector<SExpression*>& capturedVariables() const {
        return _capturedVariables;
    }

    SBlock* capturedVariables(const std::vector<SExpression*>& aCollection) {
        _capturedVariables = aCollection;
        return this;
    }

    bool capturesHome() const {
        return compiledCode()->capturesHome();
    }

    int index() const {
        return _index;
    }

    void index(int anInteger) {
        _index = anInteger;
    }

    SBlock* initialize() {
        _capturedVariables = {};
        return this;
    }

    auto inlinedArgs() const {
        return _inlinedArgs;
    }

    void inlinedArgs(auto anArray) {
        _inlinedArgs = anArray;
    }

    bool isBlock() const override {
        return true;
    }

    bool isInlined() const {
        return compiledCode() == nullptr;
    }

    int offsetOfCurrentEnvironment() const {
        return 2;
    }

    HeapObject* executableCode() const {
        return compiledCode()->executableCode();
    }

};

} // namespace Egg

#endif // ~ _SBLOCK_H_ ~
