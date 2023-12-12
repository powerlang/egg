/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include "HeapObject.h"
#include "KnownObjects.h"

using namespace Egg;

/// ~ small headers ~

bool HeapObject::SmallHeader::testFlags(uint8_t flag) const
{
	return (this->flags & flag) == flag;
}

void HeapObject::SmallHeader::setFlags(uint8_t flag)
{
	this->flags |= flag;
}

void HeapObject::SmallHeader::unsetFlags(uint8_t flag)
{
	this->flags &= flag ^ Flags::AllOn;
}

bool HeapObject::testFlags (const uint8_t flags) const { this->testFlags(flags); }
void HeapObject::setFlags  (const uint8_t flags) { this->smallHeader()->setFlags(flags); }
void HeapObject::unsetFlags(const uint8_t flags) { this->testFlags(flags); }


/// ~ header flags getters ~

bool HeapObject::isNamed() const
{
	return this->testFlags(SmallHeader::Flags::IsSpecial);
}

bool HeapObject::isSpecial() const
{
	return this->testFlags(SmallHeader::Flags::IsSpecial);
}

bool HeapObject::hasBeenSeen() const
{
	return this->testFlags(SmallHeader::Flags::HasBeenSeen);
}

bool HeapObject::isSecondGeneration() const
{
	return this->testFlags(SmallHeader::Flags::IsSecondGen);
}


bool HeapObject::isBytes() const
{
	return this->testFlags(SmallHeader::Flags::IsBytes);
}

bool HeapObject::isSmall() const
{
	return this->testFlags(SmallHeader::Flags::IsSmall);
}


bool HeapObject::isRemembered() const
{
	return this->testFlags(SmallHeader::Flags::IsRemembered);
}


/// ~ header flags setters

void HeapObject::beSmall()
{
	this->smallHeader()->setFlags(SmallHeader::Flags::IsSmall);
}

void HeapObject::beLarge()
{
	this->smallHeader()->unsetFlags(SmallHeader::Flags::IsSmall);
}

void HeapObject::beStrong()
{
	this->unsetFlags(SmallHeader::Flags::IsSpecial);
}

void HeapObject::beSecondGeneration()
{
	this->setFlags(SmallHeader::Flags::IsSecondGen);
}

void HeapObject::beNotRemembered()
{
	this->unsetFlags(SmallHeader::Flags::IsRemembered);
}

void HeapObject::beRemembered()
{
	this->setFlags(SmallHeader::Flags::IsRemembered);
}

void HeapObject::beSeen()
{
	this->setFlags(SmallHeader::Flags::HasBeenSeen);
}

void HeapObject::beUnseen()
{
	this->unsetFlags(SmallHeader::Flags::HasBeenSeen);
}


/// ~ behavior and hash ~

HeapObject* HeapObject::behavior()
{
    return reinterpret_cast<HeapObject*>((uintptr_t)smallHeader()->behavior);
}

void HeapObject::behavior(HeapObject *behavior)
{
    smallHeader()->behavior = (uint32_t)((uintptr_t)behavior);
}

uint16_t HeapObject::hash () const
{
    return this->smallHeader()->hash;
}

void HeapObject::hash (uint16_t hash)
{
    this->smallHeader()->hash  = hash;
}


/// ~ size calculation ~

uint8_t HeapObject::smallSize() const
{
	return this->smallHeader()->size;
}

void HeapObject::smallSize(uint8_t size)
{
	this->smallHeader()->size = size;
}


uint32_t HeapObject::largeSize() const
{
	return this->largeHeader()->size;
}


void HeapObject::largeSize(uint32_t size)
{
	this->largeHeader()->size = size;
}

uint32_t HeapObject::size()  const
{
	return this->isSmall() ? this->smallSize() : this->largeSize();
}

uint32_t HeapObject::bodySizeInBytes() const
{
	if (this->isBytes())
	{
		return (this->size() + WORD_SIZE - 1) & (-WORD_SIZE);

	} else
		return this->size() * WORD_SIZE;
}


uint32_t HeapObject::bodySizeInSlots() const
{
	uint32_t size = this->size();

	return this->isBytes() ? ((size + WORD_SIZE - 1) >> WORD_SIZE_SHIFT) : size;
}

uint32_t HeapObject::headerSizeInBytes() const
{
	return this->isSmall() ? sizeof(SmallHeader) : sizeof(LargeHeader);
}

uint32_t HeapObject::pointersSize() const
{
	return this->isBytes() ? 0 : this->size();
}

uint32_t HeapObject::strongPointersSize() const
{
	if (this->isBytes() || this->isSpecial())
		return 0;
	else
		return this->size();
}


/// ~ access to slots ~

HeapObject::ObjectSlot&
HeapObject::slot(const uint32_t index)
{
    ASSERT(this->isPointers());
    ASSERT(/*index >= 0 &&*/ index <= this->size());

    return ((ObjectSlot*)this)[index];
}

const uint8_t&
HeapObject::byte(const uint32_t index) const
{
    ASSERT(this->isBytes());
    ASSERT(index <= this->size());

    return *(((uint8_t*)this) + index);
}


/// ~ debugging and temp stuff ~

std::string
HeapObject::stringVal()
{
	ASSERT(this->isBytes());

    std::string str((const char*)this, this->size());
    return str;
}


HeapObject* HeapObject::klass() {
    HeapObject *current = this->behavior();
    HeapObject *k;
    auto BehaviorClass = 0;
    auto BehaviorNext = 2;
    while ((k = current->slot(BehaviorClass)->asHeapObject()) == KnownObjects::nil)
    {
        current = current->slot(BehaviorNext)->asHeapObject();
    }

    return k;
}
