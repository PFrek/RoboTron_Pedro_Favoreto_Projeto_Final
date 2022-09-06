@echo off
@echo ==============================================================================
@echo Iniciando testes em todos os endpoints

set base_command=iniciar_testes.bat

cmd /C %base_command% login %1

cmd /C %base_command% usuarios %1

cmd /C %base_command% produtos %1

cmd /C %base_command% carrinhos %1

@echo ==============================================================================
@echo Testes finalizados
@echo Acesse as pastas de cada endpoint para ver os relatorios.
@echo ==============================================================================