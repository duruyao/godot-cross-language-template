include_guard(GLOBAL)

function(gdextension_target_link_docs EXTENSION_TARGET GODOTCPP_SRC_DIR EXTENSION_DOC_DIR)
    file(GLOB_RECURSE xml_list LIST_DIRECTORIES OFF CONFIGURE_DEPENDS
            "${EXTENSION_DOC_DIR}/*.xml"
    )
    if(NOT xml_list)
        return()
    endif()

    string(MAKE_C_IDENTIFIER "${EXTENSION_TARGET}" extension_target_id)
    set(doc_source "${CMAKE_CURRENT_BINARY_DIR}/gen/${extension_target_id}_doc.cpp")

    set(python_xml_list "${xml_list}")
    list(TRANSFORM python_xml_list REPLACE "(.*\\.xml)" "'\\1'")
    list(JOIN python_xml_list "," python_xml_list)

    set(python_script
            "from doc_source_generator import generate_doc_source"
            "generate_doc_source('${doc_source}', [${python_xml_list}])"
    )
    string(REGEX REPLACE "\n *" " " python_script "${python_script}")

    get_filename_component(doc_source_dir "${doc_source}" DIRECTORY)
    file(MAKE_DIRECTORY "${doc_source_dir}")

    find_package(Python3 3.4 REQUIRED)
    add_custom_command(OUTPUT "${doc_source}"
            COMMAND "${Python3_EXECUTABLE}" "-c" "${python_script}"
            DEPENDS "${GODOTCPP_SRC_DIR}/doc_source_generator.py" ${xml_list}
            WORKING_DIRECTORY "${GODOTCPP_SRC_DIR}"
            COMMENT "Generating: ${doc_source}"
            VERBATIM
    )

    set(doc_target "gen_${EXTENSION_TARGET}_doc_source")
    add_custom_target("${doc_target}" DEPENDS "${doc_source}")
    target_sources("${EXTENSION_TARGET}" PRIVATE "${doc_source}")
    add_dependencies("${EXTENSION_TARGET}" "${doc_target}")
endfunction()
