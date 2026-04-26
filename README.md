# Godot Cross-language Template

This repository serves as a quickstart cross-language template for GDExtension development with Godot 4.0+.

## 1. Introduction

- The [third-party/godot-cpp](third-party/godot-cpp) as a submodule is the official C++ GDExtension binding.
- The [src/extensions](src/extensions) directory contains source files for multiple C++ GDExtension libraries.
- The [SConstruct](SConstruct) as the primary build system for multiple C++ GDExtension libraries.
- The [CMakeLists.txt](CMakeLists.txt) as a secondary build system for multiple C++ GDExtension libraries.
- The [src](src) directory (excluding [src/extensions](src/extensions)) contains source files (`.cs`, `.gd`, `.gdshader`, `.tscn`) for the Godot project.

## 2. Build C++ GDExtension Libraries

To use this template, log in to GitHub and click the green `Use this template` button at the top of the repository page. This will let you create a copy of this repository with a clean git history.

Initialize the submodule [third-party/godot-cpp](third-party/godot-cpp).

```shell
# git: init submodule
git submodule update --init --recursive third-party/godot-cpp
```
### 2.1. Primary Build System: SCons

Build multiple C++ GDExtension libraries via SCons.

```shell
# scons: build debug target
scons build_dir=scons-build-template_debug target=template_debug debug_symbols=yes
```

```shell
# scons: build release target
scons build_dir=scons-build-template_release target=template_release debug_symbols=no
```

### 2.2. Secondary Build System: CMake

Build multiple C++ GDExtension libraries via CMake.

```shell
# cmake: build debug target
cmake -S . -B cmake-build-template_debug -DGODOTCPP_TARGET=template_debug -DCMAKE_BUILD_TYPE=Debug
cmake --build cmake-build-template_debug -j 8
```

```shell
# cmake: build release target
cmake -S . -B cmake-build-template_release -DGODOTCPP_TARGET=template_release -DCMAKE_BUILD_TYPE=Release
cmake --build cmake-build-template_release -j 8
```

## 3. Run Godot Project

Launch the godot editor or run the project directly.

```shell
# godot: open project in editor
godot --path . --editor
```

```shell
# godot: run project without opening editor
godot --path .
```

```
Hello Bar, I am Foo.
Hello Foo, I am Bar.
```

## 4. Configure IDE

If you want to work with an IDE, you can use a compilation database file called `compile_commands.json`. Most IDEs should automatically identify this file, and self-configure appropriately. To generate the database file, you can run the following commands:

```shell
# scons: generate compile_commands.json without building
scons compiledb=yes compile_commands.json
```

[Visual Studio Code](https://code.visualstudio.com/) needs the environment variable `GODOT4_EXECUTABLE` to be set to the path of the Godot 4 executable. You can set this environment variable in your shell configuration file (e.g., `.bashrc`, `.zshrc`, etc.):

```shell
# shell: set godot 4 executable path environment variable
echo 'export GODOT4_EXECUTABLE="/path/to/godot/executable"\n' >> ~/.zprofile
source ~/.zprofile
echo $GODOT4_EXECUTABLE
```
