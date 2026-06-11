# Carried from meta-qt6 remotes/qt/6.4 for Ubuntu 24.04 ABI compat.
LICENSE = "(The-Qt-Company-Commercial | (GPL-3.0-only & Qt-GPL-exception-1.0) & (LGPL-3.0-only | GPL-2.0-only | GPL-3.0-only) & GFDL-1.3-no-invariants-only & BSD-3-Clause) & BSD-2-Clause"
LIC_FILES_CHKSUM = " \
    file://LICENSES/BSD-3-Clause.txt;md5=cb40fa7520502d8c7a3aea47cae1316c \
    file://LICENSES/GFDL-1.3-no-invariants-only.txt;md5=a22d0be1ce2284b67950a4d1673dd1b0 \
    file://LICENSES/GPL-2.0-only.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://LICENSES/GPL-3.0-only.txt;md5=d32239bcb673463ab874e80d47fae504 \
    file://LICENSES/LGPL-3.0-only.txt;md5=e6a600fd5e1d9cbde2d983680233ad02 \
    file://LICENSES/LicenseRef-Qt-Commercial.txt;md5=40a1036f91cefc0e3fabad241fb5f187 \
    file://LICENSES/Qt-GPL-exception-1.0.txt;md5=9a13522cd91a88fba784baf16ea66af8 \
    file://src/3rdparty/masm/LICENSE;md5=dadc3e328f07d2e6fca9177916e902b5 \
"

inherit qt6-cmake
include recipes-qt/qt6/qt6.inc

QT_MODULE              = "${BPN}"
QT_MODULE_BRANCH       = "6.4"
QT_MODULE_BRANCH_PARAM = "branch=${QT_MODULE_BRANCH};nobranch=1"
QT_MODULE_REPO         = "${QT_MODULE}.git"

SRC_URI = "${QT_GIT}/${QT_GIT_PROJECT}/${QT_MODULE_REPO};name=${QT_MODULE};${QT_MODULE_BRANCH_PARAM};protocol=${QT_GIT_PROTOCOL}"
PV      = "6.4.3"
SRCREV  = "bfa301f0cb2d62b77920c0ae8d9f85ec3769f151"

DEPENDS += "qtbase qtshadertools qtshadertools-native qtdeclarative-native qtlanguageserver"

# Generated .rcc/*.cpp files embed TMPDIR — known Qt build artifact
INSANE_SKIP:${PN}-src += "buildpaths"

BBCLASSEXTEND = "native nativesdk"
