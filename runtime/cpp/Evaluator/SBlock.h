#ifndef _SBLOCK_H_
#define _SBLOCK_H_

#include "SScript.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SArgumentBinding;

class SBlock : public SScript {
    int _index;
    std::vector<uint8_t> _capturedVariables;
    std::vector<uint8_t> _inlinedArgs;
public:

    SBlock()
        { _index = 0; }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitBlock(this);
    }

    const std::vector<uint8_t>& capturedVariables() const {
        return _capturedVariables;
    }

    SBlock* capturedVariables_(const std::vector<uint8_t>& aCollection) {
        _capturedVariables = aCollection;
        return this;
    }

    int index() const {
        return _index;
    }

    void index_(int anInteger) {
        _index = anInteger;
    }

    SBlock* initialize() {
        _capturedVariables = {};
        return this;
    }

    auto inlinedArgs() const {
        return _inlinedArgs;
    }

    void inlinedArgs_(auto anArray) {
        _inlinedArgs = anArray;
    }

    bool isBlock() const override {
        return true;
    }

    bool isInlined() const {
   		return _compiledCode == nullptr;
    }

    int offsetOfCurrentEnvironment() const {
        return 2;
    }

};

} // namespace Egg

#endif // ~ _SBLOCK_H_ ~
