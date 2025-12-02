add_library(helpers INTERFACE
    math.h
)

target_include_directories(helpers
INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/..
)
