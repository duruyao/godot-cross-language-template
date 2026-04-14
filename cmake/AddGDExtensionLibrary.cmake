include_guard(GLOBAL)
include(AppendGDExtensionDocSource)
include(WriteGDExtensionManifest)

function(add_gdextension_library EXTENSION_NAME GODOTCPP_SRC_DIR EXTENSION_SRC_DIR INSTALL_DIR_PREFIX)
    add_library("${EXTENSION_NAME}" SHARED)
    file(GLOB extension_sources CONFIGURE_DEPENDS
            "${EXTENSION_SRC_DIR}/*.cc"
            "${EXTENSION_SRC_DIR}/*.cpp"
            "${EXTENSION_SRC_DIR}/*.cxx"
            "${EXTENSION_SRC_DIR}/*.h"
            "${EXTENSION_SRC_DIR}/*.hh"
            "${EXTENSION_SRC_DIR}/*.hpp"
    )
    target_sources("${EXTENSION_NAME}" PRIVATE ${extension_sources})

    if("${GODOTCPP_TARGET}" MATCHES "editor|template_debug")
        append_gdextension_doc_source("${EXTENSION_NAME}" "${GODOTCPP_SRC_DIR}" "${EXTENSION_SRC_DIR}")
    endif()

    target_link_libraries("${EXTENSION_NAME}" PRIVATE godot-cpp)
    target_include_directories("${EXTENSION_NAME}" PRIVATE "${GODOTCPP_SRC_DIR}/.." "${EXTENSION_SRC_DIR}/..")

    get_target_property(godotcpp_suffix godot::cpp GODOTCPP_SUFFIX)
    get_target_property(godotcpp_platform godot::cpp GODOTCPP_PLATFORM)
    set_target_properties("${EXTENSION_NAME}"
            PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY "$<1:${CMAKE_CURRENT_BINARY_DIR}/${godotcpp_platform}>"
            RUNTIME_OUTPUT_DIRECTORY "$<1:${CMAKE_CURRENT_BINARY_DIR}/${godotcpp_platform}>"
            PREFIX "lib"
            OUTPUT_NAME "${EXTENSION_NAME}${godotcpp_suffix}"
    )

    set(manifest_filename "${EXTENSION_NAME}.gdextension")
    write_gdextension_manifest("${EXTENSION_NAME}" "${CMAKE_CURRENT_BINARY_DIR}/${manifest_filename}")

    add_custom_command(TARGET "${EXTENSION_NAME}" POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E make_directory "${INSTALL_DIR_PREFIX}/bin/${godotcpp_platform}"
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${CMAKE_CURRENT_BINARY_DIR}/${manifest_filename}" "${INSTALL_DIR_PREFIX}/bin/${manifest_filename}"
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${EXTENSION_NAME}>" "${INSTALL_DIR_PREFIX}/bin/${godotcpp_platform}/$<TARGET_FILE_NAME:${EXTENSION_NAME}>"
    )
endfunction()
