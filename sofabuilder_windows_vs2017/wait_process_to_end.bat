@ECHO OFF 

set arg1=%1

:loop
tasklist.exe | findstr %arg1% > nul
if "%ERRORLEVEL%"=="1" exit /b 0
echo %arg1% is still running ...
timeout /t 5 /nobreak > nul
goto loop
