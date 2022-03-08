import gi
gi.require_version("Gtk", "3.0")
from gi.repository import GLib, Gtk
assert(3 == Gtk.get_major_version())

# start an Xvfb virtual display if we can (if xvfbwrapper is installed)
try:
    from xvfbwrapper import Xvfb
except (ModuleNotFoundError, ImportError):
    vdisplay = None
else:
    vdisplay = Xvfb(width=1024, height=768, colordepth=24)
    vdisplay.start()

try:
    window = Gtk.Window(title="Hello World")
    window.connect("destroy", Gtk.main_quit)
    window.show_all()
    GLib.timeout_add_seconds(2, window.close)
    Gtk.main()
finally:
    # clean up the virtual display if we used one
    if vdisplay is not None:
        vdisplay.stop()
