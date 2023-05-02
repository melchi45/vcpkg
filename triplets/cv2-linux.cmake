set(TOOLCHAIN_PATH "/usr/local/linaro-aarch64-2018.08-gcc8.2/bin/aarch64-linux-gnu-")

set(CMAKE_C_COMPILER   "${TOOLCHAIN_PATH}gcc" )
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PATH}g++" )
set(CMAKE_LINKER       "${TOOLCHAIN_PATH}ld" )
set(CMAKE_NM           "${TOOLCHAIN_PATH}nm" )
set(CMAKE_OBJCOPY      "${TOOLCHAIN_PATH}objcopy" )
set(CMAKE_OBJDUMP      "${TOOLCHAIN_PATH}objdump" )
set(CMAKE_RANLIB       "${TOOLCHAIN_PATH}ranlib" )
set(CMAKE_AR           "${TOOLCHAIN_PATH}ar" )

set(CMAKE_CROSSCOMPILING TRUE)

set(VCPKG_TARGET_ARCHITECTURE arm)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

