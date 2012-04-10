echo off

echo Deleting registry keys.

set KEY=HKLM\SOFTWARE\Wow6432Node\Garmin\MapSource
reg QUERY %KEY% >NUL
if not errorlevel 1 goto key_ok
set KEY=HKLM\SOFTWARE\Garmin\MapSource
:key_ok

reg DELETE %KEY%\Families\OSM_MapTourist /f
pause
exit 0
