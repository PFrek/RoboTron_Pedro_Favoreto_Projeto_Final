@echo off
@echo ==============================================================================
@echo Iniciando testes em todos os endpoints

set base_command=iniciar_testes.bat

if "%~1" NEQ "" set base_command=%base_command% %1

pushd Login
cmd /C %base_command%
popd

pushd Usuarios
cmd /C %base_command%
popd

pushd Produtos
cmd /C %base_command%
popd

pushd Carrinhos
cmd /C %base_command%
popd

@echo ==============================================================================
@echo Testes finalizados
@echo Acesse as pastas de cada endpoint para ver os relatorios.
@echo ==============================================================================