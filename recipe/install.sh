#!/usr/bin/env bash

set -ex

# ensure that the post install script is ignored
export DESTDIR="/"

# specify --no-rebuild because timestamps have changed
meson install -C builddir --no-rebuild

if [[ "$PKG_NAME" != gtk3-tests ]]; then
    # don't include tests
    rm -r $PREFIX/libexec/installed-tests/gtk+
    rm -r $PREFIX/share/installed-tests/gtk+
    # don't include demos
    rm $PREFIX/bin/gtk3*
    rm $PREFIX/share/applications/gtk3*
    rm $PREFIX/share/glib-2.0/schemas/org.gtk.Demo.gschema.xml
fi
