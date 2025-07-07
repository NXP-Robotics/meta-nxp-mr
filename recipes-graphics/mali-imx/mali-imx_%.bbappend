FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://blacklist-panthor.conf \
            file://switch_mali_gpu_driver.sh"

RDEPENDS:mali-imx += "bash"

do_install:append () {
    # Blacklist Panthor drm driver.
    install -d ${D}${sysconfdir}/modprobe.d
    install -m 0644 ${UNPACKDIR}/blacklist-panthor.conf ${D}${sysconfdir}/modprobe.d/

    # Copy mali_csff.bin for use with Panthor drm driver.
    install -d  ${D}${nonarch_base_libdir}/firmware/arm/mali/arch10.12/
    cp ${S}/usr/lib/firmware/mali_csffw.bin ${D}${nonarch_base_libdir}/firmware/arm/mali/arch10.12/mali_csffw.bin

    # Move mali-imx (e)gl libraries to it's own folder
    install -d ${D}${libdir}/mali-imx
    find ${D}${libdir} -maxdepth 1 -type f ! -name 'libmali*' -exec mv {} ${D}${libdir}/mali-imx/ \;
    find ${D}${libdir} -maxdepth 1 -type l ! -name 'libmali*' -exec mv {} ${D}${libdir}/mali-imx/ \;

    # Replace /usr/lib with /usr/lib/mali-imx in all .pc files
    for pcfile in $(find ${D} -name '*.pc'); do
        sed -i 's|/usr/lib|/usr/lib/mali-imx|g' "$pcfile"
    done

    # Add mali-imx library path to ldconfig
    install -d ${D}${sysconfdir}/ld.so.conf.d/
    echo "/usr/lib/mali-imx" > ${D}${sysconfdir}/ld.so.conf.d/mali-imx.conf

    # Install gpu switch tool
    install -d ${D}${bindir}
    install -m 0755 ${UNPACKDIR}/switch_mali_gpu_driver.sh ${D}${bindir}/switch_mali_gpu_driver
}


FILES:${PN}-libegl = " \
    ${libdir}/mali-imx/libEGL${SOLIBS}"
FILES:${PN}-libgbm = " \
    ${libdir}/mali-imx/libgbm${SOLIBS}"
FILES:${PN}-libgles1 = " \
    ${libdir}/mali-imx/libGLESv1_CM${SOLIBS}"
FILES:${PN}-libgles2 = " \
    ${libdir}/mali-imx/libGLESv2${SOLIBS}"
FILES:${PN}-libegl-dev = " \
    ${includedir}/EGL \
    ${includedir}/KHR \
    ${libdir}/mali-imx/libEGL${SOLIBSDEV} \
    ${libdir}/pkgconfig/egl.pc"
FILES:${PN}-libgbm-dev = " \
    ${includedir}/gbm.h \
    ${libdir}/mali-imx/libgbm${SOLIBSDEV} \
    ${libdir}/pkgconfig/gbm.pc"
FILES:${PN}-libgles-dev = " \
    ${includedir}/GLES* \
    ${libdir}/mali-imx/libGLES*${SOLIBSDEV} \
    ${libdir}/pkgconfig/gles*.pc"


FILES:${PN} += "/lib/firmware/arm/mali/arch10.12/*"

ERROR_QA:remove = "libdir patch-status"
