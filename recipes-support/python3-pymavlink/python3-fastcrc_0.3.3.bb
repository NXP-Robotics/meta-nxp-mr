SUMMARY = "Fast CRC calculation module written in C."
DESCRIPTION = "A high-performance CRC (Cyclic Redundancy Check) calculation module for Python, implemented efficiently in C."
HOMEPAGE = "https://github.com/the-lost-explorer/fastcrc"
LICENSE = "MIT"
# You'll need to fetch the actual LIC_FILES_CHKSUM from the source tarball
LIC_FILES_CHKSUM = "file://LICENSE;md5=9f98c306ca1909411a5a2c70a0e498b8" 

BBCLASSEXTEND = "native nativesdk"

# Use the latest version from PyPI or specify a desired version
PV = "0.3.3"
PR = "r0"

# --- Source and Fetching ---
# Yocto's pypi class automatically constructs the SRC_URI for PyPI packages
# using the standard PyPI tarball naming convention:
SRC_URI = "https://files.pythonhosted.org/packages/source/f/fastcrc/fastcrc-${PV}.tar.gz"
SRC_URI[sha256sum] = "019bafdcae27406b26f18ee97a994d3a860f7661f31289160a064dbacea2fef1"

# --- Python Packaging ---
# Inherit pypi to handle setup.py logic and compilation of the C extension
inherit pypi

# --- Building and Installation ---
# The pypi class will automatically invoke the equivalent of 'python setup.py install'
# This handles the build and installation of the native C extension.
# Since fastcrc is a native extension, it requires the Python development headers and compiler tools.
# These are implicitly added by the pypi class and the associated recipes.

# The package name for the installed module
RDEPENDS:${PN} += "\
    python3-core \
"

# --- Packaging Split ---
# This ensures the native extension is correctly packaged.
# The default packaging split for pypi usually handles this correctly.
# If you encounter issues, you might need:
# PACKAGES =+ "${PN}-extension"
# FILES:${PN}-extension = "${PYTHON_SITEPACKAGES_DIR}/fastcrc*.so"
