cmake_minimum_required(VERSION 3.17 FATAL_ERROR)

project(godot-cross-language-template
        VERSION 1.0
        DESCRIPTION "This repository serves as a quickstart cross-language template for GDExtension development with Godot 4.0+."
        HOMEPAGE_URL "https://github.com/duruyao/godot-cross-language-template/tree/main"
        LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "Build architectures for macOS" FORCE)

if(CMAKE_C_COMPILER)
endif()

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/.gdignore" "")

set(godotcpp_submodule_path "third_party/godot-cpp")
set(godotcpp_src_dir "${CMAKE_CURRENT_SOURCE_DIR}/${godotcpp_submodule_path}")

if(NOT EXISTS "${godotcpp_src_dir}/src")
    message(NOTICE "godot-cpp bindings source not found")
    message(NOTICE "initializing/updating the godot-cpp submodule...")

    find_program(GIT git REQUIRED)
    execute_process(COMMAND "${GIT}" submodule update --init --recursive "${godotcpp_submodule_path}"
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            COMMAND_ERROR_IS_FATAL ANY
    )
endif()

list(APPEND CMAKE_MODULE_PATH "${godotcpp_src_dir}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

add_subdirectory("${godotcpp_src_dir}")

include(AddGDExtensionLibrary)
add_gdextension_library(foo
        "${godotcpp_src_dir}"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/extensions/foo"
        "${PROJECT_SOURCE_DIR}"
)
add_gdextension_library(bar
        "${godotcpp_src_dir}"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/extensions/bar"
        "${PROJECT_SOURCE_DIR}"
)
