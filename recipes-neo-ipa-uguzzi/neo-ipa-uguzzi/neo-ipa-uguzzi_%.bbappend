DESCRIPTION = "Enable IMX219 Camera Module in neo-ipa-uguzzi for i.MX95 19x19 EVK"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://camera_helper_imx219.cpp \
        file://database_imx219_1920_1080.bin \
        file://database_imx219_3280_2464.bin \
        file://imx219_neo-ipa-uguzzi_6.12.20_2.0.0.patch \
"

ERROR_QA:remove = "patch-status"

do_configure:prepend() {
    cp ${UNPACKDIR}/camera_helper_imx219.cpp ${S}/cam_helper/
    cp ${UNPACKDIR}/database_imx219_3280_2464.bin ${S}/data/
    cp ${UNPACKDIR}/database_imx219_1920_1080.bin ${S}/data/
}

