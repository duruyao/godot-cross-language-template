include_guard(GLOBAL)
include(GDExtensionTargetLinkDocs)
include(GenGDExtensionFile)

function(add_gdextension_target EXTENSION_NAME GODOTCPP_SRC_DIR EXTENSION_SRC_DIR OUTPUT_DIR_PREFIX)
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

    if(GODOTCPP_TARGET MATCHES "editor|template_debug")
        gdextension_target_link_docs("${EXTENSION_NAME}" "${GODOTCPP_SRC_DIR}" "${EXTENSION_SRC_DIR}")
    endif()

    target_link_libraries("${EXTENSION_NAME}" PRIVATE godot-cpp)
    target_include_directories("${EXTENSION_NAME}" PRIVATE "${GODOTCPP_SRC_DIR}/..")

    get_target_property(godotcpp_suffix godot::cpp GODOTCPP_SUFFIX)
    get_target_property(godotcpp_platform godot::cpp GODOTCPP_PLATFORM)
    set_target_properties("${EXTENSION_NAME}"
            PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY "$<1:${OUTPUT_DIR_PREFIX}/bin/${godotcpp_platform}>"
            RUNTIME_OUTPUT_DIRECTORY "$<1:${OUTPUT_DIR_PREFIX}/bin/${godotcpp_platform}>"
            PREFIX "lib"
            OUTPUT_NAME "${EXTENSION_NAME}${godotcpp_suffix}"
    )

    gen_gdextension_file("${EXTENSION_NAME}" "${OUTPUT_DIR_PREFIX}/bin")
endfunction()
