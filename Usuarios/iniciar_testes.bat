@echo off
set command=robot -d ./reports

if "%~1" NEQ "" set command=%command% -i %1

set command=%command%  usuarios.robot

%command%