FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-i.MX95-Uboot-SPL-Relocate-to-DDR.patch \
"

ERROR_QA:remove = "patch-status"

do_configure[mcdepends] += "mc:imx95-navqdesktop:imx95-navq-m7:zephyr-mcuboot:do_deploy"

do_configure:append () {
	cp ${TOPDIR}/tmp/m7_mcuboot_image.bin ${S}/iMX95/m7_mcuboot_image.bin
	sed -i 's/m7_image.bin/m7_mcuboot_image.bin/' ${S}/iMX95/soc.mak
}
