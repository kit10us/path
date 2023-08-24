@echo off
setlocal

rem https://api.slack.com/web
REM call curl -k -u %USERNAME% -X GET https://jira.corp.zynga.com/rest/api/latest/issue/%kEY%?fields=summary
rem curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' YOUR_WEBHOOK_URL_HERE

call curl -k -u %USERNAME% -X POST https://centraltech-zynga.slack.com/api/chat.postMessage?username=stasmith,text=hello


:end

endlocal