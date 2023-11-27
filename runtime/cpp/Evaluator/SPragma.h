#ifndef _SPRAGMA_H_
#define _SPRAGMA_H_

#include "SExpression.h"

namespace Egg {

class SPragma : public SExpression {
public:
    std::string _name;

    SPragma() {
        _name = nullptr;
    }

    const std::string& name() const {
        return _name;
    }

    SPragma* name(const std::string& aString) {
        _name = aString;
        return this;
    }

};

} // namespace Egg

#endif // ~ _SPRAGMA_H_ ~
