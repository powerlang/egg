#ifndef _SEXPRESSIONVISITOR_H_
#define _SEXPRESSIONVISITOR_H_

#include "SExpression.h"

namespace Egg {

class SAssignment;
class SExpression;
class SIdentifier;
class SReturn;
class SPragma;
class SCascade;
class SCascadeMessage;
class SMethod;
class SLiteral;
class SLiteralVar;
class SBlock;

class SOpAssign;
class SOpDispatchMessage;
class SOpDropToS;
class SOpJump;
class SOpJumpFalse;
class SOpJumpTrue;
class SOpLoadRfromFrame;
class SOpLoadRfromStack;
class SOpLoadRwithNil;
class SOpLoadRwithSelf;
class SOpPrimitive;
class SOpPopR;
class SOpPushR;
class SOpReturn;
class SOpNonLocalReturn;

class SExpressionVisitor {
public:
    // Pure virtual methods for each SExpression subclass
    virtual void visitAssignment(SAssignment *assignment) { ASSERT(false); };
    virtual void visitExpression(SExpression *expression) { ASSERT(false); };
    virtual void visitIdentifier(SIdentifier *identifier) = 0;
    virtual void visitReturn(SReturn *anSReturn) { ASSERT(false); };
    virtual void visitPragma(SPragma *anSPragma) { ASSERT(false); };
    virtual void visitCascade(SCascade *anSCascade) { ASSERT(false); };
    virtual void visitCascadeMessage(SCascadeMessage *cascadeMessage) { ASSERT(false); };
    virtual void visitMethod(SMethod *anSMethod) { ASSERT(false); };
    virtual void visitLiteral(SLiteral *anSLiteral) = 0;
    virtual void visitBlock(SBlock *anSBlock) { ASSERT(false); };

    // these types are only needed when inlining and/or linearization are used
    virtual void visitOpAssign(SOpAssign *anSOpAssign) { ASSERT(false); };
    virtual void visitOpDispatchMessage(SOpDispatchMessage *anSOpDispatchMessage) { ASSERT(false); };
    virtual void visitOpDropToS(SOpDropToS *anSOpDropToS) { ASSERT(false); };
    virtual void visitOpJump(SOpJump *anSOpJump) { ASSERT(false); };
    virtual void visitOpJumpFalse(SOpJumpFalse *anSOpJumpFalse) { ASSERT(false); };
    virtual void visitOpJumpTrue(SOpJumpTrue *anSOpJumpTrue) { ASSERT(false); };
    virtual void visitOpLoadRfromFrame(SOpLoadRfromFrame *anSOpLoadRfromFrame) { ASSERT(false); };
    virtual void visitOpLoadRfromStack(SOpLoadRfromStack *anSOpLoadRfromStack) { ASSERT(false); };
    virtual void visitOpLoadRwithNil(SOpLoadRwithNil *anSOpLoadRwithNil) { ASSERT(false); };
    virtual void visitOpLoadRwithSelf(SOpLoadRwithSelf *anSOpLoadRwithSelf) { ASSERT(false); };
    virtual void visitOpPrimitive(SOpPrimitive *anSOpPrimitive) { ASSERT(false); };
    virtual void visitOpPopR(SOpPopR *anSOpPopR) { ASSERT(false); };
    virtual void visitOpPushR(SOpPushR *anSOpPushR) { ASSERT(false); };
    virtual void visitOpReturn(SOpReturn *anSOpReturn) { ASSERT(false); };
    virtual void visitOpNonLocalReturn(SOpNonLocalReturn *anSOpNonLocalReturn) { ASSERT(false); };

};

} // namespace Egg

#endif // ~ _SEXPRESSIONVISITOR_H_ ~
