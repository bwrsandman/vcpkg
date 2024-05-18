vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO bwrsandman/bgfx.cmake
  REF cross-compile-m1
  SHA512 ebe60fb31a03aa0d28972cedfb4ea3d817cb7a1521a5595c14e0a178c419217283299d730f176484cc549d7bf1e3effaf5690816e0e827a8943247e224387e69
  HEAD_REF main
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BX
  REPO "bkaradzic/bx"
  HEAD_REF master
  REF 34ba9c7a5cf6ee6eb80eb471842a2cffd7afb187
  SHA512 2208f5f3582a7fe3f6c2962649f46303a889abdbc3de689152adf60064cb96cfc3325e0a795636dd11f9f150a9e651843d328a8fbd2519900222ee3b6d42df80
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BIMG
  REPO "bkaradzic/bimg"
  HEAD_REF master
  REF e9fa0ceff2df3399011af136c82652c81655c1d3
  SHA512 7e5511c28e590fd8dbdbf05dcf0cc94b4317dd7cfd42862b6625002f8ed7473adafa5f95b278f8da8d0e4f4be625932e95445cc855ac3746488c48c9819d707a
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BGFX
  REPO "bkaradzic/bgfx"
  HEAD_REF master
  REF 57d8a0838bb29f69be52d9486e744a99caf77105
  SHA512 63fe77d5a6e3bf7c1a98a4688f89e9bdcd1b0640c9240a958153fe3b8714d967d75517d2bcd92562069da9d38390c0dce18fd77f2fa7a53871fa6d3b16224284
)

vcpkg_check_features(
  OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES tools BGFX_BUILD_TOOLS multithreaded BGFX_CONFIG_MULTITHREADED
)

if (TARGET_TRIPLET MATCHES "(windows|uwp)")
  # bgfx doesn't apply __declspec(dllexport) which prevents dynamic linking
  set(BGFX_LIBRARY_TYPE "STATIC")
elseif (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  set(BGFX_LIBRARY_TYPE "SHARED")
else ()
  set(BGFX_LIBRARY_TYPE "STATIC")
endif ()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/vcpkg-inject-packages.cmake" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS -DBGFX_LIBRARY_TYPE=${BGFX_LIBRARY_TYPE}
          -DBX_AMALGAMATED=ON
          -DBGFX_AMALGAMATED=ON
          -DBGFX_BUILD_EXAMPLES=OFF
          -DBGFX_OPENGLES_VERSION=30
          -DBGFX_CMAKE_USER_SCRIPT=vcpkg-inject-packages.cmake
          -DBX_DIR=${SOURCE_PATH_BX}
          -DBIMG_DIR=${SOURCE_PATH_BIMG}
          -DBGFX_DIR=${SOURCE_PATH_BGFX}
          ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
vcpkg_copy_pdbs()

if ("tools" IN_LIST FEATURES)
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
