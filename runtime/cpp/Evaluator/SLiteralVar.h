#ifndef _SLITERALVAR_H_
#define _SLITERALVAR_H_

#include "SExpression.h"

namespace Egg {

class SLiteralVar : public SExpression {

    int64_t _index;

public:
    SLiteralVar(int64_t index) : _index(index) {}

    int64_t index() const {
        return _index;
    }

    SLiteralVar* index_(int64_t anInteger) {
        _index = anInteger;
        return this;
    }

};

} // namespace Egg

#endif // ~ _SLITERALVAR_H_ ~
