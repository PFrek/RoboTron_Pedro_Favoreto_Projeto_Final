* Settings *
Documentation        Arquivo de Testes para Endpoint /login
Resource             ../keywords/login_keywords.robot

Suite Setup          Criar Sessao

* Test Cases *
Cenario: POST Realizar Login 200
    [Tags]    POSTLOGIN
    POST Endpoint /login
    Validar Status Code "200"
