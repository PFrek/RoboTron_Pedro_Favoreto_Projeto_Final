* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /login.
Resource         ../support/base.robot


* Keywords *

Tentar Login
    [Documentation]    Realiza uma tentativa de login com os dados json informados.
    ...                Não faz validações dentro da keyword.
    ...                \nReturn: \${response} -- a resposta da tentativa de login.
    [Arguments]        ${json_login}

    ${login}                Set Variable     ${json["dados_teste"][${json_login}]}
    ${response}             Enviar POST      /login    ${login}

    [Return]                ${response}


Validar Login Com Sucesso
    [Documentation]    Verifica se uma tentativa de login obteve sucesso.
    [Arguments]        ${response}

    Validar Status Code    200    ${response}
    Validar Mensagem       Login realizado com sucesso    ${response}
    Should Not Be Empty    ${response.json()["authorization"]}


Validar Token Valido
    [Documentation]    Verifica se o token de autenticação retornado após login
    ...                com sucesso é válido.
    [Arguments]        ${token_auth}

    &{dados_produto}       Criar Dados Produto Dinamico
    ${id_produto}          Cadastrar Produto    ${dados_produto}   ${token_auth}

    Deletar Produto        ${id_produto}    ${token_auth} 