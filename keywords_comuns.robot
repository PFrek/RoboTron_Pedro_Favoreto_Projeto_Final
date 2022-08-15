* Settings *
Documentation    Arquivo contendo keywords comuns que são reutilizadas em vários endpoints.
Library          RequestsLibrary

* Variables *
${url}            http://localhost:3000/


* Keywords *

Criar Sessao
    [Documentation]       Inicia uma sessão na API ServeRest com alias 'serverest'.
    Create Session        serverest    ${url}


Enviar DELETE
    [Documentation]     Envia uma requisição DELETE para o endpoint escolhido.
    ...                 Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                 \nRetorna: \${response} - a resposta recebida.

    [Arguments]         ${endpoint}    ${headers}=&{EMPTY}
    ${response}=        DELETE On Session    serverest    ${endpoint}    headers=&{headers}    expected_status=any
    [Return]            ${response}

Enviar GET
    [Documentation]     Envia uma requisição GET para o endpoint escolhido.
    ...                 Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                 \nRetorna: \${response} - a resposta recebida.

    [Arguments]         ${endpoint}    ${headers}=&{EMPTY}
    ${response}=        GET On Session    serverest    ${endpoint}    headers=&{headers}    expected_status=any
    [Return]            ${response}

Enviar POST
    [Documentation]         Envia uma requisição POST contendo o argumento body para o endpoint escolhido.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \${response} - a resposta recebida.

    [Arguments]             ${endpoint}    ${body}    ${headers}=&{EMPTY}
    ${response}=            POST On Session    serverest    ${endpoint}    data=&{body}    headers=&{headers}    expected_status=any
    [Return]                ${response}

Enviar PUT
    [Documentation]         Envia uma requisição PUT contendo o argumento body para o endpoint escolhido.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \${response} - a resposta recebida.

    [Arguments]             ${endpoint}    ${body}    ${headers}=&{EMPTY}
    ${response}=           PUT On Session    serverest    ${endpoint}    data=&{body}    headers=&{headers}    expected_status=any
    [Return]                ${response}

Obter Dados De Produto Existente
    [Documentation]         Retorna os dados do produto de índice index na lista de produtos cadastrados.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \&{produto} - os dados do produto encontrado.

    [Arguments]             ${index}=0
    ${response}=            GET On Session    serverest    /produtos
    &{produto}=             Create Dictionary    &{response.json()["produtos"][${index}]}
    [Return]                &{produto}

Obter Dados De Usuario Existente
    [Documentation]         Retorna os dados do usuário de índice index na lista de usuários cadastrados.
    ...                     Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                     \nRetorna: \&{usuario} - os dados do usuário encontrado.

    [Arguments]             ${index}=0
    ${response}=            GET On Session    serverest    /usuarios
    &{usuario}=             Create Dictionary    &{response.json()["usuarios"][${index}]}
    [Return]                &{usuario}

Obter Informacoes De Login
    [Documentation]         Extrai somente email e senha de um json contendo todas as informações de um usuário.
    ...                     \nRetorna: \&{login} - dicionário contendo chaves 'email' e 'password'.

    [Arguments]             &{usuario}
    &{login}=               Create Dictionary    email=${usuario["email"]}    password=${usuario["password"]}
    [Return]                &{login}


# Keywords de validação

Validar Mensagem
    [Documentation]                   Verifica se a propriedade 'message' da resposta é a mesma que o esperado.

    [Arguments]                       ${esperado}    ${response}
    Should Be Equal As Strings        ${response.json()["message"]}    ${esperado}

Validar Status Code
    [Documentation]                Verifica se o status code na resposta é o mesmo que o esperado.
    
    [Arguments]                    ${esperado}    ${response}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}