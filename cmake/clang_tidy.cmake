include_guard()

find_program(CLANG_TIDY_COMMAND clang-tidy)

if(NOT CLANG_TIDY_COMMAND)
    message(FATAL_ERROR "clang-tidy not found. Static analysis will be disabled.")
endif()

function(enable_clang_tidy TARGET)
    set(OPTIONS "")
    set(ONE_VALUE_KEYWORDS HEADER_FILTER)
    set(MULTI_VALUE_KEYWORDS "")
    cmake_parse_arguments (CLANG_TIDY "${OPTIONS}" "${ONE_VALUE_KEYWORDS}" "${MULTI_VALUE_KEYWORDS}" ${ARGN})

    if (NOT CLANG_TIDY_HEADER_FILTER)
        list(APPEND SOURCE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/*")

        get_target_property(TARGET_LINK_LIBRARIES ${TARGET} LINK_LIBRARIES)

        foreach(LINK_LIBRARY ${TARGET_LINK_LIBRARIES})
            if (NOT TARGET ${LINK_LIBRARY})
                continue()
            endif()

            get_target_property(LIBRARY_NAME ${LINK_LIBRARY} ALIASED_TARGET)

            if (NOT LIBRARY_NAME)
                set(LIBRARY_NAME ${LINK_LIBRARY})
            endif()

            get_target_property(LIBRARY_SOURCE_DIR ${LIBRARY_NAME} SOURCE_DIR)

            if (LIBRARY_SOURCE_DIR MATCHES "^${CMAKE_SOURCE_DIR}/")
                list(APPEND SOURCE_DIRS "${LIBRARY_SOURCE_DIR}/*")
            endif()
        endforeach()

        list(JOIN SOURCE_DIRS "|" SOURCE_DIRS)
        set(CLANG_TIDY_HEADER_FILTER "${SOURCE_DIRS}")
    endif()

    set(CLANG_TIDY_PROPERTIES
        "${CMAKE_COMMAND}"
        "-DCLANG_TIDY_HEADER_FILTER=${CLANG_TIDY_HEADER_FILTER}"
        "-DCLANG_TIDY_CONFIG=${CMAKE_SOURCE_DIR}/.clang-tidy"
        "-DCLANG_TIDY_BUILD_DIR=${CMAKE_BINARY_DIR}"
        -P
        "${CMAKE_SOURCE_DIR}/cmake/clang_tidy.cmake"
    )

    set_target_properties(${TARGET}
    PROPERTIES
        CXX_CLANG_TIDY "${CLANG_TIDY_PROPERTIES}"
    )
endfunction()

if(CMAKE_SCRIPT_MODE_FILE)
    find_program(CLANG_TIDY_COMMAND clang-tidy)

    if(NOT CLANG_TIDY_COMMAND)
        message(FATAL_ERROR "clang-tidy not found. Static analysis will be disabled.")
    endif()

    set(FILTERED_ARGS "")
    set(START_OF_CLANG_TIDY_ARGS OFF)
    math(EXPR last_arg "${CMAKE_ARGC} - 1")
    set(LAST_ARG "")

    foreach(i RANGE 0 ${last_arg})
        set(ARG "${CMAKE_ARGV${i}}")

        if(NOT START_OF_CLANG_TIDY_ARGS)
            if(ARG MATCHES ".*/clang_tidy.cmake$")
                set(START_OF_CLANG_TIDY_ARGS ON)
            endif()

            continue()
        endif()

        if(ARG STREQUAL "--")
            if (LAST_ARG MATCHES ".*(.cache|JuceLibraryCode).*|.*.mm")
                cmake_language(EXIT 0)
            endif()
        endif()

        set(LAST_ARG ${ARG})

        if(ARG STREQUAL "-GL")
            continue()
        elseif(ARG MATCHES "^/GL$")
            continue()
        else()
            list(APPEND FILTERED_ARGS "${ARG}")
        endif()
    endforeach()

    execute_process(
        COMMAND ${CLANG_TIDY_COMMAND} "--header-filter=${CLANG_TIDY_HEADER_FILTER}" "--config-file=${CLANG_TIDY_CONFIG}" -p "${CLANG_TIDY_BUILD_DIR}" ${FILTERED_ARGS}
        RESULT_VARIABLE RESULT
    )

    if(NOT RESULT EQUAL 0)
        message(FATAL_ERROR "clang-tidy failed with exit code ${RESULT}")
    endif()
endif()
