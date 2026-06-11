# flit_core 3.12 expects license as a dict (PEP 639) and does not support
# the license-files field. Patch pyproject.toml to use the dict form and
# remove license-files so the build backend accepts the metadata.
do_compile:prepend() {
    sed -i 's/^license = "PSF-2.0"/license = {text = "PSF-2.0"}/' ${S}/pyproject.toml
    sed -i '/^license-files = \["LICENSE"\]/d' ${S}/pyproject.toml
}
