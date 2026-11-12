FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:imx95-navq = " file://0001-imx95-navq-move-bl33-out-of-m7-window.patch"
SRC_URI:append:imx95-navq = " file://0002-imx95-navq-keep-m7-gpio-ports-secure.patch"
