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
"

# DPDK camera data path enablement:
#  - cacheable videobuf2 dma-contig mappings, made DMABUF-import safe via
#    vb2_queue::force_non_coherent (ISI capture + neo-ISP capture nodes).
#  - ISI QUERYBUF exposing the buffer DMA address to user space.
# Camera: OS08A20 30+30 fps staggered HDR timing (linear mode stays native).
# Patch order matters: dpdk-0002 builds on dpdk-0001, and dpdk-0003 applies on
# top of the dpdk-0002 ISI change.
# The kpage_ncache module is not built here: kernel-module-dpdk-extras
# (meta-imx) already builds and packages kernel-module-kpage-ncache.
SRC_URI:append:imx95-navq = " \
         file://dpdk-0001-media-videobuf2-dma-contig-cached-mappings.patch \
         file://dpdk-0002-media-videobuf2-force-non-coherent-import-safe.patch \
         file://dpdk-0003-media-imx8-isi-add-buffer-physical-address-query.patch \
         file://cam-0001-media-ox05b1s-support-30-30-fps-for-os08a20.patch \
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

