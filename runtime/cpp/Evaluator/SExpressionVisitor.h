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

class SExpressionVisitor {
public:
    // Pure virtual methods for each SExpression subclass
    virtual void visitAssignment(SAssignment* assignment) = 0;
    virtual void visitExpression(SExpression* expression) = 0;
    virtual void visitIdentifier(SIdentifier* identifier) = 0;
    virtual void visitReturn(SReturn* sReturn) = 0;
    virtual void visitPragma(SPragma* sPragma) = 0;
    virtual void visitCascade(SCascade* sCascade) = 0;
    virtual void visitCascadeMessage(SCascadeMessage* cascadeMessage) = 0;
    virtual void visitMethod(SMethod* sMethod) = 0;
    virtual void visitLiteral(SLiteral* sLiteral) = 0;
    virtual void visitBlock(SBlock* sBlock) = 0;

};

} // namespace Egg

#endif // ~ _SEXPRESSIONVISITOR_H_ ~
