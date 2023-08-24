@ECHO off
setlocal

FOR /F "tokens=*" %%g IN ('cd') do (SET CURRENT_DIRECTORY=%%g)

echo Adding '%CURRENT_DIRECTORY%' to git safe directory.
git config --global --add safe.directory %CURRENT_DIRECTORY%

endlocal