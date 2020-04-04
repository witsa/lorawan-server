@echo off
setlocal EnableDelayedExpansion

SET SCRIPT_DIR=%~dp0
:: Server Working Directory
SET SERVER_WD=%CD%

:: Added PROGRAMW6432 in order to WOW64 erlang install
for /D %%A in ("%PROGRAMFILES%\erl*" "%PROGRAMFILES(x86)%\erl*" "%PROGRAMW6432%\erl*") do (
    for /D %%B in ("%%A\erts*") do (
        for /D %%C in ("%%B\bin\erl.exe") do (
            set "ERL_DIR=%%C"
        )
    )
)

:: Debbuging erlang detected forlder
echo "ERL_DIR = %ERL_DIR"

set "SCRIPT_DIR=%~dp0"
for %%A in ("%SCRIPT_DIR%\..") do (
    set "ROOT_DIR=%%~fA"
)

for /D %%A in ("%ROOT_DIR%\lib\*") do (
    set FILES=!FILES! "%%A\ebin"
)

set SYS_CONFIG="releases/{{release_version}}/sys.config" 

:: Allowing the use of a custom / generated lorawan_server.conf in working directory
if exist "%SERVER_WD%/lorawan_server.config" (
    set SYS_CONFIG="%SERVER_WD%/lorawan_server.config"
)


echo "Server started"
set ERL_ARGS="-lager log_root "log""
cd %SERVER_WD% && %ERL_DIR% -noinput +Bd -sname lorawan -pa !FILES! -s lorawan_app %ERL_ARGS% -config %SYS_CONFIG%
