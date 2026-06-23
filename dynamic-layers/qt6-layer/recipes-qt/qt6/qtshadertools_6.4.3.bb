# Carried from meta-qt6 remotes/qt/6.4 for Ubuntu 24.04 ABI compat.
LICENSE = "(The-Qt-Company-Commercial | (GPL-3.0-only & Qt-GPL-exception-1.0) & GFDL-1.3-no-invariants-only) & (Apache-2.0 | MIT) & BSD-3-Clause & BSD-2-Clause & Apache-2.0 & GPL-3-with-bison-exception"
LIC_FILES_CHKSUM = " \
    file://LICENSES/BSD-3-Clause.txt;md5=cb40fa7520502d8c7a3aea47cae1316c \
    file://LICENSES/GFDL-1.3-no-invariants-only.txt;md5=a22d0be1ce2284b67950a4d1673dd1b0 \
    file://LICENSES/GPL-3.0-only.txt;md5=d32239bcb673463ab874e80d47fae504 \
    file://LICENSES/LicenseRef-Qt-Commercial.txt;md5=40a1036f91cefc0e3fabad241fb5f187 \
    file://LICENSES/Qt-GPL-exception-1.0.txt;md5=9a13522cd91a88fba784baf16ea66af8 \
    file://src/3rdparty/SPIRV-Cross/KHRONOS-LICENSE.txt;md5=220cd23564f44ef34996a001e2651a36 \
    file://src/3rdparty/SPIRV-Cross/LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57 \
    file://src/3rdparty/glslang/LICENSE.txt;md5=ff2138e5b8d7cc42d9cb0b054c350922 \
"

inherit qt6-cmake
include recipes-qt/qt6/qt6.inc

QT_MODULE              = "${BPN}"
QT_MODULE_BRANCH       = "6.4"
QT_MODULE_BRANCH_PARAM = "branch=${QT_MODULE_BRANCH};nobranch=1"
QT_MODULE_REPO         = "${QT_MODULE}.git"

SRC_URI = "${QT_GIT}/${QT_GIT_PROJECT}/${QT_MODULE_REPO};name=${QT_MODULE};${QT_MODULE_BRANCH_PARAM};protocol=${QT_GIT_PROTOCOL}"
PV      = "6.4.3"
SRCREV  = "ec205234bce2f57f989d0700b2d0e0230a426656"

DEPENDS = "qtbase qtshadertools-native"

BBCLASSEXTEND = "native nativesdk"
