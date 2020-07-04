:: ********** Instructions **********
::
:: Create a file with any name ending in .cmd
:: If file doesn't have the same / similar icon as this file,
:: try copying this file and deleting the contents.
::
:: Edit the file and insert this one line:
::   export filename
:: (Replace filename with your p8 file)
::
:: For additional export arguments, add them after the filename in quotes:
::   export filename "-f -p one_button -w -i 7 -c 16 -e readme.txt"
::
:: *** HTML Export Arguments ***
:: -f exports the HTML to a filename_html folder for easier itch.io uploading
:: -p uses a custom HTML template placed in %AppData%\pico-8\plates
::    In the above example, one_button.html would be used
:: -w exports the HTML as WASM + JS, which results in a smaller and faster
::    HTML export, but is still experimental
:: 
:: *** Binary Export Arguments ***
:: Without these arguments, the cartridge label is used as the icon
:: -i chooses the icon index for the export icon
:: -s chooses the export icon size
::    3 would produce a 24x24 icon
:: -c chooses the transparent color for the export icon
::    0 (black) is default and 16 is no transparency
:: -e allows you to include an extra file in the exports
::    In the above example, readme.txt would be included
::    Only one extra file can be included
:: 
:: Up to 16 additional carts can be bundled with the third argument:
::   export filename "" dat.p8
::   export filename "args" "dat1.p8 dat2.p8 game2.p8"
:: If you have no args when using this option, args needs to be set to ""
:: If only bundling one extra cart, quotes are optional
:: Extra carts can be accessed as if they were local files:
::   RELOAD(0,0,0x2000, "DAT1.P8") -- load spritesheet from DAT1.P8
::   LOAD("GAME2.P8") -- load and run another cart

@echo off
cls
path %ProgramFiles%\PICO-8;%PATH%
path %ProgramFiles(x86)%\PICO-8;%PATH%
path %AppData%\itch\apps\pico-8\pico-8;%PATH%

:: For custom PICO-8 path, remove the :: on the next line.
:: path C:\path-to-pico8;%PATH%

if [%1]==[] goto :noarg
if not exist %1 if not exist %1.p8 if not exist %1.png if not exist %1.p8.png goto :noarg

if not [%2]==[] (
	echo Export arguments: %~2
) else (
	echo Export arguments: None
)
if not [%3]==[] (
	echo Extra carts: %~3
) else (
	echo Extra carts: None
)
echo.

:: This requires at least PICO-8 0.2.1
echo Exporting: %~n1.p8.png
pico8 %1 -F -export "%~n1.p8.png %~3"
if errorlevel 1 goto :failed

if exist %~n1_html (
	echo.
	echo Deleting: %~n1_html
	rmdir /S /Q %~n1_html
)
echo Exporting: %~n1.html
pico8 %1 -F -export "%~2 %~n1.html %~3"
if errorlevel 1 goto :failed

:: Not deleting bin folder results in
:: duplicate files within the zip exports
if exist %~n1.bin (
	echo.
	echo Deleting: %~n1.bin
	rmdir /S /Q %~n1.bin
)
echo Exporting: %~n1.bin
pico8 %1 -F -export "%~2 %~n1.bin %~3"
if errorlevel 1 goto :failed

echo.
echo Finished!
echo Note that %~n1.bin and %~n1_html (if created) will be deleted if you
echo use this script again. Don't place anything important in those folders.
echo Also, if something didn't export correctly, please update PICO-8.
goto :end

:noarg
echo Cartridge file not provided or found.
echo Please edit %~nx0 in Notepad and see instructions at top.
goto :end

:failed
echo.
echo Operation failed. If PICO-8 isn't in default location,
echo please add the path to the top of %~nx0 or in your own file.
echo In addition, make sure PICO-8 is up-to-date.
goto :end

:end
echo.
pause
