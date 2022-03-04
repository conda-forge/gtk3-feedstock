setlocal EnableDelayedExpansion
@echo on

:: ensure that the post install script is ignored
set "DESTDIR=%BUILD_PREFIX:~0,3%"

:: specify --no-rebuild because timestamps have changed
meson install -C builddir --no-rebuild
if errorlevel 1 exit 1

:: create directory for modules so post-link script doesn't fail
set "MODULEDIR=%LIBRARY_LIB%\gtk-3.0\3.0.0"
if not exist "%MODULEDIR%" md "%MODULEDIR%"
if errorlevel 1 exit 1
type nul > "%MODULEDIR%\.keep"
if errorlevel 1 exit 1

if not [%PKG_NAME%] == [gtk3-tests] (
    :: don't include tests
    rmdir /s /q %LIBRARY_PREFIX%\libexec\installed-tests\gtk+
    if errorlevel 1 exit 1
    rmdir /s /q %LIBRARY_PREFIX%\share\installed-tests\gtk+
    if errorlevel 1 exit 1
    :: don't include demos
    del /q %LIBRARY_PREFIX%\bin\gtk3*
    if errorlevel 1 exit 1
    del /q %LIBRARY_PREFIX%\share\applications\gtk3*
    if errorlevel 1 exit 1
    del /q %LIBRARY_PREFIX%\share\glib-2.0\schemas\org.gtk.Demo.gschema.xml
    if errorlevel 1 exit 1
)
