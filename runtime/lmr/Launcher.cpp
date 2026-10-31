#include "Launcher.h"

#include "Egg.h"
#include "Allocator/Memory.h"

#include <fstream>
#include <vector>


namespace lmr
{

static const bool egg_initialized = [] { Egg::Initialize(); return true; }();

Launcher::Launcher(const std::string& path)
{
    std::ifstream stream(path, std::ios::binary);
    if (!stream)
        return;
    _segment = std::make_unique<Egg::FileImageSegment>(&stream);
}

void Launcher::relocate()
{
    auto sentinel = reinterpret_cast<Egg::Object*>(_segment->spaceStart());
    std::vector<Egg::Object*> imports(_segment->_importDescriptors.size(), sentinel);
    _segment->fixPointerSlots(imports);
    this->makeExecutable();
}

void Launcher::makeExecutable()
{
    if (_segment->header.codeSize == 0)
        return;
    auto start = _segment->codeStart();
    auto end = Egg::pagealign(_segment->codeEnd());
    Egg::MakeExecutable(start, end - start);
}

Egg::HeapObject* Launcher::exported(const std::string& name)
{
    auto it = _segment->_exports.find(name);
    return it == _segment->_exports.end() ? nullptr : it->second;
}

uint64_t Launcher::run(const std::string& name)
{
    auto nativeCode = exported(name);
    auto machineCode = reinterpret_cast<Egg::HeapObject*>(nativeCode->slot(0));
    auto code = reinterpret_cast<uint8_t*>(&machineCode->byte(0));
    auto entry = reinterpret_cast<uint64_t (*)()>(code);
    return entry();
}

} // namespace lmr
