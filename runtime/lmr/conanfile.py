from conan import ConanFile


class LmrLauncherConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "CMakeToolchain"

    def configure(self):
        self.settings.compiler.cppstd = "20"
