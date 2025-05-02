#ifndef _SLITERALBINDING_H_
#define _SLITERALBINDING_H_

#include "SBinding.h"
#include "../HeapObject.h"

namespace Egg {

class SLiteralBinding : public SBinding {
public:

    bool isLiteral() const override {
        return true;
    }
};

} // namespace Egg

#endif // ~ _SLITERALBINDING_H_ ~
