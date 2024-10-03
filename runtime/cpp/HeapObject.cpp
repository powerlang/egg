/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include "HeapObject.h"
#include "KnownObjects.h"
#include "Evaluator/Runtime.h"

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

bool HeapObject::testFlags (const uint8_t flags) const { return this->smallHeader()->testFlags(flags); }
void HeapObject::setFlags  (const uint8_t flags) { this->smallHeader()->setFlags(flags); }
void HeapObject::unsetFlags(const uint8_t flags) { this->smallHeader()->unsetFlags(flags); }


/// ~ header flags getters ~

bool HeapObject::isNamed() const
{
	return this->testFlags(SmallHeader::Flags::IsNamed);
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

bool Egg::HeapObject::isPointers() const {
	return !this->isBytes();
}

bool Egg::HeapObject::isArrayed() const { 
	return this->testFlags(SmallHeader::Flags::IsArrayed);
}

bool HeapObject::isSmall() const
{
	return this->testFlags(SmallHeader::Flags::IsSmall);
}

bool Egg::HeapObject::isLarge() const {
	return !this->isSmall();
}

bool HeapObject::isRemembered() const
{
	return this->testFlags(SmallHeader::Flags::IsRemembered);
}


/// ~ header flags setters

void HeapObject::beBytes()
{
	this->smallHeader()->setFlags(SmallHeader::Flags::IsBytes);
}

void Egg::HeapObject::beArrayed()
{
	this->smallHeader()->setFlags(SmallHeader::Flags::IsArrayed);
}

void Egg::HeapObject::beNamed()
{
	this->smallHeader()->setFlags(SmallHeader::Flags::IsNamed);
}

void Egg::HeapObject::beNotSpecial() {
	this->unsetFlags(SmallHeader::Flags::IsSpecial);
}

void HeapObject::beStrong() {
	this->beNotSpecial();
}

void HeapObject::beSecondGeneration()
{
	this->setFlags(SmallHeader::Flags::IsSecondGen);
}

void HeapObject::beNotRemembered()
{
	this->unsetFlags(SmallHeader::Flags::IsRemembered);
}

void HeapObject::beRemembered() {
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

void HeapObject::beSmall()
{
	this->smallHeader()->setFlags(SmallHeader::Flags::IsSmall);
}

void HeapObject::beLarge()
{
	this->smallHeader()->unsetFlags(SmallHeader::Flags::IsSmall);
}


/// ~ behavior and hash ~

HeapObject* HeapObject::behavior()
{
    return reinterpret_cast<HeapObject*>((uintptr_t)smallHeader()->behavior);
}

void HeapObject::behavior(HeapObject *behavior)
{
    smallHeader()->behavior = (uint32_t)((uintptr_t)behavior);
	//std::cout << "made " << this << " a " << behavior->slot(0)->printString() << " of size " << this->size() << std::endl;
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
    ASSERT(/*index >= 0 &&*/ index < this->size());

    return ((ObjectSlot*)this)[index];
}

HeapObject::ObjectSlot&
HeapObject::untypedSlot(const uint32_t index)
{
	ASSERT(/*index >= 0 &&*/ index < this->size());

	return ((ObjectSlot*)this)[index];
}

uint8_t&
HeapObject::byte(const uint32_t subscript)
{
    ASSERT(this->isBytes());
    ASSERT(subscript < this->size());

    return *(((uint8_t*)this) + subscript);
}

uint8_t&
HeapObject::unsafeByte(const uint32_t subscript)
{
	return *(((uint8_t*)this) + subscript);
}

uint16_t&
HeapObject::uint16offset(const uint32_t subscript)
{
    ASSERT(this->isBytes());
    ASSERT(subscript + 1 < this->size());

    return *(uint16_t*)((uintptr_t)this + subscript);
}

uint32_t&
HeapObject::uint32offset(const uint32_t subscript)
{
    ASSERT(this->isBytes());
    ASSERT(subscript * 4 + 3 < this->size());

    return *(uint32_t*)((uintptr_t)this + subscript);
}

uint64_t&
HeapObject::uint64offset(const uint32_t subscript)
{
	ASSERT(this->isBytes());
	ASSERT(subscript + 7 < this->size());

	return *(uint64_t*)((uintptr_t)this + subscript);
}

void HeapObject::replaceBytesFrom_to_with_startingAt_(
    const uintptr_t from, const uintptr_t to, HeapObject *anObject,
    const uintptr_t startingAt) {
		if (from > to)
			return;

		auto size = to - from + 1;
		auto startingAtOffset = startingAt - 1;
		//if (size > anObject->size() - startingAtOffset) // cannot check bounds as anObject could be just a buffer
		//	error("out of bounds");
		
		auto dst = ((char*)this) + from - 1;
		auto src = ((char*)anObject) + startingAtOffset;
		std::copy(src, src + size, dst);
	}

/// ~ debugging and temp stuff ~

std::string
HeapObject::stringVal()
{
	ASSERT(this->isBytes());

    std::string str((const char*)this, this->size());
    return str;
}

std::string HeapObject::asLocalString()
{
	return std::string((char*)this, this->size() - 1);
}

bool HeapObject::sameBytesThan(const std::string &string)
{
	return string.size() == this->size() - 1 && std::equal(string.begin(), string.end(), (char*)this);
}

bool Egg::HeapObject::sameBytesThan(const HeapObject *object)
{
	auto size = this->size();
	return size == object->size() && std::equal((char*)this, (char*)this+size, (char*)object);
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

std::string Egg::HeapObject::printString()
{
	return debugRuntime->print_(this);
}
