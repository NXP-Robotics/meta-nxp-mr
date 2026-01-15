
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.12.y"
UBOOT_SRC = "git://git@github.com/NXP-Robotics/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

SRC_URI:append:imx95-navq = " file://${TARGET_NAME}.cfg"
