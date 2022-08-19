@echo off
@echo ==============================================================================
@echo Iniciando testes do endpoint /produtos

set command=robot -d ./reports

if "%~1" NEQ "" set command=%command% -i %1

set command=%command%  produtos.robot

%command%

reports\report.html

@echo ==============================================================================
@echo Testes finalizados.
@echo Acesse Produtos/reports para ver os relatorios.
@echo ==============================================================================