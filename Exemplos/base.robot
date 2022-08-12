# Sessão para configuração, documentação, imports de arquivos e libraries
* Settings *
Documentation        Arquivo simples para requisições HTTP em APIs REST
Library              RequestsLibrary


# Sessão para setagem de variáveis para utilização
* Variables *



# Sessão para criação dos cenários de teste
* Test Cases *
Cenario: GET Todos os Usuarios 200
    [Tags]    GET
    Criar Sessao
    GET Endpoint /usuarios
    Validar Status Code "200"
    Validar Quantidade "${4}"
    Printar Conteudo Response

Cenario: POST Cadastrar Usuario 201
    [Tags]    POST
    Criar Sessao
    POST Endpoint /usuarios
    Validar Status Code "201"
    Validar Se Mensagem Contem "sucesso"

Cenario: PUT Editar Usuario 200
    [Tags]    PUT
    Criar Sessao
    PUT Endpoint /usuarios
    Validar Status Code "200"

Cenario: DELETE Deletar Usuario 200
    [Tags]    DELETE
    Criar Sessao
    DELETE Endpoint /usuarios
    Validar Status Code "200"

# Sessão para criação de Keywords Personalizadas
* Keywords *
Criar Sessao
    Create Session        serverest    http://localhost:3000/

GET Endpoint /usuarios
    ${response}=            GET On Session    serverest    /usuarios
    Set Global Variable        ${response}

POST Endpoint /usuarios
    &{payload}              Create Dictionary    nome=jarb priest    email=teste3@gmail.com    password=123    administrador=true
    ${response}             POST On Session    serverest    /usuarios    data=&{payload}
    Log To Console          Resonse: ${response.content}
    Set Global Variable     ${response}

PUT Endpoint /usuarios
    &{payload}              Create Dictionary    nome=jaras priest    email=test120823@gmail.com    password=123    administrador=true
    ${response}             PUT On Session    serverest    /usuarios/VJ1xMrlgWMriSUad    data=&{payload}
    Log To Console          Response: ${response.content}
    Set Global Variable     ${response}

DELETE Endpoint /usuarios
    ${response}             DELETE On Session    serverest    /usuarios/VJ1xMrlgWMriSUad
    Log To Console          ${response.content}
    Set Global Variable     ${response}

Validar Status Code "${statuscode}"
    Should Be True    ${response.status_code} == ${statuscode}

Validar Quantidade "${quantidade}"
    Should Be Equal    ${response.json()["quantidade"]}    ${quantidade}

Validar Se Mensagem Contem "${palavra}"
    Should Contain    ${response.json()["message"]}    ${palavra}

Printar Conteudo Response
    Log To Console    Nome: ${response.json()["usuarios"][1]["nome"]}