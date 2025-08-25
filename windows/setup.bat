@echo off
setlocal

set "FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
set "FFMPEG_ZIP=%TEMP%\ffmpeg.zip"
set "FFMPEG_TEMP_DIR=%TEMP%\ffmpeg"
set "FFMPEG_DIR=C:\tools\common\ffmpeg"

set "SEVENZIP_URL=https://www.7-zip.org/a/7z2301-x64.exe"
set "SEVENZIP_EXE=%TEMP%\7zsetup.exe"
set "SEVENZIP_TEMP_DIR=%TEMP%\7z_tmp"
set "SEVENZIP_DIR=C:\tools\common\7zip"

REM Create target directories
if not exist "C:\tools\common" (
    mkdir "C:\tools\common"
)
if not exist %FFMPEG_DIR% (
    mkdir %FFMPEG_DIR%
)
if not exist %SEVENZIP_DIR% (
    mkdir %SEVENZIP_DIR%
)
if not exist %FFMPEG_TEMP_DIR% (
    mkdir %FFMPEG_TEMP_DIR%
)
if not exist %SEVENZIP_TEMP_DIR% (
    mkdir %SEVENZIP_TEMP_DIR%
)

REM Download ffmpeg zip & 7zip exe with user credentials
powershell -Command "$cred = Get-Credential; Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile '%FFMPEG_ZIP%' -UseBasicParsing -Proxy 'http://rb-proxy-na.bosch.com:8080' -ProxyCredential $cred; Invoke-WebRequest -Uri '%SEVENZIP_URL%' -OutFile '%SEVENZIP_EXE%' -UseBasicParsing  -Proxy 'http://rb-proxy-na.bosch.com:8080' -ProxyCredential $cred"

REM Extract ffmpeg zip
powershell -Command "Expand-Archive -Path '%FFMPEG_ZIP%' -DestinationPath '%FFMPEG_TEMP_DIR%' -Force"

REM Print all .exe files found in the bin folder
for /R "%FFMPEG_TEMP_DIR%" %%F in (*.exe) do (
    echo Found: %%F
    copy /Y "%%F" "%FFMPEG_DIR%\"
)

REM Clean up ffmpeg files
@REM rd /s /q "%FFMPEG_TEMP_DIR%"
@REM del "%FFMPEG_ZIP%"

REM Extract 7z.exe from installer (silent install to temp, then copy)
"%SEVENZIP_EXE%" /S /D="%SEVENZIP_TEMP_DIR%"
copy /Y "%SEVENZIP_TEMP_DIR%\7z.exe" "%SEVENZIP_DIR%\7z.exe"

REM Clean up 7zip files
@REM rd /s /q "%SEVENZIP_TEMP_DIR%"
@REM del "%SEVENZIP_EXE%"

echo 7zip installed to %SEVENZIP_TARGET%
endlocal
