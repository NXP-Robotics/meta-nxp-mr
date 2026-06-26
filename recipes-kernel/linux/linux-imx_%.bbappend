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
         file://0001-pci-imx-imx95-power-cycle-endpoint-for-cold-boot-link.patch \
         file://0002-net-pcs-xpcs-fix-i.MX95-XPCS-10GBASE-R-XFI-block-loc.patch \
         file://0007-i3c-hub-p3h2840-Add-GPIO-controller-support.patch \
         file://0008-arm64-dts-imx95-navqb-enable-p3h-TP2-GPIO.patch \
         file://0009-i3c-hub-p3h2840-hold-etx_mutex-across-SMBus-wait.patch \
         file://0010-arm64-dts-imx95-navqb-enable-Schmitt-input-on-I3C2-p.patch \
         file://0011-i3c-hub-p3h2840-make-SMBus-agent-IBI-opt-in-per-port.patch \
         file://0012-i3c-hub-p3h2840-chunk-large-SMBus-reads-to-fit-contr.patch \
         file://0014-i3c-hub-p3h2840-add-clock-frequency-DTS-support.patch \
         file://0015-i3c-hub-p3h2840-fix-stuck-SDA-false-success-and-add-bus-recovery.patch \
         file://0016-mmc-pwrseq-simple-fall-back-to-gpio-when-reset-control-unavailable.patch \
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

SRCBRANCH = "imx95-navq-lf-6.18.y-Q2"
SRCREV = "${AUTOREV}"
LINUX_IMX_SRC = "git://git@github.com/NXP-Robotics/linux-imx.git;protocol=https;branch=${SRCBRANCH}"
SRC_URI = "${LINUX_IMX_SRC}"

do_configure:append () {
    ${S}/scripts/kconfig/merge_config.sh -m -O ${B} ${B}/.config $(ls ${UNPACKDIR}/*.cfg)

    if [ ! -z "${LOCALVERSION}" ]; then
        echo "CONFIG_LOCALVERSION=\"\"" >> ${B}/.config
    fi
}

