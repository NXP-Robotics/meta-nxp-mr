FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
         file://cpufreq.cfg \
         file://usbserial.cfg \
         file://fs_sec.cfg \
"

SRC_URI:append:imx95-navq = " \
         file://rpmsg.cfg \
         file://mali.cfg \
         file://input.cfg \
         file://video-dummy.cfg \
         file://panel-ili9881c.cfg \
         file://cam.cfg \
         file://sfp.cfg \
         file://p3h.cfg \
         file://lt8912b.cfg \
         file://no-strict-devmem.cfg \
         file://m7-restart.cfg \
         file://0007-remoteproc-imx_rproc-add-m7-ddr-window.patch \
         file://0008-arm64-dts-imx95-navqb-widen-m7text-reservation.patch \
         file://0010-arm64-dts-imx95-navqb-disable-gpio5-for-m7.patch \
         file://0011-firmware-imx-sm-lmm-log-lm-boot-shutdown-events.patch \
         file://0012-firmware-imx-sm-lmm-let-other-drivers-subscribe-to-lm-events.patch \
         file://0013-remoteproc-imx_rproc-re-attach-after-an-m7-restart.patch \
         file://0014-firmware-imx-sm-lmm-add-lm-reset-operation.patch \
         file://0015-firmware-imx-add-lm-restart-driver.patch \
         file://0016-arm64-dts-imx95-navqb-add-m7-restart-node.patch \
"

SRC_URI:append:imx8mpnavq = " \
         file://0001-net-phy-nxp-c45-tja11xx-add-rev-rmii-support.patch \
         file://0002-net-fec-add-rev-rmii-support.patch \
         file://0003-arm64-dts-imx8mp-navq-Fix-TJA1103-phy.patch \
         file://0004-nxp-sr1xx-uwb-driver.patch \
         file://0005-imx8mpnavq-enable-sr1xx-spi-driver-in-dts.patch \
         file://0006-ov5645tn-driver-for-navq.patch \
         file://uwb.cfg \
"

SRCBRANCH = "imx95-navq-lf-6.18.y"
SRCREV = "${AUTOREV}"
LINUX_IMX_SRC = "git://git@github.com/NXP-Robotics/linux-imx.git;protocol=https;branch=${SRCBRANCH}"
SRC_URI = "${LINUX_IMX_SRC}"

do_configure:append () {
    ${S}/scripts/kconfig/merge_config.sh -m -O ${B} ${B}/.config $(ls ${UNPACKDIR}/*.cfg)

    if [ ! -z "${LOCALVERSION}" ]; then
        echo "CONFIG_LOCALVERSION=\"\"" >> ${B}/.config
    fi
}

