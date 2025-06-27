FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://blacklist-mali_kbase.conf"

do_install:append () {
    # Blacklist mali-imx to use Panthor drm driver instead.
    install -d ${D}${sysconfdir}/modprobe.d
    install -m 0644 ${UNPACKDIR}/blacklist-mali_kbase.conf ${D}${sysconfdir}/modprobe.d/

    # Copy mali_csff.bin for Panthor drm driver.
	install -d  ${D}${nonarch_base_libdir}/firmware/arm/mali/arch10.12/
	cp ${S}/usr/lib/firmware/mali_csffw.bin ${D}${nonarch_base_libdir}/firmware/arm/mali/arch10.12/mali_csffw.bin
}

FILES:${PN} += "/lib/firmware/arm/mali/arch10.12/*"

ERROR_QA:remove = "libdir patch-status"
