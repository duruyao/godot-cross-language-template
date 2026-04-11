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

if(CMAKE_C_COMPILER)
endif()

set(GODOTCPP_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/third_party/godot-cpp" CACHE PATH "Path to godot-cpp source directory")
file(RELATIVE_PATH godotcpp_submodule_path "${CMAKE_CURRENT_SOURCE_DIR}" "${GODOTCPP_SRC_DIR}")

if(NOT EXISTS "${GODOTCPP_SRC_DIR}/src")
    message(NOTICE "godot-cpp bindings source not found")
    message(NOTICE "initializing/updating the godot-cpp submodule...")

    find_program(GIT git REQUIRED)
    execute_process(COMMAND "${GIT}" submodule update --init --recursive "${godotcpp_submodule_path}"
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            COMMAND_ERROR_IS_FATAL ANY
    )
endif()

list(APPEND CMAKE_MODULE_PATH "${GODOTCPP_SRC_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

add_subdirectory("${GODOTCPP_SRC_DIR}")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/extensions")
