FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-Modify-regular-expression-pattern-for-kernels-filter.patch \
"

do_install:append () {
	install -d ${D}/usr/local/lib/python3.12/dist-packages
	mv ${D}/${PYTHON_SITEPACKAGES_DIR}/* ${D}/usr/local/lib/python3.12/dist-packages
	rm -rf ${D}/${PYTHON_SITEPACKAGES_DIR}
}

FILES:${PN} += "/usr/local/lib/python3.12/*"
