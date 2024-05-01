if(NOT DISTRO MATCHES "Fedora")
    return()
endif()

# Separate packages for each component
set(CPACK_RPM_COMPONENT_INSTALL ON)

# Distribution version, e.g., fc39 for Fedora 39 ("Fedora Core")
cmake_host_system_information(RESULT DISTRO_VERSION_ID QUERY DISTRIB_VERSION_ID)
set(RPM_VERSION "fc${DISTRO_VERSION_ID}")

# Convert from processor type to Architecture
if(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
    set(SRCML_SYSTEM_ARCHITECTURE "aarch64")
else()
    set(SRCML_SYSTEM_ARCHITECTURE "x86_64")
endif()

# RPM release, not part of major-minor-patch
set(CPACK_RPM_PACKAGE_RELEASE 1)

# RPM component package names
set(CPACK_RPM_CLIENT_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
set(CPACK_RPM_DEVLIB_PACKAGE_NAME "libsrcmlxpathcount")
set(CPACK_RPM_DEVELOPER_PACKAGE_NAME "libsrcmlxpathcount-devel")

# RPM component file names
set(CPACK_RPM_CLIENT_FILE_NAME "${CPACK_RPM_CLIENT_PACKAGE_NAME}-${PROJECT_VERSION}-${CPACK_RPM_PACKAGE_RELEASE}.${RPM_VERSION}.${SRCML_SYSTEM_ARCHITECTURE}.rpm")
set(CPACK_RPM_DEVLIB_FILE_NAME "${CPACK_RPM_DEVLIB_PACKAGE_NAME}-${PROJECT_VERSION}-${CPACK_RPM_PACKAGE_RELEASE}.${RPM_VERSION}.${SRCML_SYSTEM_ARCHITECTURE}.rpm")
set(CPACK_RPM_DEVELOPER_FILE_NAME "${CPACK_RPM_DEVELOPER_PACKAGE_NAME}-${PROJECT_VERSION}-${CPACK_RPM_PACKAGE_RELEASE}.${RPM_VERSION}.${SRCML_SYSTEM_ARCHITECTURE}.rpm")

# RPM component dependencies
set(CPACK_RPM_CLIENT_PACKAGE_DEPENDS "${CPACK_RPM_DEVLIB_PACKAGE_NAME} >= ${PROJECT_VERSION}")
set(CPACK_RPM_DEVLIB_PACKAGE_DEPENDS "")
set(CPACK_RPM_DEVELOPER_PACKAGE_DEPENDS "${CPACK_RPM_DEVLIB_PACKAGE_NAME} >= ${PROJECT_VERSION}")

# post install script for ldconfig
# Note: Believe that newline is required
file(WRITE ${CPACK_BINARY_DIR}/post.sh "/sbin/ldconfig\n")
set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE   ${CPACK_BINARY_DIR}/post.sh)
set(CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE ${CPACK_BINARY_DIR}/post.sh)
