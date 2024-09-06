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
        _compiledCode = nullptr;
    }

    HeapObject* compiledCode() {
        return _compiledCode;
    }

    void compiledCode_(HeapObject* anObject) {
        _compiledCode = anObject;
    }

    std::vector<SExpression*>& statements() {
        return _statements;
    }

    void statements_(const std::vector<SExpression*>& aCollection) {
        _statements = aCollection;
    }
};

} // namespace Egg

#endif // ~ _SSCRIPT_H_ ~
