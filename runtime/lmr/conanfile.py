from conan import ConanFile


class LmrLauncherConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "CMakeToolchain"
    requires = ("catch2/2.13.10",)

    def configure(self):
        self.settings.compiler.cppstd = "20"
