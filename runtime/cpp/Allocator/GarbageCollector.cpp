#include "GarbageCollector.h"
#include "KnownObjects.h"
#include "Evaluator/Runtime.h"

#include <cstring>
#include <Evaluator/Evaluator.h>

using namespace Egg;

GarbageCollector::GarbageCollector(Runtime *runtime, AllocationZone *oldZone, GCHeap *heap) :
	_runtime(runtime),
	_oldZone(oldZone),
	_heap(heap)
{
}

bool GarbageCollector::checkEphemerons()
{
    auto done = true;
	while (!_uncheckedEphemerons->empty())
    { 
        HeapObject *ephemeron = _uncheckedEphemerons->back();
        _uncheckedEphemerons->pop_back();
		if (this->checkReachablePropertyOf_(ephemeron))
        {
            this->followEphemeronWeaks_(ephemeron);
			done = false;
        }
        else
            _unreachedEphemerons->push_back(ephemeron);
    }
    return done;
}

void GarbageCollector::collect()
{
	this->initializeLocals();
	this->doCollect();
	this->releaseLocals();
}

void GarbageCollector::doCollect()
{
    this->followRoots();
    this->strengthenAndMigrateEphemerons();
    this->scanWeakContainers();
}

void GarbageCollector::followEphemerons()
{
    bool done;
	do {
        this->followLiveEphemerons();
		done = this->rescueUnreachableEphemerons();
    } while (!done);
}

void GarbageCollector::followEphemeronWeaks_(HeapObject *ephemeron)
{
	this->scan_from_to_(ephemeron, 1, ephemeron->size());
	this->followClosure();
}

void GarbageCollector::followLiveEphemerons()
{
    bool done;
	do {
		done = this->checkEphemerons();
        if (done)
            break;
        this->swapUncheckedWithUnreached();
    } while (true);
}

void GarbageCollector::followRoots()
{
	//this->scanStack_(_activeStack);
	this->scanCurrentContext();
    //this->scanThreadLocalStorages();
    this->followClosure();
    this->followEphemerons();
}

void GarbageCollector::initializeLocals()
{
    auto size = this->initialContainerCapacity();

	_weakContainers = new std::vector<HeapObject*>();
	_uncheckedEphemerons = new std::vector<HeapObject*>();
	_unreachedEphemerons = new std::vector<HeapObject*>();
	_rescuedEphemerons = new std::vector<HeapObject*>();
	_stacks = new std::vector<HeapObject*>();

    _weakContainers->reserve(size);
	_uncheckedEphemerons->reserve(size);
	_unreachedEphemerons->reserve(size);
	_rescuedEphemerons->reserve(size);
	_stacks->reserve(size);
}

void GarbageCollector::heap_(GCHeap *aGCHeap)
{
	_heap = aGCHeap;
	this->postInitialize();
}

void GarbageCollector::postInitialize()
{
	_oldZone = _heap->oldZone();

}

void Egg::GarbageCollector::releaseLocals()
{
    //warning("queueEphemerons must be implemented");
    //_memory->queueEphemerons_(_rescuedEphemerons);

	delete _weakContainers;
	delete _uncheckedEphemerons;
	delete _unreachedEphemerons;
	delete _rescuedEphemerons;
	delete _stacks;

	_weakContainers = nullptr;
    _uncheckedEphemerons = nullptr;
    _unreachedEphemerons = nullptr;
    _rescuedEphemerons = nullptr;
	_stacks = nullptr;
	//ActiveProcess stack unlock
}

void GarbageCollector::rememberSpecial_(HeapObject *anObject)
{
	auto klass = _runtime->speciesOf_((Object*)anObject);

    std::vector<HeapObject*> *collection;
	if (klass == _runtime->_ephemeronClass)
	{
        this->checkEphemeron_(anObject);
		collection = _uncheckedEphemerons;
    }
    else
    {
        collection = klass == _runtime->_processStackClass ? _stacks : _weakContainers;
    }
	collection->push_back(anObject);
}

void GarbageCollector::rescueEphemeron_(HeapObject *ephemeron)
{
	this->followEphemeronWeaks_(ephemeron);
	_rescuedEphemerons->push_back(ephemeron);
}

bool GarbageCollector::rescueUnreachableEphemerons()
{
	auto done = _unreachedEphemerons->empty();
    for (auto ephemeron : *_unreachedEphemerons)
	{
        this->rescueEphemeron_(ephemeron);
    }
    _unreachedEphemerons->clear();
	return done;
}

void GarbageCollector::scanNativeStackFrame_sized_(uintptr_t *framePointer, uintptr_t size)
{
    // all code is pinned for now
    //self fixReturnAddressIn: framePointer _asObject sized: size.

	this->scanStackFrameObjects_sized_(framePointer, size);
}

void GarbageCollector::scanStackFrameObjects_sized_(uintptr_t *framePointer, uintptr_t size) {
	//for (uintptr_t i = 0; i < size; i++)
	//	printf("adding %s to queue\n", ((Object*)framePointer[i])->printString().c_str());
	this->scan_from_to_((HeapObject*)framePointer, 1, size);
}

void GarbageCollector::scanSpecialSlots_(HeapObject *special)
{
	this->scan_from_to_(special, 1, special->size());
}

void GarbageCollector::nativeFramesStartingAt_bp_do_(uintptr_t **stack, uintptr_t sp, uintptr_t bp, std::function<void(uintptr_t*, uintptr_t)> block) {
	auto start = sp;
	auto end = bp;
	while (end != 0) {
		auto size = end - start;
	    block((uintptr_t*)&stack[start-1], size);
	    start = end + 2; // next frame stars after bp and retaddr slots
	    end = (uintptr_t)stack[end-1];
	}
}

void GarbageCollector::scanFirstStackChunk_(HeapObject *aProcessVMStack) {
	/**
	 * Scanning needs to fetch a chain of stack (frame) pointers. The head
	 * of the chain is either of two cases:
	 * - The active process.
	 *      In that case, the top of the stack is a common frame (probably a call
	 *      to a primitive). No special action needs to be done.
	 * - A sleeping (native) process.
	 *      In that case, the top of the stack is that process' env, followed
	 *      by a retaddr. The GC has to scan that addr and then continue normally.
	 *      (TODO: make env an instvar of the ProcessVMStack)
	 */
	//if (aProcessVMStack != runtime->_activeProcessStack)
	//	this->scanTopSlot_(aProcessVMStack);

	auto firstSP = _runtime->processVMStackSP_(aProcessVMStack) + 2;
	auto firstBP = _runtime->processVMStackBP_(aProcessVMStack);
	auto stack = (uintptr_t**)nullptr; //_runtime->processVMStackContext_(aProcessVMStack)->stack();
	this->nativeFramesStartingAt_bp_do_(stack, firstSP, firstBP,
		[this](uintptr_t *frame, uintptr_t size) {
			this->scanNativeStackFrame_sized_(frame, size);
		});
}

/* only for use until we have context switches */
void GarbageCollector::scanCurrentContext() {
	auto firstSP = _runtime->_evaluator->context()->stackPointer();
	auto firstBP = _runtime->_evaluator->context()->framePointer();
	auto stack = (uintptr_t**)_runtime->_evaluator->context()->stack();
	this->nativeFramesStartingAt_bp_do_(stack, firstSP, firstBP,
		[this](uintptr_t *frame, uintptr_t size) {
			this->scanNativeStackFrame_sized_(frame, size);
		});
}

void GarbageCollector::scanStack_(HeapObject *aProcessVMStack)
{
	//auto context = _runtime->processVMStackContext_(aProcessVMStack);

	// skip this stack if it corresponds to active process, which has already been scanned
	//if (context == _runtime->_evaluator->context())
		return;

	auto process = _runtime->processVMStackProcess_(aProcessVMStack);
	if (_runtime->processStackIsValid_(process))
		this->scanFirstStackChunk_(aProcessVMStack);

	/* unimplemented GC in callbacks
    this->stackFramesBeneathCallbackIn_Do_(aProcessVMStack,
        [this](uintptr_t frame, uintptr_t nativeSize) {
            this->scanNativeStackFrame_sized_(frame, nativeSize);
        });
	*/
}

void GarbageCollector::scanStacks()
{
	while (!_stacks->empty())
    {
        auto s = _stacks->back();
        _stacks->pop_back();
		this->scanSpecialSlots_(s);
        this->scanStack_(s);
    }
}

void GarbageCollector::scanWeakContainers()
{
	for (auto weakContainer : *_weakContainers)
	{
        this->updateWeakReferencesOf_(weakContainer);
    }
    _weakContainers->clear();
}

void GarbageCollector::strengthenAndMigrateEphemerons()
{
	// No need to move ephemerons anywhere now, they will be added to the
	// list of unreachable on GC release. That list is iterated after GC
	// to finalize each of them.

    for (auto ephemeron : *_rescuedEphemerons)
    {
        ephemeron->beNotSpecial();
    }
}

void GarbageCollector::swapUncheckedWithUnreached()
{
    auto aux = this->_uncheckedEphemerons;
	this->_uncheckedEphemerons = this->_unreachedEphemerons;
	this->_unreachedEphemerons = aux;
}

void GarbageCollector::updateWeakReferencesOf_(HeapObject *weakContainer)
{
    for (uint32_t i = 0; i < weakContainer->size(); i++)
	    this->updateWeak_at_(weakContainer, i);
}
