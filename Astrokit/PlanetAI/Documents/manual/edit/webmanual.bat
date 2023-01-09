@echo off

echo This batch file will create the web version from the offline version.
echo This will wipe out and rebuild the web version.
echo Any key to continue, CTRL-C to cancel.
echo.
pause > nul

echo Creating log file.

echo WEBBUILD LOG > webmanual.log
echo. >> webmanual.log
echo Last build: >> webmanual.log
date /t >> webmanual.log
time /t >> webmanual.log
echo. >> webmanual.log

echo Wiping old build.

del .\web\*.* /q >> webmanual.log

echo Copying original image files.

if exist .\offline\*.jpg copy .\offline\*.jpg .\web >> webmanual.log
if exist .\offline\*.gif copy .\offline\*.gif .\web >> webmanual.log

echo Caching PNG files.

copy .\offline\*.png .\ >> webmanual.log

echo Converting PNG to JPG.

i_view32.exe .\*.png /convert=web\*.jpg


echo Wiping cache.

del .\*.png /q >> webmanual.log

echo Copying HTML files.

if exist .\offline\*.html copy .\offline\*.html .\web >> webmanual.log

echo Updating HTML files.

for %%i in (.\web\*.html) do makeweb %%i

echo.
echo Completed. Press any key to exit.

pause > nul