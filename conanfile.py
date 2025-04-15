from conan import ConanFile
from conan.tools.cmake import cmake_layout

import os

class QtSmartHome(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"

    default_options = {
        "boost/*:without_fiber": True,
        "boost/*:without_stacktrace": True,
        "boost/*:header_only": True,
    }
    def requirements(self):
        self.requires("boost/1.87.0")
        self.requires("fmt/11.1.3")

    def layout(self):
        cmake_layout(self)#build文件夹和一些其他文件的文件结构，conan install . --output-folder=build --build=missing 可以省去中间那条命令