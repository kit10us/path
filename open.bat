@echo off
setlocal

set COMMAND=%1

if /i "%COMMAND%"=="url" goto open_url
if /i "%COMMAND%"=="jira" goto open_jira

echo Unknown command: "%COMMAND%"
echo.
echo Supported commands:
echo     url
echo     jira ^<TICKET^>

goto exit


:open_url

git config --get remote.origin.url > nul
FOR /F "tokens=*" %%g IN ('git config --get remote.origin.url') do (SET REMOTE=%%g)

git config --get remote.origin.url > nul
FOR /F "tokens=*" %%g IN ('git branch --show-current') do (SET BRANCH=%%g)


set URL=%REMOTE%
set URL=%URL::=/%
set URL=%URL:git@=http://%/tree/%BRANCH%

explorer %URL%

goto exit


:open_jira

set TICKET=%2
explorer https://jira.corp.zynga.com/browse/%TICKET%



:exit

endlocal