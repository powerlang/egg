#ifndef _SOPJUMPTRUE_H_
#define _SOPJUMPTRUE_H_

#include "SOpJump.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpJumpTrue : public SOpJump {
public:
	SOpJumpTrue(size_t target) : SOpJump(target) { }

	void acceptVisitor_(SExpressionVisitor *visitor) override {
		visitor->visitOpJumpTrue(this);
	}
};

} // namespace Egg

#endif // ~ _SOPJUMPTRUE_H_ ~
