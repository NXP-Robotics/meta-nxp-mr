SUMMARY = "Mavlink MAVSDK endpoints"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=84b641454775df91a2bae8fdd450e2e9"


SRCBRANCH = "main"

SRCREV = "cebb708a42c82c283b08177468eecd4c03f8c1ef"

SRC_URI = "gitsm://github.com/mavlink/MAVSDK.git;protocol=https;branch=${SRCBRANCH} \
           "

S = "${WORKDIR}/git"

DEPENDS = " \
	libtinyxml2 \
    xz \
	curl \
	jsoncpp \
	grpc \
	openssl \
	protobuf-native \
	python3-native \
	python3-jinja2-native \
	python3-future-native \
	python3-protobuf-native \
    mavlink-native \
	jsoncpp-native \
    libevents \
	 "

inherit cmake pkgconfig systemd

EXTRA_OECMAKE += "-DBUILD_TESTING=OFF "

do_configure[network] = "1"