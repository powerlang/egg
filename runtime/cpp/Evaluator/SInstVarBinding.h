#ifndef _SINSTVARBINDING_H_
#define _SINSTVARBINDING_H_

#include "SBinding.h"
#include "EvaluationContext.h"
#include "../Util.h"

namespace Egg {

class SInstVarBinding : public SBinding {
public:
    int _index;

    SInstVarBinding(int index) : _index(index) {}

	void assign_within_(Object *value, EvaluationContext *anEvaluationContext) override {
		anEvaluationContext->instanceVarAt_put_(this->_index, value);
	}

    int index() const {
        return this->_index;
    }

    void index(int anInteger) {
        this->_index = anInteger;
    }

	bool isInstVar() const override {
		return true;
	}

	Object* valueWithin_(EvaluationContext *anEvaluationContext) {
		return anEvaluationContext->instanceVarAt_(this->_index);
	}

};

} // namespace Egg

#endif // ~ _SINSTVARBINDING_H_ ~
