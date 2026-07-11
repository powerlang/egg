#include "Launcher.h"

#include "Egg.h"

#include <fstream>

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

} // namespace lmr
