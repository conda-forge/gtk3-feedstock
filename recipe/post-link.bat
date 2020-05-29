%PREFIX%\Library\bin\glib-compile-schemas.exe %PREFIX%\Library\share\glib-2.0\schemas
if errorlevel 1 exit 1
%PREFIX%\Library\bin\gtk-update-icon-cache.exe -f -t %PREFIX%\Library\share\icons\hicolor
if errorlevel 1 exit 1
%PREFIX%\Library\bin\gtk-query-immodules-3.0.exe > %PREFIX%\Library\lib\gtk-3.0\3.0.0\immodules.cache
if errorlevel 1 exit 1
