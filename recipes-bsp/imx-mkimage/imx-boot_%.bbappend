FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
	file://mcuboot.bin \
"

do_configure:append () {
	cp ${WORKDIR}/sources-unpack/mcuboot.bin ${WORKDIR}/git/iMX95/m7_mcuboot_image.bin
	sed -i 's/m7_image.bin/m7_mcuboot_image.bin/' ${WORKDIR}/git/iMX95/soc.mak
}

