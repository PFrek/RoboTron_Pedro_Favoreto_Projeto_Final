@echo off
@echo ==============================================================================
@echo Iniciando testes em todos os endpoints

set base_command=iniciar_testes.bat

pushd Login
cmd /C %base_command% login %1
popd

pushd Usuarios
cmd /C %base_command% usuarios %1
popd

pushd Produtos
cmd /C %base_command% produtos %1
popd

pushd Carrinhos
cmd /C %base_command% carrinhos %1
popd

@echo ==============================================================================
@echo Testes finalizados
@echo Acesse as pastas de cada endpoint para ver os relatorios.
@echo ==============================================================================