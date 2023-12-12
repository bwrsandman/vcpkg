vcpkg_download_distfile(ARCHIVE
    URLS https://github.com/twogood/unshield/archive/082df8dab34617ff26b75b3759e437bcb498767b.tar.gz
    FILENAME unshield-${VERSION}.tar.gz
    SHA512 e29ac260fefc17c570b6632c19fecc35d99e31ea70f949f43624185d9b01d911a4f7376dd38ed5af1e7e528c94ba3da9475ee2b8832c2c2758bbf0b0370d050f
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(BUILD_STATIC OFF)
else()
    set(BUILD_STATIC ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS BUILD_STATIC=${BUILD_STATIC}
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/unshield)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/pkgconfig")

vcpkg_copy_tools(TOOL_NAMES unshield AUTO_CLEAN)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
