#ifndef _SOPJUMPFALSE_H_
#define _SOPJUMPFALSE_H_

#include "SOpJump.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpJumpFalse : public SOpJump {
public:
	SOpJumpFalse(size_t target) : SOpJump(target) { }
	SOpJumpFalse() : SOpJump() { }

	void acceptVisitor_(SExpressionVisitor *visitor) override {
		visitor->visitOpJumpFalse(this);
	}
};

} // namespace Egg

#endif // ~ _SOPJUMPFALSE_H_ ~
