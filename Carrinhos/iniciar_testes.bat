@echo off
@echo ==============================================================================
@echo Iniciando testes do endpoint /carrinhos

set command=robot -d ./reports

if "%~1" NEQ "" set command=%command% -i %1

set command=%command%  carrinhos.robot

%command%

reports\report.html

@echo ==============================================================================
@echo Testes finalizados.
@echo Acesse Carrinhos/reports para ver os relatorios.
@echo ==============================================================================