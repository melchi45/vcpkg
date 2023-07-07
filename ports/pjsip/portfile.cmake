if(NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(FATAL_ERROR "Package only supports Linux platform.")
endif()

if(VCPKG_TARGET_IS_LINUX)
    message("${PORT} currently requires the following tools and libraries from the system package manager:\n  autoreconf libtool libudev\nThese can be installed on Ubuntu systems via apt-get install autoreconf libtool libudev-dev\n")
endif()

set(PJSIP_VERSION "2.13")
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pjsip/pjproject
    REF refs/tags/${PJSIP_VERSION}
    SHA512 df184511d554e5f77ca1a551bdf6b22c4c8ae2b6ad61be0e7e459e2d7db50f496af66c37e080f178019a509ea25847e70a342ac48c820a6b9302b4cbf174c520
    HEAD_REF master
    #    PATCHES
    #	0001_change_path.patch
)

#if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
#	set(OPTIONS --disable-strip)
#endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
	set(OPTIONS ${OPTIONS} "--enable-shared")
endif()

#set(OPTIONS ${OPTIONS} LIBS=-lpthread)

# This is general vcpkg configure. But this is not operating in Linux.
# because of autoconf fault in vcpkg_configure_make.
vcpkg_configure_make(
	SOURCE_PATH "${SOURCE_PATH}"
	COPY_SOURCE
	#AUTOCONFIG
	OPTIONS
		--prefix=${CURRENT_INSTALLED_DIR}
		--with-ssl=${CURRENT_INSTALLED_DIR}
		${OPTIONS}
)

vcpkg_install_make()
#vcpkg_fixup_pkgconfig()

#file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
#if(VCPKG_BUILD_TYPE STREQUAL "release")
#	file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/etc")
#	file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/libexec")
#endif()

#file(INSTALL "${SOURCE_PATH}/LICENCE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
