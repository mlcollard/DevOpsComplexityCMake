# Build for Complexity program

cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

project(Complexity VERSION 1.0.0)

# srccomplexity
add_executable(srccomplexity)
target_sources(srccomplexity PRIVATE srcComplexity.cpp)
target_compile_features(srccomplexity PRIVATE cxx_std_17)
target_compile_options(srccomplexity PRIVATE
    $<$<CXX_COMPILER_ID:MSVC>:/Wall>
    $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-Wall>
)

# srcMLXPathCountTest
add_executable(srcMLXPathCountTest)
target_sources(srcMLXPathCountTest PRIVATE srcMLXPathCountTest.cpp)
target_compile_features(srcMLXPathCountTest PRIVATE cxx_std_17)

# libxml2
find_package(LibXml2 REQUIRED)
target_link_libraries(srccomplexity PRIVATE LibXml2::LibXml2)
target_link_libraries(srcMLXPathCountTest PRIVATE LibXml2::LibXml2)

# srcMLXPathCount library
add_library(srcMLXPathCount SHARED srcMLXPathCount.cpp)
target_compile_features(srcMLXPathCount PRIVATE cxx_std_17)
target_link_libraries(srcMLXPathCount PRIVATE LibXml2::LibXml2)
target_link_libraries(srccomplexity PRIVATE srcMLXPathCount)
target_link_libraries(srcMLXPathCountTest PRIVATE srcMLXPathCount)
set_target_properties(srcMLXPathCount PROPERTIES
    POSITION_INDEPENDENT_CODE ON

    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
)

# srcMLXPathCount static library
add_library(srcMLXPathCount_static STATIC srcMLXPathCount.cpp)
target_compile_features(srcMLXPathCount_static PRIVATE cxx_std_17)
target_link_libraries(srcMLXPathCount_static PRIVATE LibXml2::LibXml2)
set_target_properties(srcMLXPathCount_static PROPERTIES OUTPUT_NAME srcMLXPathCount)

# run
add_custom_target(run
    COMMENT "Complexity"
    COMMAND $<TARGET_FILE:srccomplexity> < ${CMAKE_CURRENT_SOURCE_DIR}/srcMLXPathCount.cpp.xml
    DEPENDS srccomplexity
    USES_TERMINAL
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# install
install(TARGETS srccomplexity COMPONENT CLIENT)
install(TARGETS srcMLXPathCount COMPONENT DEVLIB)
install(TARGETS srcMLXPathCount_static COMPONENT DEVELOPER)
include(GNUInstallDirs)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/srcMLXPathCount.hpp DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} COMPONENT DEVELOPER)

# Run ldconfig for install (not cpack) on Ubuntu
# The component is for ignoring in cpack
if(DISTRO AND DISTRO MATCHES "Ubuntu")
    find_program(LDCONFIG ldconfig)
    if(LDCONFIG)
        install(CODE "message(STATUS \"Running: ldconfig\")" COMPONENT LOCAL)
        install(CODE "execute_process(COMMAND ${LDCONFIG})" COMPONENT LOCAL)
    else()
        install(CODE "message(NOTICE \"   NOTE: Unable to run ldconfig. Library libsrcml.so may not be found.\n   Suggest running ldconfig manually.\")" COMPONENT LOCAL)
    endif()
endif()

# packaging
include(CPackComponent)
cpack_add_component(CLIENT
                    DISPLAY_NAME "srccomplexity"
                    DESCRIPTION "Calculates the complexity of a C++ program using the srcML format"
                    REQUIRED
                    INSTALL_TYPES CLIENT DEVELOPER)

cpack_add_component(DEVLIB
                    DISPLAY_NAME "libsrcMLXPathCount"
                    DESCRIPTION "Calculates the complexity of a C++ program using the srcML format"
                    REQUIRED
                    INSTALL_TYPES CLIENT DEVELOPER)

cpack_add_component(DEVELOPER
                    DISPLAY_NAME "libsrcMLXPathCount Developer"
                    DESCRIPTION "Include file, development libraries, i.e.., static library"
                    INSTALL_TYPES DEVELOPER)

# Hide the LOCAL components
get_cmake_property(CPACK_COMPONENTS_ALL COMPONENTS)
list(REMOVE_ITEM CPACK_COMPONENTS_ALL "LOCAL")

# General package name
set(CPACK_PACKAGE_NAME srccomplexity)

# Determine Linux distribution
if(UNIX AND NOT APPLE)
    cmake_host_system_information(RESULT DISTRO QUERY DISTRIB_NAME)
endif()

# Debian packaging
include(debian.cmake)

# Fedora packaging
include(fedora.cmake)

# testing
include(CTest)

add_test(NAME testComplexity1
         COMMAND ${CMAKE_SOURCE_DIR}/testsuite/testComplexity1.sh
         WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_test(NAME testComplexity2
         COMMAND ${CMAKE_SOURCE_DIR}/testsuite/testComplexity2.sh
         WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

set(CPACK_PACKAGE_NAME "complexity")
set(CPACK_PACKAGE_CONTACT "Me")
set(CPACK_STRIP_FILES ON)

# Leave after all cpack configuration
include(CPack)
