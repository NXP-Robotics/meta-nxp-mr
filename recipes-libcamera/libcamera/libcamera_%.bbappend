DESCRIPTION = "Enable IMX219 Camera Module in libcamera for i.MX95 19x19 EVK"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://camera_helper_imx219.cpp \
        file://imx219_libcamera_6.12.20_2.0.0.patch \
        file://imx219.yaml \
"

ERROR_QA:remove = "patch-status"

do_configure:prepend() {
    cp ${UNPACKDIR}/camera_helper_imx219.cpp ${S}/src/ipa/nxp/cam_helper/
    cp ${UNPACKDIR}/imx219.yaml ${S}/src/ipa/nxp/neo/data/
}

