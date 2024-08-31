#ifndef _SASSOCIATIONBINDING_H_
#define _SASSOCIATIONBINDING_H_

#include "SBinding.h"
#include "KnownObjects.h"
#include "EvaluationContext.h"

namespace Egg {
class HeapObject;

class SAssociationBinding : public SBinding {
    int _index;
    HeapObject *_association;
public:
	SAssociationBinding(HeapObject *assoc) : _association(assoc) {}

	void assign_within_(Object *value, EvaluationContext *anEvaluationContext) override {
		anEvaluationContext->storeAssociation_value_(this->_association, value);
	}

	HeapObject* association() {
		return this->_association;
	}

	void association_(HeapObject *anAssociation) {
		this->_association = anAssociation;
	}

	int index() {
		return this->_index;
	}

	void index_(int anInteger) {
		this->_index = anInteger;
	}

	bool isAssociation() const override {
		return true;
	}

	virtual bool isConstant() const {
		return false;
	}

    Object* valueWithin_(EvaluationContext* anEvaluationContext) override {
        return anEvaluationContext->loadAssociationValue_(this->_association);
    }
};


} // namespace Egg

#endif // ~ _SASSOCIATIONBINDING_H_ ~
