cmake_minimum_required(VERSION 4.0)
project(aoc25 VERSION 1.0)

include(cmake/clang_tidy.cmake)
include(cmake/solutions.cmake)

add_subdirectory(helpers)

add_subdirectory(solutions/day01)
