FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-i.MX95-Uboot-SPL-Relocate-to-DDR.patch \
"

ERROR_QA:remove = "patch-status"

do_configure[mcdepends] += "mc:imx95-navqdesktop:imx95-navq-m7:zephyr-mcuboot:do_deploy"

# Also build the DDR-resident M7 container (needed for PX4, which doesn't fit
# in the 256K ITCM region) alongside the existing TCM one. Prepend so it
# becomes the first (default) target -- do_deploy symlinks "imx-boot" (used
# by the .wks) to the first entry in IMXBOOT_TARGETS.
IMXBOOT_TARGETS:prepend = "flash_all_ddr "

do_configure:append () {
	cp ${TOPDIR}/tmp/m7_mcuboot_image.bin ${S}/iMX95/m7_mcuboot_image.bin
	sed -i 's/m7_image.bin/m7_mcuboot_image.bin/' ${S}/iMX95/soc.mak
	# MR-NAVQ95 reserves 0x90000000-0x914FFFFF for M7 firmware.
	sed -i 's/M7_DDR_ADDR ?= 0x80000000/M7_DDR_ADDR ?= 0x90000000/' ${S}/iMX95/soc.mak
	# Must match ATF PLAT_NS_IMAGE_OFFSET and U-Boot CONFIG_TEXT_BASE.
	sed -i 's/^\(UBOOT_LOAD_ADDR[[:space:]]*?=[[:space:]]*\)0x90200000/\10x91600000/' ${S}/iMX95/soc.mak
	grep -q '^UBOOT_LOAD_ADDR[[:space:]]*?=[[:space:]]*0x91600000' ${S}/iMX95/soc.mak || bbfatal "UBOOT_LOAD_ADDR relocation failed"
}
