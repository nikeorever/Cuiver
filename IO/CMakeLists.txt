# Sources
file(GLOB SRCS_G "src/*.cpp")
CUIVER_SOURCES_AUTO(SRCS ${SRCS_G})

# Headers
file(GLOB_RECURSE HDRS_G "include/*.h")
CUIVER_HEADERS_AUTO(SRCS ${HDRS_G})

add_library(IO ${SRCS})
add_library(Cuiver::IO ALIAS IO)
set_target_properties(IO
        PROPERTIES
        VERSION ${SHARED_LIBRARY_VERSION} SOVERSION ${SHARED_LIBRARY_VERSION}
        OUTPUT_NAME Cuiver_IO
        LINKER_LANGUAGE CXX
        )

target_include_directories(IO
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        )

CUIVER_INSTALL(IO)
CUIVER_GENERATE_PACKAGE(IO)

if (ENABLE_TESTS)
    add_subdirectory(sample)
    add_subdirectory(test)
endif ()