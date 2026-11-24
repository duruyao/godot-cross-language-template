include_guard(GLOBAL)
include(AppendGDExtensionDocSource)
set(current_dir "${CMAKE_CURRENT_LIST_DIR}")

function(add_gdextension_library EXTENSION_NAME)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "" "GODOTCPP_SRC_DIR;EXTENSION_SRC_DIR;INSTALL_DIR_PREFIX" "EXTRA_SOURCES;EXTRA_SOURCE_DIRS;EXTRA_HEADER_DIRS;EXTRA_COMPILE_DEFINITIONS;EXTRA_COMPILE_FLAGS")
    add_library("${EXTENSION_NAME}" SHARED)
    file(GLOB extension_sources CONFIGURE_DEPENDS
            "${ARG_EXTENSION_SRC_DIR}/*.c"
            "${ARG_EXTENSION_SRC_DIR}/*.cc"
            "${ARG_EXTENSION_SRC_DIR}/*.cpp"
            "${ARG_EXTENSION_SRC_DIR}/*.cxx"
            "${ARG_EXTENSION_SRC_DIR}/*.h"
            "${ARG_EXTENSION_SRC_DIR}/*.hh"
            "${ARG_EXTENSION_SRC_DIR}/*.hpp"
    )
    set(extra_sources ${ARG_EXTRA_SOURCES})
    foreach(extra_source_dir IN LISTS ARG_EXTRA_SOURCE_DIRS)
        file(GLOB_RECURSE extra_source_dir_sources CONFIGURE_DEPENDS
                "${extra_source_dir}/*.c"
                "${extra_source_dir}/*.cc"
                "${extra_source_dir}/*.cpp"
                "${extra_source_dir}/*.cxx"
                "${extra_source_dir}/*.h"
                "${extra_source_dir}/*.hh"
                "${extra_source_dir}/*.hpp"
        )
        list(APPEND extra_sources ${extra_source_dir_sources})
    endforeach()
    target_sources("${EXTENSION_NAME}" PRIVATE ${extension_sources} ${extra_sources})

    if("${GODOTCPP_TARGET}" MATCHES "editor|template_debug")
        append_gdextension_doc_source("${EXTENSION_NAME}" "${ARG_GODOTCPP_SRC_DIR}" "${ARG_EXTENSION_SRC_DIR}")
    endif()

    target_link_libraries("${EXTENSION_NAME}" PRIVATE godot-cpp)
    target_include_directories("${EXTENSION_NAME}" PRIVATE "${ARG_EXTENSION_SRC_DIR}/.." ${ARG_EXTRA_HEADER_DIRS})
    target_compile_definitions("${EXTENSION_NAME}" PRIVATE ${ARG_EXTRA_COMPILE_DEFINITIONS})
    target_compile_options("${EXTENSION_NAME}" PRIVATE ${ARG_EXTRA_COMPILE_FLAGS})

    get_target_property(godotcpp_suffix godot::cpp GODOTCPP_SUFFIX)
    get_target_property(godotcpp_platform godot::cpp GODOTCPP_PLATFORM)
    string(REPLACE ".universal" "" extension_suffix "${godotcpp_suffix}")
    set_target_properties("${EXTENSION_NAME}"
            PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY "$<1:${ARG_INSTALL_DIR_PREFIX}/bin/${godotcpp_platform}>"
            RUNTIME_OUTPUT_DIRECTORY "$<1:${ARG_INSTALL_DIR_PREFIX}/bin/${godotcpp_platform}>"
            PREFIX "lib"
            OUTPUT_NAME "${EXTENSION_NAME}${extension_suffix}"
    )

    set(manifest_path "${ARG_INSTALL_DIR_PREFIX}/bin/${EXTENSION_NAME}.gdextension")
    add_custom_command(OUTPUT "${manifest_path}"
            COMMAND "${CMAKE_COMMAND}"
            "-DEXTENSION_NAME=${EXTENSION_NAME}"
            "-DFILE_PATH=${manifest_path}"
            -P "${current_dir}/WriteGDExtensionManifest.cmake"
            VERBATIM
    )
    add_custom_target("${EXTENSION_NAME}_manifest" ALL DEPENDS "${manifest_path}")
endfunction()
