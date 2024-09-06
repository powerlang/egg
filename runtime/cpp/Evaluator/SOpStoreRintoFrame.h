#ifndef _SOPSTORERINTOFRAME_H_
#define _SOPSTORERINTOFRAME_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpStoreRintoFrame : public SOperation {
    int _index;

public:
    SOpStoreRintoFrame(auto index) : _index(index) {}

    int index() { return _index; }

    void acceptVisitor_(SExpressionVisitor *visitor) override {
        visitor->visitOpStoreRintoFrame(this);
    }

};

} // namespace Egg

#endif // ~ _SOPSTORERINTOFRAME_H_ ~
