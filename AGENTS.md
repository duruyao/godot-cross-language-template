# AGENTS.md

## Overview

This project is a Godot game project developed with multiple languages, including GDScript, GDShader, C#, C++, CMake, SCons, Python, and Go-related tooling.

## References

- Read `README.md` before changing build flow, native extensions, or development workflow.
- Follow `.editorconfig` for general formatting.
- Follow `.clang-format` for C/C++.
- Follow `.cc-format.jsonc` for CMake.
- Use `.agents/skills/readme-localization-sync/` when syncing localized README files from `README.md`.

## Repository Layout

- `src/`: Godot project source files.
- `src/extensions/`: C++ GDExtension libraries.
- `doc/`: documentation and localized README files.
- `third_party/godot-cpp/`: Godot C++ binding submodule; treat it as third-party code.
- `SConstruct`: primary native extension build entry.
- `CMakeLists.txt`: secondary native extension build entry.

## Working Rules

- Keep changes small and consistent with nearby code.
- Do not edit `project.godot`, scene files, import metadata, generated files, or `third_party/godot-cpp/` unless the task requires it.
- When `README.md` changes, update all matching localized files under `doc/README.*.md`.
- When changing GDExtension APIs, check related Godot script call sites and extension documentation.
- Prefer existing Godot, SCons, CMake, and GDExtension patterns already used in this repository.

## Common Commands

```shell
# git: initialize submodules
git submodule update --init --recursive
# scons: build debug target
scons build_dir=scons-build-template_debug target=template_debug debug_symbols=yes
# scons: build release target
scons build_dir=scons-build-template_release target=template_release debug_symbols=no
# godot: run project without opening editor
$GODOT4_EXECUTABLE --path .
# godot: open project in editor
$GODOT4_EXECUTABLE --path . --editor
```

Use the CMake commands from `doc/dev.md` when working on the CMake build path.

## Verification

Verify according to the files changed: run Godot for game/script/resource changes, rebuild native extensions for C++ changes, and run the relevant SCons or CMake command for build-system changes. If verification cannot be run, say so clearly.
