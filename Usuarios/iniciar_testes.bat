@echo off
@echo ==============================================================================
@echo Iniciando testes do endpoint /usuarios

set command=robot -d ./reports

if "%~1" NEQ "" set command=%command% -i %1

set command=%command%  usuarios.robot

%command%

reports\report.html

@echo ==============================================================================
@echo Testes finalizados.
@echo Acesse Usuarios/reports para ver os relatorios.
@echo ==============================================================================