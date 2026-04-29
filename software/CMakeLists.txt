cmake_minimum_required(VERSION 3.23)

add_compile_options(-Wall -Wextra -Wpedantic -Werror)

project(software C)

add_executable(software)

target_include_directories(software PRIVATE include/)
target_include_directories(software SYSTEM PRIVATE /opt/picoscope/include)

set(SOURCE_DIRECTORY src/)

target_sources(software PRIVATE
	${SOURCE_DIRECTORY}/main.c

)

find_library(PICO NAMES ps2000a HINTS /opt/picoscope/lib/)
target_link_libraries(software ${PICO})
