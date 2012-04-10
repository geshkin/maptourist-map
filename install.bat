@echo off

echo Adding registry keys.

set KEY=HKLM\SOFTWARE\Wow6432Node\Garmin\MapSource
reg QUERY %KEY% 2>NUL
if not errorlevel 1 goto key_ok
set KEY=HKLM\SOFTWARE\Garmin\MapSource
:key_ok

reg ADD %KEY%\Families\OSM_MapTourist /v ID /t REG_BINARY /d FID /f
reg ADD %KEY%\Families\OSM_MapTourist /v IDX /t REG_SZ /d "%~dp0OSM_MapTourist.mdx" /f
reg ADD %KEY%\Families\OSM_MapTourist /v MDR /t REG_SZ /d "%~dp0OSM_MapTourist_mdr.img" /f
reg ADD %KEY%\Families\OSM_MapTourist /v TYP /t REG_SZ /d "%~dp0M0000000.TYP" /f

reg ADD %KEY%\Families\OSM_MapTourist\1 /v Loc /t REG_SZ /d "%~dp0\" /f
reg ADD %KEY%\Families\OSM_MapTourist\1 /v Bmap /t REG_SZ /d "%~dp0OSM_MapTourist.img" /f
reg ADD %KEY%\Families\OSM_MapTourist\1 /v Tdb /t REG_SZ /d "%~dp0OSM_MapTourist.tdb" /f
