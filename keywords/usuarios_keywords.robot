* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /usuarios.
Resource         ../support/base.robot


* Keywords *

Validar Usuario
    [Documentation]        Verifica se o usuario contém todos os campos exigidos pela ServeRest.
    [Arguments]            ${usuario}
    Should Not Be Empty        ${usuario["nome"]}
    Should Not Be Empty        ${usuario["email"]}
    Should Not Be Empty        ${usuario["password"]}
    Should Not Be Empty        ${usuario["administrador"]}
    Should Not Be Empty        ${usuario["_id"]}

Validar Usuarios Iguais
    [Documentation]        Verifica se dois usuários serverest possuem todos os campos iguais.
    ...                    Ignora o campo de '_id'.

    [Arguments]            ${usuario_1}    ${usuario_2}
    Should Be Equal        ${usuario_1["nome"]}             ${usuario_2["nome"]}
    Should Be Equal        ${usuario_1["email"]}            ${usuario_2["email"]}
    Should Be Equal        ${usuario_1["password"]}         ${usuario_2["password"]}
    Should Be Equal        ${usuario_1["administrador"]}    ${usuario_2["administrador"]}
