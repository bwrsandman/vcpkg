if(VCPKG_TARGET_IS_WINDOWS)
  vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO "bkaradzic/bgfx.cmake"
  HEAD_REF master
  REF c0ce1388cc8750894127c56daaa22063aa88bd70
  SHA512 5204a42d2ea309caabfb44c1257208ec7b8f3aa6def265400e08348cd14c725859ed4015ae32a55de18d5c53b4593b32069d233ed5616059fb87440ac8e60b2c
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BX
  REPO "bkaradzic/bx"
  HEAD_REF master
  REF 24527eabfd135dca569904baff1bdfd004ef8b41
  SHA512 d66f202143725788c693c5048a4461d148f1b10ac9bd79d59b9f9732ea546765a75a7dbe6cbed44dab9efaf69bdae25a229e2ed06d3e2b83b14f59b38758a120
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BIMG
  REPO "bkaradzic/bimg"
  HEAD_REF master
  REF 59f188a6add2c9ac4b986ccf9724575d3c41da9b
  SHA512 c5d2545a10bd8037a19546da6bacb6f8cddda312c9e9d84d60fb486ac6239dab8fbb95b1d6c3d7cce4f3682b26f2537968d503814c08449facb633c1d51b8d37
)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH_BGFX
  REPO "bkaradzic/bgfx"
  HEAD_REF master
  REF d1feabe3194b4b41ffd9c5747536acfadeae919b
  SHA512 54235179683cc78bd9b53809268a5f6fea3a9564b0549b0a6ad4a000daa049cbf19ef9cfafd4c57fbfda1b942a676abaacacd43df08e3b364d1ba2f8ce30e39b
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
