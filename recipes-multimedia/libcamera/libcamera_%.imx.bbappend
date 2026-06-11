FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

ERROR_QA:remove = "patch-status"

# mali-imx moves EGL/GLES libs to ${libdir}/mali-imx/ for runtime GPU switching.
# libcamera links Qt6Gui/Qt6OpenGL which have DT_NEEDED: libEGL.so.1/libGLESv2.so.2.
# --rpath-link lets the linker resolve those transitive DT_NEEDED entries at build time.
LDFLAGS:append:imxmali = " -Wl,-rpath-link,${STAGING_LIBDIR}/mali-imx"

# Qt rcc generates *_qrc.cpp files that embed TMPDIR — known Qt build artifact
INSANE_SKIP:${PN}-src += "buildpaths"
