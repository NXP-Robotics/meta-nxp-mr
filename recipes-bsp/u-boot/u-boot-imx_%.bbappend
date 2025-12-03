
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.12.y"
SRCREV = "484cf22f96ba8c8ce5e8594bdc53601cfbc315ec"
UBOOT_SRC = "git://git@github.com/NXPHoverGames/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"

SRC_URI:append:imx95-navq = " file://${TARGET_NAME}.cfg"
