if(VCPKG_TARGET_IS_WINDOWS)
  vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO "bkaradzic/bgfx.cmake"
  HEAD_REF master
  REF 79e4993ca5e49aa0e72d6c153d358a2576a7b6c1
  SHA512 f233b65114f3fe5a32e67efabf76f8bdf6a2515a567289e58f296a6bb208aa108b0474f1e5014da583f4bd02b304b0c3a5bf11ca2c81205940d64b658c3979a3
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BX
  REPO "bkaradzic/bx"
  HEAD_REF master
  REF e7ede513dc8b90386960587e348c73b241f7735d
  SHA512 46dd34848378b753f2d2158ffc2d6461a27364c167ca79858ae6e88f9ffcf028c5be23638a54d5399c1c3e1f981499caf1a88a815ae488478ab411faaf2d50c4
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BIMG
  REPO "bkaradzic/bimg"
  HEAD_REF master
  REF 2afa64c14c1e3dd5d28412ee03bee0dfe7242f03
  SHA512 91d56f2731d654f3c9942053e920268c648721ca62ab139df834f8358fd022ff274a06bbc80e6245da7d61f88721795d7734cd8b7d10cc219931633496261228
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BGFX
  REPO "bkaradzic/bgfx"
  HEAD_REF master
  REF cc749601adff5d6e2850cabe889191a66bf48f78
  SHA512 f93e57714b022e97562cf7c1e7b3f2babfdceb8348274982e211248407169a8929b0b293bcd2c3258623f0d2cdefcdff116ab67eeae2dbadb9e232229893aa31
)

vcpkg_check_features(
  OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    tools         BGFX_BUILD_TOOLS
    multithreaded BGFX_CONFIG_MULTITHREADED
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  set(BGFX_LIBRARY_TYPE "SHARED")
else ()
  set(BGFX_LIBRARY_TYPE "STATIC")
endif ()

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DBX_DIR=${SOURCE_PATH_BX}
    -DBIMG_DIR=${SOURCE_PATH_BIMG}
    -DBGFX_DIR=${SOURCE_PATH_BGFX}
    -DBGFX_LIBRARY_TYPE=${BGFX_LIBRARY_TYPE}
    -DBX_AMALGAMATED=ON
    -DBGFX_AMALGAMATED=ON
    -DBGFX_BUILD_EXAMPLES=OFF
    -DBGFX_OPENGLES_VERSION=30
    "-DBGFX_CMAKE_USER_SCRIPT=${CURRENT_PORT_DIR}/vcpkg-inject-packages.cmake"
    "-DBGFX_ADDITIONAL_TOOL_PATHS=${CURRENT_INSTALLED_DIR}/../${HOST_TRIPLET}/tools/bgfx"
    ${FEATURE_OPTIONS}
  OPTIONS_DEBUG
    -DBGFX_BUILD_TOOLS=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
vcpkg_copy_pdbs()

if ("tools" IN_LIST FEATURES)
  vcpkg_copy_tools(TOOL_NAMES bin2c shaderc geometryc geometryv texturec texturev AUTO_CLEAN)
endif ()

vcpkg_install_copyright(
  FILE_LIST "${CURRENT_PACKAGES_DIR}/share/licences/${PORT}/LICENSE"
  COMMENT [[
bgfx includes third-party components which are subject to specific license
terms. Check the sources for details.
]])

file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/share/licences"
  "${CURRENT_PACKAGES_DIR}/debug/include"
  "${CURRENT_PACKAGES_DIR}/debug/share"
)
