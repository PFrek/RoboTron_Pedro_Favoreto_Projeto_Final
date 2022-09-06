* Settings *
Documentation        Arquivo de Testes para Endpoint /usuarios
Resource             ../keywords/usuarios_keywords.robot

Suite Setup         Criar Sessao

* Test Cases *
Cenario: GET Todos os Usuarios 200
    [Tags]    GET
    GET Endpoint /usuarios
    Validar Status Code "200"

Cenario: POST Cadastrar Usuario 201
    [Tags]    POST
    Criar Dados Usuario Valido
    POST Endpoint /usuarios
    Validar Status Code "201"
    Validar Se Mensagem Contem "sucesso"

Cenario: PUT Editar Usuario 200
    [Tags]    PUT
    Criar Dados Usuario Valido
    POST Endpoint /usuarios
    Criar Dados Usuario Valido
    PUT Endpoint /usuarios
    Validar Status Code "200"

Cenario: DELETE Deletar Usuario 200
    [Tags]    DELETE
    Criar Dados Usuario Valido
    POST Endpoint /usuarios
    DELETE Endpoint /usuarios
    Validar Status Code "200"

Cenario: POST Criar Usuario De Massa Estatica 201
    [Tags]    POSTCRIARUSUARIOESTATICO
    Cadastrar Usuario Estatico Valido
    POST ENdpoint /usuarios
    Validar Status Code "201"
