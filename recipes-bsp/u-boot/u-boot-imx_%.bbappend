
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.12.y"
SRCREV = "ebbaed0dc20f4137efc0dad5df998b6e42fb1c56"
UBOOT_SRC = "git://git@github.com/NXPHoverGames/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"

SRC_URI:append:imx95-navq = " file://${TARGET_NAME}.cfg"
