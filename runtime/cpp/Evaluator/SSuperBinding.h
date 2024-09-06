#ifndef _SSUPERBINDING_H_
#define _SSUPERBINDING_H_

#include "SSelfBinding.h"
#include "KnownObjects.h"
#include "EvaluationContext.h"

namespace Egg {

class SSuperBinding : public SSelfBinding {
public:
    bool isSelf() const override {
        return false;
    }

    bool isSuper() const override {
        return true;
    }
};


} // namespace Egg

#endif // ~ _SSUPERBINDING_H_ ~
