# Sessão para configuração, documentação, imports de arquivos e libraries
* Settings *
Documentation        Arquivo simples para requisições HTTP em APIs
Library              RequestsLibrary


# Sessão para setagem de variáveis para utilização
* Variables *



# Sessão para criação dos cenários de teste
* Test Cases *
Cenario: GET Todos os Usuarios 200
    Criar Sessao
    ${response}=    GET Endpoint "/usuarios"
    Validar Status Code     200    ${response}



# Sessão para criação de Keywords Personalizadas
* Keywords *
Criar Sessao
    Create Session        serverest    https://serverest.dev

GET Endpoint "${endpoint}"
    ${response}            GET On Session    serverest    ${endpoint}
    [Return]               ${response}

Validar Status Code
    [Arguments]    ${statuscode}    ${response}
    Should Be True    ${response.status_code} == ${statuscode}