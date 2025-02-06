FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
         file://0001-net-phy-nxp-c45-tja11xx-add-rev-rmii-support.patch \
         file://0002-net-fec-add-rev-rmii-support.patch \
         file://0003-arm64-dts-imx8mp-navq-Fix-TJA1103-phy.patch \
         file://0004-nxp-sr1xx-uwb-driver.patch \
         file://0005-imx8mpnavq-enable-sr1xx-spi-driver-in-dts.patch \
         file://0006-ov5645tn-driver-for-navq.patch \
         file://uwb.cfg \
         file://cpufreq.cfg \
         file://usbserial.cfg \
"

SRC_URI:append:imx95-19x19-navq = " \
         file://rpmsgfs.cfg \
         file://fs_sec.cfg \
"


SRCBRANCH = "imx95-navq-lf-6.6.23"
SRCREV = "90445e44b2312bf728888865e2ef7326d6ea870e"
KERNEL_SRC = "git://git@github.com/NXPHoverGames/linux-imx-private.git;protocol=ssh;branch=${SRCBRANCH}"

KERNEL_DEVICETREE:append:use-nxp-bsp = " \
    freescale/imx95-19x19-navq.dtb \
    "

do_configure:append () {
    ${S}/scripts/kconfig/merge_config.sh -m -O ${B} ${B}/.config $(ls ${WORKDIR}/*.cfg)

    if [ ! -z "${LOCALVERSION}" ]; then
        echo "CONFIG_LOCALVERSION=\"\"" >> ${B}/.config
    fi
}

