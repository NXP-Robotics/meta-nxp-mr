FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-fix-kleidiai-hash-neutron.patch;patchdir=${UNPACKDIR} \
"

ERROR_QA:remove = "patch-status"
