SUMMARY = "Mavlink MAVSDK endpoints"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=84b641454775df91a2bae8fdd450e2e9"


SRCBRANCH = "main"

SRCREV = "d28d6b07eeefa80c6e562ab783ef0eebfe8d952e"

SRC_URI = "gitsm://github.com/mavlink/MAVSDK.git;protocol=https;branch=${SRCBRANCH} \
           file://0001-cmake-find-liblzma-module-mode.patch \
           "

DEPENDS = " \
	libtinyxml2-mavsdk \
	picosha2-mavsdk \
	xz \
	xz-native \
	curl \
	jsoncpp \
	grpc \
	libmavlike \
	mavlink \
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

EXTRA_OECMAKE += " \
    -DBUILD_TESTING=OFF \
    -DSUPERBUILD=OFF \
    -DMAVLINK_DIALECT=ardupilotmega \
    -DCMAKE_CROSSCOMPILING=0 \
    -DDEPS_INSTALL_PATH:STRING=${RECIPE_SYSROOT}/usr \
"

do_configure[network] = "1"
