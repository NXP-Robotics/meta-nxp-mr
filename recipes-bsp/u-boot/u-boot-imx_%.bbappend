
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.12.y"
SRCREV = "ea4ca05366dac756f2b66e66b238ff867c27343c"
UBOOT_SRC = "git://git@github.com/NXPHoverGames/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"

SRC_URI:append:imx95-navq = " file://${TARGET_NAME}.cfg"
