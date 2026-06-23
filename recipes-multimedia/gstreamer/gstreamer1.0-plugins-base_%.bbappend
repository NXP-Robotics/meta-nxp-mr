# libEGL.so is installed under ${libdir}/mali-imx/ for imx95 Mali GPU.
# The linker needs an explicit -L path to find it at link time.
# mali-imx puts EGL/GLES in ${libdir}/mali-imx/ for runtime GPU switching.
# Test binaries that link libgstgl (which has DT_NEEDED: libEGL.so.1) need
# --rpath-link so the linker can resolve that transitive dependency at build time.
# (-L does not work here; it only resolves explicit -lname arguments.)
LDFLAGS:append:imxmali = " -Wl,-rpath-link,${STAGING_LIBDIR}/mali-imx"

ERROR_QA:remove = "buildpaths"