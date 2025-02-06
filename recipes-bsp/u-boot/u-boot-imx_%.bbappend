
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf_v2024.04"
SRCREV = "fa409f8c7fe45e276dec1a9dc7a01eddd44daa86"
UBOOT_SRC = "git://git@github.com/NXPHoverGames/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"


SRC_URI += "${@bb.utils.contains('MACHINE', "imx95-19x19-navq", 'file://imx95-19x19-navq.cfg', '', d)}"
