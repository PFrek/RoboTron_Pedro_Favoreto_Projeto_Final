
@echo off
@echo ==============================================================================
@echo Iniciando testes do endpoint /login

set tags_validas=POST POSTANDSTATUS-2XX POSTANDSTATUS-4XX

set command=robot -d ./reports

if "%~1" NEQ "" set command=%command% -i %1

set command=%command%  login.robot

%command%

reports\report.html

@echo ==============================================================================
@echo Testes finalizados.
@echo Acesse Login/reports para ver os relatorios.
@echo ==============================================================================