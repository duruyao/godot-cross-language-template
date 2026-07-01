include_guard(GLOBAL)

function(write_geos_version)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "SOURCE_DIR;FILE_PATH" "")
    foreach(required_arg SOURCE_DIR FILE_PATH)
        if(NOT ARG_${required_arg})
            message(FATAL_ERROR "'${required_arg}' must not be empty")
        endif()
    endforeach()

    file(READ "${ARG_SOURCE_DIR}/Version.txt" version_text)

    string(REGEX MATCH "GEOS_VERSION_MAJOR=([0-9]+)" _ ${version_text})
    set(version_major ${CMAKE_MATCH_1})
    string(REGEX MATCH "GEOS_VERSION_MINOR=([0-9]+)" _ ${version_text})
    set(version_minor ${CMAKE_MATCH_1})
    string(REGEX MATCH "GEOS_VERSION_PATCH=([0-9]+)" _ ${version_text})
    set(version_patch ${CMAKE_MATCH_1})
    string(REGEX MATCH "GEOS_PATCH_WORD=([a-zA-Z0-9]*)" _ ${version_text})
    set(version_patch_word ${CMAKE_MATCH_1})
    string(REGEX MATCH "JTS_PORT=([0-9a-zA-Z.]+)" _ ${version_text})
    set(jts_port ${CMAKE_MATCH_1})

    set(version "${version_major}.${version_minor}.${version_patch}")
    if(NOT "${version_patch_word}" STREQUAL "")
        set(version "${version}${version_patch_word}")
        set(version_patch "${version_patch}${version_patch_word}")
    endif()

    get_filename_component(file_dir "${ARG_FILE_PATH}" DIRECTORY)
    file(MAKE_DIRECTORY "${file_dir}")

    file(WRITE "${ARG_FILE_PATH}"
            "#ifndef GEOS_VERSION_H_INCLUDED\n"
            "#define GEOS_VERSION_H_INCLUDED\n"
            "#define GEOS_VERSION_MAJOR ${version_major}\n"
            "#define GEOS_VERSION_MINOR ${version_minor}\n"
            "#define GEOS_VERSION_PATCH ${version_patch}\n"
            "#define GEOS_VERSION \"${version}\"\n"
            "#define GEOS_JTS_PORT \"${jts_port}\"\n"
            "#endif\n"
    )
endfunction()
