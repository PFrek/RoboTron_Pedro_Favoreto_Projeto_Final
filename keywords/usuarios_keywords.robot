* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /usuarios.
Resource         ../support/base.robot


* Keywords *

Tentar Cadastrar Usuario
    [Documentation]         Realiza uma tentativa de cadastro de usuário com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nReturn: \${response} -- a resposta da tentativa de cadastro de usuário.
    [Arguments]             ${json_usuario}
    ##########
    # Setup
    ${usuario}              Set Variable    ${json["dados_cadastro"][${json_usuario}]}

    ##########
    # Teste
    ${response}             Enviar POST    /usuarios    ${usuario}

    [Return]                ${response}

Tentar Editar Usuario Existente
    [Documentation]         Realiza uma tentativa de edição de usuário existente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário que será editado, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de usuário.
    ...                     \n\${id_usuario} -- a id do usuário criado para edição.
    [Arguments]             ${json_edicao}
    ##########
    # Setup
    ${id_usuario}           Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}          Set Variable    ${json["dados_edicao"][${json_edicao}]}

    ##########
    # Teste
    ${response}             Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}

    [Return]                ${response}    ${id_usuario}

Tentar Editar Usuario Inexistente
    [Documentation]         Realiza uma tentativa de edição de usuário inexistente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de usuário.
    [Arguments]             ${json_edicao}
    ##########
    # Setup
    ${id_usuario}           Set Variable    naoexiste321

    ${novos_dados}          Set Variable    ${json["dados_edicao"][${json_edicao}]}


    ##########
    # Teste
    ${response}             Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}

    [Return]                ${response}


Validar Usuario Valido
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
