include_guard()

function (add_solution)
    set(options "")
    set(oneValueArgs NAME)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(SOLUTION "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    message(STATUS "${SOLUTION_SOURCES}")

    add_executable(${SOLUTION_NAME}
        ${SOLUTION_SOURCES}
    )

    enable_clang_tidy(${SOLUTION_NAME})

    target_link_libraries(${SOLUTION_NAME}
    PRIVATE
        helpers
    )

    target_compile_features(${SOLUTION_NAME}
    PRIVATE
        cxx_std_23
    )

    target_compile_options(${SOLUTION_NAME}
    PRIVATE
        -g
        -O0
        -fconstexpr-steps=4294967295
        -Wall
        -Wbool-conversion
        -Wcast-align
        -Wconditional-uninitialized
        -Wconstant-conversion
        -Wconversion
        -Wdeprecated
        -Werror
        -Wextra-semi
        -Wfloat-equal
        -Wint-conversion
        -Wmissing-field-initializers
        -Wmissing-prototypes
        -Wno-ignored-qualifiers
        -Wnullable-to-nonnull-conversion
        -Wpedantic
        -Wshadow-all
        -Wshift-sign-overflow
        -Wshorten-64-to-32
        -Wsign-compare
        -Wsign-conversion
        -Wstrict-aliasing
        -Wswitch-enum
        -Wuninitialized
        -Wunreachable-code
        -Wunused-parameter
    )

    target_link_options(${SOLUTION_NAME}
    PRIVATE
        -Wl,-weak_reference_mismatches,weak
    )
endfunction()
