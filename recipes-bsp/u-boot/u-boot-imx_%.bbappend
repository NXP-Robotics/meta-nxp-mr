
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.6.52"
SRCREV = "2792ad610980324a11b08e5ee145ff75d8da68fd"
UBOOT_SRC = "git://git@github.com/NXPHoverGames/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"


SRC_URI += "${@bb.utils.contains('MACHINE', "imx95-19x19-navq", 'file://imx95-19x19-navq.cfg', '', d)}"
