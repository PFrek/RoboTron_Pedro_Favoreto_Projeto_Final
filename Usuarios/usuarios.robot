* Settings *
Documentation    Arquivo contendo os testes para o endpoint /usuarios da API ServeRest
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${endpoint}           /usuarios



* Test Cases *
Cenario: GET Todos Os Usuarios 200
    Criar Sessao
    ${resposta}=            Enviar GET "${endpoint}"
    Validar Status Code     200    ${resposta}


Cenario: POST Cadastrar Novo Usuario 201
    Criar Sessao
    # Cadastrar Usuario
    ${usuario}=            Criar Usuario Dinamico
    ${resposta}=           Enviar POST    ${endpoint}    ${usuario}
    Validar Status Code    201    ${resposta}
    Validar Mensagem       Cadastro realizado com sucesso    ${resposta}
    
    # Validar que o usuario foi realmente criado
    # ID do usuário criado
    ${id}=                     Set Variable    ${resposta.json()}[_id]
    ${resposta}=               Enviar GET "${endpoint}/${id}"
    Validar Status Code        200    ${resposta}
    Validar Usuarios Iguais    ${resposta.json()}    ${usuario}
    
    # Deletar usuario cadastrado
    # Permite que este teste seja repetido sem alterar informações do usuário
    ${resposta}=               Enviar DELETE "${endpoint}/${id}"
    Validar Status Code        200    ${resposta}
    

Cenario: POST Tentar Cadastrar Usuario Com Email Repetido 400
    Criar Sessao
    ${email}=                Obter Email Existente
    ${usuario}=              Criar Usuario Dinamico    email_existente    ${email}    1234    true
    ${resposta}=             Enviar POST    ${endpoint}    ${usuario}
    Validar Status Code      400    ${resposta}
    Validar Mensagem         Este email já está sendo usado    ${resposta}

Cenario: POST Tentar Cadastrar Usuario Com Dados Inválidos 400
    Criar Sessao
    # Usuário com email faltando
    ${usuario}=            Create Dictionary    nome=nome    password=234    administrador=false
    ${resposta}=           Enviar POST    ${endpoint}    ${usuario}
    Validar Status Code    400    ${resposta}


* Keywords *

# Listadas apenas keywords usadas unicamente nesta suíte de testes

Criar Usuario Dinamico
    [Arguments]    ${nome}=nome_teste    ${email}=email_teste@teste.com.br    ${password}=1234    ${administrador}=true
    ${usuario}=    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    [Return]        ${usuario}

Obter Email Existente
    ${usuario}=    Obter Dados De Usuario Existente
    ${login}=      Obter Informacoes De Login    ${usuario}
    ${email}=        Set Variable    ${login}[email]
    [Return]        ${email}

Validar Usuarios Iguais
    [Arguments]    ${usuario_1}    ${usuario_2}
    Should Be Equal    ${usuario_1}[nome]             ${usuario_2}[nome]
    Should Be Equal    ${usuario_1}[email]            ${usuario_2}[email]
    Should Be Equal    ${usuario_1}[password]         ${usuario_2}[password]
    Should Be Equal    ${usuario_1}[administrador]    ${usuario_2}[administrador]