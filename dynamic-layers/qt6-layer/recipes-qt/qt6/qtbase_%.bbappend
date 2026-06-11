PACKAGECONFIG_VULKAN_IMX_GPU:remove:mx8-nxp-bsp   = "vulkan"

# cmake's FindGLESv2 uses find_library() which only searches standard lib paths.
# For imx95/Mali the .so lives in ${libdir}/mali-imx/ — pass it explicitly.
EXTRA_OECMAKE:append:imxmali = " \
    -DGLESv2_LIBRARY=${STAGING_LIBDIR}/mali-imx/libGLESv2.so \
    -DGLESv2_INCLUDE_DIR=${STAGING_INCDIR} \
"
