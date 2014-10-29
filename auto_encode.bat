@ECHO OFF

REM *******************
REM 03/17/2012
REM If video isn't properly interlaced, add '-9' to the end of the command line.
REM *******************

REM *******************
REM 08/21/2011
REM Removed --drc 2.0 from both DVD and BD 
REM *******************

setlocal enabledelayedexpansion
set input_path=c:\dvd\rip
set output_path=c:\dvd\enc\
set fullpath=
set title=
set handbrake_cmd="C:\Program Files\Handbrake\HandbrakeCLI.exe"
set abitrate=256
set bdvquality=28
rem dvdvquality for x264 should be 21
set dvdvquality=4
set maxinstances=3

for /f "delims=" %%g in ('dir %input_path% /b') do (
	for /f "delims=" %%h in ('dir "%input_path%\%%g" /b') do (
		set fullpath=%input_path%\%%g\%%h
		set title=%%h
		if not exist %output_path%!title!.mp4 (call :loop %%h)
		)
	)
goto :eof

:loop
call :checkinstances
if %instances% lss %maxinstances% (
	echo Processing !fullpath!.
	if exist "%fullpath%\BDMV" (
		start /min "!title!" %handbrake_cmd% --input "%fullpath%" --output "%output_path%!title!.mp4" --encoder x264 --vfr --audio 1 --main-feature --aencoder faac --ab %abitrate% --aname English --arate Auto --mixdown 6ch --format mp4 --large-file --loose-anamorphic --markers --optimize --quality %bdvquality%
		) else (
		start /min "!title!" %handbrake_cmd% --input "%fullpath%" --output "%output_path%!title!.mp4" --encoder ffmpeg4 --vfr --audio 1 --main-feature --aencoder faac --ab %abitrate% --aname English --arate Auto --mixdown 6ch --format mp4 --large-file --loose-anamorphic --markers --optimize --quality %dvdvquality%
		)
	goto :eof
	)
ping -n 2 ::1 >nul 2>&1
goto loop
goto :eof

:checkinstances
for /f "usebackq" %%t in (`tasklist /nh /fi "imagename eq HandBrakeCLI.exe"^|find /c "HandBrakeCLI.exe"`) do set instances=%%t
goto :eof

set input_path=
set output_path=
set fullpath=
set title=
set handbrake_cmd=
set abitrate=
set bdvquality=
set dvdvquality=
set maxinstances=