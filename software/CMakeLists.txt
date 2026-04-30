cmake_minimum_required(VERSION 3.23)

add_compile_options(-Wall -Wextra -Wpedantic -Werror -O0 -g)

project(software C)

add_executable(software)

target_include_directories(software PRIVATE include/)
target_include_directories(software SYSTEM PRIVATE /opt/picoscope/include)

set(SOURCE_DIRECTORY src/)

target_sources(software PRIVATE
	${SOURCE_DIRECTORY}/main.c
	${SOURCE_DIRECTORY}/pico.c
	${SOURCE_DIRECTORY}/graph.c
)

target_link_libraries(software "/opt/picoscope/lib/libps2000.so.2" m cairo X11 pthread)
