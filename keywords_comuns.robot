* Settings *
Documentation    Arquivo contendo keywords comuns que são reutilizadas em vários endpoints
Library          RequestsLibrary

* Variables *
${url}            https://serverest.dev


* Keywords *

Criar Sessao
    [Documentation]       Inicia uma sessão na API ServeRest com alias 'serverest'
    Create Session        serverest    ${url}


Enviar DELETE "${endpoint}"
    ${resposta}=        DELETE On Session    serverest    ${endpoint}    expected_status=any
    [Return]            ${resposta}

Enviar GET "${endpoint}"
    ${resposta}=        GET On Session    serverest    ${endpoint}    expected_status=any
    [Return]            ${resposta}

Enviar POST
    [Documentation]         Envia um POST contendo o argumento body
    [Arguments]             ${endpoint}    ${body}
    ${resposta}=            POST On Session    serverest    ${endpoint}    json=${body}    expected_status=any
    [Return]                ${resposta}

Obter Dados De Usuario Existente
    [Documentation]         Retorna os dados do primeiro usuário na lista de usuários cadastrados
    ${resposta}=            GET On Session    serverest    /usuarios
    &{primeiro_usuario}=    Set Variable    ${resposta.json()}[usuarios][0]
    [Return]                &{primeiro_usuario}

Obter Informacoes De Login
    [Documentation]         Extrai somente email e senha de um json contendo todas as informações de um usuário
    [Arguments]             ${usuario}
    &{login}=               Create Dictionary    email=${usuario}[email]    password=${usuario}[password]
    [Return]                ${login}


# Keywords de validação

Validar Mensagem
    [Documentation]                   Verifica se a propriedade 'message' da resposta é a mesma que o esperado
    [Arguments]                       ${esperado}    ${resposta}
    Should Be Equal As Strings        ${resposta.json()}[message]    ${esperado}

Validar Status Code
    [Documentation]                Verifica se o status code na resposta é o mesmo que o esperado
    [Arguments]                    ${esperado}    ${resposta}
    Should Be Equal As Integers    ${resposta.status_code}    ${esperado}