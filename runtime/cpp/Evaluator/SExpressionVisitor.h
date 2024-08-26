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
    virtual void visitAssignment(SAssignment *assignment) = 0;
    virtual void visitExpression(SExpression *expression) { ASSERT(false); };
    virtual void visitIdentifier(SIdentifier *identifier) = 0;
    virtual void visitReturn(SReturn *sReturn) = 0;
    virtual void visitPragma(SPragma *sPragma) { ASSERT(false); };
    virtual void visitCascade(SCascade *sCascade) = 0;
    virtual void visitCascadeMessage(SCascadeMessage *cascadeMessage) { ASSERT(false); };
    virtual void visitMethod(SMethod *sMethod) = 0;
    virtual void visitLiteral(SLiteral *sLiteral) = 0;
    virtual void visitBlock(SBlock *sBlock) = 0;

    // these types are only needed when inlining and/or linearization are used
    virtual void visitOpAssign(SOpAssign *sOpAssign) { ASSERT(false); };
    virtual void visitOpDispatchMessage(SOpDispatchMessage *sOpDispatchMessage) { ASSERT(false); };
    virtual void visitOpDropToS(SOpDropToS *sOpDropToS) { ASSERT(false); };
    virtual void visitOpJump(SOpJump *sOpJump) { ASSERT(false); };
    virtual void visitOpJumpFalse(SOpJumpFalse *sOpJumpFalse) { ASSERT(false); };
    virtual void visitOpJumpTrue(SOpJumpTrue *sOpJumpFalse) { ASSERT(false); };
    virtual void visitOpLoadRfromFrame(SOpLoadRfromFrame *sOpLoadRfromFrame) { ASSERT(false); };
    virtual void visitOpLoadRfromStack(SOpLoadRfromStack *sOpLoadRfromStack) { ASSERT(false); };
    virtual void visitOpLoadRwithNil(SOpLoadRwithNil *sOpLoadRwithNil) { ASSERT(false); };
    virtual void visitOpLoadRwithSelf(SOpLoadRwithSelf *sOpLoadRwithSelf) { ASSERT(false); };
    virtual void visitOpPrimitive(SOpPrimitive *sOpPrimitive) { ASSERT(false); };
    virtual void visitOpPopR(SOpPopR *sOpPopR) { ASSERT(false); };
    virtual void visitOpPushR(SOpPushR *sOpPushR) { ASSERT(false); };
    virtual void visitOpReturn(SOpReturn *sOpReturn) { ASSERT(false); };
    virtual void visitOpNonLocalReturn(SOpNonLocalReturn *sOpNonLocalReturn) { ASSERT(false); };

};

} // namespace Egg

#endif // ~ _SEXPRESSIONVISITOR_H_ ~
