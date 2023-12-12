vcpkg_download_distfile(ARCHIVE
    URLS https://github.com/twogood/unshield/archive/refs/tags/${VERSION}.tar.gz
    FILENAME unshield-${VERSION}.tar.gz
    SHA512 acb130c461bed66dc3804394be067a68aea96a7cd20b348e713f64a11bf642b74f68fc172f220a9790b44573abbe01ed4585191158f27c40e863918a7342c1ca
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

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/pkgconfig")

vcpkg_copy_tools(TOOL_NAMES unshield AUTO_CLEAN)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
