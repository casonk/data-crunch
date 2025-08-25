@echo off
echo ********************************************************
echo COMPRESS ALL FILES W/ PROVIDED EXTENSION (Recursive)
echo ********************************************************
set COMPRESSOR="C:\tools\common\ffmpeg\ffmpeg.exe"

:: Prompt user for video file extension
set /p FILEEXT="Enter the video file extension to compress (e.g., avi, mp4): "

:: Prompt user for starting path
set /p STARTPATH="Enter the path to start searching in: "

if not exist "%STARTPATH%" (
    echo Path "%STARTPATH%" does not exist.
    pause
    exit /b
)

SETLOCAL EnableDelayedExpansion

:: Recurse through AVI files
for /R "%STARTPATH%" %%a in ("*.%FILEEXT%") do (
    set "fullpath=%%~fa"
    set "filename=%%~na"
    set "folder=%%~dpa"
    set "compressedfile=%%~dpa%%~na-compressed.%FILEEXT%"

    :: Get the last 11 characters of the filename (length of "-compressed")
    set "last11=!filename:~-11!"

    :: If the filename already ends with "-compressed", skip it
    if /I "!last11!"=="-compressed" (
        echo Skipping already compressed file: "%%a"
    ) else (
        :: If a compressed version already exists, skip too
        if exist "!compressedfile!" (
            echo Skipping because compressed version already exists: "%%a"
        ) else (
            :: Rename original to -raw.extension
            ren "%%~fa" "%%~na-raw.%FILEEXT%"
            set "rawfile=%%~dpa%%~na-raw.%FILEEXT%"
            set "compressedfile=%%~dpa%%~na-compressed.%FILEEXT%"

            echo Compressing "!rawfile!" to "!compressedfile!"
            %COMPRESSOR% -i "!rawfile!" -vb 3000k "!compressedfile!"

            :: Delete raw file after compression
            del "!rawfile!"
        )
    )
)

ENDLOCAL

echo ********************************************************
echo Compression complete.
echo ********************************************************
pause
