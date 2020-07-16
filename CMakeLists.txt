cmake_minimum_required(VERSION 3.16)
project(Cuiver)

file(STRINGS "${PROJECT_SOURCE_DIR}/libversion" SHARED_LIBRARY_VERSION)
# Read the version information from the VERSION file
file(STRINGS "${PROJECT_SOURCE_DIR}/VERSION" PACKAGE_VERSION)
string(REGEX REPLACE "([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" CPACK_PACKAGE_VERSION_MAJOR ${PACKAGE_VERSION})
string(REGEX REPLACE "[0-9]+\\.([0-9]+)\\.[0-9]+.*" "\\1" CPACK_PACKAGE_VERSION_MINOR ${PACKAGE_VERSION})
string(REGEX REPLACE "[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" CPACK_PACKAGE_VERSION_PATCH ${PACKAGE_VERSION})

set(PROJECT_VERSION ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH})
set(RELEASE_NAME "Unstable-trunk")

# Put the libaries and binaries that get built into directories at the
# top of the build tree rather than in hard-to-find leaf
# directories. This simplifies manual testing and the use of the build
# tree rather than installed Boost libraries.
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
# Windows DLLs are "runtime" for CMake. Output them to "bin" like the Visual Studio projects do.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Append our module directory to CMake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

##########change it in the future
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/usr/local" CACHE PATH "${CMAKE_BINARY_DIR}/usr/local/cache" FORCE)

#################################################################################
# Setup C/C++ compiler options
#################################################################################

# C++11/14 compiler flags
include(CXX1x)
check_for_cxx14_compiler(CXX14_COMPILER)

# If a C++14 compiler is available, then set the appropriate flags
if (CXX14_COMPILER)
    set(CMAKE_CXX_STANDARD 14)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
else()
    message(FATAL_ERROR "Compiler does not support C++14")
endif()

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "RelWithDebInfo")
endif ()

# Include some common macros to simpilfy the Cuiver CMake files
include(CuiverMacros)

if (CUIVER_STATIC)
    message(WARNING "CUIVER_STATIC has been deprecated. Please use BUILD_SHARED_LIBS instead.")
    option(BUILD_SHARED_LIBS "Build shared libraries" OFF)
else()
    option(BUILD_SHARED_LIBS "Build shared libraries" ON)
endif ()

# Allow enabling and disabling components
option(ENABLE_COLLECTION "Enable Collection" ON)
option(ENABLE_IO "Enable IO" ON)

option(ENABLE_TESTS
        "Set to OFF|ON (default is OFF) to control build of CUIVER tests & samples" OFF)

if(ENABLE_TESTS)
    # Google Test configuration
    configure_file(cmake/GoogleTestConfig.txt.in googletest-download/CMakeLists.txt)
    execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
            RESULT_VARIABLE result
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download
            )
    if (result)
        message(FATAL_ERROR "CMake step for googletest failed: ${result}")
    endif ()
    execute_process(COMMAND ${CMAKE_COMMAND} --build .
            RESULT_VARIABLE result
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download )
    if(result)
        message(FATAL_ERROR "Build step for googletest failed: ${result}")
    endif()
    # Prevent overriding the parent project's compiler/linker
    # settings on Windows
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

    # Add googletest directly to our build. This defines
    # the gtest and gtest_main targets.
    add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/googletest-src
            ${CMAKE_CURRENT_BINARY_DIR}/googletest-build
            EXCLUDE_FROM_ALL)

    # The gtest/gtest_main targets carry header search path
    # dependencies automatically when using CMake 2.8.11 or
    # later. Otherwise we have to add them here ourselves.
    if (CMAKE_VERSION VERSION_LESS 2.8.11)
        include_directories("${gtest_SOURCE_DIR}/include")
    endif()
    message(STATUS "Building with unittests & samples")
else()
    message(STATUS "Building without tests & samples")
endif()

# Collect the built libraries and include dirs, the will be used to create the CuiverConfig.cmake file
set(Cuiver_COMPONENTS "")

if (ENABLE_COLLECTION)
    add_subdirectory(Collection)
    list(APPEND Cuiver_COMPONENTS "Collection")
endif ()

if (ENABLE_IO)
   add_subdirectory(IO)
   list(APPEND Cuiver_COMPONENTS "IO")
endif ()

message(STATUS "CMake ${CMAKE_VERSION} successfully configured ${PROJECT_NAME} using ${CMAKE_GENERATOR} generator")
message(STATUS "Installation target path: ${CMAKE_INSTALL_PREFIX}")

message(STATUS "C_FLAGS:  =${CMAKE_C_FLAGS}")
message(STATUS "CMAKE_C_FLAGS_DEBUG:=${CMAKE_C_FLAGS_DEBUG}")
message(STATUS "CMAKE_C_FLAGS_RELEASE:=${CMAKE_C_FLAGS_RELEASE}")
message(STATUS "CMAKE_C_FLAGS_MINSIZEREL:=${CMAKE_C_FLAGS_MINSIZEREL}")
message(STATUS "CMAKE_C_FLAGS_RELWITHDEBINFO:=${CMAKE_C_FLAGS_RELWITHDEBINFO}")
message(STATUS "")
message(STATUS "")
message(STATUS "CXX_FLAGS:=${CMAKE_CXX_FLAGS}")
message(STATUS "CMAKE_CXX_FLAGS_DEBUG:=${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "CMAKE_CXX_FLAGS_RELEASE:=${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "CMAKE_CXX_FLAGS_MINSIZEREL:=${CMAKE_CXX_FLAGS_MINSIZEREL}")
message(STATUS "CMAKE_CXX_FLAGS_RELWITHDEBINFO:=${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")

foreach(component ${Cuiver_COMPONENTS})
    message(STATUS "Building: ${component}")
endforeach()