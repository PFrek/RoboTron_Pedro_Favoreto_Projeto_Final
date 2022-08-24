
@echo off
if "%~1" == "" (
    echo Numero de argumentos invalido
    echo Uso: iniciar_tests.bat [endpoint] [tags]
    exit /b
)

@echo ==============================================================================
@echo Iniciando testes do endpoint /%1

set command=robot -d ./reports/%1

if "%~2" NEQ "" set command=%command% -i %2

set command=%command% ./tests/%1_tests.robot

%command%

reports\%1\report.html

@echo ==============================================================================
@echo Testes finalizados.
@echo Acesse reports/ para ver os relatorios.
@echo ==============================================================================