#ifndef _SMESSAGE_H_
#define _SMESSAGE_H_

#include <vector>

#include "SExpression.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SMessage : public SExpression {
    HeapObject *_selector;
    SExpression *_receiver;
    std::vector<SExpression*> _arguments;
    std::vector<HeapObject*> _cache;
    bool _inlined;

    public:
    SMessage(SExpression *receiver, HeapObject *selector, const std::vector<SExpression*>& arguments, bool inlined) :
        _selector(selector), _receiver(receiver), _arguments(arguments), _inlined(inlined)
        { }

};

} // namespace Egg

#endif // ~ _SMESSAGE_H_ ~
