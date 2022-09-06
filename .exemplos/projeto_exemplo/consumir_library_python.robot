* Settings *
Documentation        Arquivo de Testes para Library PYTHON
Library              library_teste.py

* Test Cases *

Teste Library 1
    ${json}            Get Endpoint Usuarios Tantas Vezes        ${1}
    Log To Console     ${json}

Teste Library 2
    ${users}           Pegar Quantidade De Usuarios Cadastrados
    Log To Console     ${users}