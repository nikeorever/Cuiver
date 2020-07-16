macro(CUIVER_HEADERS_AUTO out)
    foreach (f ${ARGN})
        get_filename_component(fname ${f} NAME)

        # Read the package name from the source file
        file(STRINGS ${f} package REGEX "// Package: (.*)")
        if (package)
            string(REGEX REPLACE ".*: (.*)" "\\1" name ${package})
            #message(STATUS "Header: ${name} ${f}")
            CUIVER_HEADERS(${out} ${name} ${f})
        else ()
            #message(STATUS "Header: Unknown ${f}")
            CUIVER_HEADERS(${out} Unknown ${f})
        endif ()
    endforeach ()
endmacro()

macro(CUIVER_HEADERS out name)
    set_source_files_properties(${ARGN} PROPERTIES HEADER_FILE_ONLY TRUE)
    source_group("${name}\\Header Files" FILES ${ARGN})
    list(APPEND ${out} ${ARGN})
endmacro()


macro(CUIVER_SOURCES out name)
    CUIVER_SOURCES_PLAT(${out} ${name} ON ${ARGN})
endmacro()

macro(CUIVER_SOURCES_AUTO out)
    CUIVER_SOURCES_AUTO_PLAT(${out} ON ${ARGN})
endmacro()

macro(CUIVER_SOURCES_AUTO_PLAT out platform)
    foreach (f ${ARGN})
        # File name without directory
        get_filename_component(fname ${f} NAME)

        # Read the package name from the source file
        file(STRINGS ${f} package REGEX "// Package: (.*)")
        if (package)
            string(REGEX REPLACE ".*: (.*)" "\\1" name ${package})

            # Files of the Form X_UNIX.cpp are treated as headers
            if (${fname} MATCHES ".*_.*\\..*")
                #message(STATUS "Platform: ${name} ${f} ${platform}")
                CUIVER_SOURCES_PLAT(${out} ${name} OFF ${f})
            else ()
                #message(STATUS "Source: ${name} ${f} ${platform}")
                CUIVER_SOURCES_PLAT(${out} ${name} ${platform} ${f})
            endif ()
        else ()
            #message(STATUS "Source: Unknown ${f} ${platform}")
            CUIVER_SOURCES_PLAT(${out} Unknown ${platform} ${f})
        endif ()
    endforeach ()
endmacro()

macro(CUIVER_SOURCES_PLAT out name platform)
    source_group("${name}\\Source Files" FILES ${ARGN})
    list(APPEND ${out} ${ARGN})
    if (NOT (${platform}))
        set_source_files_properties(${ARGN} PROPERTIES HEADER_FILE_ONLY TRUE)
    endif ()
endmacro()


#===============================================================================
# Macros for simplified installation
#
#  CUIVER_INSTALL - Install the given target
#    Usage: CUIVER_INSTALL(target_name)
#      INPUT:
#           target_name             the name of the target.
#    Example: CUIVER_INSTALL(IO)
macro(CUIVER_INSTALL target_name)
    install(
            DIRECTORY include/Cuiver
            DESTINATION include
            COMPONENT Devel
            PATTERN ".svn" EXCLUDE
    )

    install(
            TARGETS "${target_name}" EXPORT "${target_name}Targets"
            LIBRARY DESTINATION lib${LIB_SUFFIX}
            ARCHIVE DESTINATION lib${LIB_SUFFIX}
            RUNTIME DESTINATION bin
            INCLUDES DESTINATION include
    )
endmacro()

#===============================================================================
# Macros for Package generation
#
#  CUIVER_GENERATE_PACKAGE - Generates *Config.cmake
#    Usage: CUIVER_GENERATE_PACKAGE(target_name)
#      INPUT:
#           target_name             the name of the target.
#    Example: CUIVER_GENERATE_PACKAGE(Foundation)
macro(CUIVER_GENERATE_PACKAGE target_name)
    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(
            "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}ConfigVersion.cmake"
            VERSION ${PROJECT_VERSION}
            COMPATIBILITY AnyNewerVersion
    )
    if ("${CMAKE_VERSION}" VERSION_LESS "3.0.0")
        if (NOT EXISTS "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Targets.cmake")
            export(TARGETS "${target_name}" APPEND
                    FILE "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Targets.cmake"
                    NAMESPACE "${PROJECT_NAME}::"
                    )
        endif ()
    else ()
        export(EXPORT "${target_name}Targets"
                FILE "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Targets.cmake"
                NAMESPACE "${PROJECT_NAME}::"
                )
    endif ()
    configure_file("cmake/Cuiver${target_name}Config.cmake"
            "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Config.cmake"
            @ONLY
            )

    # Set config script install location in a location that find_package() will
    # look for, which is different on MS Windows than for UNIX
    # Note: also set in root CMakeLists.txt
    if (WIN32)
        set(CuiverConfigPackageLocation "cmake")
    else ()
        set(CuiverConfigPackageLocation "lib${LIB_SUFFIX}/cmake/${PROJECT_NAME}")
    endif ()

    install(
            EXPORT "${target_name}Targets"
            FILE "${PROJECT_NAME}${target_name}Targets.cmake"
            NAMESPACE "${PROJECT_NAME}::"
            DESTINATION "${CuiverConfigPackageLocation}"
    )

    install(
            FILES
            "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Config.cmake"
            "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}ConfigVersion.cmake"
            DESTINATION "${CuiverConfigPackageLocation}"
            COMPONENT Devel
    )

endmacro()
