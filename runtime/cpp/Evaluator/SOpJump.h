#ifndef _SOPJUMP_H_
#define _SOPJUMP_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpJump : public SOperation {
	size_t _target;

public:
	SOpJump(size_t target) : _target(target) { }
	SOpJump() : _target(0xFFFFFFFF) { }


	void acceptVisitor_(SExpressionVisitor *visitor) override {
		visitor->visitOpJump(this);
	}

	size_t target() {
		return this->_target;
	}

	void target_(size_t anInteger) {
		this->_target = anInteger;
	}


};

} // namespace Egg

#endif // ~ _SOPJUMP_H_ ~
