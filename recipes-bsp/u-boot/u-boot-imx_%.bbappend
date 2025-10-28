
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.12.y"
SRCREV = "a4ab51ff8c3d9e6287e695cf91e42b041f68c1ba"
UBOOT_SRC = "git://git@github.com/NXPHoverGames/uboot-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"

SRC_URI:append:imx95-navq = " file://${TARGET_NAME}.cfg"
