SUMMARY = "Create directories who can be mounted by rpmsgfs on the PX4 and Cerebri M7 core applications"

LICENSE = "BSD-3-Clause"

do_install () {
	install -d ${D}/cerebri
	install -d ${D}/px4
}

FILES:${PN} += "/cerebri"
FILES:${PN} += "/px4"

