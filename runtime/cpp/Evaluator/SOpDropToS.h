#ifndef _SOPDROPTOS_H_
#define _SOPDROPTOS_H_

#include "SOperation.h"

namespace Egg {

class SOpDropToS : public SOperation {
    size_t _count;
    public:

    SOpDropToS(auto count) : _count(count) {}
	void acceptVisitor_(SExpressionVisitor *visitor) override {
		visitor->visitOpDropToS(this);
	}

    size_t count() {
        return _count;
    }
};

} // namespace Egg

#endif // ~ _SOPDROPTOS_H_ ~
