#include "Object.h"
#include "HeapObject.h"
#include "SmallInteger.h"

using namespace Egg;

std::string Object::printString()
{
    return this->isSmallInteger() ?
            this->asSmallInteger()->printString() :
            this->asHeapObject()->printString();
}

std::string Object::printContents()
{
    return this->isSmallInteger() ?
        this->printString() :
        this->asHeapObject()->printContents();
}