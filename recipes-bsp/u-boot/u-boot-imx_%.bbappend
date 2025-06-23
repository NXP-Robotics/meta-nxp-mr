
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.12.y"
SRCREV = "ec8e406f0acb281ed5816bdcf7e87edcda294b10"
UBOOT_SRC = "git://git@github.com/NXPHoverGames/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"


SRC_URI += "${@bb.utils.contains('MACHINE', "imx95-19x19-navq", 'file://imx95-19x19-navq.cfg', '', d)}"
