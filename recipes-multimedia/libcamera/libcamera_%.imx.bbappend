FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
         file://0001-imx8-isi-Fix-null-pointer-dereference.patch \
"

ERROR_QA:remove = "patch-status"
