FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# GCC15 with glibc 2.39 no longer provides stat()/struct stat via transitive
# includes. Add explicit sys/stat.h to gst_pipeline_imx.cpp.
SRC_URI:append = " file://0001-fix-sys-stat-include-for-gcc15.patch"
