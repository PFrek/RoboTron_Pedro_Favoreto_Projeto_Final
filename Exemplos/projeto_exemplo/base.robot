# Sessão para configuração, documentação, imports de arquivos e libraries
* Settings *
Documentation        Arquivo simples para requisições HTTP em APIs REST
Library              RequestsLibrary
Resource             ./usuarios_keywords.robot
Resource             ./login_keywords.robot
Resource             ./produtos_keywords.robot


# Sessão para setagem de variáveis para utilização
* Variables *
${nome_do_usuario}        herbert richards
${senha_do_usuario}       teste123
${email_do_usuario}       testes@gmail.com

# Sessão para criação dos cenários de teste
* Test Cases *
Cenario: GET Todos os Usuarios 200
    [Tags]    GET
    Criar Sessao
    GET Endpoint /usuarios
    Validar Status Code "200"
    Validar Quantidade "${2}"
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

Cenario: POST Realizar Login 200
    [Tags]    POSTLOGIN
    Criar Sessao
    POST Endpoint /login
    Validar Status Code "200"

Cenario: POST Criar Produto 201
    [Tags]    POSTPRODUTO
    Criar Sessao
    POST Endpoint /produtos
    Validar Status Code "201"

# Sessão para criação de Keywords Personalizadas
* Keywords *
Criar Sessao
    Create Session        serverest    http://localhost:3000/

Validar Status Code "${statuscode}"
    Should Be True    ${response.status_code} == ${statuscode}

Validar Quantidade "${quantidade}"
    Should Be Equal    ${response.json()["quantidade"]}    ${quantidade}

Validar Se Mensagem Contem "${palavra}"
    Should Contain    ${response.json()["message"]}    ${palavra}

Printar Conteudo Response
    Log To Console    Nome: ${response.json()["usuarios"][1]["nome"]}