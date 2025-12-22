DESCRIPTION = "Enable IMX219 Camera Module in libcamera for i.MX95 19x19 EVK"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://camera_helper_imx219.cpp \
        file://camera_helper_imx258.cpp \
        file://camera_helper_imx477.cpp \
        file://imx_libcamera_6.12.20_2.0.0.patch \
        file://imx219.yaml \
        file://imx258.yaml \
        file://imx477.yaml \
"

ERROR_QA:remove = "patch-status"

do_configure:prepend() {
    cp ${UNPACKDIR}/camera_helper_imx219.cpp ${S}/src/ipa/nxp/cam_helper/
    cp ${UNPACKDIR}/camera_helper_imx258.cpp ${S}/src/ipa/nxp/cam_helper/
    cp ${UNPACKDIR}/camera_helper_imx477.cpp ${S}/src/ipa/nxp/cam_helper/
    cp ${UNPACKDIR}/imx219.yaml ${S}/src/ipa/nxp/neo/data/
    cp ${UNPACKDIR}/imx258.yaml ${S}/src/ipa/nxp/neo/data/
    cp ${UNPACKDIR}/imx477.yaml ${S}/src/ipa/nxp/neo/data/
}

