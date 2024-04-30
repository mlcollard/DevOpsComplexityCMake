# Debian packaging

if(NOT DISTRO MATCHES "Ubuntu")
    return()
endif()

# Separate packages for each component
set(CPACK_DEB_COMPONENT_INSTALL ON)

# Distribution version, e.g., ubuntu24.04
cmake_host_system_information(RESULT DISTRO_VERSION_ID QUERY DISTRIB_VERSION_ID)
cmake_host_system_information(RESULT DISTRO_ID QUERY DISTRIB_ID)
set(DEBIAN_VERSION "${DISTRO_ID}${DISTRO_VERSION_ID}")

# Convert from processor type to Architecture
if(CMAKE_SYSTEM_PROCESSOR EQUAL "aarch64")
    set(SRCML_SYSTEM_ARCHITECTURE "arm64")
else()
    set(SRCML_SYSTEM_ARCHITECTURE "amd64")
endif()

# Debian release, not part of major-minor-patch
set(CPACK_DEBIAN_PACKAGE_RELEASE 1)

# Debian component package names
set(CPACK_DEBIAN_CLIENT_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
set(CPACK_DEBIAN_DEVLIB_PACKAGE_NAME "libsrcmlxpathcount")
set(CPACK_DEBIAN_DEVELOPER_PACKAGE_NAME "libsrcmlxpathcount-dev")

# Debian component file names
set(CPACK_DEBIAN_CLIENT_FILE_NAME "${CPACK_DEBIAN_CLIENT_PACKAGE_NAME}_${PROJECT_VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE}_${DEBIAN_VERSION}_${CMAKE_SYSTEM_PROCESSOR}.deb")
set(CPACK_DEBIAN_DEVLIB_FILE_NAME "${CPACK_DEBIAN_DEVLIB_PACKAGE_NAME}_${PROJECT_VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE}_${DEBIAN_VERSION}_${CMAKE_SYSTEM_PROCESSOR}.deb")
set(CPACK_DEBIAN_DEVELOPER_FILE_NAME "${CPACK_DEBIAN_DEVELOPER_PACKAGE_NAME}_${PROJECT_VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE}_${DEBIAN_VERSION}_${CMAKE_SYSTEM_PROCESSOR}.deb")

# Debian component dependencies
set(CPACK_DEBIAN_CLIENT_PACKAGE_DEPENDS "${CPACK_DEBIAN_DEVLIB_PACKAGE_NAME} (>= ${PROJECT_VERSION})")
set(CPACK_DEBIAN_DEVLIB_PACKAGE_DEPENDS "")
set(CPACK_DEBIAN_DEVELOPER_PACKAGE_DEPENDS "${CPACK_DEBIAN_DEVLIB_PACKAGE_NAME} (>= ${PROJECT_VERSION})")
