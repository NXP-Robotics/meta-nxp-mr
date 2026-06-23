
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCBRANCH = "imx95-navq-lf-6.18.y"
UBOOT_SRC = "git://git@github.com/NXP-Robotics/uboot-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

SRC_URI:append:imx95-navq = " \
    file://${TARGET_NAME}.cfg \
    file://0001-imx95-navq-fix-SPL-DDR-address-not-covered-by-MMU-map.patch \
"
