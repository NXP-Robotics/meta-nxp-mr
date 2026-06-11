# Carried from meta-qt6 remotes/qt/6.4 for Ubuntu 24.04 ABI compat.
LICENSE = "(The-Qt-Company-Commercial | (GPL-3.0-only & Qt-GPL-exception-1.0) & (LGPL-3.0-only | GPL-2.0-only | GPL-3.0-only) & GFDL-1.3-no-invariants-only) & Apache-2.0 & BSD-3-Clause & BSL-1.0 & MIT"
LIC_FILES_CHKSUM = " \
    file://LICENSES/Apache-2.0.txt;md5=b4c615f64dff32f71eeed614d13dff96 \
    file://LICENSES/BSD-3-Clause.txt;md5=cb40fa7520502d8c7a3aea47cae1316c \
    file://LICENSES/BSL-1.0.txt;md5=8c92b4c255bdcce2989707d5b8a4d302 \
    file://LICENSES/GFDL-1.3-no-invariants-only.txt;md5=a22d0be1ce2284b67950a4d1673dd1b0 \
    file://LICENSES/GPL-2.0-only.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://LICENSES/GPL-3.0-only.txt;md5=d32239bcb673463ab874e80d47fae504 \
    file://LICENSES/LGPL-3.0-only.txt;md5=e6a600fd5e1d9cbde2d983680233ad02 \
    file://LICENSES/LicenseRef-Qt-Commercial.txt;md5=40a1036f91cefc0e3fabad241fb5f187 \
    file://LICENSES/MIT.txt;md5=3605d54ecceddcd50962eb89318779ec \
    file://LICENSES/Qt-GPL-exception-1.0.txt;md5=9a13522cd91a88fba784baf16ea66af8 \
    file://src/assistant/qlitehtml/src/3rdparty/litehtml/LICENSE;md5=55d411204c54bf2524f471635a7d306a \
    file://src/assistant/qlitehtml/src/3rdparty/litehtml/src/gumbo/LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57 \
"

inherit qt6-cmake
include recipes-qt/qt6/qt6.inc

QT_MODULE              = "${BPN}"
QT_MODULE_BRANCH       = "6.4"
QT_MODULE_BRANCH_PARAM = "branch=${QT_MODULE_BRANCH};nobranch=1"
QT_MODULE_REPO         = "${QT_MODULE}.git"

SRC_URI  = "${QT_GIT}/${QT_GIT_PROJECT}/${QT_MODULE_REPO};name=${QT_MODULE};${QT_MODULE_BRANCH_PARAM};protocol=${QT_GIT_PROTOCOL}"
SRC_URI += " \
    ${QT_GIT}/playground/qlitehtml.git;name=qttools-qlitehtml;branch=master;protocol=${QT_GIT_PROTOCOL};destsuffix=${BB_GIT_DEFAULT_DESTSUFFIX}/src/assistant/qlitehtml \
    git://github.com/litehtml/litehtml.git;name=qttools-qlitehtml-litehtml;branch=master;destsuffix=${BB_GIT_DEFAULT_DESTSUFFIX}/src/assistant/qlitehtml/src/3rdparty/litehtml;protocol=https \
"

PV     = "6.4.3"
SRCREV = "e2100dac619336186d834d77c1586f811df824ec"
SRCREV_qttools-qlitehtml         = "bd70f93ce41443a6a90a269531393f575685283e"
SRCREV_qttools-qlitehtml-litehtml = "e3f37e3d5a6931ddecf81a9d746fc3e9a3475998"

SRCREV_FORMAT = "qttools_qttools-qlitehtml_qttools-qlitehtml-litehtml"

DEPENDS += "qtbase qtdeclarative qttools-native"

FILES:${PN}-tools += "${QT6_INSTALL_DATADIR}/phrasebooks"

BBCLASSEXTEND = "native nativesdk"
