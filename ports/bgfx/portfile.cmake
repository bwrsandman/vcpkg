vcpkg_download_distfile(ARCHIVE
  URLS "https://github.com/bwrsandman/bgfx.cmake/archive/refs/heads/truer-bgfx.tar.gz"
  FILENAME "v1.118.8384-362.tar.gz"
  SHA512 f2f282e77bee1d45722ac0283dffae3421c45cd000a6dc046e55cfa3293c210de46401c303279177943ec9b4736ae2ac0049c94b4c4b9bd651b6c5940d08162a
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BX
  REPO "bkaradzic/bx"
  HEAD_REF master
  REF aed1086c48884b1b4f1c2f9af34c5198624263f6
  SHA512 63bc5c6358f6a760bd5d8d056ef6fc6de175dcf8b940d5490225f13dfdd791c6b1d6bd2087d5d48a34955649bc12cbcc92f5221188ba0df5eb5c5d00eb389e94
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BIMG
  REPO "bkaradzic/bimg"
  HEAD_REF master
  REF 1af90543ca262c1cfa10aa477aef9dc1b11419f4
  SHA512 309b1e1aeb5fc1bdd189e848b642a209d27602ea5f5cdc405cc0ab8f17bc426f5a331fb396424b0ebad49407638c85d0d97fee51faf10750e512a30b49cabd23
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BGFX
  REPO "bkaradzic/bgfx"
  HEAD_REF master
  REF 5f435ea56b29c3dd3ebdf9fab1a8f408681ff919
  SHA512 5d072fad3c1bfdf0c805f9cf18f34e10cbeb602e9bb7440c962fed58c400b89e9e6487e9986cfcd16d3ab65916a37ef62ebc6b43560ce132364a4e2466138f63
)

vcpkg_check_features(
  OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES tools BGFX_BUILD_TOOLS multithreaded BGFX_CONFIG_MULTITHREADED
)

if (BGFX_BUILD_TOOLS AND TARGET_TRIPLET MATCHES "(windows|uwp)")
  # bgfx doesn't apply __declspec(dllexport) which prevents dynamic linking for tools
  set(BGFX_LIBRARY_TYPE "STATIC")
elseif (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  set(BGFX_LIBRARY_TYPE "SHARED")
else ()
  set(BGFX_LIBRARY_TYPE "STATIC")
endif ()

vcpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/vcpkg-inject-packages.cmake" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS -DBX_DIR=${SOURCE_PATH_BX}
          -DBIMG_DIR=${SOURCE_PATH_BIMG}
          -DBGFX_DIR=${SOURCE_PATH_BGFX}
          -DBGFX_LIBRARY_TYPE=${BGFX_LIBRARY_TYPE}
          -DBX_AMALGAMATED=ON
          -DBGFX_AMALGAMATED=ON
          -DBGFX_BUILD_EXAMPLES=OFF
          -DBGFX_OPENGLES_VERSION=30
          -DBGFX_CMAKE_USER_SCRIPT=vcpkg-inject-packages.cmake
          ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
vcpkg_copy_pdbs()

if (BGFX_BUILD_TOOLS)
  vcpkg_copy_tools(
    TOOL_NAMES bin2c shaderc geometryc geometryv texturec texturev AUTO_CLEAN
  )
endif ()

# Handle copyright
file(
  INSTALL "${CURRENT_PACKAGES_DIR}/share/licences/${PORT}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/licences"
     "${CURRENT_PACKAGES_DIR}/debug/include"
     "${CURRENT_PACKAGES_DIR}/debug/share"
)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT VCPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()
