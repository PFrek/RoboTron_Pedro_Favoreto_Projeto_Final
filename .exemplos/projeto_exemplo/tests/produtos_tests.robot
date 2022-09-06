* Settings *
Documentation        Arquivo de Testes para Endpoint /produtos
Resource             ../keywords/produtos_keywords.robot

Suite Setup          Criar Sessao

* Test Cases *
Cenario: POST Criar Produto 201
    [Tags]    POSTPRODUTO
    Fazer Login e Armazenar Token
    POST Endpoint /produtos
    Validar Status Code "201"

Cenario: DELETE Excluir Produto 200
    [Tags]    DELETEPRODUTO
    Fazer Login e Armazenar Token
    Criar Um Produto e Armazenar ID
    DELETE Endpoint /produtos
    Validar Status Code "200"
