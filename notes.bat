@echo off
setlocal
REM Consumes/shifts parameters as processed.

set NOTES_PATH=%HOMEDRIVE%%HOMEPATH%\Documents\Notes

FOR /F "tokens=*" %%g IN ('cd') do (SET CURRENT_DIRECTORY=%%g)

set NOTE_PAGE_PATH=%NOTES_PATH%\%CURRENT_DIRECTORY::=%


IF [%1%] == [] (
	goto goto_show_notes
)

IF /I [%1%] == [/SHOW] (
	shift
	goto goto_show_notes
)
IF /I [%1%] == [/S] (
	shift
	goto goto_show_notes
)

IF /I [%1%] == [/HELP] (
	shift
	goto goto_help
)
IF /I [%1%] == [/H] (
	shift
	goto goto_help
)

IF /I [%1%] == [/PATH] (
	shift
	goto goto_show_path
)

IF /I [%1%] == [/WRITE] (
	shift
	goto goto_write_note
)
IF /I [%1%] == [/W] (
	shift
	goto goto_write_note
)

IF /I [%1%] == [/RENAME] (
	shift
	goto goto_rename
)
IF /I [%1%] == [/R] (
	shift
	goto goto_rename
)

IF /I [%1%] == [/DELETE] (
	shift
	goto goto_delete
)

IF /I [%1%] == [/LIST] (
	shift
	goto goto_list
)
IF /I [%1%] == [/L] (
	shift
	goto goto_list
)

IF /I [%1%] == [/EXPLORER] (
	shift
	goto goto_open_explorer
)
IF /I [%1%] == [/E] (
	shift
	goto goto_open_explorer
)


set UNKNOWN_COMMAND_TEST=%1%
set FIRST_CHAR=%UNKNOWN_COMMAND_TEST:~0,1%
IF [^%FIRST_CHAR%] == [/] (
	echo Unknown command: %UNKNOWN_COMMAND_TEST%
	goto goto_end
)

REM No known command is considered a write operation.
goto goto_write_note


:goto_help
echo Notes
echo by Stacy Smith
echo:
echo Syntax:
echo     Notes [/show|/S]
echo         - Reads out notes for current directory.
echo     Notes (/show|/s) <notes page name>
goto goto_end


:goto_show_notes
set ORIGINAL_CD=%CD%
:goto_show_notes_root
IF EXIST [%CD%\root.txt] (
	echo [root in "%CD%"]
	type %CD%\root.txt
	echo:
)

set OLD_CD=%CD%
cd ..
IF NOT [%CD%] == [%OLD_CD%] (
	goto goto_show_notes_root
)

cd "%ORIGINAL_CD%"
IF [%1] == [] (
	FOR /F "tokens=*" %%g IN ('dir /b /a:-d %NOTE_PAGE_PATH%') do (
		echo [%%g]
		type %NOTE_PAGE_PATH%\%%g
		echo:
	)
	goto goto_end
)

set PAGE_NAME=%1%
set PAGE_NAME_RESOLVED=%NOTE_PAGE_PATH%\%PAGE_NAME%.txt
shift
IF EXIST "%PAGE_NAME_RESOLVED%" (
	echo [%PAGE_NAME%]
	type %PAGE_NAME_RESOLVED%
	echo:
	goto goto_end
) else (
	echo Note "%PAGE_NAME%" does not exist.
	echo:
)
goto goto_end


:goto_show_path
echo Path to note:
echo %NOTE_PAGE_PATH%
echo:
goto goto_end


:goto_write_note
set NOTE_NAME=notes
IF NOT [%3%] == [] (
    echo Too many parameters.
	goto goto_end
)
IF [%1%] == [] (
	echo Write command requires note text.
	goto goto_end
)
IF [%2%] == [] (
    set NOTE_NAME=notes
    set NOTE_TEXT=%~1%
)
IF NOT [%2%] == [] (
    set NOTE_NAME=%1%
    set NOTE_TEXT=%~2%
)

IF NOT EXIST "%NOTE_PAGE_PATH%\" ( mkdir "%NOTE_PAGE_PATH%\")

set NOTE_PAGE=%NOTE_PAGE_PATH%\%NOTE_NAME%.txt
echo %NOTE_TEXT%
echo %NOTE_TEXT% >> %NOTE_PAGE%
goto goto_end


:goto_rename
IF NOT [%3%] == [] (
	echo Too many parameters for rename.
	echo 	note ^/rename ^<before^> ^<after^>
	goto goto_end
)
IF [%2%] == [] (
	echo Invalid format
	echo 	note ^/rename ^<before^> ^<after^>
	goto goto_end
)

set NOTE_NAME_BEFORE=%NOTE_PAGE_PATH%\%1%.txt
set NOTE_NAME_AFTER=%NOTE_PAGE_PATH%\%2%.txt

IF NOT EXIST "%NOTE_NAME_BEFORE%" (
	echo Page to rename not found.
	goto goto_end
)

IF EXIST "%NOTE_NAME_AFTER%" (
	echo Page to rename to already exists.
	goto goto_end
)

echo Renamed page "%1%" to "%2%"
move "%NOTE_NAME_BEFORE%" "%NOTE_NAME_AFTER%"

goto goto_end


:goto_delete
IF NOT [%2%] == [] (
	echo Too many parameters to delete.
	echo     notes /delete ^<note page^>
	goto goto_end
)

set NOTE_NAME=%1%
set NOTE_PAGE=%NOTE_PAGE_PATH%\%NOTE_NAME%.txt
IF NOT EXIST "%NOTE_PAGE%" (
	echo No note named %NOTE_NAME% exists.
	goto goto_end
)

echo Deleting note %NOTE_NAME%
del "%NOTE_PAGE%"
goto goto_end


:goto_list
dir /b "%NOTE_PAGE_PATH%"\*.txt
goto goto_end

:goto_open_explorer
explorer "%NOTE_PAGE_PATH%
goto goto_end


:goto_end
endlocal