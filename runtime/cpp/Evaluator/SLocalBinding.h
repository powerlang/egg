#ifndef _SLOCALBINDING_H_
#define _SLOCALBINDING_H_

#include "SBinding.h"
#include "../Util.h"

namespace Egg {

class SLocalBinding : public SBinding {
public:
    int _position;
    int _environment;

    SLocalBinding(int pos, int env) : SBinding(), _position(pos), _environment(env) {}

    int environment() const {
        return this->_environment;
    }

    SLocalBinding* environment_(int anInteger) {
        this->_environment = anInteger;
        return this;
    }

    int index() const {
        return this->_position;
    }

    SLocalBinding* index_(int anInteger) {
        this->_position = anInteger;
        return this;
    }

    bool isInStack() const {
        ASSERT(false);
        return this->_environment == 0;
    }
};

} // namespace Egg

#endif // ~ _SLOCALBINDING_H_ ~
