@echo off
echo ********************************************************
echo COMPRESS ALL FILES W/ PROVIDED EXTENSION (Recursive)
echo ********************************************************
set ZIPPER="C:\tools\common\7zip\7z.exe"

:: Prompt user for file extension
set /p FILEEXT="Enter the file extension to compress (e.g., txt, exe): "

:: Prompt user for starting path
set /p STARTPATH="Enter the path to start searching in: "

if not exist "%STARTPATH%" (
  echo Path "%STARTPATH%" does not exist.
  pause
  exit /b
)

:: Recurse through STARTPATH and zip files with the provided extension
for /r "%STARTPATH%" %%i in (*.%FILEEXT%) do (
  %ZIPPER% a "%%i.7z" "%%i"
  del "%%i"
)

if %errorlevel% equ 0 (
  echo ********************************************************
  echo ZIP FILES CREATED
  echo ********************************************************
) else (
  echo ********************************************************
  echo ERROR %errorlevel% OCCURRED WHILE ZIPPING FILES
  echo ********************************************************
)

pause
