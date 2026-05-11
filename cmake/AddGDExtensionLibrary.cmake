include_guard(GLOBAL)
include(AppendGDExtensionDocSource)
set(current_dir "${CMAKE_CURRENT_LIST_DIR}")

function(add_gdextension_library EXTENSION_NAME)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "" "GODOTCPP_SRC_DIR;EXTENSION_SRC_DIR;INSTALL_DIR_PREFIX" "EXTRA_SOURCES;EXTRA_HEADER_DIRS")
    add_library("${EXTENSION_NAME}" SHARED)
    file(GLOB extension_sources CONFIGURE_DEPENDS
            "${ARG_EXTENSION_SRC_DIR}/*.cc"
            "${ARG_EXTENSION_SRC_DIR}/*.cpp"
            "${ARG_EXTENSION_SRC_DIR}/*.cxx"
            "${ARG_EXTENSION_SRC_DIR}/*.h"
            "${ARG_EXTENSION_SRC_DIR}/*.hh"
            "${ARG_EXTENSION_SRC_DIR}/*.hpp"
    )
    target_sources("${EXTENSION_NAME}" PRIVATE ${extension_sources} ${ARG_EXTRA_SOURCES})

    if("${GODOTCPP_TARGET}" MATCHES "editor|template_debug")
        append_gdextension_doc_source("${EXTENSION_NAME}" "${ARG_GODOTCPP_SRC_DIR}" "${ARG_EXTENSION_SRC_DIR}")
    endif()

    target_link_libraries("${EXTENSION_NAME}" PRIVATE godot-cpp)
    target_include_directories("${EXTENSION_NAME}" PRIVATE "${ARG_GODOTCPP_SRC_DIR}" "${ARG_GODOTCPP_SRC_DIR}/include" "${ARG_GODOTCPP_SRC_DIR}/gen/include" "${ARG_EXTENSION_SRC_DIR}/.." ${ARG_EXTRA_HEADER_DIRS})

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
