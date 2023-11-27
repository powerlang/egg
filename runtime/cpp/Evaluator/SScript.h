#ifndef _SSCRIPT_H_
#define _SSCRIPT_H_

#include <vector>
#include "SExpression.h"
#include "../HeapObject.h"

namespace Egg {

class SScript : public SExpression {
public:
    std::vector<SExpression*> _statements;
    HeapObject* _compiledCode;

    SScript() {
        _statements = {};
        _compiledCode = nullptr;
    }

    HeapObject* compiledCode() {
        return _compiledCode;
    }

    SScript* compiledCode(HeapObject* anObject) {
        _compiledCode = anObject;
        return this;
    }

    const std::vector<SExpression*>& statements() const {
        return _statements;
    }

    SScript* statements(const std::vector<SExpression*>& aCollection) {
        _statements = aCollection;
        return this;
    }
};

} // namespace Egg

#endif // ~ _SSCRIPT_H_ ~
