include(AddGDExtensionLibrary)

add_gdextension_library(foo
        "${GODOTCPP_SRC_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}/foo"
        "${PROJECT_SOURCE_DIR}/project"
)

add_gdextension_library(bar
        "${GODOTCPP_SRC_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}/bar"
        "${PROJECT_SOURCE_DIR}/project"
)
