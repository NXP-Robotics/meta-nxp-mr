FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://mcuboot.bin \
	file://0001-i.MX95-Uboot-SPL-Relocate-to-DDR.patch \
"

ERROR_QA:remove = "patch-status"

do_configure:append () {
	cp ${WORKDIR}/sources-unpack/mcuboot.bin ${WORKDIR}/git/iMX95/m7_mcuboot_image.bin
	sed -i 's/m7_image.bin/m7_mcuboot_image.bin/' ${WORKDIR}/git/iMX95/soc.mak
}

