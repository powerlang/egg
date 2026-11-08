#include "Launcher.h"

#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <string>

int main(int argc, char** argv)
{
    if (argc < 3) {
        std::fprintf(stderr, "usage: %s <segments directory> <module> [arguments...]\n", argv[0]);
        return 1;
    }
    lmr::Launcher launcher((std::filesystem::path(argv[1]) / "LMR.Start.ems").string());
    if (!launcher.loaded()) {
        std::fprintf(stderr, "cannot find LMR.Start.ems in %s\n", argv[1]);
        return 1;
    }
    launcher.bindFFI();
    launcher.bind("LMR.Start");
    launcher.arguments(argc, argv);
    launcher.relocate();
    return static_cast<int>(static_cast<int64_t>(launcher.run("start")) >> 1);
}
