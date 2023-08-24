@echo off
setlocal


git config --get remote.origin.url > nul
FOR /F "tokens=*" %%g IN ('git config --get remote.origin.url') do (SET REMOTE=%%g)

git config --get remote.origin.url > nul
FOR /F "tokens=*" %%g IN ('git branch --show-current') do (SET BRANCH=%%g)


set URL=%REMOTE%
set URL=%URL::=/%
set URL=%URL:git@=http://%/tree/%BRANCH%

explorer %URL%

endlocal