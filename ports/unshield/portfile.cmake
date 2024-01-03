vcpkg_download_distfile(ARCHIVE
    URLS https://github.com/bwrsandman/unshield/archive/6da5ca2d9461898d7d99f0f0c363654a85cfbf23.tar.gz
    FILENAME unshield-${VERSION}.tar.gz
    SHA512 8af4c6d5fac39c7d169ec66302b2fd432804443fb7954a98eb6086f579f1a0ccd1c39719e332c47fe2417070ebbc5a966d2b5e09a9a2b719a6c0edf8f048a26b
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
