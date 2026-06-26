# Route the Ara2 runtime service to the journal only. Upstream ships the unit
# with StandardOutput/StandardError set to "journal+console", which clutters the
# boot tty and echoes accelerator-probe failures when no Ara2 device is attached.
# Logs stay available via journalctl.
ARA2_SERVICE = "${D}${sysconfdir}/systemd/system/rt-sdk-ara2.service"

do_install:append() {
    sed -i 's/=journal+console$/=journal/' "${ARA2_SERVICE}"
}
